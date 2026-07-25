import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_error.dart';
import '../../core/providers.dart';
import 'assistant_api.dart';
import 'assistant_models.dart';

final assistantApiProvider =
    Provider<AssistantApi>((ref) => AssistantApi(ref.watch(dioProvider)));

/// How the last send resolved — drives which non-chat UI (if any) to show.
enum AssistantOutcome {
  none,

  /// Server flagged an emergency; route to the P13 emergency screen.
  redFlag,

  /// Offline: the assistant needs connectivity. Nothing is queued.
  offline,

  /// A failure — the bubble shows approved contact content.
  failed,
}

@immutable
class AssistantState {
  const AssistantState({
    this.messages = const [],
    this.sending = false,
    this.outcome = AssistantOutcome.none,
    this.threadId,
  });

  final List<ChatMessage> messages;
  final bool sending;
  final AssistantOutcome outcome;
  final String? threadId;

  AssistantState copyWith({
    List<ChatMessage>? messages,
    bool? sending,
    AssistantOutcome? outcome,
    String? threadId,
  }) =>
      AssistantState(
        messages: messages ?? this.messages,
        sending: sending ?? this.sending,
        outcome: outcome ?? this.outcome,
        threadId: threadId ?? this.threadId,
      );
}

class AssistantController extends Notifier<AssistantState> {
  @override
  AssistantState build() => const AssistantState();

  /// Send a patient message and stream the reply. Returns the emergency
  /// content key when the server flags a red flag, so the screen can route
  /// to P13; otherwise null.
  Future<String?> send(String text) async {
    final message = text.trim();
    if (message.isEmpty || state.sending) return null;

    final patientMsg = ChatMessage(role: ChatRole.patient, text: message);
    final liveIndex = state.messages.length + 1;
    state = state.copyWith(
      sending: true,
      outcome: AssistantOutcome.none,
      messages: [
        ...state.messages,
        patientMsg,
        const ChatMessage(
          role: ChatRole.assistant,
          text: '',
          streaming: true,
        ),
      ],
    );

    final buffer = StringBuffer();
    void updateLive({String? contentKey, bool streaming = true}) {
      final msgs = [...state.messages];
      if (liveIndex < msgs.length) {
        msgs[liveIndex] = ChatMessage(
          role: ChatRole.assistant,
          text: buffer.toString(),
          contentKey: contentKey,
          streaming: streaming,
        );
        state = state.copyWith(messages: msgs);
      }
    }

    try {
      await for (final chunk in ref
          .read(assistantApiProvider)
          .sendMessage(message: message, threadId: state.threadId)) {
        switch (chunk) {
          case AssistantDelta(:final text):
            buffer.write(text);
            updateLive();
          case AssistantDone(:final contentKey, :final isRedFlag):
            if (isRedFlag) {
              state = state.copyWith(
                sending: false,
                outcome: AssistantOutcome.redFlag,
              );
              return contentKey ?? 'emergency.headline';
            }
            // replaced → resolve contentKey as the answer; passed → keep
            // the streamed text.
            updateLive(contentKey: contentKey, streaming: false);
            state = state.copyWith(sending: false);
            return null;
          case AssistantError():
            updateLive(contentKey: 'assistant.error', streaming: false);
            state = state.copyWith(
              sending: false,
              outcome: AssistantOutcome.failed,
            );
            return null;
        }
      }
      // Stream ended without an explicit done — settle on what we have.
      updateLive(streaming: false);
      state = state.copyWith(sending: false);
      return null;
    } on DioException catch (e) {
      final offline = e.error is NetworkUnavailable;
      // Drop the empty live bubble; the screen shows the state banner.
      final msgs = [...state.messages]..removeAt(liveIndex);
      state = state.copyWith(
        messages: msgs,
        sending: false,
        outcome:
            offline ? AssistantOutcome.offline : AssistantOutcome.failed,
      );
      return null;
    }
  }

  void clearOutcome() => state = state.copyWith(outcome: AssistantOutcome.none);

  /// Best-effort: load the most recent thread's history so returning to the
  /// assistant shows past messages. The server response is untyped, so this
  /// is fully defensive — any unexpected shape leaves the chat empty rather
  /// than crashing. Only runs when the chat is currently empty.
  Future<void> loadHistory() async {
    if (state.messages.isNotEmpty || state.sending) return;
    try {
      final api = ref.read(assistantApiProvider);
      final threads = await api.threads();
      if (threads.isEmpty) return;
      final id = _firstString(threads.first, ['id', 'threadId', '_id']);
      if (id == null) return;
      final thread = await api.thread(id);
      final rawMessages = _listField(thread, ['messages', 'items', 'history']);
      final parsed = <ChatMessage>[];
      for (final m in rawMessages) {
        if (m is! Map<String, dynamic>) continue;
        final role = _firstString(m, ['role', 'sender', 'from', 'author']);
        final text = _firstString(m, ['text', 'content', 'message', 'body']);
        final contentKey = _firstString(m, ['contentKey', 'content_key']);
        if (text == null && contentKey == null) continue;
        final isPatient =
            role == 'patient' || role == 'user' || role == 'me';
        parsed.add(
          ChatMessage(
            role: isPatient ? ChatRole.patient : ChatRole.assistant,
            text: text ?? '',
            contentKey: isPatient ? null : contentKey,
          ),
        );
      }
      if (parsed.isNotEmpty && state.messages.isEmpty) {
        state = state.copyWith(messages: parsed, threadId: id);
      }
    } on Object {
      // Untyped/absent history — leave the chat empty. Never breaks the UI.
    }
  }

  static String? _firstString(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.isNotEmpty) return v;
    }
    return null;
  }

  static List<dynamic> _listField(
    Map<String, dynamic>? m,
    List<String> keys,
  ) {
    if (m == null) return const [];
    for (final k in keys) {
      final v = m[k];
      if (v is List) return v;
    }
    return const [];
  }
}

final assistantProvider =
    NotifierProvider<AssistantController, AssistantState>(
  AssistantController.new,
);
