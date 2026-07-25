import 'package:flutter/foundation.dart';

/// One SSE chunk from POST /me/assistant/messages. Shapes per the
/// integration guide §7.2.
sealed class AssistantChunk {
  const AssistantChunk();

  static AssistantChunk? parse(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'delta':
        final text = json['text'];
        return text is String ? AssistantDelta(text) : null;
      case 'done':
        return AssistantDone(
          verdict: json['verdict'] as String? ?? 'passed',
          contentKey: json['contentKey'] as String?,
          contentRefs: (json['contentRefs'] as List?)?.cast<String>(),
        );
      case 'error':
        return AssistantError(json['code'] as String? ?? 'INTERNAL_ERROR');
      default:
        return null;
    }
  }
}

/// Append this ALREADY-SAFE text to the live bubble.
class AssistantDelta extends AssistantChunk {
  const AssistantDelta(this.text);
  final String text;
}

/// End of turn.
///  - verdict `passed`          → the streamed text IS the answer.
///  - verdict `red_flag_bypass` → server sent emergency content; render the
///    P13 emergency UI, contentKey = emergency.headline.
///  - verdict `replaced`        → reply withheld; resolve contentKey
///    (usually contact.body) and show THAT as the answer.
class AssistantDone extends AssistantChunk {
  const AssistantDone({
    required this.verdict,
    this.contentKey,
    this.contentRefs,
  });
  final String verdict;
  final String? contentKey;
  final List<String>? contentRefs;

  bool get isRedFlag => verdict == 'red_flag_bypass';
}

/// A failure — show approved contact-clinic content.
class AssistantError extends AssistantChunk {
  const AssistantError(this.code);
  final String code;
}

/// A rendered message in the thread.
enum ChatRole { patient, assistant }

@immutable
class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.text,
    this.contentKey,
    this.streaming = false,
  });

  final ChatRole role;

  /// For assistant messages this may be empty while [contentKey] carries an
  /// approved-content reference to resolve instead (replaced / red-flag).
  final String text;
  final String? contentKey;
  final bool streaming;

  ChatMessage copyWith({String? text, bool? streaming, String? contentKey}) =>
      ChatMessage(
        role: role,
        text: text ?? this.text,
        contentKey: contentKey ?? this.contentKey,
        streaming: streaming ?? this.streaming,
      );
}
