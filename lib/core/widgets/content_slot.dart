import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Development placeholder for clinician-approved prose that does not exist
/// yet: shows the content key and skeleton bars instead of inventing text.
/// Never shown once the key resolves — the real string replaces it with no
/// layout change. The key itself is an identifier, not patient prose.
class ContentSlot extends StatelessWidget {
  const ContentSlot({required this.contentKey, this.lines = 5, super.key});

  final String contentKey;
  final int lines;

  static const _widths = [1.0, 0.96, 0.88, 1.0, 0.72, 0.94, 0.6];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: BoxDecoration(
        color: AppColors.brand50.withValues(alpha: 0.7),
        borderRadius: AppRadius.cardAll,
        border: Border.all(color: AppColors.brand200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contentKey,
            style: AppText.caption.copyWith(
              fontFamily: AppText.monoFamily,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.brand700,
            ),
          ),
          const SizedBox(height: AppSpace.s16),
          for (var i = 0; i < lines; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: _widths[i % _widths.length],
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.brand200.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
