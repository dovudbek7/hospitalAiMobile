// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ContentCacheRowsTable extends ContentCacheRows
    with TableInfo<$ContentCacheRowsTable, ContentCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentCacheRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentKeyMeta = const VerificationMeta(
    'contentKey',
  );
  @override
  late final GeneratedColumn<String> contentKey = GeneratedColumn<String>(
    'content_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPlaceholderMeta = const VerificationMeta(
    'isPlaceholder',
  );
  @override
  late final GeneratedColumn<bool> isPlaceholder = GeneratedColumn<bool>(
    'is_placeholder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_placeholder" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<int> fetchedAt = GeneratedColumn<int>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentKey,
    language,
    version,
    body,
    isPlaceholder,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_cache_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_key')) {
      context.handle(
        _contentKeyMeta,
        contentKey.isAcceptableOrUnknown(data['content_key']!, _contentKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_contentKeyMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_placeholder')) {
      context.handle(
        _isPlaceholderMeta,
        isPlaceholder.isAcceptableOrUnknown(
          data['is_placeholder']!,
          _isPlaceholderMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentKey, language};
  @override
  ContentCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentCacheRow(
      contentKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_key'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      isPlaceholder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_placeholder'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $ContentCacheRowsTable createAlias(String alias) {
    return $ContentCacheRowsTable(attachedDatabase, alias);
  }
}

class ContentCacheRow extends DataClass implements Insertable<ContentCacheRow> {
  final String contentKey;
  final String language;
  final int version;
  final String body;
  final bool isPlaceholder;
  final int fetchedAt;
  const ContentCacheRow({
    required this.contentKey,
    required this.language,
    required this.version,
    required this.body,
    required this.isPlaceholder,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_key'] = Variable<String>(contentKey);
    map['language'] = Variable<String>(language);
    map['version'] = Variable<int>(version);
    map['body'] = Variable<String>(body);
    map['is_placeholder'] = Variable<bool>(isPlaceholder);
    map['fetched_at'] = Variable<int>(fetchedAt);
    return map;
  }

  ContentCacheRowsCompanion toCompanion(bool nullToAbsent) {
    return ContentCacheRowsCompanion(
      contentKey: Value(contentKey),
      language: Value(language),
      version: Value(version),
      body: Value(body),
      isPlaceholder: Value(isPlaceholder),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory ContentCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentCacheRow(
      contentKey: serializer.fromJson<String>(json['contentKey']),
      language: serializer.fromJson<String>(json['language']),
      version: serializer.fromJson<int>(json['version']),
      body: serializer.fromJson<String>(json['body']),
      isPlaceholder: serializer.fromJson<bool>(json['isPlaceholder']),
      fetchedAt: serializer.fromJson<int>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentKey': serializer.toJson<String>(contentKey),
      'language': serializer.toJson<String>(language),
      'version': serializer.toJson<int>(version),
      'body': serializer.toJson<String>(body),
      'isPlaceholder': serializer.toJson<bool>(isPlaceholder),
      'fetchedAt': serializer.toJson<int>(fetchedAt),
    };
  }

  ContentCacheRow copyWith({
    String? contentKey,
    String? language,
    int? version,
    String? body,
    bool? isPlaceholder,
    int? fetchedAt,
  }) => ContentCacheRow(
    contentKey: contentKey ?? this.contentKey,
    language: language ?? this.language,
    version: version ?? this.version,
    body: body ?? this.body,
    isPlaceholder: isPlaceholder ?? this.isPlaceholder,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  ContentCacheRow copyWithCompanion(ContentCacheRowsCompanion data) {
    return ContentCacheRow(
      contentKey: data.contentKey.present
          ? data.contentKey.value
          : this.contentKey,
      language: data.language.present ? data.language.value : this.language,
      version: data.version.present ? data.version.value : this.version,
      body: data.body.present ? data.body.value : this.body,
      isPlaceholder: data.isPlaceholder.present
          ? data.isPlaceholder.value
          : this.isPlaceholder,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentCacheRow(')
          ..write('contentKey: $contentKey, ')
          ..write('language: $language, ')
          ..write('version: $version, ')
          ..write('body: $body, ')
          ..write('isPlaceholder: $isPlaceholder, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentKey,
    language,
    version,
    body,
    isPlaceholder,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentCacheRow &&
          other.contentKey == this.contentKey &&
          other.language == this.language &&
          other.version == this.version &&
          other.body == this.body &&
          other.isPlaceholder == this.isPlaceholder &&
          other.fetchedAt == this.fetchedAt);
}

class ContentCacheRowsCompanion extends UpdateCompanion<ContentCacheRow> {
  final Value<String> contentKey;
  final Value<String> language;
  final Value<int> version;
  final Value<String> body;
  final Value<bool> isPlaceholder;
  final Value<int> fetchedAt;
  final Value<int> rowid;
  const ContentCacheRowsCompanion({
    this.contentKey = const Value.absent(),
    this.language = const Value.absent(),
    this.version = const Value.absent(),
    this.body = const Value.absent(),
    this.isPlaceholder = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentCacheRowsCompanion.insert({
    required String contentKey,
    required String language,
    required int version,
    required String body,
    this.isPlaceholder = const Value.absent(),
    required int fetchedAt,
    this.rowid = const Value.absent(),
  }) : contentKey = Value(contentKey),
       language = Value(language),
       version = Value(version),
       body = Value(body),
       fetchedAt = Value(fetchedAt);
  static Insertable<ContentCacheRow> custom({
    Expression<String>? contentKey,
    Expression<String>? language,
    Expression<int>? version,
    Expression<String>? body,
    Expression<bool>? isPlaceholder,
    Expression<int>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentKey != null) 'content_key': contentKey,
      if (language != null) 'language': language,
      if (version != null) 'version': version,
      if (body != null) 'body': body,
      if (isPlaceholder != null) 'is_placeholder': isPlaceholder,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentCacheRowsCompanion copyWith({
    Value<String>? contentKey,
    Value<String>? language,
    Value<int>? version,
    Value<String>? body,
    Value<bool>? isPlaceholder,
    Value<int>? fetchedAt,
    Value<int>? rowid,
  }) {
    return ContentCacheRowsCompanion(
      contentKey: contentKey ?? this.contentKey,
      language: language ?? this.language,
      version: version ?? this.version,
      body: body ?? this.body,
      isPlaceholder: isPlaceholder ?? this.isPlaceholder,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentKey.present) {
      map['content_key'] = Variable<String>(contentKey.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isPlaceholder.present) {
      map['is_placeholder'] = Variable<bool>(isPlaceholder.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<int>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentCacheRowsCompanion(')
          ..write('contentKey: $contentKey, ')
          ..write('language: $language, ')
          ..write('version: $version, ')
          ..write('body: $body, ')
          ..write('isPlaceholder: $isPlaceholder, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedTasksTable extends CachedTasks
    with TableInfo<$CachedTasksTable, CachedTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recoveryDayMeta = const VerificationMeta(
    'recoveryDay',
  );
  @override
  late final GeneratedColumn<int> recoveryDay = GeneratedColumn<int>(
    'recovery_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentRefMeta = const VerificationMeta(
    'contentRef',
  );
  @override
  late final GeneratedColumn<String> contentRef = GeneratedColumn<String>(
    'content_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledForMeta = const VerificationMeta(
    'scheduledFor',
  );
  @override
  late final GeneratedColumn<String> scheduledFor = GeneratedColumn<String>(
    'scheduled_for',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowClosesAtMeta = const VerificationMeta(
    'windowClosesAt',
  );
  @override
  late final GeneratedColumn<String> windowClosesAt = GeneratedColumn<String>(
    'window_closes_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onTimeMeta = const VerificationMeta('onTime');
  @override
  late final GeneratedColumn<bool> onTime = GeneratedColumn<bool>(
    'on_time',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("on_time" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recoveryDay,
    taskType,
    contentRef,
    scheduledFor,
    windowClosesAt,
    status,
    onTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recovery_day')) {
      context.handle(
        _recoveryDayMeta,
        recoveryDay.isAcceptableOrUnknown(
          data['recovery_day']!,
          _recoveryDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recoveryDayMeta);
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTypeMeta);
    }
    if (data.containsKey('content_ref')) {
      context.handle(
        _contentRefMeta,
        contentRef.isAcceptableOrUnknown(data['content_ref']!, _contentRefMeta),
      );
    } else if (isInserting) {
      context.missing(_contentRefMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
        _scheduledForMeta,
        scheduledFor.isAcceptableOrUnknown(
          data['scheduled_for']!,
          _scheduledForMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledForMeta);
    }
    if (data.containsKey('window_closes_at')) {
      context.handle(
        _windowClosesAtMeta,
        windowClosesAt.isAcceptableOrUnknown(
          data['window_closes_at']!,
          _windowClosesAtMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('on_time')) {
      context.handle(
        _onTimeMeta,
        onTime.isAcceptableOrUnknown(data['on_time']!, _onTimeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recoveryDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recovery_day'],
      )!,
      taskType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_type'],
      )!,
      contentRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_ref'],
      )!,
      scheduledFor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_for'],
      )!,
      windowClosesAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}window_closes_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      onTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}on_time'],
      ),
    );
  }

  @override
  $CachedTasksTable createAlias(String alias) {
    return $CachedTasksTable(attachedDatabase, alias);
  }
}

class CachedTask extends DataClass implements Insertable<CachedTask> {
  final String id;
  final int recoveryDay;
  final String taskType;
  final String contentRef;
  final String scheduledFor;
  final String? windowClosesAt;
  final String status;
  final bool? onTime;
  const CachedTask({
    required this.id,
    required this.recoveryDay,
    required this.taskType,
    required this.contentRef,
    required this.scheduledFor,
    this.windowClosesAt,
    required this.status,
    this.onTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recovery_day'] = Variable<int>(recoveryDay);
    map['task_type'] = Variable<String>(taskType);
    map['content_ref'] = Variable<String>(contentRef);
    map['scheduled_for'] = Variable<String>(scheduledFor);
    if (!nullToAbsent || windowClosesAt != null) {
      map['window_closes_at'] = Variable<String>(windowClosesAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || onTime != null) {
      map['on_time'] = Variable<bool>(onTime);
    }
    return map;
  }

  CachedTasksCompanion toCompanion(bool nullToAbsent) {
    return CachedTasksCompanion(
      id: Value(id),
      recoveryDay: Value(recoveryDay),
      taskType: Value(taskType),
      contentRef: Value(contentRef),
      scheduledFor: Value(scheduledFor),
      windowClosesAt: windowClosesAt == null && nullToAbsent
          ? const Value.absent()
          : Value(windowClosesAt),
      status: Value(status),
      onTime: onTime == null && nullToAbsent
          ? const Value.absent()
          : Value(onTime),
    );
  }

  factory CachedTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTask(
      id: serializer.fromJson<String>(json['id']),
      recoveryDay: serializer.fromJson<int>(json['recoveryDay']),
      taskType: serializer.fromJson<String>(json['taskType']),
      contentRef: serializer.fromJson<String>(json['contentRef']),
      scheduledFor: serializer.fromJson<String>(json['scheduledFor']),
      windowClosesAt: serializer.fromJson<String?>(json['windowClosesAt']),
      status: serializer.fromJson<String>(json['status']),
      onTime: serializer.fromJson<bool?>(json['onTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recoveryDay': serializer.toJson<int>(recoveryDay),
      'taskType': serializer.toJson<String>(taskType),
      'contentRef': serializer.toJson<String>(contentRef),
      'scheduledFor': serializer.toJson<String>(scheduledFor),
      'windowClosesAt': serializer.toJson<String?>(windowClosesAt),
      'status': serializer.toJson<String>(status),
      'onTime': serializer.toJson<bool?>(onTime),
    };
  }

  CachedTask copyWith({
    String? id,
    int? recoveryDay,
    String? taskType,
    String? contentRef,
    String? scheduledFor,
    Value<String?> windowClosesAt = const Value.absent(),
    String? status,
    Value<bool?> onTime = const Value.absent(),
  }) => CachedTask(
    id: id ?? this.id,
    recoveryDay: recoveryDay ?? this.recoveryDay,
    taskType: taskType ?? this.taskType,
    contentRef: contentRef ?? this.contentRef,
    scheduledFor: scheduledFor ?? this.scheduledFor,
    windowClosesAt: windowClosesAt.present
        ? windowClosesAt.value
        : this.windowClosesAt,
    status: status ?? this.status,
    onTime: onTime.present ? onTime.value : this.onTime,
  );
  CachedTask copyWithCompanion(CachedTasksCompanion data) {
    return CachedTask(
      id: data.id.present ? data.id.value : this.id,
      recoveryDay: data.recoveryDay.present
          ? data.recoveryDay.value
          : this.recoveryDay,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      contentRef: data.contentRef.present
          ? data.contentRef.value
          : this.contentRef,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      windowClosesAt: data.windowClosesAt.present
          ? data.windowClosesAt.value
          : this.windowClosesAt,
      status: data.status.present ? data.status.value : this.status,
      onTime: data.onTime.present ? data.onTime.value : this.onTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTask(')
          ..write('id: $id, ')
          ..write('recoveryDay: $recoveryDay, ')
          ..write('taskType: $taskType, ')
          ..write('contentRef: $contentRef, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('windowClosesAt: $windowClosesAt, ')
          ..write('status: $status, ')
          ..write('onTime: $onTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recoveryDay,
    taskType,
    contentRef,
    scheduledFor,
    windowClosesAt,
    status,
    onTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTask &&
          other.id == this.id &&
          other.recoveryDay == this.recoveryDay &&
          other.taskType == this.taskType &&
          other.contentRef == this.contentRef &&
          other.scheduledFor == this.scheduledFor &&
          other.windowClosesAt == this.windowClosesAt &&
          other.status == this.status &&
          other.onTime == this.onTime);
}

class CachedTasksCompanion extends UpdateCompanion<CachedTask> {
  final Value<String> id;
  final Value<int> recoveryDay;
  final Value<String> taskType;
  final Value<String> contentRef;
  final Value<String> scheduledFor;
  final Value<String?> windowClosesAt;
  final Value<String> status;
  final Value<bool?> onTime;
  final Value<int> rowid;
  const CachedTasksCompanion({
    this.id = const Value.absent(),
    this.recoveryDay = const Value.absent(),
    this.taskType = const Value.absent(),
    this.contentRef = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.windowClosesAt = const Value.absent(),
    this.status = const Value.absent(),
    this.onTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTasksCompanion.insert({
    required String id,
    required int recoveryDay,
    required String taskType,
    required String contentRef,
    required String scheduledFor,
    this.windowClosesAt = const Value.absent(),
    required String status,
    this.onTime = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recoveryDay = Value(recoveryDay),
       taskType = Value(taskType),
       contentRef = Value(contentRef),
       scheduledFor = Value(scheduledFor),
       status = Value(status);
  static Insertable<CachedTask> custom({
    Expression<String>? id,
    Expression<int>? recoveryDay,
    Expression<String>? taskType,
    Expression<String>? contentRef,
    Expression<String>? scheduledFor,
    Expression<String>? windowClosesAt,
    Expression<String>? status,
    Expression<bool>? onTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recoveryDay != null) 'recovery_day': recoveryDay,
      if (taskType != null) 'task_type': taskType,
      if (contentRef != null) 'content_ref': contentRef,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (windowClosesAt != null) 'window_closes_at': windowClosesAt,
      if (status != null) 'status': status,
      if (onTime != null) 'on_time': onTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTasksCompanion copyWith({
    Value<String>? id,
    Value<int>? recoveryDay,
    Value<String>? taskType,
    Value<String>? contentRef,
    Value<String>? scheduledFor,
    Value<String?>? windowClosesAt,
    Value<String>? status,
    Value<bool?>? onTime,
    Value<int>? rowid,
  }) {
    return CachedTasksCompanion(
      id: id ?? this.id,
      recoveryDay: recoveryDay ?? this.recoveryDay,
      taskType: taskType ?? this.taskType,
      contentRef: contentRef ?? this.contentRef,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      windowClosesAt: windowClosesAt ?? this.windowClosesAt,
      status: status ?? this.status,
      onTime: onTime ?? this.onTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recoveryDay.present) {
      map['recovery_day'] = Variable<int>(recoveryDay.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (contentRef.present) {
      map['content_ref'] = Variable<String>(contentRef.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<String>(scheduledFor.value);
    }
    if (windowClosesAt.present) {
      map['window_closes_at'] = Variable<String>(windowClosesAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (onTime.present) {
      map['on_time'] = Variable<bool>(onTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedTasksCompanion(')
          ..write('id: $id, ')
          ..write('recoveryDay: $recoveryDay, ')
          ..write('taskType: $taskType, ')
          ..write('contentRef: $contentRef, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('windowClosesAt: $windowClosesAt, ')
          ..write('status: $status, ')
          ..write('onTime: $onTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingActionsTable extends PendingActions
    with TableInfo<$PendingActionsTable, PendingAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<String> occurredAt = GeneratedColumn<String>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    payload,
    idempotencyKey,
    occurredAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurred_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $PendingActionsTable createAlias(String alias) {
    return $PendingActionsTable(attachedDatabase, alias);
  }
}

class PendingAction extends DataClass implements Insertable<PendingAction> {
  final String id;
  final String type;
  final String payload;
  final String idempotencyKey;
  final String occurredAt;
  final int attempts;
  final String? lastError;
  const PendingAction({
    required this.id,
    required this.type,
    required this.payload,
    required this.idempotencyKey,
    required this.occurredAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['payload'] = Variable<String>(payload);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['occurred_at'] = Variable<String>(occurredAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  PendingActionsCompanion toCompanion(bool nullToAbsent) {
    return PendingActionsCompanion(
      id: Value(id),
      type: Value(type),
      payload: Value(payload),
      idempotencyKey: Value(idempotencyKey),
      occurredAt: Value(occurredAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory PendingAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingAction(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      payload: serializer.fromJson<String>(json['payload']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      occurredAt: serializer.fromJson<String>(json['occurredAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'payload': serializer.toJson<String>(payload),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'occurredAt': serializer.toJson<String>(occurredAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  PendingAction copyWith({
    String? id,
    String? type,
    String? payload,
    String? idempotencyKey,
    String? occurredAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => PendingAction(
    id: id ?? this.id,
    type: type ?? this.type,
    payload: payload ?? this.payload,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    occurredAt: occurredAt ?? this.occurredAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  PendingAction copyWithCompanion(PendingActionsCompanion data) {
    return PendingAction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingAction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    payload,
    idempotencyKey,
    occurredAt,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingAction &&
          other.id == this.id &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.idempotencyKey == this.idempotencyKey &&
          other.occurredAt == this.occurredAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class PendingActionsCompanion extends UpdateCompanion<PendingAction> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> payload;
  final Value<String> idempotencyKey;
  final Value<String> occurredAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> rowid;
  const PendingActionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingActionsCompanion.insert({
    required String id,
    required String type,
    required String payload,
    required String idempotencyKey,
    required String occurredAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       payload = Value(payload),
       idempotencyKey = Value(idempotencyKey),
       occurredAt = Value(occurredAt);
  static Insertable<PendingAction> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? payload,
    Expression<String>? idempotencyKey,
    Expression<String>? occurredAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingActionsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? payload,
    Value<String>? idempotencyKey,
    Value<String>? occurredAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return PendingActionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      occurredAt: occurredAt ?? this.occurredAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<String>(occurredAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingActionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TelemetryOutboxTable extends TelemetryOutbox
    with TableInfo<$TelemetryOutboxTable, TelemetryOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelemetryOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propsMeta = const VerificationMeta('props');
  @override
  late final GeneratedColumn<String> props = GeneratedColumn<String>(
    'props',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<String> occurredAt = GeneratedColumn<String>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentMeta = const VerificationMeta('sent');
  @override
  late final GeneratedColumn<bool> sent = GeneratedColumn<bool>(
    'sent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, props, occurredAt, sent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telemetry_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<TelemetryOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('props')) {
      context.handle(
        _propsMeta,
        props.isAcceptableOrUnknown(data['props']!, _propsMeta),
      );
    } else if (isInserting) {
      context.missing(_propsMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('sent')) {
      context.handle(
        _sentMeta,
        sent.isAcceptableOrUnknown(data['sent']!, _sentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TelemetryOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelemetryOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      props: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}props'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurred_at'],
      )!,
      sent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sent'],
      )!,
    );
  }

  @override
  $TelemetryOutboxTable createAlias(String alias) {
    return $TelemetryOutboxTable(attachedDatabase, alias);
  }
}

class TelemetryOutboxData extends DataClass
    implements Insertable<TelemetryOutboxData> {
  final String id;
  final String name;
  final String props;
  final String occurredAt;
  final bool sent;
  const TelemetryOutboxData({
    required this.id,
    required this.name,
    required this.props,
    required this.occurredAt,
    required this.sent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['props'] = Variable<String>(props);
    map['occurred_at'] = Variable<String>(occurredAt);
    map['sent'] = Variable<bool>(sent);
    return map;
  }

  TelemetryOutboxCompanion toCompanion(bool nullToAbsent) {
    return TelemetryOutboxCompanion(
      id: Value(id),
      name: Value(name),
      props: Value(props),
      occurredAt: Value(occurredAt),
      sent: Value(sent),
    );
  }

  factory TelemetryOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelemetryOutboxData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      props: serializer.fromJson<String>(json['props']),
      occurredAt: serializer.fromJson<String>(json['occurredAt']),
      sent: serializer.fromJson<bool>(json['sent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'props': serializer.toJson<String>(props),
      'occurredAt': serializer.toJson<String>(occurredAt),
      'sent': serializer.toJson<bool>(sent),
    };
  }

  TelemetryOutboxData copyWith({
    String? id,
    String? name,
    String? props,
    String? occurredAt,
    bool? sent,
  }) => TelemetryOutboxData(
    id: id ?? this.id,
    name: name ?? this.name,
    props: props ?? this.props,
    occurredAt: occurredAt ?? this.occurredAt,
    sent: sent ?? this.sent,
  );
  TelemetryOutboxData copyWithCompanion(TelemetryOutboxCompanion data) {
    return TelemetryOutboxData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      props: data.props.present ? data.props.value : this.props,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      sent: data.sent.present ? data.sent.value : this.sent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelemetryOutboxData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('props: $props, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sent: $sent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, props, occurredAt, sent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelemetryOutboxData &&
          other.id == this.id &&
          other.name == this.name &&
          other.props == this.props &&
          other.occurredAt == this.occurredAt &&
          other.sent == this.sent);
}

class TelemetryOutboxCompanion extends UpdateCompanion<TelemetryOutboxData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> props;
  final Value<String> occurredAt;
  final Value<bool> sent;
  final Value<int> rowid;
  const TelemetryOutboxCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.props = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.sent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TelemetryOutboxCompanion.insert({
    required String id,
    required String name,
    required String props,
    required String occurredAt,
    this.sent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       props = Value(props),
       occurredAt = Value(occurredAt);
  static Insertable<TelemetryOutboxData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? props,
    Expression<String>? occurredAt,
    Expression<bool>? sent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (props != null) 'props': props,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (sent != null) 'sent': sent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TelemetryOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? props,
    Value<String>? occurredAt,
    Value<bool>? sent,
    Value<int>? rowid,
  }) {
    return TelemetryOutboxCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      props: props ?? this.props,
      occurredAt: occurredAt ?? this.occurredAt,
      sent: sent ?? this.sent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (props.present) {
      map['props'] = Variable<String>(props.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<String>(occurredAt.value);
    }
    if (sent.present) {
      map['sent'] = Variable<bool>(sent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelemetryOutboxCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('props: $props, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sent: $sent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContentCacheRowsTable contentCacheRows = $ContentCacheRowsTable(
    this,
  );
  late final $CachedTasksTable cachedTasks = $CachedTasksTable(this);
  late final $PendingActionsTable pendingActions = $PendingActionsTable(this);
  late final $TelemetryOutboxTable telemetryOutbox = $TelemetryOutboxTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contentCacheRows,
    cachedTasks,
    pendingActions,
    telemetryOutbox,
  ];
}

typedef $$ContentCacheRowsTableCreateCompanionBuilder =
    ContentCacheRowsCompanion Function({
      required String contentKey,
      required String language,
      required int version,
      required String body,
      Value<bool> isPlaceholder,
      required int fetchedAt,
      Value<int> rowid,
    });
typedef $$ContentCacheRowsTableUpdateCompanionBuilder =
    ContentCacheRowsCompanion Function({
      Value<String> contentKey,
      Value<String> language,
      Value<int> version,
      Value<String> body,
      Value<bool> isPlaceholder,
      Value<int> fetchedAt,
      Value<int> rowid,
    });

class $$ContentCacheRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentCacheRowsTable> {
  $$ContentCacheRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentKey => $composableBuilder(
    column: $table.contentKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPlaceholder => $composableBuilder(
    column: $table.isPlaceholder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentCacheRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentCacheRowsTable> {
  $$ContentCacheRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentKey => $composableBuilder(
    column: $table.contentKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPlaceholder => $composableBuilder(
    column: $table.isPlaceholder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentCacheRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentCacheRowsTable> {
  $$ContentCacheRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentKey => $composableBuilder(
    column: $table.contentKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isPlaceholder => $composableBuilder(
    column: $table.isPlaceholder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$ContentCacheRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentCacheRowsTable,
          ContentCacheRow,
          $$ContentCacheRowsTableFilterComposer,
          $$ContentCacheRowsTableOrderingComposer,
          $$ContentCacheRowsTableAnnotationComposer,
          $$ContentCacheRowsTableCreateCompanionBuilder,
          $$ContentCacheRowsTableUpdateCompanionBuilder,
          (
            ContentCacheRow,
            BaseReferences<
              _$AppDatabase,
              $ContentCacheRowsTable,
              ContentCacheRow
            >,
          ),
          ContentCacheRow,
          PrefetchHooks Function()
        > {
  $$ContentCacheRowsTableTableManager(
    _$AppDatabase db,
    $ContentCacheRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentCacheRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentCacheRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentCacheRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentKey = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isPlaceholder = const Value.absent(),
                Value<int> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentCacheRowsCompanion(
                contentKey: contentKey,
                language: language,
                version: version,
                body: body,
                isPlaceholder: isPlaceholder,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentKey,
                required String language,
                required int version,
                required String body,
                Value<bool> isPlaceholder = const Value.absent(),
                required int fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => ContentCacheRowsCompanion.insert(
                contentKey: contentKey,
                language: language,
                version: version,
                body: body,
                isPlaceholder: isPlaceholder,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentCacheRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentCacheRowsTable,
      ContentCacheRow,
      $$ContentCacheRowsTableFilterComposer,
      $$ContentCacheRowsTableOrderingComposer,
      $$ContentCacheRowsTableAnnotationComposer,
      $$ContentCacheRowsTableCreateCompanionBuilder,
      $$ContentCacheRowsTableUpdateCompanionBuilder,
      (
        ContentCacheRow,
        BaseReferences<_$AppDatabase, $ContentCacheRowsTable, ContentCacheRow>,
      ),
      ContentCacheRow,
      PrefetchHooks Function()
    >;
typedef $$CachedTasksTableCreateCompanionBuilder =
    CachedTasksCompanion Function({
      required String id,
      required int recoveryDay,
      required String taskType,
      required String contentRef,
      required String scheduledFor,
      Value<String?> windowClosesAt,
      required String status,
      Value<bool?> onTime,
      Value<int> rowid,
    });
typedef $$CachedTasksTableUpdateCompanionBuilder =
    CachedTasksCompanion Function({
      Value<String> id,
      Value<int> recoveryDay,
      Value<String> taskType,
      Value<String> contentRef,
      Value<String> scheduledFor,
      Value<String?> windowClosesAt,
      Value<String> status,
      Value<bool?> onTime,
      Value<int> rowid,
    });

class $$CachedTasksTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTasksTable> {
  $$CachedTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recoveryDay => $composableBuilder(
    column: $table.recoveryDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentRef => $composableBuilder(
    column: $table.contentRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windowClosesAt => $composableBuilder(
    column: $table.windowClosesAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onTime => $composableBuilder(
    column: $table.onTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTasksTable> {
  $$CachedTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recoveryDay => $composableBuilder(
    column: $table.recoveryDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentRef => $composableBuilder(
    column: $table.contentRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windowClosesAt => $composableBuilder(
    column: $table.windowClosesAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onTime => $composableBuilder(
    column: $table.onTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTasksTable> {
  $$CachedTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recoveryDay => $composableBuilder(
    column: $table.recoveryDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<String> get contentRef => $composableBuilder(
    column: $table.contentRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get windowClosesAt => $composableBuilder(
    column: $table.windowClosesAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get onTime =>
      $composableBuilder(column: $table.onTime, builder: (column) => column);
}

class $$CachedTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTasksTable,
          CachedTask,
          $$CachedTasksTableFilterComposer,
          $$CachedTasksTableOrderingComposer,
          $$CachedTasksTableAnnotationComposer,
          $$CachedTasksTableCreateCompanionBuilder,
          $$CachedTasksTableUpdateCompanionBuilder,
          (
            CachedTask,
            BaseReferences<_$AppDatabase, $CachedTasksTable, CachedTask>,
          ),
          CachedTask,
          PrefetchHooks Function()
        > {
  $$CachedTasksTableTableManager(_$AppDatabase db, $CachedTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> recoveryDay = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<String> contentRef = const Value.absent(),
                Value<String> scheduledFor = const Value.absent(),
                Value<String?> windowClosesAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool?> onTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTasksCompanion(
                id: id,
                recoveryDay: recoveryDay,
                taskType: taskType,
                contentRef: contentRef,
                scheduledFor: scheduledFor,
                windowClosesAt: windowClosesAt,
                status: status,
                onTime: onTime,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int recoveryDay,
                required String taskType,
                required String contentRef,
                required String scheduledFor,
                Value<String?> windowClosesAt = const Value.absent(),
                required String status,
                Value<bool?> onTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTasksCompanion.insert(
                id: id,
                recoveryDay: recoveryDay,
                taskType: taskType,
                contentRef: contentRef,
                scheduledFor: scheduledFor,
                windowClosesAt: windowClosesAt,
                status: status,
                onTime: onTime,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTasksTable,
      CachedTask,
      $$CachedTasksTableFilterComposer,
      $$CachedTasksTableOrderingComposer,
      $$CachedTasksTableAnnotationComposer,
      $$CachedTasksTableCreateCompanionBuilder,
      $$CachedTasksTableUpdateCompanionBuilder,
      (
        CachedTask,
        BaseReferences<_$AppDatabase, $CachedTasksTable, CachedTask>,
      ),
      CachedTask,
      PrefetchHooks Function()
    >;
typedef $$PendingActionsTableCreateCompanionBuilder =
    PendingActionsCompanion Function({
      required String id,
      required String type,
      required String payload,
      required String idempotencyKey,
      required String occurredAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$PendingActionsTableUpdateCompanionBuilder =
    PendingActionsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> payload,
      Value<String> idempotencyKey,
      Value<String> occurredAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$PendingActionsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingActionsTable> {
  $$PendingActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingActionsTable> {
  $$PendingActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingActionsTable> {
  $$PendingActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$PendingActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingActionsTable,
          PendingAction,
          $$PendingActionsTableFilterComposer,
          $$PendingActionsTableOrderingComposer,
          $$PendingActionsTableAnnotationComposer,
          $$PendingActionsTableCreateCompanionBuilder,
          $$PendingActionsTableUpdateCompanionBuilder,
          (
            PendingAction,
            BaseReferences<_$AppDatabase, $PendingActionsTable, PendingAction>,
          ),
          PendingAction,
          PrefetchHooks Function()
        > {
  $$PendingActionsTableTableManager(
    _$AppDatabase db,
    $PendingActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> occurredAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingActionsCompanion(
                id: id,
                type: type,
                payload: payload,
                idempotencyKey: idempotencyKey,
                occurredAt: occurredAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String payload,
                required String idempotencyKey,
                required String occurredAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingActionsCompanion.insert(
                id: id,
                type: type,
                payload: payload,
                idempotencyKey: idempotencyKey,
                occurredAt: occurredAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingActionsTable,
      PendingAction,
      $$PendingActionsTableFilterComposer,
      $$PendingActionsTableOrderingComposer,
      $$PendingActionsTableAnnotationComposer,
      $$PendingActionsTableCreateCompanionBuilder,
      $$PendingActionsTableUpdateCompanionBuilder,
      (
        PendingAction,
        BaseReferences<_$AppDatabase, $PendingActionsTable, PendingAction>,
      ),
      PendingAction,
      PrefetchHooks Function()
    >;
typedef $$TelemetryOutboxTableCreateCompanionBuilder =
    TelemetryOutboxCompanion Function({
      required String id,
      required String name,
      required String props,
      required String occurredAt,
      Value<bool> sent,
      Value<int> rowid,
    });
typedef $$TelemetryOutboxTableUpdateCompanionBuilder =
    TelemetryOutboxCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> props,
      Value<String> occurredAt,
      Value<bool> sent,
      Value<int> rowid,
    });

class $$TelemetryOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $TelemetryOutboxTable> {
  $$TelemetryOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get props => $composableBuilder(
    column: $table.props,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sent => $composableBuilder(
    column: $table.sent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TelemetryOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $TelemetryOutboxTable> {
  $$TelemetryOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get props => $composableBuilder(
    column: $table.props,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sent => $composableBuilder(
    column: $table.sent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TelemetryOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelemetryOutboxTable> {
  $$TelemetryOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get props =>
      $composableBuilder(column: $table.props, builder: (column) => column);

  GeneratedColumn<String> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sent =>
      $composableBuilder(column: $table.sent, builder: (column) => column);
}

class $$TelemetryOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TelemetryOutboxTable,
          TelemetryOutboxData,
          $$TelemetryOutboxTableFilterComposer,
          $$TelemetryOutboxTableOrderingComposer,
          $$TelemetryOutboxTableAnnotationComposer,
          $$TelemetryOutboxTableCreateCompanionBuilder,
          $$TelemetryOutboxTableUpdateCompanionBuilder,
          (
            TelemetryOutboxData,
            BaseReferences<
              _$AppDatabase,
              $TelemetryOutboxTable,
              TelemetryOutboxData
            >,
          ),
          TelemetryOutboxData,
          PrefetchHooks Function()
        > {
  $$TelemetryOutboxTableTableManager(
    _$AppDatabase db,
    $TelemetryOutboxTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelemetryOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelemetryOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelemetryOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> props = const Value.absent(),
                Value<String> occurredAt = const Value.absent(),
                Value<bool> sent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelemetryOutboxCompanion(
                id: id,
                name: name,
                props: props,
                occurredAt: occurredAt,
                sent: sent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String props,
                required String occurredAt,
                Value<bool> sent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelemetryOutboxCompanion.insert(
                id: id,
                name: name,
                props: props,
                occurredAt: occurredAt,
                sent: sent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TelemetryOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TelemetryOutboxTable,
      TelemetryOutboxData,
      $$TelemetryOutboxTableFilterComposer,
      $$TelemetryOutboxTableOrderingComposer,
      $$TelemetryOutboxTableAnnotationComposer,
      $$TelemetryOutboxTableCreateCompanionBuilder,
      $$TelemetryOutboxTableUpdateCompanionBuilder,
      (
        TelemetryOutboxData,
        BaseReferences<
          _$AppDatabase,
          $TelemetryOutboxTable,
          TelemetryOutboxData
        >,
      ),
      TelemetryOutboxData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContentCacheRowsTableTableManager get contentCacheRows =>
      $$ContentCacheRowsTableTableManager(_db, _db.contentCacheRows);
  $$CachedTasksTableTableManager get cachedTasks =>
      $$CachedTasksTableTableManager(_db, _db.cachedTasks);
  $$PendingActionsTableTableManager get pendingActions =>
      $$PendingActionsTableTableManager(_db, _db.pendingActions);
  $$TelemetryOutboxTableTableManager get telemetryOutbox =>
      $$TelemetryOutboxTableTableManager(_db, _db.telemetryOutbox);
}
