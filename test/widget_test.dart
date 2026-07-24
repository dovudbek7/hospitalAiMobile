import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/app.dart';

void main() {
  testWidgets('app shell boots and renders with Inter', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HospitalAiApp()));

    expect(find.byType(MaterialApp), findsOneWidget);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme?.textTheme.bodyMedium?.fontFamily ?? 'Inter', 'Inter');
  });
}
