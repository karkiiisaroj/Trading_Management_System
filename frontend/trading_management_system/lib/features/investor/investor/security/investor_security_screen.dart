import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/animations.dart';

class InvestorSecurityScreen extends StatefulWidget {
  const InvestorSecurityScreen({
    super.key,
    this.symbol = 'ABCD',
    this.companyName = 'Sample Bank Ltd',
    this.sector = 'Banking',
    this.price = 512.00,
    this.changePercent = 1.2,
    this.closeDate = '08 Oct',
    this.open = 506.00,
    this.high = 515.00,
    this.low = 503.50,
    this.volume = 12400,
    this.onBack,
    this.onDestinationSelected,
  });

  final String symbol;
  final String companyName;
  final String sector;
  final double price;
  final double changePercent;
  final String closeDate;
  final double open;
  final double high;
  final double low;
  final int volume;

  final VoidCallback? onBack;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<InvestorSecurityScreen> createState() => _InvestorSecurityScreenState();
}

class _InvestorSecurityScreenState extends State<InvestorSecurityScreen> {

  String _selectedRange = '1M';

  final List<_Candle> _candles = const [
    _Candle(430, 438, 425, 432, false, 135),
    _Candle(432, 436, 424, 426, false, 204),
    _Candle(426, 434, 421, 423, false, 177),
    _Candle(423, 439, 420, 435, true, 145),
    _Candle(435, 450, 432, 448, true, 109),
    _Candle(448, 452, 447, 450, true, 154),
    _Candle(450, 455, 446, 453, true, 166),
    _Candle(453, 454, 440, 444, false, 150),
    _Candle(444, 445, 433, 436, false, 166),
    _Candle(436, 456, 433, 455, true, 101),
    _Candle(455, 457, 451, 454, false, 173),
    _Candle(454, 460, 450, 458, true, 123),
    _Candle(458, 470, 455, 468, true, 157),
    _Candle(468, 475, 466, 472, true, 152),
    _Candle(472, 481, 469, 478, true, 124),
    _Candle(478, 483, 476, 480, true, 141),
    _Candle(480, 486, 477, 484, true, 140),
    _Candle(484, 495, 480, 490, true, 202),
    _Candle(490, 499, 488, 496, true, 190),
    _Candle(496, 506, 493, 503, true, 150),
    _Candle(503, 509, 501, 507, true, 190),
    _Candle(507, 510, 504, 509, true, 140),
    _Candle(509, 516, 506, 514, true, 202),
    _Candle(514, 520, 512, 518, true, 150),
  ];

  String _money(double value) {
    return 'Rs. ${value.toStringAsFixed(2)}';
  }

  String _formatVolume(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.changePercent >= 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader().fadeUp(0),
                    const SizedBox(height: 2),
                    _buildCompanyName().fadeUp(1),
                    const SizedBox(height: 14),
                    _buildPrice(isPositive).fadeUp(2),
                    const SizedBox(height: 16),
                    _buildChartCard().fadeUp(3),
                    const SizedBox(height: 12),
                    _buildStatistics().fadeUp(4),
                    const SizedBox(height: 16),
                    _buildViewOnlyNotice().fadeUp(5),
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
          onPressed: widget.onBack,
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.text, size: 28),
          tooltip: 'Back',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
        ),
        const SizedBox(width: 6),
        Text(
          widget.symbol,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyName() {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        '${widget.companyName} · ${widget.sector}',
        style: const TextStyle(color: AppColors.muted, fontSize: 13),
      ),
    );
  }

  Widget _buildPrice(bool isPositive) {
    final movement = isPositive
        ? Icons.arrow_drop_up_rounded
        : Icons.arrow_drop_down_rounded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountUp(
          value: widget.price,
          builder: (context, value) => Text(
            _money(value),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  movement,
                  color: isPositive ? AppColors.gain : AppColors.loss,
                  size: 19,
                ),
                Text(
                  '${widget.changePercent.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive ? AppColors.gain : AppColors.loss,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Text(
              'Close ${widget.closeDate}',
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brass),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Historical',
                style: TextStyle(color: AppColors.brass, fontSize: 11),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            // Draws in left to right; a new range key replays it.
            child: RevealSweep(
              key: ValueKey(_selectedRange),
              child: CustomPaint(
                painter: _CandlestickPainter(
                  candles: _candles,
                  currentPrice: widget.price,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('08 Sep', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('08 Oct', style: TextStyle(color: AppColors.muted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: ['1W', '1M', '3M', '1Y'].map((range) {
              final selected = _selectedRange == range;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      setState(() {
                        _selectedRange = range;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.brass : Colors.transparent,
                        border: Border.all(color: selected ? AppColors.brass : AppColors.border),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        range,
                        style: TextStyle(
                          color: selected ? AppColors.deep : AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Daily candles. Hollow: close above open. Filled: close below open.',
              style: TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.15,
      children: [
        _statCard('Open', _money(widget.open)),
        _statCard('High', _money(widget.high)),
        _statCard('Low', _money(widget.low)),
        _statCard('Volume', _formatVolume(widget.volume)),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewOnlyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.visibility_outlined, color: AppColors.brass, size: 21),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View only',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Orders are placed from the Trade tab with a registered trading account.',
                  style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
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
          final selected = index == 2;

          return Expanded(
            child: InkWell(
              onTap: () => widget.onDestinationSelected?.call(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 22, color: selected ? AppColors.brass : AppColors.muted),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
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
}

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _Candle {
  const _Candle(
    this.open,
    this.high,
    this.low,
    this.close,
    this.isBullish,
    this.volume,
  );

  final double open;
  final double high;
  final double low;
  final double close;
  final bool isBullish;
  final double volume;
}

class _CandlestickPainter extends CustomPainter {
  const _CandlestickPainter({
    required this.candles,
    required this.currentPrice,
  });

  final List<_Candle> candles;
  final double currentPrice;


  @override
  void paint(Canvas canvas, Size size) {
    const left = 0.0;
    const right = 43.0;
    const top = 8.0;
    const bottom = 37.0;

    final chartWidth = size.width - right;
    final chartHeight = size.height - top - bottom;
    final volumeTop = size.height - 25;
    final volumeHeight = 19.0;

    final minPrice =
        candles.map((c) => c.low).reduce((a, b) => a < b ? a : b) - 5;

    final maxPrice =
        candles.map((c) => c.high).reduce((a, b) => a > b ? a : b) + 5;

    final range = maxPrice - minPrice;

    double y(double price) {
      return top + ((maxPrice - price) / range) * chartHeight;
    }

    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    final labelStyle = const TextStyle(color: AppColors.muted, fontSize: 10);

    for (var i = 0; i < 3; i++) {
      final price = maxPrice - (range * i / 2);
      final dy = y(price);

      canvas.drawLine(Offset(left, dy), Offset(chartWidth, dy), gridPaint);

      final text = TextPainter(
        text: TextSpan(text: price.toStringAsFixed(0), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      text.paint(canvas, Offset(chartWidth + 5, dy - 6));
    }

    final candleSpace = chartWidth / candles.length;
    final candleWidth = candleSpace * 0.52;

    final maxVolume = candles
        .map((c) => c.volume)
        .reduce((a, b) => a > b ? a : b);

    for (var i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final centerX = (i + 0.5) * candleSpace;
      final color = candle.isBullish ? AppColors.gain : AppColors.loss;

      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = 1.4;

      canvas.drawLine(
        Offset(centerX, y(candle.high)),
        Offset(centerX, y(candle.low)),
        wickPaint,
      );

      final bodyTop = y(
        candle.open > candle.close ? candle.open : candle.close,
      );

      final bodyBottom = y(
        candle.open < candle.close ? candle.open : candle.close,
      );

      final body = Rect.fromLTRB(
        centerX - candleWidth / 2,
        bodyTop,
        centerX + candleWidth / 2,
        bodyBottom,
      );

      final bodyPaint = Paint()
        ..color = candle.isBullish ? AppColors.surface : color
        ..style = candle.isBullish ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = 1.4;

      canvas.drawRect(body, bodyPaint);

      final volumeBarHeight = (candle.volume / maxVolume) * volumeHeight;

      final volumePaint = Paint()..color = color.withOpacity(0.45);

      canvas.drawRect(
        Rect.fromLTWH(
          centerX - candleWidth / 2,
          volumeTop + volumeHeight - volumeBarHeight,
          candleWidth,
          volumeBarHeight,
        ),
        volumePaint,
      );
    }

    // Current price reference line.
    final priceY = y(currentPrice);

    final pricePaint = Paint()
      ..color = AppColors.brass
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashX = 0;

    while (dashX < chartWidth) {
      canvas.drawLine(
        Offset(dashX, priceY),
        Offset((dashX + 4).clamp(0, chartWidth), priceY),
        pricePaint,
      );
      dashX += 7;
    }

    final priceLabel = TextPainter(
      text: TextSpan(
        text: currentPrice.toStringAsFixed(2),
        style: const TextStyle(
          color: AppColors.deep,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final labelRect = Rect.fromLTWH(chartWidth + 1, priceY - 9, 41, 17);

    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
      Paint()..color = AppColors.brass,
    );

    priceLabel.paint(
      canvas,
      Offset(
        labelRect.left + (labelRect.width - priceLabel.width) / 2,
        labelRect.top + 3,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) {
    return oldDelegate.candles != candles ||
        oldDelegate.currentPrice != currentPrice;
  }
}
