import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class TradeReviewScreen extends StatelessWidget {
  const TradeReviewScreen({
    super.key,
    this.symbol = 'ABCD',
    this.companyName = 'Sample Bank Ltd',
    this.action = 'Buy',
    this.quantity = 50,
    this.pricePerUnit = 512.00,
    this.accountNumber = 'A001',
    this.onBack,
    this.onConfirmOrder,
    this.onEditDetails,
    this.onDestinationSelected,
  });

  final String symbol;
  final String companyName;
  final String action;
  final int quantity;
  final double pricePerUnit;
  final String accountNumber;

  final VoidCallback? onBack;
  final VoidCallback? onConfirmOrder;
  final VoidCallback? onEditDetails;
  final ValueChanged<int>? onDestinationSelected;


  double get estimatedTotal => quantity * pricePerUnit;

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final buffer = StringBuffer();

    for (int i = 0; i < whole.length; i++) {
      buffer.write(whole[i]);

      final remaining = whole.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }

    return 'Rs. ${buffer.toString()}.${parts[1]}';
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack ?? () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text,
                size: 30,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
            const SizedBox(width: 4),
            const Text(
              'Review order',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 34),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Step 2 of 3 · Enter details → '),
                TextSpan(
                  text: 'Review',
                  style: TextStyle(color: AppColors.brass, fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' → Confirm'),
              ],
            ),
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool isLast = false,
    bool emphasize = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _buildDetailRow(label: 'Security', value: '$symbol · $companyName'),
          _buildDetailRow(label: 'Action', value: action),
          _buildDetailRow(label: 'Quantity', value: quantity.toString()),
          _buildDetailRow(
            label: 'Price per unit',
            value: _formatAmount(pricePerUnit),
          ),
          _buildDetailRow(
            label: 'Estimated total',
            value: _formatAmount(estimatedTotal),
            emphasize: true,
          ),
          _buildDetailRow(
            label: 'Trading account',
            value: accountNumber,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onConfirmOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: AppColors.deep,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Confirm order',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onEditDetails,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Edit details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      (Icons.home_outlined, 'Home'),
      (Icons.pie_chart_outline_rounded, 'Portfolio'),
      (Icons.show_chart_rounded, 'Market'),
      (Icons.swap_vert_rounded, 'Trade'),
      (Icons.more_horiz_rounded, 'More'),
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
          final selected = index == 3;

          return Expanded(
            child: InkWell(
              onTap: () => onDestinationSelected?.call(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.$1, size: 22, color: selected ? AppColors.brass : AppColors.muted),
                  const SizedBox(height: 4),
                  Text(
                    item.$2,
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),
                        _buildOrderSummary(),
                        const SizedBox(height: 14),
                        const Text(
                          'Prices are historical closes. The order is '
                          'created with the status Pending.',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildPrimaryButton(),
                        const SizedBox(height: 12),
                        _buildSecondaryButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
}
