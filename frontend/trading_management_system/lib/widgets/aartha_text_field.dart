import 'package:flutter/material.dart';

import '../theme/aartha_theme.dart';

/// Labelled input with the AARTHA look. The border animates between
/// rest / hover (mouse) / focus (brass border + soft ring).
class AarthaTextField extends StatefulWidget {
  const AarthaTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.focusNode,
    this.height = 52,
    this.obscureText = false,
    this.trailing,
    this.textInputAction,
    this.autofillHints,
    this.autofocus = false,
    this.enabled = true,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final double height;
  final bool obscureText;
  final Widget? trailing;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AarthaTextField> createState() => _AarthaTextFieldState();
}

class _AarthaTextFieldState extends State<AarthaTextField> {
  FocusNode? _ownNode;
  bool _hover = false;
  bool _focused = false;

  FocusNode get _node => widget.focusNode ?? (_ownNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(AarthaTextField old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      (old.focusNode ?? _ownNode)?.removeListener(_onFocus);
      _node.addListener(_onFocus);
    }
  }

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    _ownNode?.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (_focused != _node.hasFocus) setState(() => _focused = _node.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _focused
        ? AarthaColors.brass
        : _hover
            ? AarthaColors.outlineHover
            : AarthaColors.outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AarthaType.label),
        const SizedBox(height: 8),
        MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: widget.height,
            decoration: BoxDecoration(
              color: AarthaColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
              boxShadow: [
                if (_focused)
                  const BoxShadow(
                    color: Color.fromRGBO(196, 167, 108, 0.16),
                    spreadRadius: 3,
                  ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: widget.trailing == null ? 16 : 0,
                    ),
                    child: Semantics(
                      label: widget.label,
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _node,
                        autofocus: widget.autofocus,
                        enabled: widget.enabled,
                        obscureText: widget.obscureText,
                        enableSuggestions: !widget.obscureText,
                        autocorrect: false,
                        textInputAction: widget.textInputAction,
                        autofillHints: widget.autofillHints,
                        onSubmitted: widget.onSubmitted,
                        style: AarthaType.input,
                        cursorColor: AarthaColors.brass,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: widget.hint,
                          hintStyle: AarthaType.input.copyWith(
                            color: const Color.fromRGBO(181, 195, 185, 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.trailing != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: widget.trailing,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
