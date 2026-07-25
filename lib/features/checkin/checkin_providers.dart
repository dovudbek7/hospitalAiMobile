// Check-in flow state. THE safety-critical invariants live here:
//
//  1. Tier is assigned SERVER-SIDE. This file routes on the server's tier
//     string verbatim and contains no rule that reads an answer. A malformed
//     response is an explicit failure — never a guessed tier.
//  2. Offline SUBMIT IS BLOCKED, and nothing enters any queue.
//  3. A failed submission NEVER renders as success.
//  4. The Idempotency-Key is created with the draft and reused on every
//     retry of the same logical submission.
//  5. Partial completion saves and resumes within the same day.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/auth/session.dart';
import '../../core/models/api_models.dart';
import '../../core/network/api_error.dart';
import '../../core/providers.dart';

final checkinQuestionsProvider = FutureProvider<List<CheckinQuestion>>(
  (ref) => ref.watch(patientApiProvider).getCheckinQuestions(),
);

/// Where the flow stands after a submit attempt.
enum CheckinPhase {
  answering,

  /// The device is offline: submission is blocked and NOT queued. The UI
  /// shows the clinic phone and the emergency instruction.
  blockedOffline,

  /// The server rejected or the send failed — explicit failure, with the
  /// clinic phone. Never rendered as success.
  failed,

  /// The server answered with a tier; route on it verbatim.
  submitted,
}

@immutable
class CheckinState {
  const CheckinState({
    this.index = 0,
    this.answers = const {},
    this.phase = CheckinPhase.answering,
    this.submitting = false,
    this.result,
  });

  final int index;
  final Map<String, Object> answers;
  final CheckinPhase phase;
  final bool submitting;
  final CheckinResult? result;

  CheckinState copyWith({
    int? index,
    Map<String, Object>? answers,
    CheckinPhase? phase,
    bool? submitting,
    CheckinResult? result,
  }) {
    return CheckinState(
      index: index ?? this.index,
      answers: answers ?? this.answers,
      phase: phase ?? this.phase,
      submitting: submitting ?? this.submitting,
      result: result ?? this.result,
    );
  }
}

/// The ONLY thing the client does with a tier: pick which screen renders
/// the server's decision. Unknown tiers are failures, not fallbacks.
String? routeForTier(String tier) => switch (tier) {
      'routine' => '/checkin/result/routine',
      'urgent' => '/checkin/result/urgent',
      'emergency' => '/emergency',
      _ => null,
    };

class CheckinFlowNotifier extends Notifier<CheckinState> {
  static const _uuid = Uuid();

  String get _draftKey {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return 'checkin.draft.${now.year}-${two(now.month)}-${two(now.day)}';
  }

  @override
  CheckinState build() {
    // Resume a same-day draft (spec P10). Older drafts never resume.
    final prefs = ref.read(sharedPrefsProvider);
    final raw = prefs.getString(_draftKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final answers = (decoded['answers'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as Object));
        return CheckinState(answers: answers);
      } catch (_) {
        // Corrupt draft: start clean.
      }
    }
    return const CheckinState();
  }

  String _draftIdempotencyKey() {
    final prefs = ref.read(sharedPrefsProvider);
    final raw = prefs.getString(_draftKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final existing = decoded['idempotencyKey'];
        if (existing is String && existing.isNotEmpty) return existing;
      } catch (_) {}
    }
    return _uuid.v4();
  }

  Future<void> _saveDraft(String idempotencyKey) async {
    await ref.read(sharedPrefsProvider).setString(
          _draftKey,
          jsonEncode({
            'answers': state.answers,
            'idempotencyKey': idempotencyKey,
          }),
        );
  }

  Future<void> _clearDraft() async {
    await ref.read(sharedPrefsProvider).remove(_draftKey);
  }

  void answer(String qRef, Object value) {
    state = state.copyWith(
      answers: {...state.answers, qRef: value},
      phase: CheckinPhase.answering,
    );
    // Fire-and-forget draft save with the stable key.
    // ignore: unawaited_futures
    _saveDraft(_draftIdempotencyKey());
  }

  void toggleMulti(String qRef, String code, {String noneCode = 'none'}) {
    final current = state.answers[qRef];
    var selected = current is List
        ? List<String>.from(current.cast<String>())
        : <String>[];
    if (code == noneCode) {
      selected = selected.contains(noneCode) ? [] : [noneCode];
    } else {
      selected.remove(noneCode);
      selected.contains(code) ? selected.remove(code) : selected.add(code);
    }
    answer(qRef, selected);
  }

  void goTo(int index) => state = state.copyWith(index: index);

  /// Submit. Returns the route to go to, or null when the state screen
  /// (offline / failed) should stay.
  Future<String?> submit() async {
    if (state.submitting) return null;
    state = state.copyWith(submitting: true);
    try {
      final key = _draftIdempotencyKey();
      await _saveDraft(key); // key survives a retry of this submission
      final result = await ref.read(patientApiProvider).submitCheckin(
        answers: [
          for (final e in state.answers.entries)
            {'ref': e.key, 'value': e.value},
        ],
        idempotencyKey: key,
      );
      final route = routeForTier(result.tier);
      if (route == null) {
        // A tier this client does not recognise is a FAILURE. Guessing a
        // reassurance level is the one unforgivable bug on this screen.
        state = state.copyWith(
          phase: CheckinPhase.failed,
          submitting: false,
        );
        return null;
      }
      await _clearDraft();
      state = state.copyWith(
        phase: CheckinPhase.submitted,
        submitting: false,
        result: result,
      );
      return route;
    } on DioException catch (e) {
      final err = e.error;
      state = state.copyWith(
        phase: err is NetworkUnavailable
            ? CheckinPhase.blockedOffline
            : CheckinPhase.failed,
        submitting: false,
      );
      // NOTHING is queued on either path — deliberately.
      return null;
    }
  }

  void backToAnswering() =>
      state = state.copyWith(phase: CheckinPhase.answering);
}

final checkinFlowProvider =
    NotifierProvider<CheckinFlowNotifier, CheckinState>(
  CheckinFlowNotifier.new,
);
