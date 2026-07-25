import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:hospital_ai/core/time/recovery_day.dart';

void main() {
  setUpAll(tzdata.initializeTimeZones);

  test('discharge day is day 0 in the clinic timezone', () {
    expect(
      recoveryDay(
        dischargeDate: '2026-07-20',
        clinicTimezone: 'Asia/Tashkent',
        nowUtc: DateTime.utc(2026, 7, 20, 10),
      ),
      0,
    );
  });

  test('day increments at the CLINIC-local midnight, not UTC midnight', () {
    // Tashkent is UTC+5. 2026-07-24T18:59 UTC = 23:59 local → still day 4.
    expect(
      recoveryDay(
        dischargeDate: '2026-07-20',
        clinicTimezone: 'Asia/Tashkent',
        nowUtc: DateTime.utc(2026, 7, 24, 18, 59),
      ),
      4,
    );
    // One minute later: 2026-07-24T19:00 UTC = 2026-07-25T00:00 local → day 5.
    expect(
      recoveryDay(
        dischargeDate: '2026-07-20',
        clinicTimezone: 'Asia/Tashkent',
        nowUtc: DateTime.utc(2026, 7, 24, 19),
      ),
      5,
    );
  });

  test('a DST transition never shifts the day count', () {
    // Europe/Berlin DST ends 2026-10-25: the local day is 25 hours long.
    // Crossing it must still count exactly one calendar day.
    final beforeShift = recoveryDay(
      dischargeDate: '2026-10-20',
      clinicTimezone: 'Europe/Berlin',
      nowUtc: DateTime.utc(2026, 10, 24, 12),
    );
    final afterShift = recoveryDay(
      dischargeDate: '2026-10-20',
      clinicTimezone: 'Europe/Berlin',
      nowUtc: DateTime.utc(2026, 10, 25, 12),
    );
    expect(beforeShift, 4);
    expect(afterShift, 5, reason: '25-hour day still counts as one day');
  });

  test('day 30 boundary — programme completion routing depends on this', () {
    expect(
      recoveryDay(
        dischargeDate: '2026-07-01',
        clinicTimezone: 'Asia/Tashkent',
        nowUtc: DateTime.utc(2026, 7, 31, 6),
      ),
      30,
    );
  });

  test('localDateKey groups instants by clinic-local calendar day', () {
    expect(
      localDateKey(DateTime.utc(2026, 7, 24, 18, 59), 'Asia/Tashkent'),
      '2026-07-24',
    );
    expect(
      localDateKey(DateTime.utc(2026, 7, 24, 19), 'Asia/Tashkent'),
      '2026-07-25',
    );
  });
}
