import 'dart:convert';

import 'package:dio/dio.dart';

import '../api/patient_api.dart';
import '../network/api_error.dart';
import '../storage/app_database.dart';
import 'action_queue.dart';

/// Drains the offline queue. Called on connectivity regain and app resume.
///
/// Guarantees:
///  - the SAME persisted Idempotency-Key is replayed on every retry;
///  - the original `occurredAt` travels with the request — never the sync
///    time;
///  - DUPLICATE_REQUEST from the server means the effect already happened —
///    the row is settled, not retried forever;
///  - transport failure stops the drain (still offline) without touching
///    attempt counts.
class SyncWorker {
  SyncWorker({required PatientApi api, required ActionQueue queue})
      // ignore: prefer_initializing_formals
      : _api = api,
        // ignore: prefer_initializing_formals
        _queue = queue;

  final PatientApi _api;
  final ActionQueue _queue;

  bool _draining = false;

  /// Returns the number of actions settled (synced or deduplicated).
  Future<int> drainOnce() async {
    if (_draining) return 0;
    _draining = true;
    var settled = 0;
    try {
      for (final row in await _queue.pending()) {
        try {
          await _dispatch(row);
          await _queue.remove(row.id);
          settled++;
        } on DioException catch (e) {
          final err = e.error;
          if (err is NetworkUnavailable) {
            // Still offline — stop, keep everything, no attempt bump.
            return settled;
          }
          if (err is ApiError) {
            if (err.code == ApiErrorCode.duplicateRequest) {
              // The original request already landed. Settled.
              await _queue.remove(row.id);
              settled++;
              continue;
            }
            if (err.code == ApiErrorCode.validationError ||
                err.code == ApiErrorCode.notFound) {
              // Permanently unprocessable (task deleted, plan changed).
              // Keep the patient's day working: drop with a recorded reason.
              await _queue.bumpAttempts(row, err.code.wire);
              await _queue.remove(row.id);
              continue;
            }
            // Transient server-side trouble: bump and move on; a later
            // drain retries with the same key.
            await _queue.bumpAttempts(row, err.code.wire);
            continue;
          }
          await _queue.bumpAttempts(row, e.type.name);
        }
      }
      return settled;
    } finally {
      _draining = false;
    }
  }

  Future<void> _dispatch(PendingAction row) async {
    final type = PendingActionType.parse(row.type);
    final payload = jsonDecode(row.payload) as Map<String, dynamic>;
    switch (type) {
      case PendingActionType.completeTask:
      case PendingActionType.uncompleteTask:
        await _api.completeTask(
          taskId: payload['taskId'] as String,
          idempotencyKey: row.idempotencyKey,
          occurredAt: row.occurredAt,
          uncomplete: type == PendingActionType.uncompleteTask,
        );
    }
  }
}
