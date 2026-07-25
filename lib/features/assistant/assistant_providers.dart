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
}

final assistantProvider =
    NotifierProvider<AssistantController, AssistantState>(
  AssistantController.new,
);
