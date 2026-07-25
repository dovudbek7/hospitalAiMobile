import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/content/txt.dart';
import 'package:hospital_ai/core/providers.dart';

Widget _app(
  Widget child, {
  required Map<(String, String), ContentResult> content,
  String lang = 'EN',
}) {
  return ProviderScope(
    overrides: [
      contentProvider.overrideWith((ref, spec) async {
        return content[spec] ??
            ContentNotApproved(contentKey: spec.$1, language: spec.$2);
      }),
      languageProvider.overrideWith(_FixedLang.new),
    ],
    child: _LangSetter(
      lang: lang,
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
}

class _FixedLang extends LanguageNotifier {}

class _LangSetter extends ConsumerStatefulWidget {
  const _LangSetter({required this.lang, required this.child});

  final String lang;
  final Widget child;

  @override
  ConsumerState<_LangSetter> createState() => _LangSetterState();
}

class _LangSetterState extends ConsumerState<_LangSetter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(languageProvider.notifier).set(widget.lang);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

void main() {
  testWidgets('Txt renders resolved text with interpolation', (tester) async {
    await tester.pumpWidget(
      _app(
        const Txt('today.title', vars: {'N': '6'}),
        content: {
          ('today.title', 'EN'): const ContentResolved(
            text: 'Day {N} of 30',
            version: 1,
            isPlaceholder: true,
          ),
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Day 6 of 30'), findsOneWidget);
  });

  testWidgets('Txt renders NOTHING on NotApproved — fail closed',
      (tester) async {
    await tester.pumpWidget(
      _app(const Txt('missing.key'), content: const {}),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('language switch never flashes the previous language',
      (tester) async {
    final content = {
      ('today.title', 'EN'): const ContentResolved(
        text: 'english', version: 1, isPlaceholder: false,),
      ('today.title', 'UZ'): const ContentResolved(
        text: 'uzbek', version: 1, isPlaceholder: false,),
    };
    late WidgetRef appRef;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentProvider.overrideWith((ref, spec) async => content[spec]!),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              appRef = ref;
              return const Scaffold(body: Txt('today.title'));
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('english'), findsOneWidget);

    appRef.read(languageProvider.notifier).set('UZ');
    // The frame straight after the switch: EN must ALREADY be gone,
    // even though UZ may still be loading.
    await tester.pump();
    expect(find.text('english'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('uzbek'), findsOneWidget);
  });

  testWidgets('TxtGate shows fallback when a required key is refused',
      (tester) async {
    await tester.pumpWidget(
      _app(
        const TxtGate(
          requiredKeys: ['clinical.article'],
          fallback: Icon(Icons.lock_outline_rounded),
          child: Icon(Icons.article_outlined),
        ),
        content: const {},
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.article_outlined), findsNothing);
  });
}
