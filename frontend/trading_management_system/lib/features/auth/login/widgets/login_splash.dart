import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/animations.dart';

/// Plays the animated AARTHA splash, then cross-fades into [child].
///
/// Timeline (ms):
///   logo      0 - 600   fades in, scales 80% -> 100%
///   wordmark  300 - 1000 fades in, letter-spacing .7em -> .3em
///   tagline   800 - 1300 fades in, rises 8px
///   hold
///   fade out  1700 - 2100
///
/// [child] is built at 1700 ms, when the fade-out starts, so its own entrance
/// animations (staggered fields, wave) play while the splash dissolves. It is
/// never rebuilt afterwards, so text and focus state are kept.
///
/// Skipped entirely when the OS asks for reduced motion.
class LoginSplash extends StatefulWidget {
  const LoginSplash({super.key, required this.child});

  final Widget child;

  static const double revealMs = 1700;
  static const double endMs = 2100;

  @override
  State<LoginSplash> createState() => _LoginSplashState();
}

class _LoginSplashState extends State<LoginSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2100),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (reduceMotion(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Eased 0..1 progress of a span of the timeline.
  double _span(double from, double to, [Curve curve = Curves.easeOut]) {
    final ms = _controller.value * LoginSplash.endMs;
    return curve.transform(((ms - from) / (to - from)).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final ms = _controller.value * LoginSplash.endMs;
        final done = ms >= LoginSplash.endMs;
        final showChild = ms >= LoginSplash.revealMs;

        // Stack shape never changes so [child] keeps its state.
        return Stack(
          fit: StackFit.expand,
          children: [
            Material(
              color: AppColors.background,
              child: showChild ? widget.child : const SizedBox.expand(),
            ),
            done
                ? const SizedBox.shrink()
                : IgnorePointer(
                    child: Opacity(
                      opacity:
                          1 -
                          _span(
                            LoginSplash.revealMs,
                            LoginSplash.endMs,
                            Curves.easeIn,
                          ),
                      child: _SplashContent(
                        logo: _span(0, 600),
                        word: _span(300, 1000),
                        tag: _span(800, 1300),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({
    required this.logo,
    required this.word,
    required this.tag,
  });

  final double logo;
  final double word;
  final double tag;

  @override
  Widget build(BuildContext context) {
    // Bigger on tablet / desktop so it isn't a tiny mark in a large window.
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final scale = (shortest / 520).clamp(1.0, 1.5).toDouble();

    const wordSize = 36.0;
    final tracking = wordSize * lerpDouble(0.7, 0.3, word)!;

    return Material(
      color: AppColors.background,
      child: Center(
        child: Transform.scale(
          scale: scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: logo,
                child: Transform.scale(
                  scale: 0.8 + 0.2 * logo,
                  child: Image.asset(
                    AppAssets.logo,
                    width: 170,
                    filterQuality: FilterQuality.medium,
                    semanticLabel: 'AARTHA logo',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Opacity(
                opacity: word,
                // Trailing letter-spacing would pull the word off-centre.
                child: Padding(
                  padding: EdgeInsets.only(left: tracking),
                  child: Text(
                    'AARTHA',
                    style: AppTypography.wordmark.copyWith(
                      fontSize: wordSize,
                      letterSpacing: tracking,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Opacity(
                opacity: tag,
                child: Transform.translate(
                  offset: Offset(0, 8 * (1 - tag)),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 2.2),
                    child: Text(
                      'FINANCIAL TECHNOLOGY',
                      style: AppTypography.overline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 34),
              Opacity(
                opacity: tag,
                child: Transform.translate(
                  offset: Offset(0, 8 * (1 - tag)),
                  child: Text(
                    'Clarity in every decision.',
                    style: AppTypography.tagline.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
