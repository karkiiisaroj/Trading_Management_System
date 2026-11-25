import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';
import 'package:trading_management_system/core/widgets/widgets.dart';

/// Shown on the Orders screen when the investor has not placed any order.
class EmptyOrdersState extends StatelessWidget {
  const EmptyOrdersState({
    super.key,
    this.onBack,
    this.onPlaceOrder,
    this.onDestinationSelected,
  });

  final VoidCallback? onBack;
  final VoidCallback? onPlaceOrder;
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
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed:
                              onBack ?? () => Navigator.maybePop(context),
                          tooltip: 'Back',
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            color: AppColors.text,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Orders', style: AppTypography.heading),
                      ],
                    ),
                    const Spacer(),
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
                              Icons.format_list_bulleted_rounded,
                              color: AppColors.brass,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'No orders yet',
                            textAlign: TextAlign.center,
                            style: AppTypography.heading,
                          ),
                          const SizedBox(height: AppSpacing.s),
                          SizedBox(
                            width: 290,
                            child: Text(
                              'Your buy and sell orders will be listed here '
                              'once you place one.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMuted.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          AarthaButton(
                            label: 'Place an order',
                            onPressed: onPlaceOrder,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
            InvestorBottomNav(
              selectedIndex: InvestorTab.trade.index,
              onSelected: onDestinationSelected,
            ),
          ],
        ),
      ),
    );
  }
}
