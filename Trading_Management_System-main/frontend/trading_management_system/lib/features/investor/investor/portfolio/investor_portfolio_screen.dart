import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class InvestorPortfolioScreen extends StatelessWidget {
  const InvestorPortfolioScreen({
    super.key,
    this.totalValue = 1245000,
    this.gainPercent = 5.5,
    this.onDestinationSelected,
    this.onSecuritySelected,
  });

  final double totalValue;
  final double gainPercent;
  final ValueChanged<int>? onDestinationSelected;
  final ValueChanged<String>? onSecuritySelected;


  static const List<_Holding> _holdings = [
    _Holding(
      symbol: 'ABCD',
      company: 'Sample Bank Ltd',
      quantity: 50,
      averageCost: 420.00,
    ),
    _Holding(
      symbol: 'EFGH',
      company: 'Sample Hydropower Ltd',
      quantity: 120,
      averageCost: 310.50,
    ),
    _Holding(
      symbol: 'IJKL',
      company: 'Sample Insurance Ltd',
      quantity: 30,
      averageCost: 890.00,
    ),
    _Holding(
      symbol: 'MNOP',
      company: 'Sample Finance Ltd',
      quantity: 200,
      averageCost: 215.25,
    ),
  ];

  String _formatCurrency(double value) {
    final rounded = value.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < rounded.length; i++) {
      buffer.write(rounded[i]);

      final remaining = rounded.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }

    return 'Rs. $buffer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                    sliver: SliverToBoxAdapter(child: _buildHeader()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                    sliver: SliverToBoxAdapter(child: _buildSummaryCard()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 2),
                    sliver: SliverToBoxAdapter(child: _buildColumnHeaders()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return _buildHoldingRow(context, _holdings[index]);
                      }, childCount: _holdings.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Portfolio',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Your holdings',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total value',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _formatCurrency(totalValue),
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Gain', style: TextStyle(color: AppColors.muted, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                '${gainPercent >= 0 ? '▲' : '▼'} ${gainPercent.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  color: gainPercent >= 0 ? AppColors.gain : AppColors.loss,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeaders() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SECURITY',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'QUANTITY / AVG COST',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingRow(BuildContext context, _Holding holding) {
    return InkWell(
      onTap: () {
        onSecuritySelected?.call(holding.symbol);
      },
      splashColor: AppColors.brass.withValues(alpha: 0.08),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holding.symbol,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    holding.company,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${holding.quantity} units',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Avg Rs. ${holding.averageCost.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      _NavItem(Icons.home_outlined, 'Home'),
      _NavItem(Icons.pie_chart_outline_rounded, 'Portfolio'),
      _NavItem(Icons.show_chart_rounded, 'Market'),
      _NavItem(Icons.swap_vert_rounded, 'Trade'),
      _NavItem(Icons.more_horiz_rounded, 'More'),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == 1;

          return Expanded(
            child: InkWell(
              onTap: () {
                onDestinationSelected?.call(index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: selected ? AppColors.brass : AppColors.muted, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? AppColors.brass : AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Holding {
  const _Holding({
    required this.symbol,
    required this.company,
    required this.quantity,
    required this.averageCost,
  });

  final String symbol;
  final String company;
  final int quantity;
  final double averageCost;
}

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
