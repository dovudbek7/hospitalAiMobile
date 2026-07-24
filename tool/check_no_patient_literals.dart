// Hospital AI — the no-patient-literals gate.
//
// Golden rule 2: every patient-visible string resolves from the content
// library by key. No string literals in patient-facing widgets, ever.
//
// This script walks lib/features/** and lib/core/widgets/** and fails the
// build when a string literal is passed where a patient could read it:
//
//   Text('...')            TextSpan(text: '...')
//   hintText: '...'        labelText: '...'
//   tooltip: '...'         Semantics(label: '...')
//   SnackBar(content: Text('...'))   — caught via Text()
//
// What is allowed:
//   - lib/features/onboarding/**/p1_language_screen.dart — the three
//     language names (Oʻzbekcha / Русский / English), the only hardcoded
//     patient strings permitted in the entire app.
//   - Txt('content.key') — a content KEY, not display text. The Txt widget
//     resolves it through the content library (F3).
//   - Key('...'), debugLabel: '...', semanticsIdentifier: '...'
//   - anything in a line ending with  // literal-ok: <reason>
//     (for developer-facing debug scaffolding; reviewed in PR)
//
// Run:  dart run tool/check_no_patient_literals.dart
// CI runs this on every push. Exit code 1 on any violation.

import 'dart:io';

const scannedRoots = ['lib/features', 'lib/core/widgets'];

const allowlistedFiles = [
  // P1: the only hardcoded patient-visible strings in the app.
  'p1_language_screen.dart',
  // Developer-facing gallery on a debug-only route — sample strings for
  // visual review against design/index.html, never shown to a patient.
  'design_gallery_screen.dart',
];

// Patterns that put a literal in front of a patient.
final violations = <String, RegExp>{
  "Text('…')": RegExp('''\\bText\\(\\s*r?['"]'''),
  "Text.rich with literal": RegExp('''\\bTextSpan\\(\\s*text:\\s*r?['"]'''),
  "hintText: '…'": RegExp('''\\bhintText:\\s*r?['"]'''),
  "labelText: '…'": RegExp('''\\blabelText:\\s*r?['"]'''),
  "helperText: '…'": RegExp('''\\bhelperText:\\s*r?['"]'''),
  "errorText: '…'": RegExp('''\\berrorText:\\s*r?['"]'''),
  "tooltip: '…'": RegExp('''\\btooltip:\\s*r?['"]'''),
  "Semantics label: '…'": RegExp('''\\blabel:\\s*r?['"]'''),
  "semanticLabel: '…'": RegExp('''\\bsemanticLabel:\\s*r?['"]'''),
};

// Lines matching any of these are fine even if a violation pattern hits.
final lineExceptions = <RegExp>[
  RegExp(r'//\s*literal-ok:'),
  RegExp('''\\bKey\\(\\s*r?['"]'''),
  RegExp('''\\bdebugLabel:'''),
];

void main() {
  final findings = <String>[];

  for (final root in scannedRoots) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;

    final files = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'));

    for (final file in files) {
      final name = file.uri.pathSegments.last;
      if (allowlistedFiles.contains(name)) continue;

      final lines = file.readAsLinesSync();
      var inBlockComment = false;

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final trimmed = line.trimLeft();

        if (inBlockComment) {
          if (trimmed.contains('*/')) inBlockComment = false;
          continue;
        }
        if (trimmed.startsWith('/*')) {
          if (!trimmed.contains('*/')) inBlockComment = true;
          continue;
        }
        if (trimmed.startsWith('//')) continue;
        if (lineExceptions.any((e) => e.hasMatch(line))) continue;

        for (final entry in violations.entries) {
          if (entry.value.hasMatch(line)) {
            findings.add('${file.path}:${i + 1}: ${entry.key}\n    $trimmed');
          }
        }
      }
    }
  }

  if (findings.isEmpty) {
    stdout.writeln('no-patient-literals: clean');
    return;
  }

  stderr.writeln(
    'no-patient-literals: ${findings.length} violation(s).\n'
    'Patient-visible text must come from the content library — use '
    "Txt('content.key') instead.\n",
  );
  findings.forEach(stderr.writeln);
  exitCode = 1;
}
