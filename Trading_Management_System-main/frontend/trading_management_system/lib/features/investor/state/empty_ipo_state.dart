import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class EmptyIpoState extends StatelessWidget {
  const EmptyIpoState({
    super.key,
    this.onBack,
    this.onBackToHome,
    this.onDestinationSelected,
  });

  final VoidCallback? onBack;
  final VoidCallback? onBackToHome;
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed:
                              onBack ?? () => Navigator.maybePop(context),
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            color: AppColors.text,
                            size: 30,
                          ),
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'IPO',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 96),

                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Icons.access_time_rounded,
                              color: AppColors.brass,
                              size: 40,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'No open IPOs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const SizedBox(
                            width: 290,
                            child: Text(
                              'When an IPO opens for applications, '
                              'it will appear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  onBackToHome ??
                                  () => onDestinationSelected?.call(0),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brass,
                                foregroundColor: AppColors.deep,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Back to home',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildBottomNavigation() {
    const items = [
      _NavigationItem(label: 'Home', icon: Icons.home_outlined),
      _NavigationItem(
        label: 'Portfolio',
        icon: Icons.pie_chart_outline_rounded,
      ),
      _NavigationItem(label: 'Market', icon: Icons.show_chart_rounded),
      _NavigationItem(label: 'Trade', icon: Icons.swap_vert_rounded),
      _NavigationItem(label: 'More', icon: Icons.more_horiz_rounded),
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

          return Expanded(
            child: InkWell(
              onTap: () => onDestinationSelected?.call(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 22, color: selected ? AppColors.brass : AppColors.muted),
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

class _NavigationItem {
  const _NavigationItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
