import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Resolved content, keyed by contentKey + language + version. Unapproved
/// content is NEVER written here (golden rule 3) — a CONTENT_NOT_APPROVED
/// response deletes any stale row instead.
class ContentCacheRows extends Table {
  TextColumn get contentKey => text()();
  TextColumn get language => text()();
  IntColumn get version => integer()();
  TextColumn get body => text()();
  BoolColumn get isPlaceholder => boolean().withDefault(const Constant(false))();
  IntColumn get fetchedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {contentKey, language};
}

/// The next 7 days of tasks, cached for offline (P6–P9 rule).
class CachedTasks extends Table {
  TextColumn get id => text()();
  IntColumn get recoveryDay => integer()();
  TextColumn get taskType => text()();
  TextColumn get contentRef => text()();
  TextColumn get scheduledFor => text()();
  TextColumn get windowClosesAt => text().nullable()();
  TextColumn get status => text()();
  BoolColumn get onTime => boolean().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Offline action queue. The idempotency key is generated ONCE per logical
/// action and persisted here so every retry replays the SAME key — that is
/// what makes offline sync safe. `occurredAt` is the original action time
/// and must never be overwritten by the sync time.
///
/// NOTE: check-in submission is deliberately unrepresentable here — see
/// `PendingActionType` in lib/core/sync/action_queue.dart.
class PendingActions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get payload => text()();
  TextColumn get idempotencyKey => text()();
  TextColumn get occurredAt => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Client-side telemetry outbox — IDs and categorical values only, never
/// clinical free text (standing rule 6).
class TelemetryOutbox extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get props => text()();
  TextColumn get occurredAt => text()();
  BoolColumn get sent => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [ContentCacheRows, CachedTasks, PendingActions, TelemetryOutbox],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.open() : super(_openConnection());

  /// In-memory database for tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      return NativeDatabase.createInBackground(
        File('${dir.path}/hospital_ai.sqlite'),
      );
    });
  }
}
