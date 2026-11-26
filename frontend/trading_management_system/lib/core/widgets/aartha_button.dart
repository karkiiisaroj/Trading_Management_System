import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'animations.dart';

enum AarthaButtonVariant { primary, secondary, destructive }

/// The app's button. Primary is solid brass with a soft halo and a sheen that
/// sweeps across it; secondary and destructive are outlined.
///
/// `onPressed: null` renders the disabled state. `loading: true` shows a
/// spinner (and [loadingLabel] if given) and blocks taps.
class AarthaButton extends StatefulWidget {
  const AarthaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.loadingLabel,
    this.variant = AarthaButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final String? loadingLabel;
  final AarthaButtonVariant variant;

  @override
  State<AarthaButton> createState() => _AarthaButtonState();
}

class _AarthaButtonState extends State<AarthaButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3400),
  )..repeat();

  bool _hover = false;
  bool _down = false;

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  Color get _fg => switch (widget.variant) {
        AarthaButtonVariant.primary => AppColors.onBrass,
        AarthaButtonVariant.secondary => AppColors.text,
        AarthaButtonVariant.destructive => AppColors.loss,
      };

  Color get _bg => widget.variant == AarthaButtonVariant.primary
      ? AppColors.brass
      : Colors.transparent;

  BorderSide get _side => switch (widget.variant) {
        AarthaButtonVariant.primary => BorderSide.none,
        AarthaButtonVariant.secondary =>
          const BorderSide(color: AppColors.border),
        AarthaButtonVariant.destructive =>
          const BorderSide(color: AppColors.loss),
      };

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    final isPrimary = widget.variant == AarthaButtonVariant.primary;
    final animate = isPrimary && enabled && !reduceMotion(context);
    final radius = BorderRadius.circular(AppRadius.md);

    final opacity = widget.loading
        ? .85
        : widget.onPressed == null
            ? .45
            : 1.0;

    final text = widget.loading && widget.loadingLabel != null
        ? widget.loadingLabel!
        : widget.label;

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.loading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: _fg),
          ),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.button.copyWith(color: _fg),
          ),
        ),
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: const Cubic(.2, .8, .2, 1),
          transformAlignment: Alignment.center,
          transform: Matrix4.translationValues(
                0,
                (_hover && enabled && !_down) ? -2.0 : 0.0,
                0,
              ) *
              Matrix4.diagonal3Values(
                _down && enabled ? 0.97 : 1.0,
                _down && enabled ? 0.97 : 1.0,
                1,
              ),
          child: Opacity(
            opacity: opacity,
            child: AnimatedBuilder(
              animation: _loop,
              builder: (context, child) {
                // Halo: ring grows and fades, 0 -> 8px, alpha .35 -> 0.
                final t = _loop.value;
                final w = 1 - (2 * t - 1).abs();
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    boxShadow: animate
                        ? [
                            BoxShadow(
                              color: AppColors.brass
                                  .withValues(alpha: .35 * (1 - w)),
                              spreadRadius: 8 * w,
                            ),
                          ]
                        : null,
                  ),
                  child: child,
                );
              },
              child: SizedBox(
                width: double.infinity,
                height: AppSpacing.controlHeight,
                child: Material(
                  color: _bg,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: radius,
                    side: _side,
                  ),
                  child: InkWell(
                    onTap: enabled ? widget.onPressed : null,
                    onHighlightChanged: (v) => setState(() => _down = v),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (animate) _Sheen(animation: _loop),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                          child: content,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Light streak that crosses the button for the first 55% of each cycle.
class _Sheen extends StatelessWidget {
  const _Sheen({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            final streak = w * .35;
            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final p = Curves.easeInOut
                    .transform(math.min(animation.value / .55, 1.0));
                final x = -1.5 * streak + p * (w * 1.225 + 1.5 * streak);
                return Stack(
                  children: [
                    Positioned(
                      left: x,
                      top: 0,
                      bottom: 0,
                      width: streak,
                      child: Transform(
                        transform: Matrix4.skewX(-.364),
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
            );
          },
        ),
      ),
    );
  }
}
