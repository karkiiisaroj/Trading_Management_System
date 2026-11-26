import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

import '../data/broker_models.dart';

/// Card used all over the broker area: surface fill, border, 18 radius.
/// It is a [Material] so ink effects on rows inside it show up.
class BrokerCard extends StatelessWidget {
  const BrokerCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.color = AppColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Round 44px button used for the bell and the avatar.
class BrokerCircleButton extends StatelessWidget {
  const BrokerCircleButton({
    super.key,
    required this.child,
    required this.onTap,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(width: 44, height: 44, child: Center(child: child)),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// Number card ("Assigned investors 24").
class BrokerStatCard extends StatelessWidget {
  const BrokerStatCard({
    super.key,
    required this.label,
    required this.value,
    this.compact = false,
  });

  final String label;
  final String value;

  /// Smaller version used inside the investor details page.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BrokerCard(
      padding: EdgeInsets.all(compact ? 14 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.caption.copyWith(fontSize: 13)),
          SizedBox(height: compact ? 4 : 6),
          Text(
            value,
            style: AppTypography.figures.copyWith(fontSize: compact ? 20 : 30),
          ),
        ],
      ),
    );
  }
}

enum PillTone { good, warn, bad, neutral }

/// Small outlined status label (Pending, Executed, Active, ...).
class BrokerStatusPill extends StatelessWidget {
  const BrokerStatusPill(this.label, {super.key, this.tone = PillTone.neutral});

  factory BrokerStatusPill.order(OrderStatus status, {Key? key}) {
    final tone = switch (status) {
      OrderStatus.executed => PillTone.good,
      OrderStatus.pending ||
      OrderStatus.submitted ||
      OrderStatus.partial =>
        PillTone.warn,
      OrderStatus.rejected => PillTone.bad,
      OrderStatus.cancelled => PillTone.neutral,
    };
    return BrokerStatusPill(status.label, key: key, tone: tone);
  }

  factory BrokerStatusPill.active(bool isActive, {Key? key}) =>
      BrokerStatusPill(
        isActive ? 'Active' : 'Inactive',
        key: key,
        tone: isActive ? PillTone.good : PillTone.neutral,
      );

  final String label;
  final PillTone tone;

  Color get _color => switch (tone) {
        PillTone.good => AppColors.gain,
        PillTone.warn => AppColors.brass,
        PillTone.bad => AppColors.loss,
        PillTone.neutral => AppColors.muted,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: _color),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: _color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Brass text link such as "View" or "Update status".
class BrokerLink extends StatelessWidget {
  const BrokerLink(this.label, {super.key, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.brass,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// "‹ Investors" above a page title.
class BrokerBackLink extends StatelessWidget {
  const BrokerBackLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chevron_left_rounded,
                size: 18,
                color: AppColors.brass,
              ),
              const SizedBox(width: 2),
              Text(
                label,
                style: AppTypography.label.copyWith(color: AppColors.brass),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Label on the left, value on the right, divider under it.
class BrokerKeyValueRow extends StatelessWidget {
  const BrokerKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        children: [
          Text(label, style: AppTypography.bodyMuted.copyWith(fontSize: 14)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.body.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circle with initials, e.g. the broker or investor avatar.
class BrokerAvatar extends StatelessWidget {
  const BrokerAvatar({super.key, required this.name, this.size = 68});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.deep,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        BrokerFormat.initials(name),
        style: TextStyle(
          fontFamily: AppFonts.serif,
          fontSize: size * .42,
          fontWeight: FontWeight.w700,
          color: AppColors.brass,
        ),
      ),
    );
  }
}

/// Full-card message: empty, error, no match, no access, inactive.
class BrokerStatePanel extends StatelessWidget {
  const BrokerStatePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor = AppColors.brass,
    this.actionLabel,
    this.onAction,
    this.secondary = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Use the outlined button (e.g. "Sign out") instead of the brass one.
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    return BrokerCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.deep,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 40),
              ).popIn(1),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.heading.copyWith(
                  fontSize: 30,
                  height: 1.2,
                ),
              ).fadeUp(2),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMuted.copyWith(
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ).fadeUp(3),
              if (actionLabel != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: 220,
                  child: AarthaButton(
                    label: actionLabel!,
                    onPressed: onAction,
                    variant: secondary
                        ? AarthaButtonVariant.secondary
                        : AarthaButtonVariant.primary,
                  ),
                ).fadeUp(4),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Cross-fades when [phase] changes (loading -> content, error, empty), so
/// a page never snaps between states. Instant when motion is reduced.
class BrokerPhaseSwitcher extends StatelessWidget {
  const BrokerPhaseSwitcher({
    super.key,
    required this.phase,
    required this.child,
  });

  /// Anything comparable; a new value starts the cross-fade.
  final Object phase;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: reduceMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      // passthrough keeps the parent's width, so cards still stretch.
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.topCenter,
        children: [...previous, if (current != null) current],
      ),
      child: KeyedSubtree(key: ValueKey<Object>(phase), child: child),
    );
  }
}

/// Soft pulse used by skeletons. Static when the OS asks for less motion.
class BrokerPulse extends StatefulWidget {
  const BrokerPulse({super.key, required this.child});

  final Widget child;

  @override
  State<BrokerPulse> createState() => _BrokerPulseState();
}

class _BrokerPulseState extends State<BrokerPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return FadeTransition(
      opacity: Tween<double>(begin: .45, end: 1).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}

class BrokerSkeletonBar extends StatelessWidget {
  const BrokerSkeletonBar({super.key, this.width, this.height = 14});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

/// Loading card for pages that are not a table.
class BrokerLoadingCard extends StatelessWidget {
  const BrokerLoadingCard({super.key, this.label = 'Loading\u2026'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return BrokerCard(
      padding: const EdgeInsets.all(24),
      child: BrokerPulse(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrokerSkeletonBar(width: 180, height: 20),
            const SizedBox(height: 18),
            for (var i = 0; i < 4; i++) ...[
              const BrokerSkeletonBar(),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 6),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

/// Loads data and shows loading / error / content. Owns the future so Retry
/// just loads again.
class BrokerFutureBuilder<T> extends StatefulWidget {
  const BrokerFutureBuilder({
    super.key,
    required this.load,
    required this.builder,
    this.loadingLabel = 'Loading\u2026',
    this.errorTitle = "Couldn't load this page",
    this.errorBuilder,
  });

  final Future<T> Function() load;
  final Widget Function(BuildContext context, T data) builder;
  final String loadingLabel;
  final String errorTitle;

  /// Handle specific errors yourself (e.g. a 403). Return null to fall back
  /// to the standard error panel.
  final Widget? Function(BuildContext context, Object error)? errorBuilder;

  @override
  State<BrokerFutureBuilder<T>> createState() => _BrokerFutureBuilderState<T>();
}

class _BrokerFutureBuilderState<T> extends State<BrokerFutureBuilder<T>> {
  late Future<T> _future = widget.load();

  void _retry() => setState(() => _future = widget.load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error!;
          final custom = widget.errorBuilder?.call(context, error);
          if (custom != null) {
            return BrokerPhaseSwitcher(phase: 'error', child: custom);
          }
          return BrokerPhaseSwitcher(phase: 'error', child: BrokerStatePanel(
            icon: Icons.error_outline_rounded,
            iconColor: AppColors.loss,
            title: widget.errorTitle,
            message: 'Check your connection and try again. If this keeps '
                'happening, contact your administrator.',
            actionLabel: 'Try again',
            onAction: _retry,
          ));
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return BrokerPhaseSwitcher(
            phase: 'loading',
            child: BrokerLoadingCard(label: widget.loadingLabel),
          );
        }
        return BrokerPhaseSwitcher(
          phase: 'content',
          child: widget.builder(context, snapshot.data as T),
        );
      },
    );
  }
}
