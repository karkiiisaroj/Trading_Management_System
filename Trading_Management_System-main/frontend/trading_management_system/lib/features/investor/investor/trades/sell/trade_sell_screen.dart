import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';

class TradeSellScreen extends StatefulWidget {
  const TradeSellScreen({
    super.key,
    this.symbol = 'EFGH',
    this.companyName = 'Sample Hydropower Ltd',
    this.pricePerUnit = 298.40,
    this.closeDate = '08 Oct',
    this.heldUnits = 120,
    this.initialQuantity = 150,
    this.accountNumber = 'A001',
    this.onBack,
    this.onBuySelected,
    this.onReviewOrder,
    this.onDestinationSelected,
  });

  final String symbol;
  final String companyName;
  final double pricePerUnit;
  final String closeDate;
  final int heldUnits;
  final int initialQuantity;
  final String accountNumber;

  final VoidCallback? onBack;
  final VoidCallback? onBuySelected;
  final ValueChanged<int>? onReviewOrder;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<TradeSellScreen> createState() => _TradeSellScreenState();
}

class _TradeSellScreenState extends State<TradeSellScreen> {

  late int _quantity;

  bool get _isValidQuantity => _quantity > 0 && _quantity <= widget.heldUnits;

  double get _estimatedTotal => _quantity * widget.pricePerUnit;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  String _formatPrice(double price) {
    final parts = price.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final buffer = StringBuffer();

    for (int i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }

    return '${buffer.toString()}.${parts[1]}';
  }

  void _decreaseQuantity() {
    if (_quantity <= 1) return;

    setState(() {
      _quantity--;
    });
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _reviewOrder() {
    if (!_isValidQuantity) return;

    if (widget.onReviewOrder != null) {
      widget.onReviewOrder!(_quantity);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review order is not connected yet.'),
          backgroundColor: AppColors.surface,
        ),
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
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 6),
                    _buildProgress(),
                    const SizedBox(height: 16),
                    _buildTradeSelector(),
                    const SizedBox(height: 16),
                    _buildSecurityCard(),
                    const SizedBox(height: 18),
                    _buildQuantitySection(),
                    const SizedBox(height: 18),
                    _buildPriceSection(),
                    const SizedBox(height: 18),
                    _buildEstimatedTotal(),
                    const SizedBox(height: 20),
                    _buildReviewButton(),
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
            onPressed: widget.onBack ?? () => Navigator.maybePop(context),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.chevron_left, color: AppColors.text, size: 30),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'Trade',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.only(left: 34),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: AppColors.muted, fontSize: 12),
          children: [
            TextSpan(text: 'Step 1 of 3 · '),
            TextSpan(
              text: 'Enter details',
              style: TextStyle(color: AppColors.brass, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' → Review → Confirm'),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onBuySelected,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                alignment: Alignment.center,
                child: const Text(
                  'Buy',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.brass,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Sell',
                style: TextStyle(
                  color: AppColors.onBrass,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
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
                  'Last close Rs. ${_formatPrice(widget.pricePerUnit)} · '
                  '${widget.closeDate} (historical)',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'You hold',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.heldUnits} units',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
    final invalid = !_isValidQuantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quantity', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            _quantityButton(icon: Icons.remove, onPressed: _decreaseQuantity),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: invalid ? AppColors.loss : AppColors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _quantityButton(icon: Icons.add, onPressed: _increaseQuantity),
          ],
        ),
        if (invalid) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.loss,
                size: 15,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _quantity <= 0
                      ? 'Enter at least 1 unit to sell.'
                      : 'You can’t sell more than you hold '
                            '(${widget.heldUnits} units).',
                  style: const TextStyle(color: AppColors.loss, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.text, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price per unit',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            'Rs. ${_formatPrice(widget.pricePerUnit)}',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstimatedTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Estimated total',
          style: TextStyle(color: AppColors.muted, fontSize: 14),
        ),
        Text(
          'Rs. ${_formatPrice(_estimatedTotal)}',
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isValidQuantity ? _reviewOrder : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          disabledBackgroundColor: AppColors.brass.withOpacity(0.45),
          disabledForegroundColor: AppColors.onBrass,
          foregroundColor: AppColors.onBrass,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Review order',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      _NavItem(Icons.home_outlined, 'Home'),
      _NavItem(Icons.pie_chart_outline, 'Portfolio'),
      _NavItem(Icons.show_chart, 'Market'),
      _NavItem(Icons.swap_vert, 'Trade'),
      _NavItem(Icons.more_horiz, 'More'),
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
                  Icon(item.icon, color: selected ? AppColors.brass : AppColors.muted, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
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
}

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
