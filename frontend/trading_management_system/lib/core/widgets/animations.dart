import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// True when the OS asks for reduced motion; every animation here respects it.
bool reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// Fades a child in while sliding it up. Use [delay] to stagger a column.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.offset = const Offset(0, 18),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Starting offset in logical pixels.
  final Offset offset;

  /// Delay for the [index]-th item of a staggered list (70 ms apart).
  static Duration stagger(int index, {int baseMs = 80}) =>
      Duration(milliseconds: baseMs + math.min(index, 10) * 70);

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Inside a lazy list this stops a row replaying its entrance each time it
  // is scrolled back into view. Outside a list it has no effect.
  @override
  bool get wantKeepAlive => true;

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _curve =
      CurvedAnimation(parent: _controller, curve: const Cubic(.2, .7, .2, 1));
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
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
    super.build(context); // required by AutomaticKeepAliveClientMixin
    if (reduceMotion(context)) return widget.child;
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final v = _curve.value;
        return Opacity(
          opacity: v.clamp(0.0, 1.0).toDouble(),
          child: Transform.translate(
            offset: Offset(
              widget.offset.dx * (1 - v),
              widget.offset.dy * (1 - v),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// Horizontal shake. Bump [trigger] to play it (e.g. on a failed sign in).
class Shake extends StatefulWidget {
  const Shake({super.key, required this.trigger, required this.child});

  final int trigger;
  final Widget child;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.trigger > 0) _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = _controller.value;
        final dx = math.sin(t * math.pi * 4) * 7 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );
  }
}

/// Gentle endless up-and-down float (used on the logo).
class Floating extends StatefulWidget {
  const Floating({super.key, required this.child, this.distance = 6});

  final Widget child;
  final double distance;

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final v = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, -widget.distance * v),
          child: child,
        );
      },
    );
  }
}

/// Shorthand for staggered entrances.
///
/// ```dart
/// buildHeader().fadeUp(0),
/// buildCard().fadeUp(1),
/// row.fadeUp(index + 2, 120), // lists: smaller base delay
/// ```
extension FadeUpX on Widget {
  Widget fadeUp([int index = 0, int baseMs = 80]) => FadeSlideIn(
        delay: FadeSlideIn.stagger(index, baseMs: baseMs),
        duration: const Duration(milliseconds: 600),
        child: this,
      );

  /// Fade in while sliding from the left (sidebar items).
  Widget fadeLeft([int index = 0, int baseMs = 80]) => FadeSlideIn(
        delay: FadeSlideIn.stagger(index, baseMs: baseMs),
        duration: const Duration(milliseconds: 600),
        offset: const Offset(-16, 0),
        child: this,
      );

  /// Scale-and-fade entrance with a small bounce (state icons, badges).
  Widget popIn([int index = 0]) => PopIn(
        delay: FadeSlideIn.stagger(index),
        child: this,
      );

  /// Gentle halo pulse and light sweep for a primary brass button.
  Widget shine({double radius = 14}) =>
      ButtonShine(borderRadius: radius, child: this);
}

/// Counts a number up from zero (and glides to any new value later).
///
/// ```dart
/// CountUp(
///   value: portfolioValue,
///   builder: (context, v) => Text('Rs. ${format(v)}'),
/// )
/// ```
class CountUp extends StatelessWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 1100),
  });

  final double value;
  final Widget Function(BuildContext context, double value) builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return builder(context, value);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => builder(context, v),
    );
  }
}

/// Scales and fades a child in with a small overshoot (avatars, badges).
class PopIn extends StatefulWidget {
  const PopIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 520),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
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
    if (reduceMotion(context)) return widget.child;
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final v = _curve.value;
        return Opacity(
          opacity: v.clamp(0.0, 1.0).toDouble(),
          child: Transform.scale(scale: 0.6 + 0.4 * v, child: child),
        );
      },
    );
  }
}

/// Shrinks a child slightly while a finger is on it. It only listens to raw
/// pointers, so taps and scrolling inside the child still work normally.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.scale = 0.97});

  final Widget child;
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _set(bool value) {
    if (_down != value && mounted) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Reveals a child from left to right, like a chart drawing itself.
/// Give it a new [key] to play it again (e.g. when the range changes).
class RevealSweep extends StatefulWidget {
  const RevealSweep({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 350),
    this.duration = const Duration(milliseconds: 1300),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<RevealSweep> createState() => _RevealSweepState();
}

class _RevealSweepState extends State<RevealSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _curve =
      CurvedAnimation(parent: _controller, curve: const Cubic(.4, .1, .2, 1));
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => ClipRect(
        clipper: _SweepClipper(_curve.value),
        child: child,
      ),
    );
  }
}

class _SweepClipper extends CustomClipper<Rect> {
  const _SweepClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction.clamp(0.0, 1.0), size.height);

  @override
  bool shouldReclip(_SweepClipper oldClipper) =>
      oldClipper.fraction != fraction;
}

/// The pulsing ring and sweeping light on the main brass button of a screen.
/// Wrap the button: `SizedBox(...ElevatedButton...).shine()`.
/// Taps pass straight through; it is skipped when motion is reduced.
class ButtonShine extends StatefulWidget {
  const ButtonShine({super.key, required this.child, this.borderRadius = 14});

  final Widget child;
  final double borderRadius;

  @override
  State<ButtonShine> createState() => _ButtonShineState();
}

class _ButtonShineState extends State<ButtonShine>
    with TickerProviderStateMixin {
  late final AnimationController _halo = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );
  late final AnimationController _sheen = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3400),
  );
  Timer? _haloTimer;
  Timer? _sheenTimer;

  @override
  void initState() {
    super.initState();
    _haloTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) _halo.repeat();
    });
    _sheenTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) _sheen.repeat();
    });
  }

  @override
  void dispose() {
    _haloTimer?.cancel();
    _sheenTimer?.cancel();
    _halo.dispose();
    _sheen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    final radius = BorderRadius.circular(widget.borderRadius);

    return AnimatedBuilder(
      animation: Listenable.merge([_halo, _sheen]),
      child: widget.child,
      builder: (context, child) {
        final h = _halo.value;
        final pulse = h < 0.5 ? h * 2 : (1 - h) * 2; // 0 -> 1 -> 0
        final sweep =
            Curves.easeInOut.transform((_sheen.value / 0.55).clamp(0.0, 1.0));

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: AppColors.brass.withValues(alpha: 0.35 * (1 - pulse)),
                spreadRadius: 8 * pulse,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                child!,
                Positioned.fill(
                  child: IgnorePointer(
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final band = box.maxWidth * 0.35;
                        final x = -1.5 * band + 5 * band * sweep;
                        return Stack(
                          children: [
                            Positioned(
                              left: x,
                              top: 0,
                              bottom: 0,
                              width: band,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.skewX(-0.35),
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0x00FFFFFF),
                                        Color(0x66FFFFFF),
                                        Color(0x00FFFFFF),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
