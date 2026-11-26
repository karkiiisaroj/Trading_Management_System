import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'animations.dart';

/// The two brass/ivory curves along the bottom edge. They draw themselves in
/// on first show. Place it at the bottom of a [Stack].
class AarthaWaveBackground extends StatefulWidget {
  const AarthaWaveBackground({super.key, this.animate = true});

  final bool animate;

  @override
  State<AarthaWaveBackground> createState() => _AarthaWaveBackgroundState();
}

class _AarthaWaveBackgroundState extends State<AarthaWaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _timer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skip = reduceMotion(context);
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 170,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _WavePainter(
                skip
                    ? 1
                    : const Cubic(.4, .1, .2, 1).transform(_controller.value),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // Curves are authored on a 390 x 170 board; stretch only horizontally so
    // the stroke stays 2px wide at any screen width.
    final sx = size.width / 390;

    final brass = Path()
      ..moveTo(0, 130)
      ..cubicTo(40, 110, 70, 140, 110, 105)
      ..cubicTo(150, 70, 180, 70, 220, 95)
      ..cubicTo(260, 120, 300, 40, 390, 50);

    final ivory = Path()
      ..moveTo(0, 150)
      ..cubicTo(50, 135, 90, 155, 140, 130)
      ..cubicTo(190, 105, 230, 100, 280, 120)
      ..cubicTo(330, 140, 340, 90, 390, 95);

    _stroke(canvas, brass, sx, AppColors.brass.withValues(alpha: .45));
    _stroke(canvas, ivory, sx, AppColors.text.withValues(alpha: .12));
  }

  void _stroke(Canvas canvas, Path path, double sx, Color color) {
    final scaled = path.transform(Matrix4.diagonal3Values(sx, 1, 1).storage);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color;

    for (final metric in scaled.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.progress != progress;
}
