import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Copy exists in all three languages for every key the app uses — the
/// automatable slice of "copy verified in all three languages". Semantic
/// review by a native speaker remains a hard gate before real patients.
void main() {
  test('every seed key ships EN + UZ + RU, all flagged placeholder', () {
    final seed = jsonDecode(
      File('assets/content/seed_content.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    expect(seed, isNotEmpty);
    for (final entry in seed.entries) {
      final langs = entry.value as Map<String, dynamic>;
      for (final lang in ['EN', 'UZ', 'RU']) {
        final item = langs[lang] as Map<String, dynamic>?;
        expect(item, isNotNull, reason: '${entry.key} missing $lang');
        expect(item!['text'], isNotEmpty);
        expect(item['isPlaceholder'], isTrue,
            reason: 'seed strings are placeholders until clinician sign-off');
        if (lang != 'EN') {
          expect(
            (item['text'] as String).contains('PLACEHOLDER'),
            isTrue,
            reason: '${entry.key}/$lang must carry the unreviewed marker '
                '(same convention as the live server)',
          );
        }
      }
    }
  });

  test('the {TOKEN}s inside translations match EN exactly', () {
    final seed = jsonDecode(
      File('assets/content/seed_content.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final tokenRe = RegExp(r'\{[A-Z_0-9]+\}');

    for (final entry in seed.entries) {
      final langs = entry.value as Map<String, dynamic>;
      final enTokens = tokenRe
          .allMatches((langs['EN'] as Map<String, dynamic>)['text'] as String)
          .map((m) => m.group(0))
          .toSet();
      for (final lang in ['UZ', 'RU']) {
        final tokens = tokenRe
            .allMatches(
              (langs[lang] as Map<String, dynamic>)['text'] as String,
            )
            .map((m) => m.group(0))
            .toSet();
        expect(tokens, enTokens,
            reason: '${entry.key}/$lang token set must match EN');
      }
    }
  });
}
