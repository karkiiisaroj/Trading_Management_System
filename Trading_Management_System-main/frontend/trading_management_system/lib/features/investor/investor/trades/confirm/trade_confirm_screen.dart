import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';

class TradeConfirmScreen extends StatelessWidget {
  const TradeConfirmScreen({
    super.key,
    this.orderNumber = '1042',
    this.symbol = 'ABCD',
    this.action = 'Buy',
    this.quantity = 50,
    this.status = 'Pending',
    this.onViewOrderStatus,
    this.onBackToMarket,
  });

  final String orderNumber;
  final String symbol;
  final String action;
  final int quantity;
  final String status;

  final VoidCallback? onViewOrderStatus;
  final VoidCallback? onBackToMarket;


  void _showFallbackMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _detailRow({
    required String label,
    required Widget value,
    bool showDivider = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.muted)),
          Flexible(child: value),
        ],
      ),
    );
  }

  Widget _detailValue(String value) {
    return Text(
      value,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 68,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),

                        // Success icon and confirmation message.
                        Column(
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: const BoxDecoration(
                                color: AppColors.brass,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 48,
                                color: AppColors.onBrass,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Order submitted',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Your order has been created and is pending.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Order information card.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              _detailRow(
                                label: 'Order no.',
                                value: _detailValue('#$orderNumber'),
                              ),
                              _detailRow(
                                label: 'Security',
                                value: _detailValue(symbol),
                              ),
                              _detailRow(
                                label: 'Action',
                                value: _detailValue(action),
                              ),
                              _detailRow(
                                label: 'Quantity',
                                value: _detailValue(quantity.toString()),
                              ),
                              _detailRow(
                                label: 'Status',
                                showDivider: false,
                                value: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.brass),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    status,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.brass,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // View order status.
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (onViewOrderStatus != null) {
                                onViewOrderStatus!();
                              } else {
                                _showFallbackMessage(
                                  context,
                                  'Connect this button to the order status screen.',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brass,
                              foregroundColor: AppColors.onBrass,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'View order status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Back to market.
                        SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              if (onBackToMarket != null) {
                                onBackToMarket!();
                              } else {
                                _showFallbackMessage(
                                  context,
                                  'Connect this button to the market screen.',
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.text,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Back to market',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
