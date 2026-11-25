import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class IpoAppliedState extends StatelessWidget {
  const IpoAppliedState({
    super.key,
    this.companyName = 'Sample Bank IPO',
    this.symbol = 'ABCD',
    this.unitsRequested = 50,
    this.pricePerUnit = 100,
    this.appliedDate = '08 Oct',
    this.status = 'Pending',
    this.onBack,
    this.onBackToIpos,
    this.onDestinationSelected,
  });

  final String companyName;
  final String symbol;
  final int unitsRequested;
  final double pricePerUnit;
  final String appliedDate;
  final String status;

  final VoidCallback? onBack;
  final VoidCallback? onBackToIpos;
  final ValueChanged<int>? onDestinationSelected;


  double get totalAmount => unitsRequested * pricePerUnit;

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
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildApplicationCard(),
                    const SizedBox(height: 16),
                    const Text(
                      'Each investor can apply once per IPO. You can change '
                      'your application while it is pending.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildBackButton(),
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

  Widget _buildApplicationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.gain,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You have already applied',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$companyName · $symbol',
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 8),
          _buildDetailRow('Units requested', unitsRequested.toString()),
          _buildDetailRow('Price per unit', _formatAmount(pricePerUnit)),
          _buildDetailRow('Total amount', _formatAmount(totalAmount)),
          _buildDetailRow('Applied', appliedDate),
          _buildStatusRow(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Status', style: TextStyle(color: AppColors.muted, fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.brass),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: AppColors.brass,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
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
