import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class NoAccountState extends StatelessWidget {
  const NoAccountState({
    super.key,
    this.onContactBroker,
    this.onDestinationSelected,
  });

  final VoidCallback? onContactBroker;
  final ValueChanged<int>? onDestinationSelected;


  void _handleContactBroker(BuildContext context) {
    if (onContactBroker != null) {
      onContactBroker!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect this action to your broker contact details.'),
        ),
      );
    }
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
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 120),
                    _buildEmptyState(context),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Place and track orders',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const Icon(
              Icons.work_outline_rounded,
              color: AppColors.brass,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'No trading account yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Your broker sets up your trading account. "
              "Once it's ready, you can place orders here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => _handleContactBroker(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brass,
              foregroundColor: AppColors.onBrass,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Contact your broker',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
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
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == 3;
          final itemColor = isSelected ? AppColors.brass : AppColors.muted;

          return Expanded(
            child: InkWell(
              onTap: () {
                onDestinationSelected?.call(index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: itemColor, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: itemColor,
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

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
