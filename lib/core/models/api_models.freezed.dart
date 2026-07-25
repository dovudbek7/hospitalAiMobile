// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientSession {

 String get audience; String get accessToken; String get refreshToken; String get patientId; String get clinicId;
/// Create a copy of PatientSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientSessionCopyWith<PatientSession> get copyWith => _$PatientSessionCopyWithImpl<PatientSession>(this as PatientSession, _$identity);

  /// Serializes this PatientSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientSession&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,audience,accessToken,refreshToken,patientId,clinicId);

@override
String toString() {
  return 'PatientSession(audience: $audience, accessToken: $accessToken, refreshToken: $refreshToken, patientId: $patientId, clinicId: $clinicId)';
}


}

/// @nodoc
abstract mixin class $PatientSessionCopyWith<$Res>  {
  factory $PatientSessionCopyWith(PatientSession value, $Res Function(PatientSession) _then) = _$PatientSessionCopyWithImpl;
@useResult
$Res call({
 String audience, String accessToken, String refreshToken, String patientId, String clinicId
});




}
/// @nodoc
class _$PatientSessionCopyWithImpl<$Res>
    implements $PatientSessionCopyWith<$Res> {
  _$PatientSessionCopyWithImpl(this._self, this._then);

  final PatientSession _self;
  final $Res Function(PatientSession) _then;

/// Create a copy of PatientSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? audience = null,Object? accessToken = null,Object? refreshToken = null,Object? patientId = null,Object? clinicId = null,}) {
  return _then(_self.copyWith(
audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientSession].
extension PatientSessionPatterns on PatientSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientSession value)  $default,){
final _that = this;
switch (_that) {
case _PatientSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientSession value)?  $default,){
final _that = this;
switch (_that) {
case _PatientSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String audience,  String accessToken,  String refreshToken,  String patientId,  String clinicId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientSession() when $default != null:
return $default(_that.audience,_that.accessToken,_that.refreshToken,_that.patientId,_that.clinicId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String audience,  String accessToken,  String refreshToken,  String patientId,  String clinicId)  $default,) {final _that = this;
switch (_that) {
case _PatientSession():
return $default(_that.audience,_that.accessToken,_that.refreshToken,_that.patientId,_that.clinicId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String audience,  String accessToken,  String refreshToken,  String patientId,  String clinicId)?  $default,) {final _that = this;
switch (_that) {
case _PatientSession() when $default != null:
return $default(_that.audience,_that.accessToken,_that.refreshToken,_that.patientId,_that.clinicId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientSession implements PatientSession {
  const _PatientSession({required this.audience, required this.accessToken, required this.refreshToken, required this.patientId, required this.clinicId});
  factory _PatientSession.fromJson(Map<String, dynamic> json) => _$PatientSessionFromJson(json);

@override final  String audience;
@override final  String accessToken;
@override final  String refreshToken;
@override final  String patientId;
@override final  String clinicId;

/// Create a copy of PatientSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientSessionCopyWith<_PatientSession> get copyWith => __$PatientSessionCopyWithImpl<_PatientSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientSession&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,audience,accessToken,refreshToken,patientId,clinicId);

@override
String toString() {
  return 'PatientSession(audience: $audience, accessToken: $accessToken, refreshToken: $refreshToken, patientId: $patientId, clinicId: $clinicId)';
}


}

/// @nodoc
abstract mixin class _$PatientSessionCopyWith<$Res> implements $PatientSessionCopyWith<$Res> {
  factory _$PatientSessionCopyWith(_PatientSession value, $Res Function(_PatientSession) _then) = __$PatientSessionCopyWithImpl;
@override @useResult
$Res call({
 String audience, String accessToken, String refreshToken, String patientId, String clinicId
});




}
/// @nodoc
class __$PatientSessionCopyWithImpl<$Res>
    implements _$PatientSessionCopyWith<$Res> {
  __$PatientSessionCopyWithImpl(this._self, this._then);

  final _PatientSession _self;
  final $Res Function(_PatientSession) _then;

/// Create a copy of PatientSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? audience = null,Object? accessToken = null,Object? refreshToken = null,Object? patientId = null,Object? clinicId = null,}) {
  return _then(_PatientSession(
audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Clinic {

 String get name; String get phone; String? get emergencyNumber; String? get workingHours; String? get workingDays; String? get timezone;
/// Create a copy of Clinic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClinicCopyWith<Clinic> get copyWith => _$ClinicCopyWithImpl<Clinic>(this as Clinic, _$identity);

  /// Serializes this Clinic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Clinic&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.emergencyNumber, emergencyNumber) || other.emergencyNumber == emergencyNumber)&&(identical(other.workingHours, workingHours) || other.workingHours == workingHours)&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,emergencyNumber,workingHours,workingDays,timezone);

@override
String toString() {
  return 'Clinic(name: $name, phone: $phone, emergencyNumber: $emergencyNumber, workingHours: $workingHours, workingDays: $workingDays, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $ClinicCopyWith<$Res>  {
  factory $ClinicCopyWith(Clinic value, $Res Function(Clinic) _then) = _$ClinicCopyWithImpl;
@useResult
$Res call({
 String name, String phone, String? emergencyNumber, String? workingHours, String? workingDays, String? timezone
});




}
/// @nodoc
class _$ClinicCopyWithImpl<$Res>
    implements $ClinicCopyWith<$Res> {
  _$ClinicCopyWithImpl(this._self, this._then);

  final Clinic _self;
  final $Res Function(Clinic) _then;

/// Create a copy of Clinic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phone = null,Object? emergencyNumber = freezed,Object? workingHours = freezed,Object? workingDays = freezed,Object? timezone = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,emergencyNumber: freezed == emergencyNumber ? _self.emergencyNumber : emergencyNumber // ignore: cast_nullable_to_non_nullable
as String?,workingHours: freezed == workingHours ? _self.workingHours : workingHours // ignore: cast_nullable_to_non_nullable
as String?,workingDays: freezed == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Clinic].
extension ClinicPatterns on Clinic {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Clinic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Clinic() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Clinic value)  $default,){
final _that = this;
switch (_that) {
case _Clinic():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Clinic value)?  $default,){
final _that = this;
switch (_that) {
case _Clinic() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phone,  String? emergencyNumber,  String? workingHours,  String? workingDays,  String? timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Clinic() when $default != null:
return $default(_that.name,_that.phone,_that.emergencyNumber,_that.workingHours,_that.workingDays,_that.timezone);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phone,  String? emergencyNumber,  String? workingHours,  String? workingDays,  String? timezone)  $default,) {final _that = this;
switch (_that) {
case _Clinic():
return $default(_that.name,_that.phone,_that.emergencyNumber,_that.workingHours,_that.workingDays,_that.timezone);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phone,  String? emergencyNumber,  String? workingHours,  String? workingDays,  String? timezone)?  $default,) {final _that = this;
switch (_that) {
case _Clinic() when $default != null:
return $default(_that.name,_that.phone,_that.emergencyNumber,_that.workingHours,_that.workingDays,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Clinic implements Clinic {
  const _Clinic({required this.name, required this.phone, this.emergencyNumber, this.workingHours, this.workingDays, this.timezone});
  factory _Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);

@override final  String name;
@override final  String phone;
@override final  String? emergencyNumber;
@override final  String? workingHours;
@override final  String? workingDays;
@override final  String? timezone;

/// Create a copy of Clinic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClinicCopyWith<_Clinic> get copyWith => __$ClinicCopyWithImpl<_Clinic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClinicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Clinic&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.emergencyNumber, emergencyNumber) || other.emergencyNumber == emergencyNumber)&&(identical(other.workingHours, workingHours) || other.workingHours == workingHours)&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,emergencyNumber,workingHours,workingDays,timezone);

@override
String toString() {
  return 'Clinic(name: $name, phone: $phone, emergencyNumber: $emergencyNumber, workingHours: $workingHours, workingDays: $workingDays, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$ClinicCopyWith<$Res> implements $ClinicCopyWith<$Res> {
  factory _$ClinicCopyWith(_Clinic value, $Res Function(_Clinic) _then) = __$ClinicCopyWithImpl;
@override @useResult
$Res call({
 String name, String phone, String? emergencyNumber, String? workingHours, String? workingDays, String? timezone
});




}
/// @nodoc
class __$ClinicCopyWithImpl<$Res>
    implements _$ClinicCopyWith<$Res> {
  __$ClinicCopyWithImpl(this._self, this._then);

  final _Clinic _self;
  final $Res Function(_Clinic) _then;

/// Create a copy of Clinic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = null,Object? emergencyNumber = freezed,Object? workingHours = freezed,Object? workingDays = freezed,Object? timezone = freezed,}) {
  return _then(_Clinic(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,emergencyNumber: freezed == emergencyNumber ? _self.emergencyNumber : emergencyNumber // ignore: cast_nullable_to_non_nullable
as String?,workingHours: freezed == workingHours ? _self.workingHours : workingHours // ignore: cast_nullable_to_non_nullable
as String?,workingDays: freezed == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Profile {

 String? get name; int get recoveryDay; int? get programmeDays; String get language; String? get procedureType; String? get consentVersion; Clinic? get clinic;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.name, name) || other.name == name)&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&(identical(other.programmeDays, programmeDays) || other.programmeDays == programmeDays)&&(identical(other.language, language) || other.language == language)&&(identical(other.procedureType, procedureType) || other.procedureType == procedureType)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.clinic, clinic) || other.clinic == clinic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,recoveryDay,programmeDays,language,procedureType,consentVersion,clinic);

@override
String toString() {
  return 'Profile(name: $name, recoveryDay: $recoveryDay, programmeDays: $programmeDays, language: $language, procedureType: $procedureType, consentVersion: $consentVersion, clinic: $clinic)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String? name, int recoveryDay, int? programmeDays, String language, String? procedureType, String? consentVersion, Clinic? clinic
});


$ClinicCopyWith<$Res>? get clinic;

}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? recoveryDay = null,Object? programmeDays = freezed,Object? language = null,Object? procedureType = freezed,Object? consentVersion = freezed,Object? clinic = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,programmeDays: freezed == programmeDays ? _self.programmeDays : programmeDays // ignore: cast_nullable_to_non_nullable
as int?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,procedureType: freezed == procedureType ? _self.procedureType : procedureType // ignore: cast_nullable_to_non_nullable
as String?,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,clinic: freezed == clinic ? _self.clinic : clinic // ignore: cast_nullable_to_non_nullable
as Clinic?,
  ));
}
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClinicCopyWith<$Res>? get clinic {
    if (_self.clinic == null) {
    return null;
  }

  return $ClinicCopyWith<$Res>(_self.clinic!, (value) {
    return _then(_self.copyWith(clinic: value));
  });
}
}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  int recoveryDay,  int? programmeDays,  String language,  String? procedureType,  String? consentVersion,  Clinic? clinic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.recoveryDay,_that.programmeDays,_that.language,_that.procedureType,_that.consentVersion,_that.clinic);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  int recoveryDay,  int? programmeDays,  String language,  String? procedureType,  String? consentVersion,  Clinic? clinic)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.name,_that.recoveryDay,_that.programmeDays,_that.language,_that.procedureType,_that.consentVersion,_that.clinic);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  int recoveryDay,  int? programmeDays,  String language,  String? procedureType,  String? consentVersion,  Clinic? clinic)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.recoveryDay,_that.programmeDays,_that.language,_that.procedureType,_that.consentVersion,_that.clinic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({this.name, required this.recoveryDay, this.programmeDays, required this.language, this.procedureType, this.consentVersion, this.clinic});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String? name;
@override final  int recoveryDay;
@override final  int? programmeDays;
@override final  String language;
@override final  String? procedureType;
@override final  String? consentVersion;
@override final  Clinic? clinic;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.name, name) || other.name == name)&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&(identical(other.programmeDays, programmeDays) || other.programmeDays == programmeDays)&&(identical(other.language, language) || other.language == language)&&(identical(other.procedureType, procedureType) || other.procedureType == procedureType)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.clinic, clinic) || other.clinic == clinic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,recoveryDay,programmeDays,language,procedureType,consentVersion,clinic);

@override
String toString() {
  return 'Profile(name: $name, recoveryDay: $recoveryDay, programmeDays: $programmeDays, language: $language, procedureType: $procedureType, consentVersion: $consentVersion, clinic: $clinic)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String? name, int recoveryDay, int? programmeDays, String language, String? procedureType, String? consentVersion, Clinic? clinic
});


@override $ClinicCopyWith<$Res>? get clinic;

}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? recoveryDay = null,Object? programmeDays = freezed,Object? language = null,Object? procedureType = freezed,Object? consentVersion = freezed,Object? clinic = freezed,}) {
  return _then(_Profile(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,programmeDays: freezed == programmeDays ? _self.programmeDays : programmeDays // ignore: cast_nullable_to_non_nullable
as int?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,procedureType: freezed == procedureType ? _self.procedureType : procedureType // ignore: cast_nullable_to_non_nullable
as String?,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,clinic: freezed == clinic ? _self.clinic : clinic // ignore: cast_nullable_to_non_nullable
as Clinic?,
  ));
}

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClinicCopyWith<$Res>? get clinic {
    if (_self.clinic == null) {
    return null;
  }

  return $ClinicCopyWith<$Res>(_self.clinic!, (value) {
    return _then(_self.copyWith(clinic: value));
  });
}
}


/// @nodoc
mixin _$PatientTask {

 String get id; String get taskType; String get contentRef; String get scheduledFor; String? get windowClosesAt; String get status; bool? get onTime;
/// Create a copy of PatientTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientTaskCopyWith<PatientTask> get copyWith => _$PatientTaskCopyWithImpl<PatientTask>(this as PatientTask, _$identity);

  /// Serializes this PatientTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientTask&&(identical(other.id, id) || other.id == id)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.contentRef, contentRef) || other.contentRef == contentRef)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.windowClosesAt, windowClosesAt) || other.windowClosesAt == windowClosesAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.onTime, onTime) || other.onTime == onTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskType,contentRef,scheduledFor,windowClosesAt,status,onTime);

@override
String toString() {
  return 'PatientTask(id: $id, taskType: $taskType, contentRef: $contentRef, scheduledFor: $scheduledFor, windowClosesAt: $windowClosesAt, status: $status, onTime: $onTime)';
}


}

/// @nodoc
abstract mixin class $PatientTaskCopyWith<$Res>  {
  factory $PatientTaskCopyWith(PatientTask value, $Res Function(PatientTask) _then) = _$PatientTaskCopyWithImpl;
@useResult
$Res call({
 String id, String taskType, String contentRef, String scheduledFor, String? windowClosesAt, String status, bool? onTime
});




}
/// @nodoc
class _$PatientTaskCopyWithImpl<$Res>
    implements $PatientTaskCopyWith<$Res> {
  _$PatientTaskCopyWithImpl(this._self, this._then);

  final PatientTask _self;
  final $Res Function(PatientTask) _then;

/// Create a copy of PatientTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskType = null,Object? contentRef = null,Object? scheduledFor = null,Object? windowClosesAt = freezed,Object? status = null,Object? onTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,contentRef: null == contentRef ? _self.contentRef : contentRef // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as String,windowClosesAt: freezed == windowClosesAt ? _self.windowClosesAt : windowClosesAt // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,onTime: freezed == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientTask].
extension PatientTaskPatterns on PatientTask {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientTask() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientTask value)  $default,){
final _that = this;
switch (_that) {
case _PatientTask():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientTask value)?  $default,){
final _that = this;
switch (_that) {
case _PatientTask() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskType,  String contentRef,  String scheduledFor,  String? windowClosesAt,  String status,  bool? onTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientTask() when $default != null:
return $default(_that.id,_that.taskType,_that.contentRef,_that.scheduledFor,_that.windowClosesAt,_that.status,_that.onTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskType,  String contentRef,  String scheduledFor,  String? windowClosesAt,  String status,  bool? onTime)  $default,) {final _that = this;
switch (_that) {
case _PatientTask():
return $default(_that.id,_that.taskType,_that.contentRef,_that.scheduledFor,_that.windowClosesAt,_that.status,_that.onTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskType,  String contentRef,  String scheduledFor,  String? windowClosesAt,  String status,  bool? onTime)?  $default,) {final _that = this;
switch (_that) {
case _PatientTask() when $default != null:
return $default(_that.id,_that.taskType,_that.contentRef,_that.scheduledFor,_that.windowClosesAt,_that.status,_that.onTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientTask implements PatientTask {
  const _PatientTask({required this.id, required this.taskType, required this.contentRef, required this.scheduledFor, this.windowClosesAt, required this.status, this.onTime});
  factory _PatientTask.fromJson(Map<String, dynamic> json) => _$PatientTaskFromJson(json);

@override final  String id;
@override final  String taskType;
@override final  String contentRef;
@override final  String scheduledFor;
@override final  String? windowClosesAt;
@override final  String status;
@override final  bool? onTime;

/// Create a copy of PatientTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientTaskCopyWith<_PatientTask> get copyWith => __$PatientTaskCopyWithImpl<_PatientTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientTask&&(identical(other.id, id) || other.id == id)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.contentRef, contentRef) || other.contentRef == contentRef)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.windowClosesAt, windowClosesAt) || other.windowClosesAt == windowClosesAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.onTime, onTime) || other.onTime == onTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskType,contentRef,scheduledFor,windowClosesAt,status,onTime);

@override
String toString() {
  return 'PatientTask(id: $id, taskType: $taskType, contentRef: $contentRef, scheduledFor: $scheduledFor, windowClosesAt: $windowClosesAt, status: $status, onTime: $onTime)';
}


}

/// @nodoc
abstract mixin class _$PatientTaskCopyWith<$Res> implements $PatientTaskCopyWith<$Res> {
  factory _$PatientTaskCopyWith(_PatientTask value, $Res Function(_PatientTask) _then) = __$PatientTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskType, String contentRef, String scheduledFor, String? windowClosesAt, String status, bool? onTime
});




}
/// @nodoc
class __$PatientTaskCopyWithImpl<$Res>
    implements _$PatientTaskCopyWith<$Res> {
  __$PatientTaskCopyWithImpl(this._self, this._then);

  final _PatientTask _self;
  final $Res Function(_PatientTask) _then;

/// Create a copy of PatientTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskType = null,Object? contentRef = null,Object? scheduledFor = null,Object? windowClosesAt = freezed,Object? status = null,Object? onTime = freezed,}) {
  return _then(_PatientTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,contentRef: null == contentRef ? _self.contentRef : contentRef // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as String,windowClosesAt: freezed == windowClosesAt ? _self.windowClosesAt : windowClosesAt // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,onTime: freezed == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$TodayResponse {

 int get recoveryDay; Map<String, List<PatientTask>> get groups; bool get checkinDue;
/// Create a copy of TodayResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayResponseCopyWith<TodayResponse> get copyWith => _$TodayResponseCopyWithImpl<TodayResponse>(this as TodayResponse, _$identity);

  /// Serializes this TodayResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayResponse&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.checkinDue, checkinDue) || other.checkinDue == checkinDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recoveryDay,const DeepCollectionEquality().hash(groups),checkinDue);

@override
String toString() {
  return 'TodayResponse(recoveryDay: $recoveryDay, groups: $groups, checkinDue: $checkinDue)';
}


}

/// @nodoc
abstract mixin class $TodayResponseCopyWith<$Res>  {
  factory $TodayResponseCopyWith(TodayResponse value, $Res Function(TodayResponse) _then) = _$TodayResponseCopyWithImpl;
@useResult
$Res call({
 int recoveryDay, Map<String, List<PatientTask>> groups, bool checkinDue
});




}
/// @nodoc
class _$TodayResponseCopyWithImpl<$Res>
    implements $TodayResponseCopyWith<$Res> {
  _$TodayResponseCopyWithImpl(this._self, this._then);

  final TodayResponse _self;
  final $Res Function(TodayResponse) _then;

/// Create a copy of TodayResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recoveryDay = null,Object? groups = null,Object? checkinDue = null,}) {
  return _then(_self.copyWith(
recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as Map<String, List<PatientTask>>,checkinDue: null == checkinDue ? _self.checkinDue : checkinDue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayResponse].
extension TodayResponsePatterns on TodayResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayResponse value)  $default,){
final _that = this;
switch (_that) {
case _TodayResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TodayResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int recoveryDay,  Map<String, List<PatientTask>> groups,  bool checkinDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayResponse() when $default != null:
return $default(_that.recoveryDay,_that.groups,_that.checkinDue);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int recoveryDay,  Map<String, List<PatientTask>> groups,  bool checkinDue)  $default,) {final _that = this;
switch (_that) {
case _TodayResponse():
return $default(_that.recoveryDay,_that.groups,_that.checkinDue);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int recoveryDay,  Map<String, List<PatientTask>> groups,  bool checkinDue)?  $default,) {final _that = this;
switch (_that) {
case _TodayResponse() when $default != null:
return $default(_that.recoveryDay,_that.groups,_that.checkinDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodayResponse implements TodayResponse {
  const _TodayResponse({required this.recoveryDay, required final  Map<String, List<PatientTask>> groups, required this.checkinDue}): _groups = groups;
  factory _TodayResponse.fromJson(Map<String, dynamic> json) => _$TodayResponseFromJson(json);

@override final  int recoveryDay;
 final  Map<String, List<PatientTask>> _groups;
@override Map<String, List<PatientTask>> get groups {
  if (_groups is EqualUnmodifiableMapView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groups);
}

@override final  bool checkinDue;

/// Create a copy of TodayResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayResponseCopyWith<_TodayResponse> get copyWith => __$TodayResponseCopyWithImpl<_TodayResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayResponse&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&const DeepCollectionEquality().equals(other._groups, _groups)&&(identical(other.checkinDue, checkinDue) || other.checkinDue == checkinDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recoveryDay,const DeepCollectionEquality().hash(_groups),checkinDue);

@override
String toString() {
  return 'TodayResponse(recoveryDay: $recoveryDay, groups: $groups, checkinDue: $checkinDue)';
}


}

/// @nodoc
abstract mixin class _$TodayResponseCopyWith<$Res> implements $TodayResponseCopyWith<$Res> {
  factory _$TodayResponseCopyWith(_TodayResponse value, $Res Function(_TodayResponse) _then) = __$TodayResponseCopyWithImpl;
@override @useResult
$Res call({
 int recoveryDay, Map<String, List<PatientTask>> groups, bool checkinDue
});




}
/// @nodoc
class __$TodayResponseCopyWithImpl<$Res>
    implements _$TodayResponseCopyWith<$Res> {
  __$TodayResponseCopyWithImpl(this._self, this._then);

  final _TodayResponse _self;
  final $Res Function(_TodayResponse) _then;

/// Create a copy of TodayResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recoveryDay = null,Object? groups = null,Object? checkinDue = null,}) {
  return _then(_TodayResponse(
recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as Map<String, List<PatientTask>>,checkinDue: null == checkinDue ? _self.checkinDue : checkinDue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Adherence {

 double get value; int get numerator; int get denominator;
/// Create a copy of Adherence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceCopyWith<Adherence> get copyWith => _$AdherenceCopyWithImpl<Adherence>(this as Adherence, _$identity);

  /// Serializes this Adherence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Adherence&&(identical(other.value, value) || other.value == value)&&(identical(other.numerator, numerator) || other.numerator == numerator)&&(identical(other.denominator, denominator) || other.denominator == denominator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,numerator,denominator);

@override
String toString() {
  return 'Adherence(value: $value, numerator: $numerator, denominator: $denominator)';
}


}

/// @nodoc
abstract mixin class $AdherenceCopyWith<$Res>  {
  factory $AdherenceCopyWith(Adherence value, $Res Function(Adherence) _then) = _$AdherenceCopyWithImpl;
@useResult
$Res call({
 double value, int numerator, int denominator
});




}
/// @nodoc
class _$AdherenceCopyWithImpl<$Res>
    implements $AdherenceCopyWith<$Res> {
  _$AdherenceCopyWithImpl(this._self, this._then);

  final Adherence _self;
  final $Res Function(Adherence) _then;

/// Create a copy of Adherence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? numerator = null,Object? denominator = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,numerator: null == numerator ? _self.numerator : numerator // ignore: cast_nullable_to_non_nullable
as int,denominator: null == denominator ? _self.denominator : denominator // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Adherence].
extension AdherencePatterns on Adherence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Adherence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Adherence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Adherence value)  $default,){
final _that = this;
switch (_that) {
case _Adherence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Adherence value)?  $default,){
final _that = this;
switch (_that) {
case _Adherence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double value,  int numerator,  int denominator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Adherence() when $default != null:
return $default(_that.value,_that.numerator,_that.denominator);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double value,  int numerator,  int denominator)  $default,) {final _that = this;
switch (_that) {
case _Adherence():
return $default(_that.value,_that.numerator,_that.denominator);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double value,  int numerator,  int denominator)?  $default,) {final _that = this;
switch (_that) {
case _Adherence() when $default != null:
return $default(_that.value,_that.numerator,_that.denominator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Adherence implements Adherence {
  const _Adherence({required this.value, required this.numerator, required this.denominator});
  factory _Adherence.fromJson(Map<String, dynamic> json) => _$AdherenceFromJson(json);

@override final  double value;
@override final  int numerator;
@override final  int denominator;

/// Create a copy of Adherence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceCopyWith<_Adherence> get copyWith => __$AdherenceCopyWithImpl<_Adherence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Adherence&&(identical(other.value, value) || other.value == value)&&(identical(other.numerator, numerator) || other.numerator == numerator)&&(identical(other.denominator, denominator) || other.denominator == denominator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,numerator,denominator);

@override
String toString() {
  return 'Adherence(value: $value, numerator: $numerator, denominator: $denominator)';
}


}

/// @nodoc
abstract mixin class _$AdherenceCopyWith<$Res> implements $AdherenceCopyWith<$Res> {
  factory _$AdherenceCopyWith(_Adherence value, $Res Function(_Adherence) _then) = __$AdherenceCopyWithImpl;
@override @useResult
$Res call({
 double value, int numerator, int denominator
});




}
/// @nodoc
class __$AdherenceCopyWithImpl<$Res>
    implements _$AdherenceCopyWith<$Res> {
  __$AdherenceCopyWithImpl(this._self, this._then);

  final _Adherence _self;
  final $Res Function(_Adherence) _then;

/// Create a copy of Adherence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? numerator = null,Object? denominator = null,}) {
  return _then(_Adherence(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,numerator: null == numerator ? _self.numerator : numerator // ignore: cast_nullable_to_non_nullable
as int,denominator: null == denominator ? _self.denominator : denominator // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PerDayAdherence {

 int get recoveryDay; double get value; int get numerator; int get denominator;
/// Create a copy of PerDayAdherence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerDayAdherenceCopyWith<PerDayAdherence> get copyWith => _$PerDayAdherenceCopyWithImpl<PerDayAdherence>(this as PerDayAdherence, _$identity);

  /// Serializes this PerDayAdherence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerDayAdherence&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&(identical(other.value, value) || other.value == value)&&(identical(other.numerator, numerator) || other.numerator == numerator)&&(identical(other.denominator, denominator) || other.denominator == denominator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recoveryDay,value,numerator,denominator);

@override
String toString() {
  return 'PerDayAdherence(recoveryDay: $recoveryDay, value: $value, numerator: $numerator, denominator: $denominator)';
}


}

/// @nodoc
abstract mixin class $PerDayAdherenceCopyWith<$Res>  {
  factory $PerDayAdherenceCopyWith(PerDayAdherence value, $Res Function(PerDayAdherence) _then) = _$PerDayAdherenceCopyWithImpl;
@useResult
$Res call({
 int recoveryDay, double value, int numerator, int denominator
});




}
/// @nodoc
class _$PerDayAdherenceCopyWithImpl<$Res>
    implements $PerDayAdherenceCopyWith<$Res> {
  _$PerDayAdherenceCopyWithImpl(this._self, this._then);

  final PerDayAdherence _self;
  final $Res Function(PerDayAdherence) _then;

/// Create a copy of PerDayAdherence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recoveryDay = null,Object? value = null,Object? numerator = null,Object? denominator = null,}) {
  return _then(_self.copyWith(
recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,numerator: null == numerator ? _self.numerator : numerator // ignore: cast_nullable_to_non_nullable
as int,denominator: null == denominator ? _self.denominator : denominator // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PerDayAdherence].
extension PerDayAdherencePatterns on PerDayAdherence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerDayAdherence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerDayAdherence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerDayAdherence value)  $default,){
final _that = this;
switch (_that) {
case _PerDayAdherence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerDayAdherence value)?  $default,){
final _that = this;
switch (_that) {
case _PerDayAdherence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int recoveryDay,  double value,  int numerator,  int denominator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PerDayAdherence() when $default != null:
return $default(_that.recoveryDay,_that.value,_that.numerator,_that.denominator);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int recoveryDay,  double value,  int numerator,  int denominator)  $default,) {final _that = this;
switch (_that) {
case _PerDayAdherence():
return $default(_that.recoveryDay,_that.value,_that.numerator,_that.denominator);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int recoveryDay,  double value,  int numerator,  int denominator)?  $default,) {final _that = this;
switch (_that) {
case _PerDayAdherence() when $default != null:
return $default(_that.recoveryDay,_that.value,_that.numerator,_that.denominator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PerDayAdherence implements PerDayAdherence {
  const _PerDayAdherence({required this.recoveryDay, required this.value, required this.numerator, required this.denominator});
  factory _PerDayAdherence.fromJson(Map<String, dynamic> json) => _$PerDayAdherenceFromJson(json);

@override final  int recoveryDay;
@override final  double value;
@override final  int numerator;
@override final  int denominator;

/// Create a copy of PerDayAdherence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerDayAdherenceCopyWith<_PerDayAdherence> get copyWith => __$PerDayAdherenceCopyWithImpl<_PerDayAdherence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerDayAdherenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerDayAdherence&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&(identical(other.value, value) || other.value == value)&&(identical(other.numerator, numerator) || other.numerator == numerator)&&(identical(other.denominator, denominator) || other.denominator == denominator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recoveryDay,value,numerator,denominator);

@override
String toString() {
  return 'PerDayAdherence(recoveryDay: $recoveryDay, value: $value, numerator: $numerator, denominator: $denominator)';
}


}

/// @nodoc
abstract mixin class _$PerDayAdherenceCopyWith<$Res> implements $PerDayAdherenceCopyWith<$Res> {
  factory _$PerDayAdherenceCopyWith(_PerDayAdherence value, $Res Function(_PerDayAdherence) _then) = __$PerDayAdherenceCopyWithImpl;
@override @useResult
$Res call({
 int recoveryDay, double value, int numerator, int denominator
});




}
/// @nodoc
class __$PerDayAdherenceCopyWithImpl<$Res>
    implements _$PerDayAdherenceCopyWith<$Res> {
  __$PerDayAdherenceCopyWithImpl(this._self, this._then);

  final _PerDayAdherence _self;
  final $Res Function(_PerDayAdherence) _then;

/// Create a copy of PerDayAdherence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recoveryDay = null,Object? value = null,Object? numerator = null,Object? denominator = null,}) {
  return _then(_PerDayAdherence(
recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,numerator: null == numerator ? _self.numerator : numerator // ignore: cast_nullable_to_non_nullable
as int,denominator: null == denominator ? _self.denominator : denominator // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProgressResponse {

 Adherence get adherence; int get daysCompleted; int get programmeDays; List<PerDayAdherence> get perDay;
/// Create a copy of ProgressResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressResponseCopyWith<ProgressResponse> get copyWith => _$ProgressResponseCopyWithImpl<ProgressResponse>(this as ProgressResponse, _$identity);

  /// Serializes this ProgressResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressResponse&&(identical(other.adherence, adherence) || other.adherence == adherence)&&(identical(other.daysCompleted, daysCompleted) || other.daysCompleted == daysCompleted)&&(identical(other.programmeDays, programmeDays) || other.programmeDays == programmeDays)&&const DeepCollectionEquality().equals(other.perDay, perDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adherence,daysCompleted,programmeDays,const DeepCollectionEquality().hash(perDay));

@override
String toString() {
  return 'ProgressResponse(adherence: $adherence, daysCompleted: $daysCompleted, programmeDays: $programmeDays, perDay: $perDay)';
}


}

/// @nodoc
abstract mixin class $ProgressResponseCopyWith<$Res>  {
  factory $ProgressResponseCopyWith(ProgressResponse value, $Res Function(ProgressResponse) _then) = _$ProgressResponseCopyWithImpl;
@useResult
$Res call({
 Adherence adherence, int daysCompleted, int programmeDays, List<PerDayAdherence> perDay
});


$AdherenceCopyWith<$Res> get adherence;

}
/// @nodoc
class _$ProgressResponseCopyWithImpl<$Res>
    implements $ProgressResponseCopyWith<$Res> {
  _$ProgressResponseCopyWithImpl(this._self, this._then);

  final ProgressResponse _self;
  final $Res Function(ProgressResponse) _then;

/// Create a copy of ProgressResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adherence = null,Object? daysCompleted = null,Object? programmeDays = null,Object? perDay = null,}) {
  return _then(_self.copyWith(
adherence: null == adherence ? _self.adherence : adherence // ignore: cast_nullable_to_non_nullable
as Adherence,daysCompleted: null == daysCompleted ? _self.daysCompleted : daysCompleted // ignore: cast_nullable_to_non_nullable
as int,programmeDays: null == programmeDays ? _self.programmeDays : programmeDays // ignore: cast_nullable_to_non_nullable
as int,perDay: null == perDay ? _self.perDay : perDay // ignore: cast_nullable_to_non_nullable
as List<PerDayAdherence>,
  ));
}
/// Create a copy of ProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceCopyWith<$Res> get adherence {
  
  return $AdherenceCopyWith<$Res>(_self.adherence, (value) {
    return _then(_self.copyWith(adherence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressResponse].
extension ProgressResponsePatterns on ProgressResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProgressResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Adherence adherence,  int daysCompleted,  int programmeDays,  List<PerDayAdherence> perDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressResponse() when $default != null:
return $default(_that.adherence,_that.daysCompleted,_that.programmeDays,_that.perDay);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Adherence adherence,  int daysCompleted,  int programmeDays,  List<PerDayAdherence> perDay)  $default,) {final _that = this;
switch (_that) {
case _ProgressResponse():
return $default(_that.adherence,_that.daysCompleted,_that.programmeDays,_that.perDay);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Adherence adherence,  int daysCompleted,  int programmeDays,  List<PerDayAdherence> perDay)?  $default,) {final _that = this;
switch (_that) {
case _ProgressResponse() when $default != null:
return $default(_that.adherence,_that.daysCompleted,_that.programmeDays,_that.perDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressResponse implements ProgressResponse {
  const _ProgressResponse({required this.adherence, required this.daysCompleted, required this.programmeDays, final  List<PerDayAdherence> perDay = const <PerDayAdherence>[]}): _perDay = perDay;
  factory _ProgressResponse.fromJson(Map<String, dynamic> json) => _$ProgressResponseFromJson(json);

@override final  Adherence adherence;
@override final  int daysCompleted;
@override final  int programmeDays;
 final  List<PerDayAdherence> _perDay;
@override@JsonKey() List<PerDayAdherence> get perDay {
  if (_perDay is EqualUnmodifiableListView) return _perDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_perDay);
}


/// Create a copy of ProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressResponseCopyWith<_ProgressResponse> get copyWith => __$ProgressResponseCopyWithImpl<_ProgressResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressResponse&&(identical(other.adherence, adherence) || other.adherence == adherence)&&(identical(other.daysCompleted, daysCompleted) || other.daysCompleted == daysCompleted)&&(identical(other.programmeDays, programmeDays) || other.programmeDays == programmeDays)&&const DeepCollectionEquality().equals(other._perDay, _perDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adherence,daysCompleted,programmeDays,const DeepCollectionEquality().hash(_perDay));

@override
String toString() {
  return 'ProgressResponse(adherence: $adherence, daysCompleted: $daysCompleted, programmeDays: $programmeDays, perDay: $perDay)';
}


}

/// @nodoc
abstract mixin class _$ProgressResponseCopyWith<$Res> implements $ProgressResponseCopyWith<$Res> {
  factory _$ProgressResponseCopyWith(_ProgressResponse value, $Res Function(_ProgressResponse) _then) = __$ProgressResponseCopyWithImpl;
@override @useResult
$Res call({
 Adherence adherence, int daysCompleted, int programmeDays, List<PerDayAdherence> perDay
});


@override $AdherenceCopyWith<$Res> get adherence;

}
/// @nodoc
class __$ProgressResponseCopyWithImpl<$Res>
    implements _$ProgressResponseCopyWith<$Res> {
  __$ProgressResponseCopyWithImpl(this._self, this._then);

  final _ProgressResponse _self;
  final $Res Function(_ProgressResponse) _then;

/// Create a copy of ProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adherence = null,Object? daysCompleted = null,Object? programmeDays = null,Object? perDay = null,}) {
  return _then(_ProgressResponse(
adherence: null == adherence ? _self.adherence : adherence // ignore: cast_nullable_to_non_nullable
as Adherence,daysCompleted: null == daysCompleted ? _self.daysCompleted : daysCompleted // ignore: cast_nullable_to_non_nullable
as int,programmeDays: null == programmeDays ? _self.programmeDays : programmeDays // ignore: cast_nullable_to_non_nullable
as int,perDay: null == perDay ? _self._perDay : perDay // ignore: cast_nullable_to_non_nullable
as List<PerDayAdherence>,
  ));
}

/// Create a copy of ProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceCopyWith<$Res> get adherence {
  
  return $AdherenceCopyWith<$Res>(_self.adherence, (value) {
    return _then(_self.copyWith(adherence: value));
  });
}
}


/// @nodoc
mixin _$CheckinOption {

 String get code; String get label;
/// Create a copy of CheckinOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinOptionCopyWith<CheckinOption> get copyWith => _$CheckinOptionCopyWithImpl<CheckinOption>(this as CheckinOption, _$identity);

  /// Serializes this CheckinOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckinOption&&(identical(other.code, code) || other.code == code)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,label);

@override
String toString() {
  return 'CheckinOption(code: $code, label: $label)';
}


}

/// @nodoc
abstract mixin class $CheckinOptionCopyWith<$Res>  {
  factory $CheckinOptionCopyWith(CheckinOption value, $Res Function(CheckinOption) _then) = _$CheckinOptionCopyWithImpl;
@useResult
$Res call({
 String code, String label
});




}
/// @nodoc
class _$CheckinOptionCopyWithImpl<$Res>
    implements $CheckinOptionCopyWith<$Res> {
  _$CheckinOptionCopyWithImpl(this._self, this._then);

  final CheckinOption _self;
  final $Res Function(CheckinOption) _then;

/// Create a copy of CheckinOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? label = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckinOption].
extension CheckinOptionPatterns on CheckinOption {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckinOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckinOption() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckinOption value)  $default,){
final _that = this;
switch (_that) {
case _CheckinOption():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckinOption value)?  $default,){
final _that = this;
switch (_that) {
case _CheckinOption() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckinOption() when $default != null:
return $default(_that.code,_that.label);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String label)  $default,) {final _that = this;
switch (_that) {
case _CheckinOption():
return $default(_that.code,_that.label);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String label)?  $default,) {final _that = this;
switch (_that) {
case _CheckinOption() when $default != null:
return $default(_that.code,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckinOption implements CheckinOption {
  const _CheckinOption({required this.code, required this.label});
  factory _CheckinOption.fromJson(Map<String, dynamic> json) => _$CheckinOptionFromJson(json);

@override final  String code;
@override final  String label;

/// Create a copy of CheckinOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinOptionCopyWith<_CheckinOption> get copyWith => __$CheckinOptionCopyWithImpl<_CheckinOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckinOption&&(identical(other.code, code) || other.code == code)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,label);

@override
String toString() {
  return 'CheckinOption(code: $code, label: $label)';
}


}

/// @nodoc
abstract mixin class _$CheckinOptionCopyWith<$Res> implements $CheckinOptionCopyWith<$Res> {
  factory _$CheckinOptionCopyWith(_CheckinOption value, $Res Function(_CheckinOption) _then) = __$CheckinOptionCopyWithImpl;
@override @useResult
$Res call({
 String code, String label
});




}
/// @nodoc
class __$CheckinOptionCopyWithImpl<$Res>
    implements _$CheckinOptionCopyWith<$Res> {
  __$CheckinOptionCopyWithImpl(this._self, this._then);

  final _CheckinOption _self;
  final $Res Function(_CheckinOption) _then;

/// Create a copy of CheckinOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? label = null,}) {
  return _then(_CheckinOption(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CheckinScale {

 int get min; int get max;
/// Create a copy of CheckinScale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinScaleCopyWith<CheckinScale> get copyWith => _$CheckinScaleCopyWithImpl<CheckinScale>(this as CheckinScale, _$identity);

  /// Serializes this CheckinScale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckinScale&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,max);

@override
String toString() {
  return 'CheckinScale(min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class $CheckinScaleCopyWith<$Res>  {
  factory $CheckinScaleCopyWith(CheckinScale value, $Res Function(CheckinScale) _then) = _$CheckinScaleCopyWithImpl;
@useResult
$Res call({
 int min, int max
});




}
/// @nodoc
class _$CheckinScaleCopyWithImpl<$Res>
    implements $CheckinScaleCopyWith<$Res> {
  _$CheckinScaleCopyWithImpl(this._self, this._then);

  final CheckinScale _self;
  final $Res Function(CheckinScale) _then;

/// Create a copy of CheckinScale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? min = null,Object? max = null,}) {
  return _then(_self.copyWith(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckinScale].
extension CheckinScalePatterns on CheckinScale {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckinScale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckinScale() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckinScale value)  $default,){
final _that = this;
switch (_that) {
case _CheckinScale():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckinScale value)?  $default,){
final _that = this;
switch (_that) {
case _CheckinScale() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int min,  int max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckinScale() when $default != null:
return $default(_that.min,_that.max);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int min,  int max)  $default,) {final _that = this;
switch (_that) {
case _CheckinScale():
return $default(_that.min,_that.max);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int min,  int max)?  $default,) {final _that = this;
switch (_that) {
case _CheckinScale() when $default != null:
return $default(_that.min,_that.max);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckinScale implements CheckinScale {
  const _CheckinScale({required this.min, required this.max});
  factory _CheckinScale.fromJson(Map<String, dynamic> json) => _$CheckinScaleFromJson(json);

@override final  int min;
@override final  int max;

/// Create a copy of CheckinScale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinScaleCopyWith<_CheckinScale> get copyWith => __$CheckinScaleCopyWithImpl<_CheckinScale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinScaleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckinScale&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,max);

@override
String toString() {
  return 'CheckinScale(min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class _$CheckinScaleCopyWith<$Res> implements $CheckinScaleCopyWith<$Res> {
  factory _$CheckinScaleCopyWith(_CheckinScale value, $Res Function(_CheckinScale) _then) = __$CheckinScaleCopyWithImpl;
@override @useResult
$Res call({
 int min, int max
});




}
/// @nodoc
class __$CheckinScaleCopyWithImpl<$Res>
    implements _$CheckinScaleCopyWith<$Res> {
  __$CheckinScaleCopyWithImpl(this._self, this._then);

  final _CheckinScale _self;
  final $Res Function(_CheckinScale) _then;

/// Create a copy of CheckinScale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? min = null,Object? max = null,}) {
  return _then(_CheckinScale(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CheckinQuestion {

 String get ref; String get questionContentKey; String get type; List<CheckinOption> get options; CheckinScale? get scale;
/// Create a copy of CheckinQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinQuestionCopyWith<CheckinQuestion> get copyWith => _$CheckinQuestionCopyWithImpl<CheckinQuestion>(this as CheckinQuestion, _$identity);

  /// Serializes this CheckinQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckinQuestion&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.questionContentKey, questionContentKey) || other.questionContentKey == questionContentKey)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.scale, scale) || other.scale == scale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref,questionContentKey,type,const DeepCollectionEquality().hash(options),scale);

@override
String toString() {
  return 'CheckinQuestion(ref: $ref, questionContentKey: $questionContentKey, type: $type, options: $options, scale: $scale)';
}


}

/// @nodoc
abstract mixin class $CheckinQuestionCopyWith<$Res>  {
  factory $CheckinQuestionCopyWith(CheckinQuestion value, $Res Function(CheckinQuestion) _then) = _$CheckinQuestionCopyWithImpl;
@useResult
$Res call({
 String ref, String questionContentKey, String type, List<CheckinOption> options, CheckinScale? scale
});


$CheckinScaleCopyWith<$Res>? get scale;

}
/// @nodoc
class _$CheckinQuestionCopyWithImpl<$Res>
    implements $CheckinQuestionCopyWith<$Res> {
  _$CheckinQuestionCopyWithImpl(this._self, this._then);

  final CheckinQuestion _self;
  final $Res Function(CheckinQuestion) _then;

/// Create a copy of CheckinQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? questionContentKey = null,Object? type = null,Object? options = null,Object? scale = freezed,}) {
  return _then(_self.copyWith(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,questionContentKey: null == questionContentKey ? _self.questionContentKey : questionContentKey // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<CheckinOption>,scale: freezed == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as CheckinScale?,
  ));
}
/// Create a copy of CheckinQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckinScaleCopyWith<$Res>? get scale {
    if (_self.scale == null) {
    return null;
  }

  return $CheckinScaleCopyWith<$Res>(_self.scale!, (value) {
    return _then(_self.copyWith(scale: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckinQuestion].
extension CheckinQuestionPatterns on CheckinQuestion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckinQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckinQuestion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckinQuestion value)  $default,){
final _that = this;
switch (_that) {
case _CheckinQuestion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckinQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _CheckinQuestion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ref,  String questionContentKey,  String type,  List<CheckinOption> options,  CheckinScale? scale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckinQuestion() when $default != null:
return $default(_that.ref,_that.questionContentKey,_that.type,_that.options,_that.scale);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ref,  String questionContentKey,  String type,  List<CheckinOption> options,  CheckinScale? scale)  $default,) {final _that = this;
switch (_that) {
case _CheckinQuestion():
return $default(_that.ref,_that.questionContentKey,_that.type,_that.options,_that.scale);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ref,  String questionContentKey,  String type,  List<CheckinOption> options,  CheckinScale? scale)?  $default,) {final _that = this;
switch (_that) {
case _CheckinQuestion() when $default != null:
return $default(_that.ref,_that.questionContentKey,_that.type,_that.options,_that.scale);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckinQuestion implements CheckinQuestion {
  const _CheckinQuestion({required this.ref, required this.questionContentKey, required this.type, final  List<CheckinOption> options = const <CheckinOption>[], this.scale}): _options = options;
  factory _CheckinQuestion.fromJson(Map<String, dynamic> json) => _$CheckinQuestionFromJson(json);

@override final  String ref;
@override final  String questionContentKey;
@override final  String type;
 final  List<CheckinOption> _options;
@override@JsonKey() List<CheckinOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  CheckinScale? scale;

/// Create a copy of CheckinQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinQuestionCopyWith<_CheckinQuestion> get copyWith => __$CheckinQuestionCopyWithImpl<_CheckinQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckinQuestion&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.questionContentKey, questionContentKey) || other.questionContentKey == questionContentKey)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.scale, scale) || other.scale == scale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref,questionContentKey,type,const DeepCollectionEquality().hash(_options),scale);

@override
String toString() {
  return 'CheckinQuestion(ref: $ref, questionContentKey: $questionContentKey, type: $type, options: $options, scale: $scale)';
}


}

/// @nodoc
abstract mixin class _$CheckinQuestionCopyWith<$Res> implements $CheckinQuestionCopyWith<$Res> {
  factory _$CheckinQuestionCopyWith(_CheckinQuestion value, $Res Function(_CheckinQuestion) _then) = __$CheckinQuestionCopyWithImpl;
@override @useResult
$Res call({
 String ref, String questionContentKey, String type, List<CheckinOption> options, CheckinScale? scale
});


@override $CheckinScaleCopyWith<$Res>? get scale;

}
/// @nodoc
class __$CheckinQuestionCopyWithImpl<$Res>
    implements _$CheckinQuestionCopyWith<$Res> {
  __$CheckinQuestionCopyWithImpl(this._self, this._then);

  final _CheckinQuestion _self;
  final $Res Function(_CheckinQuestion) _then;

/// Create a copy of CheckinQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? questionContentKey = null,Object? type = null,Object? options = null,Object? scale = freezed,}) {
  return _then(_CheckinQuestion(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,questionContentKey: null == questionContentKey ? _self.questionContentKey : questionContentKey // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<CheckinOption>,scale: freezed == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as CheckinScale?,
  ));
}

/// Create a copy of CheckinQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckinScaleCopyWith<$Res>? get scale {
    if (_self.scale == null) {
    return null;
  }

  return $CheckinScaleCopyWith<$Res>(_self.scale!, (value) {
    return _then(_self.copyWith(scale: value));
  });
}
}


/// @nodoc
mixin _$CheckinResult {

 String get checkinId; String get tier; String get ruleVersion; int get recoveryDay; bool get withinClinicHours; String? get contentKey; String? get body; String? get escalationId;
/// Create a copy of CheckinResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinResultCopyWith<CheckinResult> get copyWith => _$CheckinResultCopyWithImpl<CheckinResult>(this as CheckinResult, _$identity);

  /// Serializes this CheckinResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckinResult&&(identical(other.checkinId, checkinId) || other.checkinId == checkinId)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.ruleVersion, ruleVersion) || other.ruleVersion == ruleVersion)&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&(identical(other.withinClinicHours, withinClinicHours) || other.withinClinicHours == withinClinicHours)&&(identical(other.contentKey, contentKey) || other.contentKey == contentKey)&&(identical(other.body, body) || other.body == body)&&(identical(other.escalationId, escalationId) || other.escalationId == escalationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkinId,tier,ruleVersion,recoveryDay,withinClinicHours,contentKey,body,escalationId);

@override
String toString() {
  return 'CheckinResult(checkinId: $checkinId, tier: $tier, ruleVersion: $ruleVersion, recoveryDay: $recoveryDay, withinClinicHours: $withinClinicHours, contentKey: $contentKey, body: $body, escalationId: $escalationId)';
}


}

/// @nodoc
abstract mixin class $CheckinResultCopyWith<$Res>  {
  factory $CheckinResultCopyWith(CheckinResult value, $Res Function(CheckinResult) _then) = _$CheckinResultCopyWithImpl;
@useResult
$Res call({
 String checkinId, String tier, String ruleVersion, int recoveryDay, bool withinClinicHours, String? contentKey, String? body, String? escalationId
});




}
/// @nodoc
class _$CheckinResultCopyWithImpl<$Res>
    implements $CheckinResultCopyWith<$Res> {
  _$CheckinResultCopyWithImpl(this._self, this._then);

  final CheckinResult _self;
  final $Res Function(CheckinResult) _then;

/// Create a copy of CheckinResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkinId = null,Object? tier = null,Object? ruleVersion = null,Object? recoveryDay = null,Object? withinClinicHours = null,Object? contentKey = freezed,Object? body = freezed,Object? escalationId = freezed,}) {
  return _then(_self.copyWith(
checkinId: null == checkinId ? _self.checkinId : checkinId // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,ruleVersion: null == ruleVersion ? _self.ruleVersion : ruleVersion // ignore: cast_nullable_to_non_nullable
as String,recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,withinClinicHours: null == withinClinicHours ? _self.withinClinicHours : withinClinicHours // ignore: cast_nullable_to_non_nullable
as bool,contentKey: freezed == contentKey ? _self.contentKey : contentKey // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,escalationId: freezed == escalationId ? _self.escalationId : escalationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckinResult].
extension CheckinResultPatterns on CheckinResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckinResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckinResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckinResult value)  $default,){
final _that = this;
switch (_that) {
case _CheckinResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckinResult value)?  $default,){
final _that = this;
switch (_that) {
case _CheckinResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String checkinId,  String tier,  String ruleVersion,  int recoveryDay,  bool withinClinicHours,  String? contentKey,  String? body,  String? escalationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckinResult() when $default != null:
return $default(_that.checkinId,_that.tier,_that.ruleVersion,_that.recoveryDay,_that.withinClinicHours,_that.contentKey,_that.body,_that.escalationId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String checkinId,  String tier,  String ruleVersion,  int recoveryDay,  bool withinClinicHours,  String? contentKey,  String? body,  String? escalationId)  $default,) {final _that = this;
switch (_that) {
case _CheckinResult():
return $default(_that.checkinId,_that.tier,_that.ruleVersion,_that.recoveryDay,_that.withinClinicHours,_that.contentKey,_that.body,_that.escalationId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String checkinId,  String tier,  String ruleVersion,  int recoveryDay,  bool withinClinicHours,  String? contentKey,  String? body,  String? escalationId)?  $default,) {final _that = this;
switch (_that) {
case _CheckinResult() when $default != null:
return $default(_that.checkinId,_that.tier,_that.ruleVersion,_that.recoveryDay,_that.withinClinicHours,_that.contentKey,_that.body,_that.escalationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckinResult implements CheckinResult {
  const _CheckinResult({required this.checkinId, required this.tier, required this.ruleVersion, required this.recoveryDay, required this.withinClinicHours, this.contentKey, this.body, this.escalationId});
  factory _CheckinResult.fromJson(Map<String, dynamic> json) => _$CheckinResultFromJson(json);

@override final  String checkinId;
@override final  String tier;
@override final  String ruleVersion;
@override final  int recoveryDay;
@override final  bool withinClinicHours;
@override final  String? contentKey;
@override final  String? body;
@override final  String? escalationId;

/// Create a copy of CheckinResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinResultCopyWith<_CheckinResult> get copyWith => __$CheckinResultCopyWithImpl<_CheckinResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckinResult&&(identical(other.checkinId, checkinId) || other.checkinId == checkinId)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.ruleVersion, ruleVersion) || other.ruleVersion == ruleVersion)&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&(identical(other.withinClinicHours, withinClinicHours) || other.withinClinicHours == withinClinicHours)&&(identical(other.contentKey, contentKey) || other.contentKey == contentKey)&&(identical(other.body, body) || other.body == body)&&(identical(other.escalationId, escalationId) || other.escalationId == escalationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkinId,tier,ruleVersion,recoveryDay,withinClinicHours,contentKey,body,escalationId);

@override
String toString() {
  return 'CheckinResult(checkinId: $checkinId, tier: $tier, ruleVersion: $ruleVersion, recoveryDay: $recoveryDay, withinClinicHours: $withinClinicHours, contentKey: $contentKey, body: $body, escalationId: $escalationId)';
}


}

/// @nodoc
abstract mixin class _$CheckinResultCopyWith<$Res> implements $CheckinResultCopyWith<$Res> {
  factory _$CheckinResultCopyWith(_CheckinResult value, $Res Function(_CheckinResult) _then) = __$CheckinResultCopyWithImpl;
@override @useResult
$Res call({
 String checkinId, String tier, String ruleVersion, int recoveryDay, bool withinClinicHours, String? contentKey, String? body, String? escalationId
});




}
/// @nodoc
class __$CheckinResultCopyWithImpl<$Res>
    implements _$CheckinResultCopyWith<$Res> {
  __$CheckinResultCopyWithImpl(this._self, this._then);

  final _CheckinResult _self;
  final $Res Function(_CheckinResult) _then;

/// Create a copy of CheckinResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkinId = null,Object? tier = null,Object? ruleVersion = null,Object? recoveryDay = null,Object? withinClinicHours = null,Object? contentKey = freezed,Object? body = freezed,Object? escalationId = freezed,}) {
  return _then(_CheckinResult(
checkinId: null == checkinId ? _self.checkinId : checkinId // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,ruleVersion: null == ruleVersion ? _self.ruleVersion : ruleVersion // ignore: cast_nullable_to_non_nullable
as String,recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,withinClinicHours: null == withinClinicHours ? _self.withinClinicHours : withinClinicHours // ignore: cast_nullable_to_non_nullable
as bool,contentKey: freezed == contentKey ? _self.contentKey : contentKey // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,escalationId: freezed == escalationId ? _self.escalationId : escalationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ContentItem {

 String get contentKey; String get language; String get text; int get version; bool get isPlaceholder;
/// Create a copy of ContentItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentItemCopyWith<ContentItem> get copyWith => _$ContentItemCopyWithImpl<ContentItem>(this as ContentItem, _$identity);

  /// Serializes this ContentItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentItem&&(identical(other.contentKey, contentKey) || other.contentKey == contentKey)&&(identical(other.language, language) || other.language == language)&&(identical(other.text, text) || other.text == text)&&(identical(other.version, version) || other.version == version)&&(identical(other.isPlaceholder, isPlaceholder) || other.isPlaceholder == isPlaceholder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentKey,language,text,version,isPlaceholder);

@override
String toString() {
  return 'ContentItem(contentKey: $contentKey, language: $language, text: $text, version: $version, isPlaceholder: $isPlaceholder)';
}


}

/// @nodoc
abstract mixin class $ContentItemCopyWith<$Res>  {
  factory $ContentItemCopyWith(ContentItem value, $Res Function(ContentItem) _then) = _$ContentItemCopyWithImpl;
@useResult
$Res call({
 String contentKey, String language, String text, int version, bool isPlaceholder
});




}
/// @nodoc
class _$ContentItemCopyWithImpl<$Res>
    implements $ContentItemCopyWith<$Res> {
  _$ContentItemCopyWithImpl(this._self, this._then);

  final ContentItem _self;
  final $Res Function(ContentItem) _then;

/// Create a copy of ContentItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentKey = null,Object? language = null,Object? text = null,Object? version = null,Object? isPlaceholder = null,}) {
  return _then(_self.copyWith(
contentKey: null == contentKey ? _self.contentKey : contentKey // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isPlaceholder: null == isPlaceholder ? _self.isPlaceholder : isPlaceholder // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentItem].
extension ContentItemPatterns on ContentItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentItem value)  $default,){
final _that = this;
switch (_that) {
case _ContentItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentItem value)?  $default,){
final _that = this;
switch (_that) {
case _ContentItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contentKey,  String language,  String text,  int version,  bool isPlaceholder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentItem() when $default != null:
return $default(_that.contentKey,_that.language,_that.text,_that.version,_that.isPlaceholder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contentKey,  String language,  String text,  int version,  bool isPlaceholder)  $default,) {final _that = this;
switch (_that) {
case _ContentItem():
return $default(_that.contentKey,_that.language,_that.text,_that.version,_that.isPlaceholder);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contentKey,  String language,  String text,  int version,  bool isPlaceholder)?  $default,) {final _that = this;
switch (_that) {
case _ContentItem() when $default != null:
return $default(_that.contentKey,_that.language,_that.text,_that.version,_that.isPlaceholder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContentItem implements ContentItem {
  const _ContentItem({required this.contentKey, required this.language, required this.text, required this.version, this.isPlaceholder = false});
  factory _ContentItem.fromJson(Map<String, dynamic> json) => _$ContentItemFromJson(json);

@override final  String contentKey;
@override final  String language;
@override final  String text;
@override final  int version;
@override@JsonKey() final  bool isPlaceholder;

/// Create a copy of ContentItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentItemCopyWith<_ContentItem> get copyWith => __$ContentItemCopyWithImpl<_ContentItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentItem&&(identical(other.contentKey, contentKey) || other.contentKey == contentKey)&&(identical(other.language, language) || other.language == language)&&(identical(other.text, text) || other.text == text)&&(identical(other.version, version) || other.version == version)&&(identical(other.isPlaceholder, isPlaceholder) || other.isPlaceholder == isPlaceholder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentKey,language,text,version,isPlaceholder);

@override
String toString() {
  return 'ContentItem(contentKey: $contentKey, language: $language, text: $text, version: $version, isPlaceholder: $isPlaceholder)';
}


}

/// @nodoc
abstract mixin class _$ContentItemCopyWith<$Res> implements $ContentItemCopyWith<$Res> {
  factory _$ContentItemCopyWith(_ContentItem value, $Res Function(_ContentItem) _then) = __$ContentItemCopyWithImpl;
@override @useResult
$Res call({
 String contentKey, String language, String text, int version, bool isPlaceholder
});




}
/// @nodoc
class __$ContentItemCopyWithImpl<$Res>
    implements _$ContentItemCopyWith<$Res> {
  __$ContentItemCopyWithImpl(this._self, this._then);

  final _ContentItem _self;
  final $Res Function(_ContentItem) _then;

/// Create a copy of ContentItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentKey = null,Object? language = null,Object? text = null,Object? version = null,Object? isPlaceholder = null,}) {
  return _then(_ContentItem(
contentKey: null == contentKey ? _self.contentKey : contentKey // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isPlaceholder: null == isPlaceholder ? _self.isPlaceholder : isPlaceholder // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EducationItem {

 String get contentKey; int get unlockDay; String? get category;
/// Create a copy of EducationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationItemCopyWith<EducationItem> get copyWith => _$EducationItemCopyWithImpl<EducationItem>(this as EducationItem, _$identity);

  /// Serializes this EducationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationItem&&(identical(other.contentKey, contentKey) || other.contentKey == contentKey)&&(identical(other.unlockDay, unlockDay) || other.unlockDay == unlockDay)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentKey,unlockDay,category);

@override
String toString() {
  return 'EducationItem(contentKey: $contentKey, unlockDay: $unlockDay, category: $category)';
}


}

/// @nodoc
abstract mixin class $EducationItemCopyWith<$Res>  {
  factory $EducationItemCopyWith(EducationItem value, $Res Function(EducationItem) _then) = _$EducationItemCopyWithImpl;
@useResult
$Res call({
 String contentKey, int unlockDay, String? category
});




}
/// @nodoc
class _$EducationItemCopyWithImpl<$Res>
    implements $EducationItemCopyWith<$Res> {
  _$EducationItemCopyWithImpl(this._self, this._then);

  final EducationItem _self;
  final $Res Function(EducationItem) _then;

/// Create a copy of EducationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentKey = null,Object? unlockDay = null,Object? category = freezed,}) {
  return _then(_self.copyWith(
contentKey: null == contentKey ? _self.contentKey : contentKey // ignore: cast_nullable_to_non_nullable
as String,unlockDay: null == unlockDay ? _self.unlockDay : unlockDay // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationItem].
extension EducationItemPatterns on EducationItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationItem value)  $default,){
final _that = this;
switch (_that) {
case _EducationItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationItem value)?  $default,){
final _that = this;
switch (_that) {
case _EducationItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contentKey,  int unlockDay,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationItem() when $default != null:
return $default(_that.contentKey,_that.unlockDay,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contentKey,  int unlockDay,  String? category)  $default,) {final _that = this;
switch (_that) {
case _EducationItem():
return $default(_that.contentKey,_that.unlockDay,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contentKey,  int unlockDay,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _EducationItem() when $default != null:
return $default(_that.contentKey,_that.unlockDay,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationItem implements EducationItem {
  const _EducationItem({required this.contentKey, required this.unlockDay, this.category});
  factory _EducationItem.fromJson(Map<String, dynamic> json) => _$EducationItemFromJson(json);

@override final  String contentKey;
@override final  int unlockDay;
@override final  String? category;

/// Create a copy of EducationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationItemCopyWith<_EducationItem> get copyWith => __$EducationItemCopyWithImpl<_EducationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationItem&&(identical(other.contentKey, contentKey) || other.contentKey == contentKey)&&(identical(other.unlockDay, unlockDay) || other.unlockDay == unlockDay)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentKey,unlockDay,category);

@override
String toString() {
  return 'EducationItem(contentKey: $contentKey, unlockDay: $unlockDay, category: $category)';
}


}

/// @nodoc
abstract mixin class _$EducationItemCopyWith<$Res> implements $EducationItemCopyWith<$Res> {
  factory _$EducationItemCopyWith(_EducationItem value, $Res Function(_EducationItem) _then) = __$EducationItemCopyWithImpl;
@override @useResult
$Res call({
 String contentKey, int unlockDay, String? category
});




}
/// @nodoc
class __$EducationItemCopyWithImpl<$Res>
    implements _$EducationItemCopyWith<$Res> {
  __$EducationItemCopyWithImpl(this._self, this._then);

  final _EducationItem _self;
  final $Res Function(_EducationItem) _then;

/// Create a copy of EducationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentKey = null,Object? unlockDay = null,Object? category = freezed,}) {
  return _then(_EducationItem(
contentKey: null == contentKey ? _self.contentKey : contentKey // ignore: cast_nullable_to_non_nullable
as String,unlockDay: null == unlockDay ? _self.unlockDay : unlockDay // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EducationIndex {

 String? get category; String? get procedureType; int get recoveryDay; List<EducationItem> get items;
/// Create a copy of EducationIndex
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationIndexCopyWith<EducationIndex> get copyWith => _$EducationIndexCopyWithImpl<EducationIndex>(this as EducationIndex, _$identity);

  /// Serializes this EducationIndex to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationIndex&&(identical(other.category, category) || other.category == category)&&(identical(other.procedureType, procedureType) || other.procedureType == procedureType)&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,procedureType,recoveryDay,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'EducationIndex(category: $category, procedureType: $procedureType, recoveryDay: $recoveryDay, items: $items)';
}


}

/// @nodoc
abstract mixin class $EducationIndexCopyWith<$Res>  {
  factory $EducationIndexCopyWith(EducationIndex value, $Res Function(EducationIndex) _then) = _$EducationIndexCopyWithImpl;
@useResult
$Res call({
 String? category, String? procedureType, int recoveryDay, List<EducationItem> items
});




}
/// @nodoc
class _$EducationIndexCopyWithImpl<$Res>
    implements $EducationIndexCopyWith<$Res> {
  _$EducationIndexCopyWithImpl(this._self, this._then);

  final EducationIndex _self;
  final $Res Function(EducationIndex) _then;

/// Create a copy of EducationIndex
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = freezed,Object? procedureType = freezed,Object? recoveryDay = null,Object? items = null,}) {
  return _then(_self.copyWith(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,procedureType: freezed == procedureType ? _self.procedureType : procedureType // ignore: cast_nullable_to_non_nullable
as String?,recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<EducationItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationIndex].
extension EducationIndexPatterns on EducationIndex {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationIndex value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationIndex() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationIndex value)  $default,){
final _that = this;
switch (_that) {
case _EducationIndex():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationIndex value)?  $default,){
final _that = this;
switch (_that) {
case _EducationIndex() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? category,  String? procedureType,  int recoveryDay,  List<EducationItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationIndex() when $default != null:
return $default(_that.category,_that.procedureType,_that.recoveryDay,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? category,  String? procedureType,  int recoveryDay,  List<EducationItem> items)  $default,) {final _that = this;
switch (_that) {
case _EducationIndex():
return $default(_that.category,_that.procedureType,_that.recoveryDay,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? category,  String? procedureType,  int recoveryDay,  List<EducationItem> items)?  $default,) {final _that = this;
switch (_that) {
case _EducationIndex() when $default != null:
return $default(_that.category,_that.procedureType,_that.recoveryDay,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationIndex implements EducationIndex {
  const _EducationIndex({this.category, this.procedureType, required this.recoveryDay, final  List<EducationItem> items = const <EducationItem>[]}): _items = items;
  factory _EducationIndex.fromJson(Map<String, dynamic> json) => _$EducationIndexFromJson(json);

@override final  String? category;
@override final  String? procedureType;
@override final  int recoveryDay;
 final  List<EducationItem> _items;
@override@JsonKey() List<EducationItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of EducationIndex
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationIndexCopyWith<_EducationIndex> get copyWith => __$EducationIndexCopyWithImpl<_EducationIndex>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationIndexToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationIndex&&(identical(other.category, category) || other.category == category)&&(identical(other.procedureType, procedureType) || other.procedureType == procedureType)&&(identical(other.recoveryDay, recoveryDay) || other.recoveryDay == recoveryDay)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,procedureType,recoveryDay,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'EducationIndex(category: $category, procedureType: $procedureType, recoveryDay: $recoveryDay, items: $items)';
}


}

/// @nodoc
abstract mixin class _$EducationIndexCopyWith<$Res> implements $EducationIndexCopyWith<$Res> {
  factory _$EducationIndexCopyWith(_EducationIndex value, $Res Function(_EducationIndex) _then) = __$EducationIndexCopyWithImpl;
@override @useResult
$Res call({
 String? category, String? procedureType, int recoveryDay, List<EducationItem> items
});




}
/// @nodoc
class __$EducationIndexCopyWithImpl<$Res>
    implements _$EducationIndexCopyWith<$Res> {
  __$EducationIndexCopyWithImpl(this._self, this._then);

  final _EducationIndex _self;
  final $Res Function(_EducationIndex) _then;

/// Create a copy of EducationIndex
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = freezed,Object? procedureType = freezed,Object? recoveryDay = null,Object? items = null,}) {
  return _then(_EducationIndex(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,procedureType: freezed == procedureType ? _self.procedureType : procedureType // ignore: cast_nullable_to_non_nullable
as String?,recoveryDay: null == recoveryDay ? _self.recoveryDay : recoveryDay // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<EducationItem>,
  ));
}


}


/// @nodoc
mixin _$SurveyPayload {

 int? get q1Helpful; int? get q2Easy; int? get q3AdherenceSupport; int? get q4Recommend; String? get freeText;
/// Create a copy of SurveyPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyPayloadCopyWith<SurveyPayload> get copyWith => _$SurveyPayloadCopyWithImpl<SurveyPayload>(this as SurveyPayload, _$identity);

  /// Serializes this SurveyPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyPayload&&(identical(other.q1Helpful, q1Helpful) || other.q1Helpful == q1Helpful)&&(identical(other.q2Easy, q2Easy) || other.q2Easy == q2Easy)&&(identical(other.q3AdherenceSupport, q3AdherenceSupport) || other.q3AdherenceSupport == q3AdherenceSupport)&&(identical(other.q4Recommend, q4Recommend) || other.q4Recommend == q4Recommend)&&(identical(other.freeText, freeText) || other.freeText == freeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,q1Helpful,q2Easy,q3AdherenceSupport,q4Recommend,freeText);

@override
String toString() {
  return 'SurveyPayload(q1Helpful: $q1Helpful, q2Easy: $q2Easy, q3AdherenceSupport: $q3AdherenceSupport, q4Recommend: $q4Recommend, freeText: $freeText)';
}


}

/// @nodoc
abstract mixin class $SurveyPayloadCopyWith<$Res>  {
  factory $SurveyPayloadCopyWith(SurveyPayload value, $Res Function(SurveyPayload) _then) = _$SurveyPayloadCopyWithImpl;
@useResult
$Res call({
 int? q1Helpful, int? q2Easy, int? q3AdherenceSupport, int? q4Recommend, String? freeText
});




}
/// @nodoc
class _$SurveyPayloadCopyWithImpl<$Res>
    implements $SurveyPayloadCopyWith<$Res> {
  _$SurveyPayloadCopyWithImpl(this._self, this._then);

  final SurveyPayload _self;
  final $Res Function(SurveyPayload) _then;

/// Create a copy of SurveyPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? q1Helpful = freezed,Object? q2Easy = freezed,Object? q3AdherenceSupport = freezed,Object? q4Recommend = freezed,Object? freeText = freezed,}) {
  return _then(_self.copyWith(
q1Helpful: freezed == q1Helpful ? _self.q1Helpful : q1Helpful // ignore: cast_nullable_to_non_nullable
as int?,q2Easy: freezed == q2Easy ? _self.q2Easy : q2Easy // ignore: cast_nullable_to_non_nullable
as int?,q3AdherenceSupport: freezed == q3AdherenceSupport ? _self.q3AdherenceSupport : q3AdherenceSupport // ignore: cast_nullable_to_non_nullable
as int?,q4Recommend: freezed == q4Recommend ? _self.q4Recommend : q4Recommend // ignore: cast_nullable_to_non_nullable
as int?,freeText: freezed == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyPayload].
extension SurveyPayloadPatterns on SurveyPayload {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyPayload() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyPayload value)  $default,){
final _that = this;
switch (_that) {
case _SurveyPayload():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyPayload value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyPayload() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? q1Helpful,  int? q2Easy,  int? q3AdherenceSupport,  int? q4Recommend,  String? freeText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyPayload() when $default != null:
return $default(_that.q1Helpful,_that.q2Easy,_that.q3AdherenceSupport,_that.q4Recommend,_that.freeText);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? q1Helpful,  int? q2Easy,  int? q3AdherenceSupport,  int? q4Recommend,  String? freeText)  $default,) {final _that = this;
switch (_that) {
case _SurveyPayload():
return $default(_that.q1Helpful,_that.q2Easy,_that.q3AdherenceSupport,_that.q4Recommend,_that.freeText);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? q1Helpful,  int? q2Easy,  int? q3AdherenceSupport,  int? q4Recommend,  String? freeText)?  $default,) {final _that = this;
switch (_that) {
case _SurveyPayload() when $default != null:
return $default(_that.q1Helpful,_that.q2Easy,_that.q3AdherenceSupport,_that.q4Recommend,_that.freeText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyPayload implements SurveyPayload {
  const _SurveyPayload({this.q1Helpful, this.q2Easy, this.q3AdherenceSupport, this.q4Recommend, this.freeText});
  factory _SurveyPayload.fromJson(Map<String, dynamic> json) => _$SurveyPayloadFromJson(json);

@override final  int? q1Helpful;
@override final  int? q2Easy;
@override final  int? q3AdherenceSupport;
@override final  int? q4Recommend;
@override final  String? freeText;

/// Create a copy of SurveyPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyPayloadCopyWith<_SurveyPayload> get copyWith => __$SurveyPayloadCopyWithImpl<_SurveyPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyPayload&&(identical(other.q1Helpful, q1Helpful) || other.q1Helpful == q1Helpful)&&(identical(other.q2Easy, q2Easy) || other.q2Easy == q2Easy)&&(identical(other.q3AdherenceSupport, q3AdherenceSupport) || other.q3AdherenceSupport == q3AdherenceSupport)&&(identical(other.q4Recommend, q4Recommend) || other.q4Recommend == q4Recommend)&&(identical(other.freeText, freeText) || other.freeText == freeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,q1Helpful,q2Easy,q3AdherenceSupport,q4Recommend,freeText);

@override
String toString() {
  return 'SurveyPayload(q1Helpful: $q1Helpful, q2Easy: $q2Easy, q3AdherenceSupport: $q3AdherenceSupport, q4Recommend: $q4Recommend, freeText: $freeText)';
}


}

/// @nodoc
abstract mixin class _$SurveyPayloadCopyWith<$Res> implements $SurveyPayloadCopyWith<$Res> {
  factory _$SurveyPayloadCopyWith(_SurveyPayload value, $Res Function(_SurveyPayload) _then) = __$SurveyPayloadCopyWithImpl;
@override @useResult
$Res call({
 int? q1Helpful, int? q2Easy, int? q3AdherenceSupport, int? q4Recommend, String? freeText
});




}
/// @nodoc
class __$SurveyPayloadCopyWithImpl<$Res>
    implements _$SurveyPayloadCopyWith<$Res> {
  __$SurveyPayloadCopyWithImpl(this._self, this._then);

  final _SurveyPayload _self;
  final $Res Function(_SurveyPayload) _then;

/// Create a copy of SurveyPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? q1Helpful = freezed,Object? q2Easy = freezed,Object? q3AdherenceSupport = freezed,Object? q4Recommend = freezed,Object? freeText = freezed,}) {
  return _then(_SurveyPayload(
q1Helpful: freezed == q1Helpful ? _self.q1Helpful : q1Helpful // ignore: cast_nullable_to_non_nullable
as int?,q2Easy: freezed == q2Easy ? _self.q2Easy : q2Easy // ignore: cast_nullable_to_non_nullable
as int?,q3AdherenceSupport: freezed == q3AdherenceSupport ? _self.q3AdherenceSupport : q3AdherenceSupport // ignore: cast_nullable_to_non_nullable
as int?,q4Recommend: freezed == q4Recommend ? _self.q4Recommend : q4Recommend // ignore: cast_nullable_to_non_nullable
as int?,freeText: freezed == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LeaveResponse {

 int? get tasksStopped;
/// Create a copy of LeaveResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveResponseCopyWith<LeaveResponse> get copyWith => _$LeaveResponseCopyWithImpl<LeaveResponse>(this as LeaveResponse, _$identity);

  /// Serializes this LeaveResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveResponse&&(identical(other.tasksStopped, tasksStopped) || other.tasksStopped == tasksStopped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tasksStopped);

@override
String toString() {
  return 'LeaveResponse(tasksStopped: $tasksStopped)';
}


}

/// @nodoc
abstract mixin class $LeaveResponseCopyWith<$Res>  {
  factory $LeaveResponseCopyWith(LeaveResponse value, $Res Function(LeaveResponse) _then) = _$LeaveResponseCopyWithImpl;
@useResult
$Res call({
 int? tasksStopped
});




}
/// @nodoc
class _$LeaveResponseCopyWithImpl<$Res>
    implements $LeaveResponseCopyWith<$Res> {
  _$LeaveResponseCopyWithImpl(this._self, this._then);

  final LeaveResponse _self;
  final $Res Function(LeaveResponse) _then;

/// Create a copy of LeaveResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasksStopped = freezed,}) {
  return _then(_self.copyWith(
tasksStopped: freezed == tasksStopped ? _self.tasksStopped : tasksStopped // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveResponse].
extension LeaveResponsePatterns on LeaveResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveResponse value)  $default,){
final _that = this;
switch (_that) {
case _LeaveResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? tasksStopped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveResponse() when $default != null:
return $default(_that.tasksStopped);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? tasksStopped)  $default,) {final _that = this;
switch (_that) {
case _LeaveResponse():
return $default(_that.tasksStopped);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? tasksStopped)?  $default,) {final _that = this;
switch (_that) {
case _LeaveResponse() when $default != null:
return $default(_that.tasksStopped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveResponse implements LeaveResponse {
  const _LeaveResponse({this.tasksStopped});
  factory _LeaveResponse.fromJson(Map<String, dynamic> json) => _$LeaveResponseFromJson(json);

@override final  int? tasksStopped;

/// Create a copy of LeaveResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveResponseCopyWith<_LeaveResponse> get copyWith => __$LeaveResponseCopyWithImpl<_LeaveResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveResponse&&(identical(other.tasksStopped, tasksStopped) || other.tasksStopped == tasksStopped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tasksStopped);

@override
String toString() {
  return 'LeaveResponse(tasksStopped: $tasksStopped)';
}


}

/// @nodoc
abstract mixin class _$LeaveResponseCopyWith<$Res> implements $LeaveResponseCopyWith<$Res> {
  factory _$LeaveResponseCopyWith(_LeaveResponse value, $Res Function(_LeaveResponse) _then) = __$LeaveResponseCopyWithImpl;
@override @useResult
$Res call({
 int? tasksStopped
});




}
/// @nodoc
class __$LeaveResponseCopyWithImpl<$Res>
    implements _$LeaveResponseCopyWith<$Res> {
  __$LeaveResponseCopyWithImpl(this._self, this._then);

  final _LeaveResponse _self;
  final $Res Function(_LeaveResponse) _then;

/// Create a copy of LeaveResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasksStopped = freezed,}) {
  return _then(_LeaveResponse(
tasksStopped: freezed == tasksStopped ? _self.tasksStopped : tasksStopped // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
