// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientSession _$PatientSessionFromJson(Map<String, dynamic> json) =>
    _PatientSession(
      audience: json['audience'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      patientId: json['patientId'] as String,
      clinicId: json['clinicId'] as String,
    );

Map<String, dynamic> _$PatientSessionToJson(_PatientSession instance) =>
    <String, dynamic>{
      'audience': instance.audience,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'patientId': instance.patientId,
      'clinicId': instance.clinicId,
    };

_Clinic _$ClinicFromJson(Map<String, dynamic> json) => _Clinic(
  name: json['name'] as String,
  phone: json['phone'] as String,
  emergencyNumber: json['emergencyNumber'] as String?,
  workingHours: json['workingHours'] as String?,
  workingDays: json['workingDays'] as String?,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$ClinicToJson(_Clinic instance) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'emergencyNumber': instance.emergencyNumber,
  'workingHours': instance.workingHours,
  'workingDays': instance.workingDays,
  'timezone': instance.timezone,
};

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  name: json['name'] as String?,
  recoveryDay: (json['recoveryDay'] as num).toInt(),
  programmeDays: (json['programmeDays'] as num?)?.toInt(),
  language: json['language'] as String,
  procedureType: json['procedureType'] as String?,
  consentVersion: json['consentVersion'] as String?,
  clinic: json['clinic'] == null
      ? null
      : Clinic.fromJson(json['clinic'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'name': instance.name,
  'recoveryDay': instance.recoveryDay,
  'programmeDays': instance.programmeDays,
  'language': instance.language,
  'procedureType': instance.procedureType,
  'consentVersion': instance.consentVersion,
  'clinic': instance.clinic,
};

_PatientTask _$PatientTaskFromJson(Map<String, dynamic> json) => _PatientTask(
  id: json['id'] as String,
  taskType: json['taskType'] as String,
  contentRef: json['contentRef'] as String,
  scheduledFor: json['scheduledFor'] as String,
  windowClosesAt: json['windowClosesAt'] as String?,
  status: json['status'] as String,
  onTime: json['onTime'] as bool?,
);

Map<String, dynamic> _$PatientTaskToJson(_PatientTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskType': instance.taskType,
      'contentRef': instance.contentRef,
      'scheduledFor': instance.scheduledFor,
      'windowClosesAt': instance.windowClosesAt,
      'status': instance.status,
      'onTime': instance.onTime,
    };

_TodayResponse _$TodayResponseFromJson(Map<String, dynamic> json) =>
    _TodayResponse(
      recoveryDay: (json['recoveryDay'] as num).toInt(),
      groups: (json['groups'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => PatientTask.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      checkinDue: json['checkinDue'] as bool,
    );

Map<String, dynamic> _$TodayResponseToJson(_TodayResponse instance) =>
    <String, dynamic>{
      'recoveryDay': instance.recoveryDay,
      'groups': instance.groups,
      'checkinDue': instance.checkinDue,
    };

_Adherence _$AdherenceFromJson(Map<String, dynamic> json) => _Adherence(
  value: (json['value'] as num).toDouble(),
  numerator: (json['numerator'] as num).toInt(),
  denominator: (json['denominator'] as num).toInt(),
);

Map<String, dynamic> _$AdherenceToJson(_Adherence instance) =>
    <String, dynamic>{
      'value': instance.value,
      'numerator': instance.numerator,
      'denominator': instance.denominator,
    };

_PerDayAdherence _$PerDayAdherenceFromJson(Map<String, dynamic> json) =>
    _PerDayAdherence(
      recoveryDay: (json['recoveryDay'] as num).toInt(),
      value: (json['value'] as num).toDouble(),
      numerator: (json['numerator'] as num).toInt(),
      denominator: (json['denominator'] as num).toInt(),
    );

Map<String, dynamic> _$PerDayAdherenceToJson(_PerDayAdherence instance) =>
    <String, dynamic>{
      'recoveryDay': instance.recoveryDay,
      'value': instance.value,
      'numerator': instance.numerator,
      'denominator': instance.denominator,
    };

_ProgressResponse _$ProgressResponseFromJson(Map<String, dynamic> json) =>
    _ProgressResponse(
      adherence: Adherence.fromJson(json['adherence'] as Map<String, dynamic>),
      daysCompleted: (json['daysCompleted'] as num).toInt(),
      programmeDays: (json['programmeDays'] as num).toInt(),
      perDay:
          (json['perDay'] as List<dynamic>?)
              ?.map((e) => PerDayAdherence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PerDayAdherence>[],
    );

Map<String, dynamic> _$ProgressResponseToJson(_ProgressResponse instance) =>
    <String, dynamic>{
      'adherence': instance.adherence,
      'daysCompleted': instance.daysCompleted,
      'programmeDays': instance.programmeDays,
      'perDay': instance.perDay,
    };

_CheckinOption _$CheckinOptionFromJson(Map<String, dynamic> json) =>
    _CheckinOption(
      code: json['code'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$CheckinOptionToJson(_CheckinOption instance) =>
    <String, dynamic>{'code': instance.code, 'label': instance.label};

_CheckinScale _$CheckinScaleFromJson(Map<String, dynamic> json) =>
    _CheckinScale(
      min: (json['min'] as num).toInt(),
      max: (json['max'] as num).toInt(),
    );

Map<String, dynamic> _$CheckinScaleToJson(_CheckinScale instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

_CheckinQuestion _$CheckinQuestionFromJson(Map<String, dynamic> json) =>
    _CheckinQuestion(
      ref: json['ref'] as String,
      questionContentKey: json['questionContentKey'] as String,
      type: json['type'] as String,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => CheckinOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CheckinOption>[],
      scale: json['scale'] == null
          ? null
          : CheckinScale.fromJson(json['scale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckinQuestionToJson(_CheckinQuestion instance) =>
    <String, dynamic>{
      'ref': instance.ref,
      'questionContentKey': instance.questionContentKey,
      'type': instance.type,
      'options': instance.options,
      'scale': instance.scale,
    };

_CheckinResult _$CheckinResultFromJson(Map<String, dynamic> json) =>
    _CheckinResult(
      checkinId: json['checkinId'] as String,
      tier: json['tier'] as String,
      ruleVersion: json['ruleVersion'] as String,
      recoveryDay: (json['recoveryDay'] as num).toInt(),
      withinClinicHours: json['withinClinicHours'] as bool,
      contentKey: json['contentKey'] as String?,
      body: json['body'] as String?,
      escalationId: json['escalationId'] as String?,
    );

Map<String, dynamic> _$CheckinResultToJson(_CheckinResult instance) =>
    <String, dynamic>{
      'checkinId': instance.checkinId,
      'tier': instance.tier,
      'ruleVersion': instance.ruleVersion,
      'recoveryDay': instance.recoveryDay,
      'withinClinicHours': instance.withinClinicHours,
      'contentKey': instance.contentKey,
      'body': instance.body,
      'escalationId': instance.escalationId,
    };

_ContentItem _$ContentItemFromJson(Map<String, dynamic> json) => _ContentItem(
  contentKey: json['contentKey'] as String,
  language: json['language'] as String,
  text: json['text'] as String,
  version: (json['version'] as num).toInt(),
  isPlaceholder: json['isPlaceholder'] as bool? ?? false,
);

Map<String, dynamic> _$ContentItemToJson(_ContentItem instance) =>
    <String, dynamic>{
      'contentKey': instance.contentKey,
      'language': instance.language,
      'text': instance.text,
      'version': instance.version,
      'isPlaceholder': instance.isPlaceholder,
    };

_EducationItem _$EducationItemFromJson(Map<String, dynamic> json) =>
    _EducationItem(
      contentKey: json['contentKey'] as String,
      unlockDay: (json['unlockDay'] as num).toInt(),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$EducationItemToJson(_EducationItem instance) =>
    <String, dynamic>{
      'contentKey': instance.contentKey,
      'unlockDay': instance.unlockDay,
      'category': instance.category,
    };

_EducationIndex _$EducationIndexFromJson(Map<String, dynamic> json) =>
    _EducationIndex(
      category: json['category'] as String?,
      procedureType: json['procedureType'] as String?,
      recoveryDay: (json['recoveryDay'] as num).toInt(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => EducationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EducationItem>[],
    );

Map<String, dynamic> _$EducationIndexToJson(_EducationIndex instance) =>
    <String, dynamic>{
      'category': instance.category,
      'procedureType': instance.procedureType,
      'recoveryDay': instance.recoveryDay,
      'items': instance.items,
    };

_SurveyPayload _$SurveyPayloadFromJson(Map<String, dynamic> json) =>
    _SurveyPayload(
      q1Helpful: (json['q1Helpful'] as num?)?.toInt(),
      q2Easy: (json['q2Easy'] as num?)?.toInt(),
      q3AdherenceSupport: (json['q3AdherenceSupport'] as num?)?.toInt(),
      q4Recommend: (json['q4Recommend'] as num?)?.toInt(),
      freeText: json['freeText'] as String?,
    );

Map<String, dynamic> _$SurveyPayloadToJson(_SurveyPayload instance) =>
    <String, dynamic>{
      'q1Helpful': instance.q1Helpful,
      'q2Easy': instance.q2Easy,
      'q3AdherenceSupport': instance.q3AdherenceSupport,
      'q4Recommend': instance.q4Recommend,
      'freeText': instance.freeText,
    };

_LeaveResponse _$LeaveResponseFromJson(Map<String, dynamic> json) =>
    _LeaveResponse(tasksStopped: (json['tasksStopped'] as num?)?.toInt());

Map<String, dynamic> _$LeaveResponseToJson(_LeaveResponse instance) =>
    <String, dynamic>{'tasksStopped': instance.tasksStopped};
