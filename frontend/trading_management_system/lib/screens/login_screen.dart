import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/aartha_theme.dart';
import '../widgets/aartha_lockup.dart';
import '../widgets/reveal.dart';
import '../widgets/splash_overlay.dart';
import '../widgets/wave_background.dart';
import 'login_form.dart';

/// Splash -> login, adapting to phone, tablet and desktop.
///
/// * phone / tablet: animated splash, cross-fades into the login layout whose
///   blocks then rise in one after another.
/// * desktop: same splash, then the split layout builds in.
/// * all: wave lines draw on and then drift gently; hover / focus / press
///   states on controls. Everything is skipped when the OS asks for reduced
///   motion.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onSignIn});

  final SignInCallback onSignIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Intro duration (ms): splash 0-2100, then the login builds up to ~3.4s.
  static const _introTotal = 3600;

  late final AnimationController _intro = AnimationController(vsync: this);
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  );

  // Keeps form state (text, focus, loading) alive when the window is resized
  // across a breakpoint and the layout swaps.
  final _formKey = GlobalKey();

  bool _configured = false;
  bool _splash = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_configured) return;
    _configured = true;

    final media = MediaQuery.of(context);
    final reduceMotion = media.disableAnimations;
    // The splash plays on phone, tablet and desktop alike.
    _splash = !reduceMotion;

    if (reduceMotion) {
      _intro.duration = const Duration(milliseconds: 1);
      _intro.value = 1;
    } else {
      _intro.duration = const Duration(milliseconds: _introTotal);
      _intro.forward();
      _drift.repeat();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeline = IntroTimeline(_intro);

    return Scaffold(
      backgroundColor: AarthaColors.forest,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final formFactor = FormFactor.fromWidth(constraints.maxWidth);

          // Slot -> start time. With the splash, blocks wait for the cross-fade
          // and then rise one after another (~0.2s apart), as in the reference.
          final slotStart = _splash ? 1900.0 : 100.0;
          final slotStep = _splash ? 200.0 : 130.0;
          final slotDuration = _splash ? 500.0 : 600.0;

          Widget stagger(
            int slot,
            Widget child, {
            double dy = 18,
            double dx = 0,
            double scaleFrom = 1,
          }) {
            final start = slotStart + slotStep * slot;
            return Reveal(
              controller: _intro,
              interval: timeline.span(start, start + slotDuration),
              dy: dy,
              dx: dx,
              scaleFrom: scaleFrom,
              child: child,
            );
          }

          final waveDraw = _splash
              ? timeline.animation(1500, 3000, Curves.easeInOut)
              : timeline.animation(0, 1500, Curves.easeInOut);

          final layout = switch (formFactor) {
            FormFactor.phone => _PhoneLayout(
              onSignIn: widget.onSignIn,
              formKey: _formKey,
              stagger: stagger,
              waveDraw: waveDraw,
              drift: _drift,
            ),
            FormFactor.tablet => _TabletLayout(
              onSignIn: widget.onSignIn,
              formKey: _formKey,
              stagger: stagger,
              waveDraw: waveDraw,
              drift: _drift,
            ),
            FormFactor.desktop => _DesktopLayout(
              onSignIn: widget.onSignIn,
              formKey: _formKey,
              stagger: stagger,
              waveDraw: waveDraw,
              drift: _drift,
            ),
          };

          if (!_splash) return layout;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Login layer fades in underneath the splash while it fades out.
              AnimatedBuilder(
                animation: _intro,
                child: layout,
                builder: (context, child) {
                  final fade = timeline.progress(1700, 2100);
                  return IgnorePointer(
                    ignoring: timeline.elapsedMs < 1900,
                    child: Opacity(opacity: fade, child: child),
                  );
                },
              ),
              SplashOverlay(timeline: timeline),
            ],
          );
        },
      ),
    );
  }
}

typedef _StaggerFn =
    Widget Function(
      int slot,
      Widget child, {
      double dy,
      double dx,
      double scaleFrom,
    });

// ---------------------------------------------------------------------------
// Phone (< 600 wide)
// ---------------------------------------------------------------------------

class _PhoneLayout extends StatelessWidget {
  const _PhoneLayout({
    required this.onSignIn,
    required this.formKey,
    required this.stagger,
    required this.waveDraw,
    required this.drift,
  });

  final SignInCallback onSignIn;
  final GlobalKey formKey;
  final _StaggerFn stagger;
  final Animation<double> waveDraw;
  final Animation<double> drift;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewPaddingOf(context);
    final top = math.max(56.0, insets.top + 24);

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 170,
          child: IgnorePointer(
            child: WaveBackground(draw: waveDraw, drift: drift),
          ),
        ),
        CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(28, top, 28, 36 + insets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stagger(0, const AarthaLockup(markSize: 52)),
                    const SizedBox(height: 44),
                    LoginForm(
                      key: formKey,
                      onSignIn: onSignIn,
                      stagger: (slot, child) => stagger(slot, child),
                    ),
                    const Spacer(),
                    const SizedBox(height: 32),
                    stagger(
                      5,
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Clarity in every decision.',
                              style: AarthaType.tagline(19),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Accounts are created by your broker.',
                              style: AarthaType.small,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tablet (600 - 999 wide): centred card
// ---------------------------------------------------------------------------

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({
    required this.onSignIn,
    required this.formKey,
    required this.stagger,
    required this.waveDraw,
    required this.drift,
  });

  final SignInCallback onSignIn;
  final GlobalKey formKey;
  final _StaggerFn stagger;
  final Animation<double> waveDraw;
  final Animation<double> drift;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final top = (c.maxHeight * 0.118).clamp(40.0, 140.0);
        final waveHeight = (c.maxHeight * 0.254).clamp(160.0, 300.0);
        final cardWidth = math.min(480.0, c.maxWidth - 48);

        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: waveHeight,
              child: IgnorePointer(
                child: WaveBackground(draw: waveDraw, drift: drift),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top, 24, 40),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    stagger(0, const AarthaLockup(markSize: 60)),
                    const SizedBox(height: 40),
                    stagger(
                      1,
                      Container(
                        width: cardWidth,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: AarthaColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AarthaColors.outline),
                        ),
                        child: LoginForm(
                          key: formKey,
                          onSignIn: onSignIn,
                          fieldHeight: 56,
                          headingSize: 38,
                          // Card enters at slot 1; its contents follow.
                          stagger: (slot, child) => stagger(slot + 1, child),
                        ),
                      ),
                      scaleFrom: 0.97,
                    ),
                    const SizedBox(height: 32),
                    stagger(
                      6,
                      Column(
                        children: [
                          Text(
                            'Clarity in every decision.',
                            style: AarthaType.tagline(22),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Accounts are created by your broker.',
                            style: AarthaType.small,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop (>= 1000 wide): brand panel + form
// ---------------------------------------------------------------------------

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.onSignIn,
    required this.formKey,
    required this.stagger,
    required this.waveDraw,
    required this.drift,
  });

  final SignInCallback onSignIn;
  final GlobalKey formKey;
  final _StaggerFn stagger;
  final Animation<double> waveDraw;
  final Animation<double> drift;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 11, child: _brandPanel()),
        Expanded(flex: 10, child: _formPanel()),
      ],
    );
  }

  Widget _brandPanel() {
    return ClipRect(
      child: ColoredBox(
        color: AarthaColors.forestDeep,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 260,
              child: IgnorePointer(
                child: WaveBackground(draw: waveDraw, drift: drift),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(56),
              child: LayoutBuilder(
                builder: (context, c) {
                  final textWidth = math.min(520.0, c.maxWidth);
                  final headline = (textWidth / 520 * 60).clamp(40.0, 60.0);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      stagger(
                        0,
                        const AarthaLockup(markSize: 56),
                        dy: 0,
                        dx: -16,
                      ),
                      const Spacer(),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: textWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            stagger(
                              1,
                              Text(
                                'Clarity in every decision.',
                                style: AarthaType.heading(
                                  headline,
                                  height: 1.05,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            stagger(
                              2,
                              const Text(
                                'Your portfolio and market history, in one place.',
                                style: TextStyle(
                                  fontFamily: AarthaType.body,
                                  fontSize: 16,
                                  height: 1.6,
                                  color: AarthaColors.mistDim,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formPanel() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: LoginForm(
                key: formKey,
                onSignIn: onSignIn,
                headingSize: 38,
                autofocus: true,
                stagger: (slot, child) => stagger(slot, child),
              ),
            ),
            const SizedBox(height: 48),
            stagger(
              5,
              const Text(
                'Accounts are created by your broker.',
                style: AarthaType.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
