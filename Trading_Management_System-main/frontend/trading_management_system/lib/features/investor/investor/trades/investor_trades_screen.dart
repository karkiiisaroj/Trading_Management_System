import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/investor_bottom_nav.dart';

/// One executed trade (BR-I30). An order can produce several of these when
/// it is filled in parts (BR-I31), so [partLabel] reads like "Part 1 of 2".
class InvestorTradeRecord {
  const InvestorTradeRecord({
    required this.orderNumber,
    required this.symbol,
    required this.isBuy,
    required this.executedQuantity,
    required this.orderQuantity,
    required this.executionPrice,
    required this.date,
    this.partLabel,
  });

  final String orderNumber;
  final String symbol;
  final bool isBuy;

  /// Quantity actually executed (BR-I32), may be below [orderQuantity].
  final int executedQuantity;
  final int orderQuantity;

  /// Actual execution price (BR-I33).
  final double executionPrice;
  final String date;
  final String? partLabel;
}

/// Trades tab reached from More / Home explore: executions of the
/// investor's own orders only (BR-I27, BR-I36).
class InvestorTradesScreen extends StatelessWidget {
  const InvestorTradesScreen({
    super.key,
    this.trades = const [],
    this.onBack,
    this.onTradeSelected,
    this.onDestinationSelected,
  });

  final List<InvestorTradeRecord> trades;
  final VoidCallback? onBack;
  final ValueChanged<InvestorTradeRecord>? onTradeSelected;
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
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: onBack ?? () => Navigator.maybePop(context),
                        tooltip: 'Back',
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.text,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text('Trades', style: AppTypography.heading),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(left: 52),
                    child: Text(
                      'Executions of your orders',
                      style: AppTypography.label,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  if (trades.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxl),
                      child: Center(
                        child: Text(
                          'No trades yet. Executed orders appear here.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMuted,
                        ),
                      ),
                    )
                  else
                    for (final t in trades)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.m),
                        child: _TradeCard(
                          trade: t,
                          onTap: () => onTradeSelected?.call(t),
                        ),
                      ),
                ],
              ),
            ),
            InvestorBottomNav(
              selectedIndex: InvestorTab.more.index,
              onSelected: onDestinationSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade, required this.onTap});

  final InvestorTradeRecord trade;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final partial = trade.executedQuantity < trade.orderQuantity;
    final sideColor = trade.isBuy ? AppColors.gain : AppColors.loss;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    trade.isBuy ? 'Buy' : 'Sell',
                    style: AppTypography.label.copyWith(
                      color: sideColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Text(
                    trade.symbol,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(trade.date, style: AppTypography.caption),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                partial
                    ? '${trade.executedQuantity} of ${trade.orderQuantity} units'
                    : '${trade.executedQuantity} units',
                style: AppTypography.body,
              ),
              const SizedBox(height: 2),
              Text(
                'Rs. ${trade.executionPrice.toStringAsFixed(2)} per unit',
                style: AppTypography.bodyMuted.copyWith(fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                [
                  'Order #${trade.orderNumber}',
                  if (trade.partLabel != null) trade.partLabel!,
                ].join(' · '),
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
