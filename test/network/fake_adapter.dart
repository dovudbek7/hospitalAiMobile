import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeHandler = FakeResponse Function(RequestOptions options);

class FakeResponse {
  FakeResponse(this.statusCode, this.body);

  final int statusCode;
  final Object? body;
}

/// Canned-response adapter for Dio — no sockets, fully deterministic.
/// Records every request so tests can assert on headers and replay counts.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final FakeHandler handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final res = handler(options);
    return ResponseBody.fromString(
      jsonEncode(res.body),
      res.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
