import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'action_queue.dart';
import 'sync_worker.dart';

/// True when the device believes it has a network path. The offline strip
/// watches this; check-in submission BLOCKS on it (and then still treats a
/// send failure as failure — the UI never trusts this flag alone).
final onlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  final first = await connectivity.checkConnectivity();
  yield !first.contains(ConnectivityResult.none);
  await for (final results in connectivity.onConnectivityChanged) {
    yield !results.contains(ConnectivityResult.none);
  }
});

final actionQueueProvider =
    Provider<ActionQueue>((ref) => ActionQueue(ref.watch(databaseProvider)));

final syncWorkerProvider = Provider<SyncWorker>(
  (ref) => SyncWorker(
    api: ref.watch(patientApiProvider),
    queue: ref.watch(actionQueueProvider),
  ),
);

/// Kicks a queue drain whenever connectivity comes back. Kept alive for the
/// app's lifetime from the shell.
final syncTriggerProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<bool>>(onlineProvider, (prev, next) {
    final wasOffline = prev?.value == false;
    final nowOnline = next.value == true;
    if (wasOffline && nowOnline) {
      // Fire and forget; the worker serialises itself.
      Future<void>.delayed(
        const Duration(milliseconds: 500),
        () => ref.read(syncWorkerProvider).drainOnce(),
      );
    }
  });
});
