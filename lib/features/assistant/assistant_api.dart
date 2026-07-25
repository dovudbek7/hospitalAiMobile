import 'dart:convert';

import 'package:dio/dio.dart';

import 'assistant_models.dart';

/// Streaming client for the AI assistant (integration guide §7).
///
/// Uses Dio's streamed response so the call still passes through the app's
/// interceptors (bearer auth) AND the demo adapter — the UI never touches
/// a second HTTP client. Safety is enforced SERVER-side; this only parses
/// and forwards chunks.
class AssistantApi {
  AssistantApi(this._dio);

  final Dio _dio;

  /// GET /me/assistant/threads → raw thread list (newest first). The server
  /// response is untyped, so callers must treat entries defensively.
  Future<List<Map<String, dynamic>>> threads() async {
    final r = await _dio.get<dynamic>('/me/assistant/threads');
    final data = r.data;
    if (data is List) {
      return [
        for (final t in data)
          if (t is Map<String, dynamic>) t,
      ];
    }
    return const [];
  }

  /// GET /me/assistant/threads/{id} → the raw thread (with messages). Untyped.
  Future<Map<String, dynamic>?> thread(String id) async {
    final r = await _dio.get<dynamic>('/me/assistant/threads/$id');
    return r.data is Map<String, dynamic> ? r.data as Map<String, dynamic> : null;
  }

  /// POST /me/assistant/messages → a stream of parsed [AssistantChunk]s.
  Stream<AssistantChunk> sendMessage({
    required String message,
    String? threadId,
  }) async* {
    final response = await _dio.post<ResponseBody>(
      '/me/assistant/messages',
      data: {'message': message, 'threadId': ?threadId},
      options: Options(
        responseType: ResponseType.stream,
        headers: {'Accept': 'text/event-stream'},
      ),
    );

    final body = response.data!;
    var buffer = '';
    await for (final bytes in body.stream) {
      buffer += utf8.decode(bytes, allowMalformed: true);
      // SSE frames are separated by a blank line.
      while (true) {
        final i = buffer.indexOf('\n\n');
        if (i < 0) break;
        final frame = buffer.substring(0, i);
        buffer = buffer.substring(i + 2);
        for (final line in const LineSplitter().convert(frame)) {
          final trimmed = line.trimLeft();
          if (!trimmed.startsWith('data:')) continue;
          final payload = trimmed.substring(5).trim();
          if (payload.isEmpty) continue;
          try {
            final json = jsonDecode(payload) as Map<String, dynamic>;
            final chunk = AssistantChunk.parse(json);
            if (chunk != null) yield chunk;
          } catch (_) {
            // Ignore a malformed frame; the stream continues.
          }
        }
      }
    }
  }
}
