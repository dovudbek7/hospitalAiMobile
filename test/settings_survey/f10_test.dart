import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/features/learn/p15_article_screen.dart';
import 'package:hospital_ai/features/settings/p16_settings_screen.dart';
import 'package:hospital_ai/features/survey/p17_survey_screen.dart';

import '../network/fake_adapter.dart';

Future<(ProviderContainer, FakeAdapter)> _setup({
  Map<(String, String), String>? content,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final adapter = FakeAdapter((o) => FakeResponse(200, {'ok': true}));
  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      databaseProvider.overrideWith((ref) {
        final db = AppDatabase.memory();
        ref.onDispose(db.close);
        return db;
      }),
      contentProvider.overrideWith((ref, spec) async {
        final mapped = content?[spec];
        if (mapped != null) {
          return ContentResolved(
            text: mapped,
            version: 1,
            isPlaceholder: true,
          );
        }
        if (content != null) {
          return ContentNotApproved(
            contentKey: spec.$1,
            language: spec.$2,
          );
        }
        return ContentResolved(
          text: 'txt:${spec.$2}:${spec.$1}',
          version: 1,
          isPlaceholder: true,
        );
      }),
    ],
  );
  addTearDown(container.dispose);
  container.read(dioProvider).httpClientAdapter = adapter;
  return (container, adapter);
}

void main() {
  testWidgets(
      'P16: language switch re-renders every Txt instantly, no restart',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final (c, adapter) = await _setup();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: const MaterialApp(home: P16SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // EN initially — every Txt carries the language marker.
    expect(find.text('txt:EN:settings.language'), findsOneWidget);

    await tester.tap(find.text('Русский'));
    await tester.pumpAndSettle();

    // The SAME widget tree now renders RU text — no navigation happened.
    expect(find.text('txt:RU:settings.language'), findsOneWidget);
    expect(find.text('txt:EN:settings.language'), findsNothing);
    // And the change was pushed to the server.
    expect(
      adapter.requests.any((r) => r.path.contains('/me/language')),
      isTrue,
    );
  });

  testWidgets('P17: exactly five questions; free text only in the API call',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final (c, adapter) = await _setup();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: const MaterialApp(home: P17SurveyScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Exactly five question keys on screen, no more.
    for (final q in ['q1', 'q2', 'q3', 'q4', 'q5']) {
      expect(find.text('txt:EN:survey.$q'), findsOneWidget);
    }
    // Exactly ONE free-text field in the whole screen (and app).
    expect(find.byType(TextField), findsOneWidget);

    // Answer q1 (tap "3") and type free text.
    await tester.ensureVisible(find.text('3').first);
    await tester.tap(find.text('3').first);
    await tester.enterText(
      find.byType(TextField),
      'private feedback for humans',
    );
    await tester.ensureVisible(find.text('txt:EN:survey.submit'));
    await tester.tap(find.text('txt:EN:survey.submit'));
    await tester.pumpAndSettle();

    // The API payload carries the text…
    final survey = adapter.requests
        .where((r) => r.path.contains('/me/survey'))
        .single;
    final body = survey.data as Map<String, dynamic>;
    expect(body['freeText'], 'private feedback for humans');
    expect(body['q1Helpful'], 3);

    // …and the telemetry outbox contains NO event with that prose.
    final db = c.read(databaseProvider);
    final events = await db.select(db.telemetryOutbox).get();
    for (final e in events) {
      expect(e.props.contains('private feedback'), isFalse,
          reason: 'free text must never enter an analytics event');
    }
  });

  testWidgets(
      'P15: missing translation shows the explicit panel, never a fallback',
      (tester) async {
    final (c, _) = await _setup(
      content: {
        // Only the panel strings resolve; the article itself does not.
        ('content.unavailable_in_language', 'EN'): 'Not in your language.',
        ('content.contact_hint', 'EN'): 'Contact your clinic.',
      },
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: const MaterialApp(
          home: P15ArticleScreen(
            contentKey: 'clinical.laparoscopic_appendectomy.day_5',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Not in your language.'), findsOneWidget);
    expect(find.text('CONTENT_NOT_APPROVED'), findsOneWidget);

    // content_viewed still fired, with the content_ref id only.
    final db = c.read(databaseProvider);
    final events = await db.select(db.telemetryOutbox).get();
    expect(
      events.any((e) =>
          e.name == 'content_viewed' &&
          e.props.contains('clinical.laparoscopic_appendectomy.day_5')),
      isTrue,
    );
  });
}
