import 'package:flutter/material.dart';

import '../theme/theme.dart';

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.icon,
                      size: 22,
                      color: tab.index == selectedIndex
                          ? AppColors.brass
                          : AppColors.muted,
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
              ),
            ),
        ],
      ),
    );
  }
}
