import 'package:flutter/material.dart';

/// Dashboard-specific color palette.
/// Based on the supplied HTML design.
class InvestorDashboardColors {
  static const background = Color(0xFF18372B);
  static const card = Color(0xFF1F4435);
  static const cardDark = Color(0xFF12291F);
  static const border = Color(0xFF34584A);

  static const textPrimary = Color(0xFFF4F1E9);
  static const textMuted = Color(0xFFB5C3B9);

  static const gold = Color(0xFFC4A76C);
  static const positive = Color(0xFF7BE0B0);
}

/// Investor dashboard header.
class InvestorHeader extends StatelessWidget {
  const InvestorHeader({super.key, required this.investorName});

  final String investorName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good morning',
              style: TextStyle(
                fontSize: 13,
                color: InvestorDashboardColors.textMuted,
                fontFamily: 'Manrope',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              investorName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: InvestorDashboardColors.textPrimary,
                fontFamily: 'Cormorant Garamond',
              ),
            ),
          ],
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: InvestorDashboardColors.card,
            shape: BoxShape.circle,
            border: Border.all(color: InvestorDashboardColors.border),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                size: 22,
                color: InvestorDashboardColors.textPrimary,
              ),

              Positioned(
                top: 9,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: InvestorDashboardColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Main portfolio value card.
class PortfolioValueCard extends StatelessWidget {
  const PortfolioValueCard({
    super.key,
    required this.portfolioValue,
    required this.growthAmount,
    required this.growthPercentage,
  });

  final String portfolioValue;
  final String growthAmount;
  final String growthPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: InvestorDashboardColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: InvestorDashboardColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio value',
            style: TextStyle(
              fontSize: 13,
              color: InvestorDashboardColors.textMuted,
              fontFamily: 'Manrope',
            ),
          ),

          const SizedBox(height: 6),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              portfolioValue,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: InvestorDashboardColors.textPrimary,
                fontFamily: 'Manrope',
              ),
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                size: 15,
                color: InvestorDashboardColors.positive,
              ),

              Text(
                '$growthAmount ($growthPercentage)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: InvestorDashboardColors.positive,
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Sample data',
            style: TextStyle(
              fontSize: 11,
              color: InvestorDashboardColors.textMuted,
              fontFamily: 'Manrope',
            ),
          ),
        ],
      ),
    );
  }
}

/// Holdings and invested summary cards.
class InvestorSummaryCards extends StatelessWidget {
  const InvestorSummaryCards({
    super.key,
    required this.holdings,
    required this.invested,
  });

  final String holdings;
  final String invested;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(title: 'Holdings', value: holdings),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _SummaryCard(title: 'Invested', value: invested),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: InvestorDashboardColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: InvestorDashboardColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: InvestorDashboardColors.textMuted,
              fontFamily: 'Manrope',
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: InvestorDashboardColors.textPrimary,
              fontFamily: 'Manrope',
            ),
          ),
        ],
      ),
    );
  }
}

/// Explore shortcuts.
class InvestorExploreGrid extends StatelessWidget {
  const InvestorExploreGrid({super.key, required this.onTap});

  final ValueChanged<String> onTap;

  static const List<_ExploreItem> _items = [
    _ExploreItem('Orders', Icons.format_list_bulleted_rounded),
    _ExploreItem('Trades', Icons.sync_rounded),
    _ExploreItem('Transactions', Icons.receipt_long_outlined),
    _ExploreItem('IPO', Icons.flag_outlined),
    _ExploreItem('Notifications', Icons.notifications_none_rounded),
    _ExploreItem('Profile', Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 104,
      ),
      itemBuilder: (context, index) {
        final item = _items[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(item.title),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                color: InvestorDashboardColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: InvestorDashboardColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: InvestorDashboardColors.cardDark,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: InvestorDashboardColors.gold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: InvestorDashboardColors.textPrimary,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExploreItem {
  const _ExploreItem(this.title, this.icon);

  final String title;
  final IconData icon;
}

/// Investor bottom navigation.
class InvestorNavItem {
  static const labels = ['Home', 'Portfolio', 'Market', 'Trade', 'More'];
}

class InvestorBottomNav extends StatelessWidget {
  const InvestorBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.pie_chart_outline_rounded,
    Icons.show_chart_rounded,
    Icons.swap_vert_rounded,
    Icons.more_horiz_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: InvestorDashboardColors.cardDark,
        border: Border(top: BorderSide(color: InvestorDashboardColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(InvestorNavItem.labels.length, (index) {
            final isSelected = selectedIndex == index;

            final color = isSelected
                ? InvestorDashboardColors.gold
                : InvestorDashboardColors.textMuted;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_icons[index], size: 22, color: color),

                    const SizedBox(height: 4),

                    Text(
                      InvestorNavItem.labels[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: color,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
