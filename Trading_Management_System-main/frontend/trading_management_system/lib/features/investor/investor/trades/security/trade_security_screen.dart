import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class TradeSecurityScreen extends StatefulWidget {
  const TradeSecurityScreen({
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
    this.accountNumber = 'A001',
    this.accountStatus = 'Active',
    this.onBack,
    this.onTrade,
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
  final String accountNumber;
  final String accountStatus;

  final VoidCallback? onBack;
  final VoidCallback? onTrade;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<TradeSecurityScreen> createState() => _TradeSecurityScreenState();
}

class _TradeSecurityScreenState extends State<TradeSecurityScreen> {
  static const Color _deepGreen = AppColors.deep;

  String _selectedRange = '1M';

  static const List<String> _ranges = ['1W', '1M', '3M', '1Y'];

  static const List<_Candle> _candles = [
    _Candle(430, 425, 438, 420, 0.55),
    _Candle(425, 418, 431, 414, 0.75),
    _Candle(418, 414, 423, 408, 0.65),
    _Candle(414, 421, 424, 410, 0.58),
    _Candle(421, 435, 438, 417, 0.42),
    _Candle(435, 437, 440, 433, 0.62),
    _Candle(437, 441, 445, 434, 0.68),
    _Candle(441, 433, 444, 425, 0.61),
    _Candle(433, 426, 436, 421, 0.64),
    _Candle(426, 441, 446, 420, 0.42),
    _Candle(441, 440, 444, 438, 0.70),
    _Candle(440, 443, 446, 436, 0.53),
    _Candle(443, 453, 456, 439, 0.60),
    _Candle(453, 460, 464, 450, 0.64),
    _Candle(460, 469, 474, 456, 0.60),
    _Candle(469, 476, 480, 465, 0.54),
    _Candle(476, 481, 486, 470, 0.63),
    _Candle(481, 489, 493, 476, 0.72),
    _Candle(489, 498, 502, 485, 0.95),
    _Candle(498, 505, 509, 492, 0.82),
    _Candle(505, 508, 513, 501, 0.78),
    _Candle(508, 512, 515, 504, 0.65),
  ];

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

  String _formatVolume(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      final remaining = text.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  Widget _buildHeader(BuildContext context) {
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
            Text(
              widget.symbol,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Text(
            '${widget.companyName} · ${widget.sector}',
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _formatAmount(widget.price),
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${widget.changePercent >= 0 ? '▲' : '▼'} '
              '${widget.changePercent.abs().toStringAsFixed(1)}%',
              style: TextStyle(
                color: widget.changePercent >= 0 ? AppColors.gain : AppColors.loss,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Close ${widget.closeDate}',
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(width: 10),
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

  Widget _buildChart() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 164,
            width: double.infinity,
            child: CustomPaint(
              painter: _CandlestickPainter(
                candles: _candles,
                currentPrice: widget.price,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('08 Sep', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                Text('08 Oct', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _ranges.map((range) {
              final selected = _selectedRange == range;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedRange = range);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.brass : Colors.transparent,
                      border: Border.all(color: selected ? AppColors.brass : AppColors.border),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      range,
                      style: TextStyle(
                        color: selected ? _deepGreen : AppColors.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const Text(
            'Daily candles. Hollow: close above open. '
            'Filled: close below open.',
            style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
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
        _buildStatCard('Open', _formatAmount(widget.open)),
        _buildStatCard('High', _formatAmount(widget.high)),
        _buildStatCard('Low', _formatAmount(widget.low)),
        _buildStatCard('Volume', _formatVolume(widget.volume)),
      ],
    );
  }

  Widget _buildAccountCard() {
    final isActive = widget.accountStatus.toLowerCase() == 'active';

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
                children: [
                  const TextSpan(text: 'Trading account  '),
                  TextSpan(
                    text: widget.accountNumber,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: isActive ? AppColors.gain : AppColors.loss),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              widget.accountStatus,
              style: TextStyle(
                color: isActive ? AppColors.gain : AppColors.loss,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeButton(BuildContext context) {
    final isActive = widget.accountStatus.toLowerCase() == 'active';

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (!isActive) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'This trading account is inactive. '
                  'Choose an active account to continue.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          if (widget.onTrade != null) {
            widget.onTrade!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connect this button to the trade order screen.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: _deepGreen,
          disabledBackgroundColor: AppColors.border,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Trade this security',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
        color: _deepGreen,
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
                        _buildChart(),
                        const SizedBox(height: 12),
                        _buildStatistics(),
                        _buildAccountCard(),
                        const SizedBox(height: 12),
                        _buildTradeButton(context),
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

class _Candle {
  const _Candle(this.open, this.close, this.high, this.low, this.volume);

  final double open;
  final double close;
  final double high;
  final double low;
  final double volume;
}

class _CandlestickPainter extends CustomPainter {
  const _CandlestickPainter({
    required this.candles,
    required this.currentPrice,
  });

  final List<_Candle> candles;
  final double currentPrice;

  static const Color _deepGreen = AppColors.onBrass;

  @override
  void paint(Canvas canvas, Size size) {
    const rightSpace = 42.0;
    const topSpace = 8.0;
    const bottomSpace = 5.0;

    final plotWidth = size.width - rightSpace;
    final priceHeight = size.height * 0.69;
    final volumeTop = size.height * 0.84;
    final volumeHeight = size.height - volumeTop - bottomSpace;

    const minPrice = 400.0;
    const maxPrice = 525.0;

    double priceY(double value) {
      return topSpace +
          (maxPrice - value) / (maxPrice - minPrice) * priceHeight;
    }

    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    final labelStyle = const TextStyle(color: AppColors.muted, fontSize: 10);

    void drawLabel(String text, Offset offset) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(canvas, offset);
    }

    for (final level in [415.0, 444.0, 474.0]) {
      final y = priceY(level);

      canvas.drawLine(Offset(0, y), Offset(plotWidth, y), gridPaint);

      drawLabel(level.toInt().toString(), Offset(plotWidth + 5, y - 6));
    }

    final currentY = priceY(currentPrice);

    final currentPaint = Paint()
      ..color = AppColors.brass
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;

    for (double x = 0; x < plotWidth; x += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(x, currentY),
        Offset(math.min(x + dashWidth, plotWidth), currentY),
        currentPaint,
      );
    }

    final badgeRect = Rect.fromLTWH(
      plotWidth + 2,
      currentY - 8,
      rightSpace - 3,
      16,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(badgeRect, const Radius.circular(4)),
      Paint()..color = AppColors.brass,
    );

    final pricePainter = TextPainter(
      text: TextSpan(
        text: currentPrice.toStringAsFixed(2),
        style: const TextStyle(
          color: _deepGreen,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    pricePainter.paint(
      canvas,
      Offset(
        badgeRect.left + (badgeRect.width - pricePainter.width) / 2,
        badgeRect.top + 2,
      ),
    );

    final candleWidth = math.min(8.0, plotWidth / candles.length * 0.62);

    final spacing = plotWidth / candles.length;

    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final centerX = spacing * i + spacing / 2;

      final rising = candle.close >= candle.open;
      final color = rising ? AppColors.gain : AppColors.loss;

      final candlePaint = Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(centerX, priceY(candle.high)),
        Offset(centerX, priceY(candle.low)),
        candlePaint,
      );

      final bodyTop = priceY(math.max(candle.open, candle.close));
      final bodyBottom = priceY(math.min(candle.open, candle.close));

      final bodyRect = Rect.fromLTRB(
        centerX - candleWidth / 2,
        bodyTop,
        centerX + candleWidth / 2,
        math.max(bodyBottom, bodyTop + 1.5),
      );

      final bodyPaint = Paint()
        ..color = rising ? AppColors.surface : color
        ..style = rising ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = 1.5;

      canvas.drawRect(bodyRect, bodyPaint);

      final volumeRect = Rect.fromLTWH(
        centerX - candleWidth / 2,
        volumeTop + (1 - candle.volume) * volumeHeight,
        candleWidth,
        candle.volume * volumeHeight,
      );

      canvas.drawRect(volumeRect, Paint()..color = color.withOpacity(0.45));
    }
  }

  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) {
    return oldDelegate.currentPrice != currentPrice ||
        oldDelegate.candles != candles;
  }
}
