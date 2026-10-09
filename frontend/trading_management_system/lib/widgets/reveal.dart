import 'package:flutter/material.dart';

/// Millisecond-based view over a single intro [AnimationController], so every
/// element of the intro choreography can be scheduled on one shared clock.
class IntroTimeline {
  const IntroTimeline(this.controller);

  final AnimationController controller;

  double get totalMs => controller.duration!.inMilliseconds.toDouble();
  double get elapsedMs => controller.value * totalMs;

  Interval span(double startMs, double endMs, [Curve curve = Curves.easeOut]) {
    final begin = (startMs / totalMs).clamp(0.0, 1.0);
    final end = (endMs / totalMs).clamp(0.0, 1.0);
    return Interval(begin, end < begin ? begin : end, curve: curve);
  }

  /// Eased 0..1 progress of the span at the controller's current value.
  double progress(double startMs, double endMs, [Curve curve = Curves.easeOut]) =>
      span(startMs, endMs, curve).transform(controller.value);

  /// Same as [progress] but as an [Animation] (for painters).
  Animation<double> animation(double startMs, double endMs,
          [Curve curve = Curves.easeOut]) =>
      controller.drive(CurveTween(curve: span(startMs, endMs, curve)));
}

/// Maps a choreography slot to a wrapped widget. Slots are ordered:
/// 0 logo lockup, 1 heading, 2 username, 3 password, 4 button, 5+ footer.
typedef Stagger = Widget Function(int slot, Widget child);

/// Fades and slides [child] in while [interval] plays on [controller].
///
/// The wrapper structure never changes after the animation finishes, so
/// stateful children (text fields) keep their state and focus.
class Reveal extends StatelessWidget {
  const Reveal({
    super.key,
    required this.controller,
    required this.interval,
    required this.child,
    this.dy = 18,
    this.dx = 0,
    this.scaleFrom = 1,
  });

  final Animation<double> controller;
  final Interval interval;
  final double dy;
  final double dx;
  final double scaleFrom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        final t = interval.transform(controller.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(dx * (1 - t), dy * (1 - t)),
            child: Transform.scale(
              scale: scaleFrom + (1 - scaleFrom) * t,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
