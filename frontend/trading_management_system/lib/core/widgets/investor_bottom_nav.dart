import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'animations.dart';

/// The five investor tabs, in order. Every investor screen reports taps as
/// an index into this list, so the flow in `main.dart` can map them back.
enum InvestorTab {
  home('Home', Icons.home_outlined),
  portfolio('Portfolio', Icons.pie_chart_outline_rounded),
  market('Market', Icons.show_chart_rounded),
  trade('Trade', Icons.swap_vert_rounded),
  more('More', Icons.more_horiz_rounded);

  const InvestorTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Shared bottom navigation for the investor area.
class InvestorBottomNav extends StatelessWidget {
  const InvestorBottomNav({
    super.key,
    required this.selectedIndex,
    this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (final tab in InvestorTab.values)
            Expanded(
              child: InkWell(
                onTap: () => onSelected?.call(tab.index),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Brass bar that grows in over the selected tab.
                    if (tab.index == selectedIndex)
                      Positioned(
                        top: 0,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 30),
                          duration: reduceMotion(context)
                              ? Duration.zero
                              : const Duration(milliseconds: 420),
                          curve: Curves.easeOutCubic,
                          builder: (context, width, _) => Container(
                            width: width,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: AppColors.brass,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: tab.index == selectedIndex ? 1.08 : 1,
                          duration: const Duration(milliseconds: 220),
                          child: Icon(
                            tab.icon,
                            size: 22,
                            color: tab.index == selectedIndex
                                ? AppColors.brass
                                : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          tab.label,
                          style: AppTypography.caption.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: tab.index == selectedIndex
                                ? AppColors.brass
                                : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
