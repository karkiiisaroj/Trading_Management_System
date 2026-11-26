import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';

/// Outcome of a cancel request (BR-I29).
///
/// [cancelled] true: the order was cancelled.
/// [cancelled] false: the order's status no longer permits cancellation
/// (for example it was already executed).
class CancelOrderState extends StatelessWidget {
  const CancelOrderState({
    super.key,
    this.orderNumber = '1042',
    this.symbol = 'ABCD',
    this.cancelled = true,
    this.currentStatus = 'Executed',
    this.onViewOrders,
    this.onBack,
    this.onDestinationSelected,
  });

  final String orderNumber;
  final String symbol;
  final bool cancelled;

  /// Only used when [cancelled] is false.
  final String currentStatus;

  final VoidCallback? onViewOrders;
  final VoidCallback? onBack;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final accent = cancelled ? AppColors.brass : AppColors.loss;

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
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: onBack ?? () => Navigator.maybePop(context),
                        tooltip: 'Back',
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.text,
                          size: 30,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        border: Border.all(color: accent),
                      ),
                      child: Icon(
                        cancelled
                            ? Icons.check_rounded
                            : Icons.block_rounded,
                        color: accent,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      cancelled ? 'Order cancelled' : 'Cannot cancel',
                      textAlign: TextAlign.center,
                      style: AppTypography.heading,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    SizedBox(
                      width: 300,
                      child: Text(
                        cancelled
                            ? 'Order #$orderNumber for $symbol was cancelled. '
                                  'No trade will be made.'
                            : 'Order #$orderNumber for $symbol is '
                                  '${currentStatus.toLowerCase()}, so it can '
                                  'no longer be cancelled. Contact your '
                                  'broker if you need help.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMuted.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AarthaButton(label: 'View orders', onPressed: onViewOrders),
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
