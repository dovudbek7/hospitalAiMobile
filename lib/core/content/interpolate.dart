/// `{TOKEN}` interpolation for content strings. Tokens carry config values
/// (clinic name, phone, hours) and per-patient data (first name, day) —
/// never prose. An unknown token is left verbatim so a template mistake is
/// visible in QA rather than silently swallowed.
String interpolate(String template, Map<String, String> vars) {
  return template.replaceAllMapped(RegExp(r'\{([A-Z_0-9]+)\}'), (m) {
    final token = m.group(1)!;
    return vars[token] ?? m.group(0)!;
  });
}

/// The standard variable set, built from clinic config + profile.
Map<String, String> standardVars({
  String? clinicName,
  String? clinicPhone,
  String? emergencyNumber,
  String? workingHours,
  String? workingDays,
  String? openingTime,
  String? firstName,
  int? n,
  int? total,
}) {
  return {
    'CLINIC_NAME': ?clinicName,
    'CLINIC_PHONE': ?clinicPhone,
    'EMERGENCY_NUMBER': ?emergencyNumber,
    'WORKING_HOURS': ?workingHours,
    'WORKING_DAYS': ?workingDays,
    'OPENING_TIME': ?openingTime,
    'FIRST_NAME': ?firstName,
    if (n != null) 'N': '$n',
    if (total != null) 'TOTAL': '$total',
  };
}
