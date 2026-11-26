import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import '../orders/trade_orders_screen.dart';

class TradeDashboardScreen extends StatelessWidget {
  const TradeDashboardScreen({
    super.key,
    this.accountNumber = 'A001',
    this.brokerName = 'Broker name',
    this.accountStatus = 'Active',
    this.onBuy,
    this.onSell,
    this.onSwitchAccount,
    this.onViewAllOrders,
    this.onSecuritySelected,
    this.onDestinationSelected,
    this.recentOrders = const [],
    this.awaitingApproval = 0,
  });

  final String accountNumber;
  final String brokerName;
  final String accountStatus;

  final VoidCallback? onBuy;
  final VoidCallback? onSell;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onViewAllOrders;
  final ValueChanged<String>? onSecuritySelected;
  final ValueChanged<int>? onDestinationSelected;

  /// Latest orders of this investor, newest first (live from the desk).
  final List<TradeOrderRecord> recentOrders;

  /// Orders still waiting for the broker to act on them.
  final int awaitingApproval;


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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildAccountCard(),
                    const SizedBox(height: 12),
                    _buildTradeActions(),
                    if (awaitingApproval > 0) _buildAwaitingBanner(),
                    const SizedBox(height: 24),
                    _buildRecentOrders(),
                    const SizedBox(height: 22),
                    _buildMovers(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trade',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Place and track orders',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildAccountCard() {
    final isActive = accountStatus.toLowerCase() == 'active';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trading account',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  accountNumber,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Broker $brokerName',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _statusBadge(accountStatus, isActive ? AppColors.gain : AppColors.loss),
              const SizedBox(height: 2),
              TextButton(
                onPressed: onSwitchAccount,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.brass,
                  minimumSize: const Size(0, 44),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Switch account',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeActions() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brass,
                foregroundColor: AppColors.deep,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Buy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: onSell,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.text,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Sell',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent orders',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onViewAllOrders,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: AppColors.brass,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (recentOrders.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No orders yet. Orders you request appear here.',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
        for (final o in recentOrders.take(3)) ...[
          _orderCard(
            symbol: o.symbol,
            side: o.action,
            status: o.status,
            statusColor: _statusColor(o.status),
            details:
                '${o.quantity} units at Rs. ${o.pricePerUnit.toStringAsFixed(2)}',
            date: o.date,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Executed':
        return AppColors.gain;
      case 'Rejected':
        return AppColors.loss;
      case 'Cancelled':
        return AppColors.muted;
      default:
        return AppColors.brass;
    }
  }

  Widget _buildAwaitingBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brass.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.hourglass_top_rounded, color: AppColors.brass, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              awaitingApproval == 1
                  ? '1 order is waiting for your broker to approve it.'
                  : '$awaitingApproval orders are waiting for your broker to approve them.',
              style: const TextStyle(color: AppColors.text, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard({
    required String symbol,
    required String side,
    required String status,
    required Color statusColor,
    required String details,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$symbol · $side',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _statusBadge(status, statusColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  details,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(date, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Movers',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' · historical',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        _moverRow(
          symbol: 'IJKL',
          company: 'Sample Insurance Ltd',
          price: '905.10',
          change: '▲ 2.1%',
          isPositive: true,
        ),
        _moverRow(
          symbol: 'ABCD',
          company: 'Sample Bank Ltd',
          price: '512.00',
          change: '▲ 1.2%',
          isPositive: true,
        ),
      ],
    );
  }

  Widget _moverRow({
    required String symbol,
    required String company,
    required String price,
    required String change,
    required bool isPositive,
  }) {
    return InkWell(
      onTap: () => onSecuritySelected?.call(symbol),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    company,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs. $price',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? AppColors.gain : AppColors.loss,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _navItem(Icons.home_outlined, 'Home', 0),
          _navItem(Icons.pie_chart_outline, 'Portfolio', 1),
          _navItem(Icons.show_chart, 'Market', 2),
          _navItem(Icons.swap_vert, 'Trade', 3, selected: true),
          _navItem(Icons.more_horiz, 'More', 4),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    int index, {
    bool selected = false,
  }) {
    final color = selected ? AppColors.brass : AppColors.muted;

    return Expanded(
      child: InkWell(
        onTap: () => onDestinationSelected?.call(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
