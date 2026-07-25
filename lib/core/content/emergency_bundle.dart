import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'content_repository.dart';
import 'content_result.dart';

/// P13's hard requirement: the emergency screen must render and dial with
/// NO network, ever. This bundle caches the emergency strings and both
/// numbers at enrolment (and on every language change), outside the normal
/// content cache, in its own SharedPreferences slot — so even a wiped drift
/// database cannot take the emergency screen down.
///
/// It holds no medical judgement — only the clinic's own instruction text
/// and phone numbers.
class EmergencyBundle {
  const EmergencyBundle({
    required this.headline,
    required this.body,
    required this.banner,
    required this.ambulanceNumber,
    required this.clinicName,
    required this.clinicPhone,
    required this.language,
  });

  final String headline;
  final String body;
  final String banner;
  final String ambulanceNumber;
  final String clinicName;
  final String clinicPhone;
  final String language;

  static const _prefsKey = 'emergency_bundle_v1';
  static const contentKeys = [
    'emergency.headline',
    'emergency.body',
    'emergency.banner',
  ];

  Map<String, dynamic> toJson() => {
        'headline': headline,
        'body': body,
        'banner': banner,
        'ambulanceNumber': ambulanceNumber,
        'clinicName': clinicName,
        'clinicPhone': clinicPhone,
        'language': language,
      };

  static EmergencyBundle? _fromJson(Map<String, dynamic> j) {
    final values = [
      j['headline'],
      j['body'],
      j['banner'],
      j['ambulanceNumber'],
      j['clinicName'],
      j['clinicPhone'],
      j['language'],
    ];
    if (values.any((v) => v is! String)) return null;
    return EmergencyBundle(
      headline: j['headline'] as String,
      body: j['body'] as String,
      banner: j['banner'] as String,
      ambulanceNumber: j['ambulanceNumber'] as String,
      clinicName: j['clinicName'] as String,
      clinicPhone: j['clinicPhone'] as String,
      language: j['language'] as String,
    );
  }

  static Future<EmergencyBundle?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return null;
    try {
      return _fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(toJson()));
  }

  /// Build from the content library + clinic config and persist. Called at
  /// enrolment and after every language change. Returns null (and keeps the
  /// previous bundle) if any string is missing — a partial emergency screen
  /// is worse than yesterday's complete one.
  static Future<EmergencyBundle?> refresh({
    required ContentRepository content,
    required String language,
    required String clinicName,
    required String clinicPhone,
    String ambulanceNumber = '103',
  }) async {
    final texts = <String, String>{};
    for (final key in contentKeys) {
      final result = await content.resolve(key, language);
      if (result is! ContentResolved) return null;
      texts[key] = result.text;
    }
    final bundle = EmergencyBundle(
      headline: texts['emergency.headline']!,
      body: texts['emergency.body']!,
      banner: texts['emergency.banner']!,
      ambulanceNumber: ambulanceNumber,
      clinicName: clinicName,
      clinicPhone: clinicPhone,
      language: language,
    );
    await bundle.save();
    return bundle;
  }
}
