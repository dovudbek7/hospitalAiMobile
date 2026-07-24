// P17 · Day-30 satisfaction survey. EXACTLY five questions, no more.
// Always skippable — never blocks programme completion. The free-text
// answer goes only to the API (write-only server-side); it can never reach
// telemetry because ClientEvents has no method that accepts prose.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/txt.dart';
import '../../core/models/api_models.dart';
import '../../core/providers.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/primary_button.dart';

class P17SurveyScreen extends ConsumerStatefulWidget {
  const P17SurveyScreen({super.key});

  @override
  ConsumerState<P17SurveyScreen> createState() => _P17SurveyScreenState();
}

class _P17SurveyScreenState extends ConsumerState<P17SurveyScreen> {
  int? _q1;
  int? _q2;
  int? _q3; // 5 = yes, 3 = somewhat, 1 = no (scale direction: 1 = worst)
  int? _q4; // 5 = yes, 3 = maybe, 1 = no
  final _freeText = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _freeText.dispose();
    super.dispose();
  }

  void _goHome() {
    final router = GoRouter.maybeOf(context);
    if (router == null) {
      Navigator.of(context).maybePop();
    } else {
      router.go(Routes.today);
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final text = _freeText.text.trim();
      await ref.read(patientApiProvider).submitSurvey(
            SurveyPayload(
              q1Helpful: _q1,
              q2Easy: _q2,
              q3AdherenceSupport: _q3,
              q4Recommend: _q4,
              freeText: text.isEmpty ? null : text,
            ),
          );
      if (mounted) _goHome();
    } on Exception {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.s24),
          children: [
            Txt(
              'survey.title',
              style: AppText.display.copyWith(fontSize: 28),
            ),
            const SizedBox(height: AppSpace.s4),
            const Txt('survey.intro', style: AppText.bodyL),
            const SizedBox(height: AppSpace.s32),

            // Q1 + Q2: 1–5 scales, direction identical in every language
            // (1 = worst), enforced by the shared widget below.
            _ScaleQuestion(
              questionKey: 'survey.q1',
              lowKey: 'survey.q1.low',
              highKey: 'survey.q1.high',
              value: _q1,
              onChanged: (v) => setState(() => _q1 = v),
            ),
            _ScaleQuestion(
              questionKey: 'survey.q2',
              lowKey: 'survey.q2.low',
              highKey: 'survey.q2.high',
              value: _q2,
              onChanged: (v) => setState(() => _q2 = v),
            ),
            _ChoiceQuestion(
              questionKey: 'survey.q3',
              options: const [
                ('survey.q3.yes', 5),
                ('survey.q3.somewhat', 3),
                ('survey.q3.no', 1),
              ],
              value: _q3,
              onChanged: (v) => setState(() => _q3 = v),
            ),
            _ChoiceQuestion(
              questionKey: 'survey.q4',
              options: const [
                ('survey.q4.yes', 5),
                ('survey.q4.maybe', 3),
                ('survey.q4.no', 1),
              ],
              value: _q4,
              onChanged: (v) => setState(() => _q4 = v),
            ),

            // Q5 — the ONLY free-text field in the entire app, optional,
            // stored for humans, never analytics.
            Txt(
              'survey.q5',
              style: AppText.bodyL.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpace.s4),
            const Txt('survey.optional', style: AppText.caption),
            const SizedBox(height: AppSpace.s12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.cardAll,
                border: Border.all(color: AppColors.line),
                boxShadow: AppShadow.card,
              ),
              padding: const EdgeInsets.all(AppSpace.s16),
              child: TextField(
                controller: _freeText,
                maxLines: 4,
                maxLength: 2000,
                style: AppText.body,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  counterText: '',
                ),
              ),
            ),

            const SizedBox(height: AppSpace.s32),
            PrimaryButton(
              onPressed: _submitting ? null : _submit,
              child: const Txt('survey.submit'),
            ),
            const SizedBox(height: AppSpace.s8),
            // Always skippable.
            TextButton(
              onPressed: _goHome,
              child: Txt(
                'survey.skip',
                style: AppText.button.copyWith(color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScaleQuestion extends StatelessWidget {
  const _ScaleQuestion({
    required this.questionKey,
    required this.lowKey,
    required this.highKey,
    required this.value,
    required this.onChanged,
  });

  final String questionKey;
  final String lowKey;
  final String highKey;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Txt(
            questionKey,
            style: AppText.bodyL.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpace.s12),
          Row(
            children: [
              for (var n = 1; n <= 5; n++) ...[
                if (n > 1) const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: value == n,
                    value: '$n',
                    child: Material(
                      color: value == n
                          ? AppColors.brand600
                          : AppColors.surface,
                      borderRadius: AppRadius.buttonAll,
                      child: InkWell(
                        onTap: () => onChanged(n),
                        borderRadius: AppRadius.buttonAll,
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.buttonAll,
                            border: value == n
                                ? null
                                : Border.all(color: AppColors.line),
                          ),
                          child: Text(
                            '$n',
                            style: AppText.bodyL.copyWith(
                              fontWeight: FontWeight.w700,
                              color: value == n
                                  ? AppColors.surface
                                  : AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpace.s4),
          Row(
            children: [
              Expanded(child: Txt(lowKey, style: AppText.caption)),
              const SizedBox(width: AppSpace.s12),
              Expanded(
                child: Txt(
                  highKey,
                  style: AppText.caption,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChoiceQuestion extends StatelessWidget {
  const _ChoiceQuestion({
    required this.questionKey,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String questionKey;
  final List<(String, int)> options;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Txt(
            questionKey,
            style: AppText.bodyL.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpace.s12),
          Row(
            children: [
              for (final (key, score) in options) ...[
                if (key != options.first.$1)
                  const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: value == score,
                    child: Material(
                      color: value == score
                          ? AppColors.brand600
                          : AppColors.surface,
                      borderRadius: AppRadius.buttonAll,
                      child: InkWell(
                        onTap: () => onChanged(score),
                        borderRadius: AppRadius.buttonAll,
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.buttonAll,
                            border: value == score
                                ? null
                                : Border.all(color: AppColors.line),
                          ),
                          child: DefaultTextStyle.merge(
                            style: AppText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: value == score
                                  ? AppColors.surface
                                  : AppColors.ink,
                            ),
                            child: Txt(key),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
