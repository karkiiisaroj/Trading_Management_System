import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../theme/aartha_theme.dart';
import 'reveal.dart';

/// Full-bleed splash that plays first and cross-fades into the login screen.
///
/// Timeline (ms): logo 0-600 | wordmark 300-1000 (tracking .7em -> .3em) |
/// tagline 800-1300 | hold | fade out 1700-2100. Scales up on big windows.
class SplashOverlay extends StatelessWidget {
  const SplashOverlay({super.key, required this.timeline});

  static const double endMs = 2100;

  final IntroTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: timeline.controller,
      builder: (context, _) {
        if (timeline.elapsedMs >= endMs) return const SizedBox.shrink();

        final logo = timeline.progress(0, 600);
        final word = timeline.progress(300, 1000);
        final tag = timeline.progress(800, 1300);
        final out = 1 - timeline.progress(1700, endMs, Curves.easeIn);

        final shortest = MediaQuery.sizeOf(context).shortestSide;
        final scale = (shortest / 520).clamp(1.0, 1.5);
        const wordSize = 36.0;
        final tracking = wordSize * lerpDouble(0.7, 0.3, word)!;

        return IgnorePointer(
          child: Opacity(
            opacity: out,
            child: ColoredBox(
              color: AarthaColors.forest,
              child: Center(
                // Larger on tablet / desktop so the splash isn't a tiny mark in
                // a big window.
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
                            AarthaAssets.logo,
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
                            style: AarthaType.wordmark(
                              wordSize,
                            ).copyWith(letterSpacing: tracking),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Opacity(
                        opacity: tag,
                        child: Transform.translate(
                          offset: Offset(0, 8 * (1 - tag)),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 11 * 0.2),
                            child: Text(
                              'FINANCIAL TECHNOLOGY',
                              style: AarthaType.caps,
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
                            style: AarthaType.tagline(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
