import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The two decorative "market line" curves from the design.
///
/// * [draw] 0..1 draws the lines on (entrance).
/// * [drift] 0..1 loops a slow, subtle vertical float (ambient motion).
///
/// The artwork is authored on a 390x170 canvas and stretched to fit
/// (preserveAspectRatio: none), with a constant 2px stroke.
class WaveBackground extends StatelessWidget {
  const WaveBackground({
    super.key,
    required this.draw,
    required this.drift,
  });

  final Animation<double> draw;
  final Animation<double> drift;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _WavePainter(draw: draw, drift: drift),
        size: Size.infinite,
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({required this.draw, required this.drift})
      : super(repaint: Listenable.merge([draw, drift]));

  final Animation<double> draw;
  final Animation<double> drift;

  static const _vbW = 390.0;
  static const _vbH = 170.0;

  // M0 130 C40 110 70 140 110 105 S180 70 220 95 S300 40 390 50
  static Path _goldCurve() => Path()
    ..moveTo(0, 130)
    ..cubicTo(40, 110, 70, 140, 110, 105)
    ..cubicTo(150, 70, 180, 70, 220, 95)
    ..cubicTo(260, 120, 300, 40, 390, 50);

  // M0 150 C50 135 90 155 140 130 S230 100 280 120 S340 90 390 95
  static Path _ivoryCurve() => Path()
    ..moveTo(0, 150)
    ..cubicTo(50, 135, 90, 155, 140, 130)
    ..cubicTo(190, 105, 230, 100, 280, 120)
    ..cubicTo(330, 140, 340, 90, 390, 95);

  static final Paint _goldPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..color = const Color.fromRGBO(196, 167, 108, 0.45);

  static final Paint _ivoryPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..color = const Color.fromRGBO(244, 241, 233, 0.12);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final scale =
        Matrix4.diagonal3Values(size.width / _vbW, size.height / _vbH, 1).storage;
    final progress = draw.value.clamp(0.0, 1.0);
    final phase = drift.value * 2 * math.pi;

    // Opposite phases so the two lines gently breathe against each other.
    _stroke(canvas, _goldCurve().transform(scale), _goldPaint, progress,
        math.sin(phase) * 5);
    _stroke(canvas, _ivoryCurve().transform(scale), _ivoryPaint, progress,
        math.sin(phase + math.pi) * 7);
  }

  void _stroke(Canvas canvas, Path path, Paint paint, double progress, double dy) {
    if (progress <= 0) return;
    canvas.save();
    canvas.translate(0, dy);
    if (progress >= 1) {
      canvas.drawPath(path, paint);
    } else {
      for (final metric in path.computeMetrics()) {
        canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.draw != draw || old.drift != drift;
}
