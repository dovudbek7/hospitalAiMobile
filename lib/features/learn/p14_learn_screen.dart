// P14 · Learn. Only signed-off, ALREADY-UNLOCKED content arrives from the
// server; later items are hidden by construction, never greyed. Friendly
// empty state; available offline from cache.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/txt.dart';
import '../../core/models/api_models.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/misc.dart';
import 'learn_providers.dart';

class P14LearnScreen extends ConsumerWidget {
  const P14LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final education = ref.watch(educationProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: education.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const _EmptyLearn(),
          data: (index) {
            if (index.items.isEmpty) return const _EmptyLearn();

            // Most recently unlocked first — "relevant today" on top.
            final items = [...index.items]
              ..sort((a, b) => b.unlockDay.compareTo(a.unlockDay));

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.s16,
                AppSpace.s24,
                AppSpace.s16,
                120,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 56),
                  child: Txt(
                    'learn.title',
                    style: AppText.display.copyWith(fontSize: 30),
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
                const Txt('learn.subtitle', style: AppText.body),
                const SizedBox(height: AppSpace.s24),
                const Eyebrow(
                  color: AppColors.brand700,
                  child: Txt('learn.relevant'),
                ),
                const SizedBox(height: AppSpace.s12),
                _ArticleRow(item: items.first, highlighted: true),
                if (items.length > 1) ...[
                  const SizedBox(height: AppSpace.s24),
                  const Eyebrow(child: Txt('learn.all')),
                  const SizedBox(height: AppSpace.s12),
                  for (final item in items.skip(1)) ...[
                    _ArticleRow(item: item),
                    const SizedBox(height: AppSpace.s12),
                  ],
                ],
                const SizedBox(height: AppSpace.s12),
                const Txt('learn.more_unlock', style: AppText.caption),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.item, this.highlighted = false});

  final EducationItem item;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: highlighted ? AppColors.brand200 : null,
      lifted: highlighted,
      onTap: () =>
          context.push('${Routes.article}/${Uri.encodeComponent(item.contentKey)}'),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.tintVioletBg,
              borderRadius: AppRadius.tileAll,
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: AppColors.tintVioletFg,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpace.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The server has no separate title key, so the approved
                // article text doubles as the headline (first line).
                Txt(
                  item.contentKey,
                  style: AppText.bodyL.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Txt(
                  'learn.unlocked_day',
                  vars: {'N': '${item.unlockDay}'},
                  style: AppText.caption,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class _EmptyLearn extends StatelessWidget {
  const _EmptyLearn();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppSpace.s64,
              height: AppSpace.s64,
              decoration: const BoxDecoration(
                color: AppColors.tintVioletBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: AppColors.tintVioletFg,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s16),
          Txt(
            'learn.empty',
            style: AppText.h2.copyWith(fontSize: 19),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
