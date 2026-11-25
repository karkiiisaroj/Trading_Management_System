import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.onBrowseMarket,
    this.onDestinationSelected,
  });

  final VoidCallback? onBrowseMarket;
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
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
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

                    const SizedBox(height: 110),

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
                              Icons.pie_chart_outline_rounded,
                              color: AppColors.brass,
                              size: 40,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'No holdings yet',
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
                              'When you buy securities, they will appear here.',
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
                                  onBrowseMarket ??
                                  () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Market navigation is not connected yet.',
                                        ),
                                      ),
                                    );
                                  },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brass,
                                foregroundColor: AppColors.deep,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Browse market',
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
          final selected = index == 1;

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
