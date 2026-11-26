import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/animations.dart';

class StaleDataState extends StatelessWidget {
  const StaleDataState({
    super.key,
    this.lastUpdated = '06 Oct',
    this.onRetry,
    this.onDestinationSelected,
  });

  final String lastUpdated;
  final VoidCallback? onRetry;
  final ValueChanged<int>? onDestinationSelected;


  static const List<_StaleSecurity> _securities = [
    _StaleSecurity(
      symbol: 'ABCD',
      company: 'Sample Bank Ltd',
      price: '512.00',
      change: '▲ 1.2%',
      positive: true,
    ),
    _StaleSecurity(
      symbol: 'EFGH',
      company: 'Sample Hydropower Ltd',
      price: '298.40',
      change: '▼ 0.8%',
      positive: false,
    ),
    _StaleSecurity(
      symbol: 'IJKL',
      company: 'Sample Insurance Ltd',
      price: '905.10',
      change: '▲ 0.4%',
      positive: true,
    ),
  ];

  Widget _securityCard(_StaleSecurity security) {
    final changeColor = security.positive ? AppColors.gain : AppColors.loss;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      security.symbol,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      security.company,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs. ${security.price}',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    security.change,
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 12,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Last close · $lastUpdated (historical)',
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _warningCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brass),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.refresh, color: AppColors.brass, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Couldn't update market data",
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Showing the last saved data from $lastUpdated. '
                  'We will try again later.',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 44,
                  child: TextButton(
                    onPressed: onRetry,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      foregroundColor: AppColors.brass,
                    ),
                    child: const Text(
                      'Try again',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationItem({
    required IconData icon,
    required String label,
    required int index,
    bool selected = false,
  }) {
    final color = selected ? AppColors.brass : AppColors.muted;

    return Expanded(
      child: InkWell(
        onTap: () => onDestinationSelected?.call(index),
        child: SizedBox(
          height: 76,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _navigationItem(icon: Icons.home_outlined, label: 'Home', index: 0),
          _navigationItem(
            icon: Icons.pie_chart_outline,
            label: 'Portfolio',
            index: 1,
          ),
          _navigationItem(
            icon: Icons.show_chart,
            label: 'Market',
            index: 2,
            selected: true,
          ),
          _navigationItem(icon: Icons.swap_vert, label: 'Trade', index: 3),
          _navigationItem(icon: Icons.more_horiz, label: 'More', index: 4),
        ],
      ),
    );
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Market',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ).fadeUp(0),
                    const SizedBox(height: 2),
                    const Text(
                      'Historical data · not live',
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                    ).fadeUp(1),
                    _warningCard().fadeUp(2),
                    for (final (i, security) in _securities.indexed)
                      _securityCard(security).fadeUp(i + 3),
                  ],
                ),
              ),
            ),
            _bottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class _StaleSecurity {
  const _StaleSecurity({
    required this.symbol,
    required this.company,
    required this.price,
    required this.change,
    required this.positive,
  });

  final String symbol;
  final String company;
  final String price;
  final String change;
  final bool positive;
}
