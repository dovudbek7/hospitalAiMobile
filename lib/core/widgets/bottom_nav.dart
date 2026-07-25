import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.label,
    this.semanticLabel,
  });

  final IconData icon;

  /// Patient-visible — resolved from the content library by the caller.
  final Widget label;

  /// Screen-reader name (resolved string). Inactive tabs render icon-only,
  /// so this is what TalkBack/VoiceOver announces for them.
  final String? semanticLabel;
}

/// Floating pill navigation from the prototype: 64dp white bar, the active
/// item a 50dp brand pill that stays inside the bar.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.items,
    required this.activeIndex,
    required this.onSelect,
    super.key,
  });

  final List<BottomNavItem> items;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadow.nav,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _NavButton(
                  item: items[i],
                  active: i == activeIndex,
                  onTap: () => onSelect(i),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.surface : AppColors.muted;
    return Semantics(
      button: true,
      selected: active,
      label: item.semanticLabel,
      child: Material(
        color: active ? AppColors.brand600 : Colors.transparent,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(19),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s8),
            // Active: icon + label pill. Inactive: icon only — the label
            // stays in the tree invisibly so screen readers still hear it.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 22, color: color),
                if (active) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: DefaultTextStyle.merge(
                      style: AppText.caption.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: item.label,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
