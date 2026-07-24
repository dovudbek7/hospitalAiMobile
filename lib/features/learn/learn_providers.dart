import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/api_models.dart';
import '../../core/providers.dart';
import '../today/today_providers.dart';

/// P14 data. The server returns UNLOCKED keys only — items not yet reached
/// by recovery day never arrive at the client, so they are hidden by
/// construction, not greyed (spec P14). Cached for offline.
final educationProvider = FutureProvider<EducationIndex>((ref) async {
  final api = ref.watch(patientApiProvider);
  final prefs = ref.watch(sharedPrefsProviderSafe);
  const cacheKey = 'cache.education_v1';
  try {
    final index = await api.getEducationIndex();
    await prefs?.setString(cacheKey, jsonEncode(index.toJson()));
    return index;
  } on DioException {
    final raw = prefs?.getString(cacheKey);
    if (raw != null) {
      return EducationIndex.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    rethrow;
  }
});
