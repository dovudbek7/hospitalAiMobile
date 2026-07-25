// The 0–10 spinner. The rule under test is clinical, not cosmetic: a
// centred number is NOT an answer until the patient moves the wheel.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/widgets/scale_selector.dart';

Widget _host({
  required int? value,
  required ValueChanged<int> onChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 340,
          child: ScaleSelector(
            value: value,
            onChanged: onChanged,
            hint: const Text('turn'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('does not answer on its own', (tester) async {
    var calls = 0;
    await tester.pumpWidget(_host(value: null, onChanged: (_) => calls++));
    await tester.pump(const Duration(milliseconds: 300));

    expect(calls, 0, reason: 'a centred 0 must not count as "no pain"');
    expect(find.text('turn'), findsOneWidget);
  });

  testWidgets('turning the wheel reports the centred value', (tester) async {
    int? reported;
    await tester.pumpWidget(_host(value: null, onChanged: (v) => reported = v));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.drag(find.byType(ListWheelScrollView), const Offset(-200, 0));
    await tester.pumpAndSettle();

    expect(reported, isNotNull);
    expect(reported, greaterThan(0));
  });

  testWidgets('an existing answer hides the hint', (tester) async {
    await tester.pumpWidget(_host(value: 4, onChanged: (_) {}));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('turn'), findsNothing);
    expect(find.text('4'), findsOneWidget);
  });
}
