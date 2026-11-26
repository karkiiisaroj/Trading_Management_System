import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';

class TradeOrderRecord {
  const TradeOrderRecord({
    required this.symbol,
    required this.action,
    required this.status,
    required this.quantity,
    required this.pricePerUnit,
    required this.date,
    required this.orderNumber,
  });

  final String symbol;
  final String action;
  final String status;
  final int quantity;
  final double pricePerUnit;
  final String date;
  final String orderNumber;

  double get total => quantity * pricePerUnit;
}

class TradeOrdersScreen extends StatefulWidget {
  const TradeOrdersScreen({
    super.key,
    this.orders = const [
      TradeOrderRecord(
        orderNumber: '1042',
        symbol: 'ABCD',
        action: 'Buy',
        status: 'Pending',
        quantity: 50,
        pricePerUnit: 512.00,
        date: '08 Oct',
      ),
      TradeOrderRecord(
        orderNumber: '1041',
        symbol: 'EFGH',
        action: 'Sell',
        status: 'Executed',
        quantity: 120,
        pricePerUnit: 298.40,
        date: '07 Oct',
      ),
      TradeOrderRecord(
        orderNumber: '1040',
        symbol: 'IJKL',
        action: 'Buy',
        status: 'Executed',
        quantity: 30,
        pricePerUnit: 905.10,
        date: '07 Oct',
      ),
      TradeOrderRecord(
        orderNumber: '1039',
        symbol: 'MNOP',
        action: 'Buy',
        status: 'Cancelled',
        quantity: 200,
        pricePerUnit: 221.00,
        date: '06 Oct',
      ),
    ],
    this.onBack,
    this.onOrderSelected,
    this.onDestinationSelected,
  });

  final List<TradeOrderRecord> orders;
  final VoidCallback? onBack;
  final ValueChanged<TradeOrderRecord>? onOrderSelected;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<TradeOrdersScreen> createState() => _TradeOrdersScreenState();
}

class _TradeOrdersScreenState extends State<TradeOrdersScreen> {

  static const List<String> _filters = [
    'All',
    'Pending',
    'Executed',
    'Cancelled',
  ];

  String _selectedFilter = 'All';

  List<TradeOrderRecord> get _filteredOrders {
    if (_selectedFilter == 'All') {
      return widget.orders;
    }

    return widget.orders
        .where((order) => order.status == _selectedFilter)
        .toList();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.brass;
      case 'executed':
        return AppColors.gain;
      case 'cancelled':
        return AppColors.muted;
      case 'rejected':
        return AppColors.loss;
      default:
        return AppColors.muted;
    }
  }

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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: widget.onBack ?? () => Navigator.maybePop(context),
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
              'Orders',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 34),
          child: Text(
            'Your order history',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final selected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedFilter = filter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.brass : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: selected ? AppColors.brass : AppColors.border),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: selected ? AppColors.deep : AppColors.text,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOrderCard(TradeOrderRecord order) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          if (widget.onOrderSelected != null) {
            widget.onOrderSelected!(order);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Order #${order.orderNumber} selected. '
                  'Connect this to the order status screen.',
                ),
                backgroundColor: AppColors.surface,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${order.symbol} · ${order.action}',
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${order.quantity} units at '
                      '${_formatAmount(order.pricePerUnit)}',
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ),
                  Text(
                    order.date,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(Icons.receipt_long_outlined, color: AppColors.muted, size: 36),
          const SizedBox(height: 14),
          const Text(
            'No orders found',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _selectedFilter == 'All'
                ? 'Your orders will appear here.'
                : 'You have no ${_selectedFilter.toLowerCase()} orders.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
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
          final selected = index == 4;

          return Expanded(
            child: InkWell(
              onTap: () => widget.onDestinationSelected?.call(index),
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
    final orders = _filteredOrders;

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
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 14),
                        _buildFilters(),
                        const SizedBox(height: 6),
                        if (orders.isEmpty)
                          _buildEmptyResults()
                        else
                          ...orders.map(
                            (order) => Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: _buildOrderCard(order),
                            ),
                          ),
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
