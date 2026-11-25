import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class TradeOrderDraft {
  const TradeOrderDraft({
    required this.symbol,
    required this.companyName,
    required this.action,
    required this.quantity,
    required this.pricePerUnit,
  });

  final String symbol;
  final String companyName;
  final String action;
  final int quantity;
  final double pricePerUnit;

  double get estimatedTotal => quantity * pricePerUnit;
}

class TradeOrderScreen extends StatefulWidget {
  const TradeOrderScreen({
    super.key,
    this.symbol = 'ABCD',
    this.companyName = 'Sample Bank Ltd',
    this.pricePerUnit = 512.00,
    this.lastCloseDate = '08 Oct',
    this.initialQuantity = 50,
    this.initialAction = 'Buy',
    this.onBack,
    this.onReviewOrder,
    this.onDestinationSelected,
  });

  final String symbol;
  final String companyName;
  final double pricePerUnit;
  final String lastCloseDate;
  final int initialQuantity;
  final String initialAction;

  final VoidCallback? onBack;
  final ValueChanged<TradeOrderDraft>? onReviewOrder;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<TradeOrderScreen> createState() => _TradeOrderScreenState();
}

class _TradeOrderScreenState extends State<TradeOrderScreen> {

  late int _quantity;
  late String _action;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity < 1 ? 1 : widget.initialQuantity;
    _action = widget.initialAction.toLowerCase() == 'sell' ? 'Sell' : 'Buy';
  }

  double get _estimatedTotal => _quantity * widget.pricePerUnit;

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

  void _changeQuantity(int amount) {
    setState(() {
      _quantity += amount;
      if (_quantity < 1) _quantity = 1;
    });
  }

  void _reviewOrder() {
    if (widget.pricePerUnit <= 0 || _quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quantity and price must be greater than 0.'),
          backgroundColor: AppColors.surface,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final draft = TradeOrderDraft(
      symbol: widget.symbol,
      companyName: widget.companyName,
      action: _action,
      quantity: _quantity,
      pricePerUnit: widget.pricePerUnit,
    );

    if (widget.onReviewOrder != null) {
      widget.onReviewOrder!(draft);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect this button to the review order screen.'),
          backgroundColor: AppColors.surface,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
              'Trade',
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
            'Step 1 of 3 · Enter details → Review → Confirm',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionSelector() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [_actionOption('Buy'), _actionOption('Sell')]),
    );
  }

  Widget _actionOption(String action) {
    final selected = _action == action;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _action = action);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.brass : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            action,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppColors.deep : AppColors.muted,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.symbol,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.companyName,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  'Last close ${_formatAmount(widget.pricePerUnit)} · '
                  '${widget.lastCloseDate} (historical)',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Change',
            style: TextStyle(
              color: AppColors.brass,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        _quantityButton(
          icon: Icons.remove,
          onTap: _quantity > 1 ? () => _changeQuantity(-1) : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.brass),
            ),
            child: Text(
              _quantity.toString(),
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _quantityButton(icon: Icons.add, onTap: () => _changeQuantity(1)),
      ],
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: onTap == null ? AppColors.muted : AppColors.text, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceDisplay() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        _formatAmount(widget.pricePerUnit),
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEstimatedTotal() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Estimated total',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          Text(
            _formatAmount(_estimatedTotal),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
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
          final selected = index == 3;

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
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.brass : AppColors.muted,
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
                        _buildHeader(),
                        _buildActionSelector(),
                        _buildSecurityCard(),
                        _buildSectionLabel('Quantity'),
                        _buildQuantitySelector(),
                        _buildSectionLabel('Price per unit'),
                        _buildPriceDisplay(),
                        _buildEstimatedTotal(),
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Quantity and price must be greater than 0.',
                            style: TextStyle(color: AppColors.muted, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _reviewOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brass,
                              foregroundColor: AppColors.onBrass,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Review order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ).paddingOnly(top: 22),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            'You will review the order before it is submitted.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.muted, fontSize: 12),
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

extension on Widget {
  Widget paddingOnly({double top = 0}) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: this,
    );
  }
}
