import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class OrderRejectedState extends StatelessWidget {
  const OrderRejectedState({
    super.key,
    this.orderNumber = '1042',
    this.symbol = 'ABCD',
    this.isBuy = true,
    this.quantity = 50,
    this.pricePerUnit = 512.00,
    this.submittedAt = '08 Oct · 10:42',
    this.onBack,
    this.onPlaceNewOrder,
    this.onContactBroker,
    this.onDestinationSelected,
  });

  final String orderNumber;
  final String symbol;
  final bool isBuy;
  final int quantity;
  final double pricePerUnit;
  final String submittedAt;

  final VoidCallback? onBack;
  final VoidCallback? onPlaceNewOrder;
  final VoidCallback? onContactBroker;
  final ValueChanged<int>? onDestinationSelected;


  String get formattedPrice {
    return 'Rs. ${pricePerUnit.toStringAsFixed(2)}';
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handlePlaceNewOrder(BuildContext context) {
    if (onPlaceNewOrder != null) {
      onPlaceNewOrder!();
    } else {
      _showMessage(context, 'Connect this action to the trade order screen.');
    }
  }

  void _handleContactBroker(BuildContext context) {
    if (onContactBroker != null) {
      onContactBroker!();
    } else {
      _showMessage(
        context,
        'Connect this action to your broker contact details.',
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildOrderCard(),
                    const SizedBox(height: 16),
                    _buildRejectionMessage(),
                    const SizedBox(height: 28),
                    _buildActions(context),
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
    return Row(
      children: [
        SizedBox(
          width: 34,
          height: 44,
          child: IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.text,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Order #$orderNumber',
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$symbol · ${isBuy ? 'Buy' : 'Sell'}',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.loss),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Rejected',
                  style: TextStyle(
                    color: AppColors.loss,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$quantity units at $formattedPrice',
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(submittedAt, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRejectionMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.loss),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.loss, size: 22),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order rejected',
                  style: TextStyle(
                    color: AppColors.loss,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your broker could not accept this order. '
                  'Check the price and quantity, or contact your '
                  'broker for details.',
                  style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => _handlePlaceNewOrder(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brass,
              foregroundColor: AppColors.onBrass,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Place a new order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => _handleContactBroker(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.text,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Contact your broker',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
          final isSelected = index == 4;
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
