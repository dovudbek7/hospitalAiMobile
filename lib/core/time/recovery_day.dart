import 'package:timezone/timezone.dart' as tz;

/// Recovery day = whole days between the discharge date and now, computed
/// in the CLINIC's timezone. Discharge = day 0. (ADR "Time handling": day
/// boundaries use clinic-local dates; an off-by-one here shifts every task
/// in the entire programme.)
///
/// [dischargeDate] is the ISO date the API supplies (e.g. "2026-07-20"),
/// interpreted as a clinic-local calendar date. [nowUtc] defaults to the
/// real clock; tests inject fixed instants across day boundaries and DST.
int recoveryDay({
  required String dischargeDate,
  required String clinicTimezone,
  DateTime? nowUtc,
}) {
  final location = tz.getLocation(clinicTimezone);
  final now = tz.TZDateTime.from(
    (nowUtc ?? DateTime.now().toUtc()),
    location,
  );

  final parts = dischargeDate.split('T').first.split('-');
  final discharge = DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );

  // Compare calendar DATES, not instants — DST shifts must not change the
  // day count.
  final nowDate = DateTime(now.year, now.month, now.day);
  return nowDate.difference(discharge).inDays;
}

/// Clinic-local date key (YYYY-MM-DD) for grouping cached tasks by day.
String localDateKey(DateTime utcInstant, String clinicTimezone) {
  final local = tz.TZDateTime.from(utcInstant, tz.getLocation(clinicTimezone));
  String two(int n) => n.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)}';
}
