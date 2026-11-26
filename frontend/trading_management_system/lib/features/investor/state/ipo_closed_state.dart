import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/animations.dart';

class IpoClosedState extends StatelessWidget {
  const IpoClosedState({
    super.key,
    this.companyName = 'Sample Bank IPO',
    this.closingDate = '16 Oct',
    this.onBack,
    this.onBackToIpos,
    this.onDestinationSelected,
  });

  final String companyName;
  final String closingDate;

  final VoidCallback? onBack;
  final VoidCallback? onBackToIpos;
  final ValueChanged<int>? onDestinationSelected;


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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader().fadeUp(0),
                    const SizedBox(height: 72),
                    _buildClosedContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.text, size: 21),
          tooltip: 'Back',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        ),
        const SizedBox(width: 4),
        const Text(
          'Apply for IPO',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildClosedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.access_time_rounded, color: AppColors.muted, size: 40),
        ).popIn(1),
        const SizedBox(height: 24),
        const Text(
          'Applications are closed',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ).fadeUp(2),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 290),
          child: Text(
            '$companyName closed on $closingDate, so you can no longer apply. '
            'Your broker can tell you about future offerings.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 14, height: 1.5),
          ),
        ).fadeUp(3),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.muted),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Closed',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ).popIn(4),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onBackToIpos,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brass,
              foregroundColor: AppColors.onBrass,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Back to IPOs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ).shine().fadeUp(5),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      _NavigationItem(Icons.home_outlined, 'Home'),
      _NavigationItem(Icons.pie_chart_outline, 'Portfolio'),
      _NavigationItem(Icons.show_chart, 'Market'),
      _NavigationItem(Icons.swap_vert, 'Trade'),
      _NavigationItem(Icons.more_horiz, 'More'),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == 4;
          final color = selected ? AppColors.brass : AppColors.muted;

          return Expanded(
            child: InkWell(
              onTap: () => onDestinationSelected?.call(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: color, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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

class _NavigationItem {
  const _NavigationItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
