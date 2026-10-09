import 'package:flutter/material.dart';

import '../theme/aartha_theme.dart';

/// Primary brass button with hover glow (desktop/web), press-scale (touch),
/// keyboard focus ring and a loading state.
class BrassButton extends StatefulWidget {
  const BrassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;

  @override
  State<BrassButton> createState() => _BrassButtonState();
}

class _BrassButtonState extends State<BrassButton> {
  bool _hover = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    final radius = BorderRadius.circular(14);

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      excludeSemantics: true,
      onTap: enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _pressed && enabled ? 0.98 : 1,
        duration: const Duration(milliseconds: 90),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: widget.height,
          decoration: BoxDecoration(
            color: _hover && enabled
                ? AarthaColors.brassHover
                : AarthaColors.brass,
            borderRadius: radius,
            boxShadow: [
              if (_hover && enabled)
                const BoxShadow(
                  color: Color.fromRGBO(196, 167, 108, 0.28),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              if (_focused)
                const BoxShadow(
                  color: Color.fromRGBO(244, 241, 233, 0.55),
                  spreadRadius: 3,
                ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: enabled ? widget.onPressed : null,
              onHover: (v) => setState(() => _hover = v),
              onHighlightChanged: (v) => setState(() => _pressed = v),
              onFocusChange: (v) => setState(() => _focused = v),
              splashColor: const Color.fromRGBO(18, 36, 28, 0.10),
              highlightColor: Colors.transparent,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: widget.loading
                      ? const SizedBox(
                          key: ValueKey('spinner'),
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AarthaColors.onBrass,
                          ),
                        )
                      : Text(
                          widget.label,
                          key: const ValueKey('label'),
                          style: const TextStyle(
                            fontFamily: AarthaType.body,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AarthaColors.onBrass,
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
