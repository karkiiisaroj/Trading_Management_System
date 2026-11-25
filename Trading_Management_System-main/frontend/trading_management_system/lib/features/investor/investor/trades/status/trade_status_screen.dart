import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class TradeStatusScreen extends StatefulWidget {
  const TradeStatusScreen({
    super.key,
    this.orderNumber = '1042',
    this.status = 'Pending',
    this.symbol = 'ABCD',
    this.isBuy = true,
    this.quantity = 50,
    this.pricePerUnit = 512.00,
    this.submittedAt = '08 Oct, 10:42',
    this.onBack,
    this.onCancelOrder,
    this.onDestinationSelected,
  });

  final String orderNumber;
  final String status;
  final String symbol;
  final bool isBuy;
  final int quantity;
  final double pricePerUnit;
  final String submittedAt;

  final VoidCallback? onBack;
  final VoidCallback? onCancelOrder;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<TradeStatusScreen> createState() => _TradeStatusScreenState();
}

class _TradeStatusScreenState extends State<TradeStatusScreen> {

  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.status;
  }

  double get _estimatedTotal => widget.quantity * widget.pricePerUnit;

  bool get _isPending => _currentStatus.toLowerCase() == 'pending';

  String _formatAmount(double amount) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final digits = parts[0];
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }

    return 'Rs. ${buffer.toString()}.${parts[1]}';
  }

  void _showCancelConfirmation() {
    if (!_isPending) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Cancel this order?',
            style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to cancel this pending order? '
            'This action cannot be undone.',
            style: TextStyle(color: AppColors.muted, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Keep order', style: TextStyle(color: AppColors.muted)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                if (widget.onCancelOrder != null) {
                  widget.onCancelOrder!();
                } else {
                  setState(() {
                    _currentStatus = 'Cancelled';
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order cancelled in this demo.'),
                    ),
                  );
                }
              },
              child: const Text(
                'Cancel order',
                style: TextStyle(color: AppColors.loss, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 8),
                    _buildStatusBadge(),
                    const SizedBox(height: 18),
                    _buildTimeline(),
                    const SizedBox(height: 12),
                    _buildOrderSummary(),
                    const SizedBox(height: 18),
                    _buildCancelButton(),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Only pending orders can be cancelled.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
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

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.text, size: 28),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 34, minHeight: 44),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'Order #${widget.orderNumber}',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final color = _statusColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _currentStatus,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (_currentStatus.toLowerCase()) {
      case 'executed':
        return AppColors.gain;
      case 'cancelled':
      case 'rejected':
        return AppColors.loss;
      default:
        return AppColors.brass;
    }
  }

  Widget _buildTimeline() {
    final isExecuted = _currentStatus.toLowerCase() == 'executed';
    final isCancelled = _currentStatus.toLowerCase() == 'cancelled';
    final isRejected = _currentStatus.toLowerCase() == 'rejected';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _timelineItem(
            title: 'Submitted',
            subtitle: widget.submittedAt,
            state: _TimelineState.completed,
            showConnector: true,
          ),
          _timelineItem(
            title: isCancelled
                ? 'Cancelled'
                : isRejected
                ? 'Rejected'
                : isExecuted
                ? 'Executed'
                : 'Pending',
            subtitle: isCancelled
                ? 'Order cancellation confirmed'
                : isRejected
                ? 'Order was not accepted'
                : isExecuted
                ? 'Order execution completed'
                : 'Waiting to be processed',
            state: isCancelled || isRejected
                ? _TimelineState.failed
                : isExecuted
                ? _TimelineState.completed
                : _TimelineState.current,
            showConnector: !isCancelled && !isRejected,
          ),
          if (!isCancelled && !isRejected)
            _timelineItem(
              title: 'Executed',
              subtitle: isExecuted ? 'Execution completed' : 'Not executed yet',
              state: isExecuted
                  ? _TimelineState.completed
                  : _TimelineState.upcoming,
              showConnector: false,
            ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required String title,
    required String subtitle,
    required _TimelineState state,
    required bool showConnector,
  }) {
    final Color markerColor;

    switch (state) {
      case _TimelineState.completed:
        markerColor = AppColors.brass;
        break;
      case _TimelineState.current:
        markerColor = AppColors.brass;
        break;
      case _TimelineState.failed:
        markerColor = AppColors.loss;
        break;
      case _TimelineState.upcoming:
        markerColor = AppColors.border;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state == _TimelineState.completed
                          ? markerColor
                          : Colors.transparent,
                      border: state == _TimelineState.completed
                          ? null
                          : Border.all(
                              color: markerColor,
                              width: state == _TimelineState.current ? 3 : 2,
                            ),
                    ),
                  ),
                ),
                if (showConnector)
                  Positioned(
                    left: 7,
                    top: 20,
                    bottom: -24,
                    child: Container(width: 2, color: AppColors.border),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: state == _TimelineState.upcoming ? AppColors.muted : AppColors.text,
                    fontSize: 15,
                    fontWeight: state == _TimelineState.upcoming
                        ? FontWeight.w500
                        : FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _summaryRow('Security', widget.symbol),
          _summaryRow('Action', widget.isBuy ? 'Buy' : 'Sell'),
          _summaryRow('Quantity', widget.quantity.toString()),
          _summaryRow(
            'Estimated total',
            _formatAmount(_estimatedTotal),
            isLast: true,
            isEmphasized: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isLast = false,
    bool isEmphasized = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    final canCancel = _isPending;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: canCancel ? _showCancelConfirmation : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.loss,
          disabledForegroundColor: AppColors.muted.withOpacity(0.4),
          side: BorderSide(color: canCancel ? AppColors.loss : AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          canCancel ? 'Cancel order' : 'Cancellation unavailable',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
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
          final selected = index == 4;
          final color = selected ? AppColors.brass : AppColors.muted;

          return Expanded(
            child: InkWell(
              onTap: () => widget.onDestinationSelected?.call(index),
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

enum _TimelineState { completed, current, upcoming, failed }

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
