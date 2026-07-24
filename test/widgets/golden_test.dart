import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/theme/app_theme.dart';
import 'package:hospital_ai/core/theme/tokens.dart';
import 'package:hospital_ai/core/widgets/primary_button.dart';
import 'package:hospital_ai/core/widgets/secondary_button.dart';
import 'package:hospital_ai/core/widgets/task_row.dart';
import 'package:hospital_ai/core/widgets/tier_chip.dart';

Widget _host(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Center(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );

void main() {
  testWidgets('golden: task row states', (tester) async {
    await tester.pumpWidget(
      _host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TaskRow(
              icon: const Icon(Icons.medication_outlined),
              title: const Text('Paracetamol 500 mg'),
              time: '14:00',
              state: TaskRowState.pending,
              onToggle: () {},
            ),
            const SizedBox(height: 12),
            TaskRow(
              icon: const Icon(Icons.medication_outlined),
              title: const Text('Paracetamol 500 mg'),
              time: '08:00',
              state: TaskRowState.completed,
              onToggle: () {},
            ),
            const SizedBox(height: 12),
            TaskRow(
              icon: const Icon(Icons.healing_outlined),
              title: const Text('Wound care'),
              time: '10:00',
              state: TaskRowState.overdue,
              overdueSuffix: const Text('Earlier today'),
              iconBackground: AppColors.tintAmberBg,
              iconColor: AppColors.tintAmberFg,
              onToggle: () {},
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/task_row_states.png'),
    );
  });

  testWidgets('golden: tier chips', (tester) async {
    await tester.pumpWidget(
      _host(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TierChip(tier: Tier.routine, label: Text('Routine')),
            SizedBox(width: 8),
            TierChip(tier: Tier.urgent, label: Text('Urgent')),
            SizedBox(width: 8),
            TierChip(tier: Tier.emergency, label: Text('Emergency')),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(Row).first,
      matchesGoldenFile('goldens/tier_chips.png'),
    );
  });

  testWidgets('golden: buttons', (tester) async {
    await tester.pumpWidget(
      _host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(onPressed: () {}, child: const Text('Continue')),
            const SizedBox(height: 12),
            SecondaryButton(onPressed: () {}, child: const Text('Not yet')),
            const SizedBox(height: 12),
            const PrimaryButton(onPressed: null, child: Text('Continue')),
            const SizedBox(height: 12),
            PrimaryButton(
              background: AppColors.emergency,
              height: AppHit.emergencyCall,
              onPressed: () {},
              child: const Text('Call 103'),
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/buttons.png'),
    );
  });

  testWidgets('overdue row contains no red pixels', (tester) async {
    await tester.pumpWidget(
      _host(
        TaskRow(
          icon: const Icon(Icons.healing_outlined),
          title: const Text('Wound care'),
          time: '10:00',
          state: TaskRowState.overdue,
          overdueSuffix: const Text('Earlier today'),
          iconBackground: AppColors.tintAmberBg,
          iconColor: AppColors.tintAmberFg,
          onToggle: () {},
        ),
      ),
    );

    // Standing rule 8: red is reserved for medical emergency. An overdue
    // task must not render a single emergency-red pixel.
    // toImage/toByteData are real async — they never complete inside the
    // test's FakeAsync zone, hence runAsync.
    final redPixels = await tester.runAsync<int>(() async {
      final image = await _capture(tester, find.byType(TaskRow));
      final data = (await image.toByteData())!;
      var count = 0;
      for (var i = 0; i < data.lengthInBytes; i += 4) {
        final r = data.getUint8(i);
        final g = data.getUint8(i + 1);
        final b = data.getUint8(i + 2);
        // near the emergency token #B3261E
        if ((r - 0xB3).abs() < 24 &&
            (g - 0x26).abs() < 24 &&
            (b - 0x1E).abs() < 24) {
          count++;
        }
      }
      return count;
    });
    expect(redPixels, 0);
  });
}

Future<ui.Image> _capture(WidgetTester tester, Finder finder) async {
  final element = finder.evaluate().single;
  RenderObject? node = element.renderObject;
  while (node != null && node is! RenderRepaintBoundary) {
    node = node.parent;
  }
  return (node! as RenderRepaintBoundary).toImage();
}
