import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Small red warning line shown under a field.
class AarthaInlineError extends StatelessWidget {
  const AarthaInlineError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 14,
              color: AppColors.loss,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: AppTypography.caption.copyWith(color: AppColors.loss),
            ),
          ),
        ],
      ),
    );
  }
}

/// Labelled text input matching the design system: default, focused (brass
/// border + glow), error (red border + message) and disabled states.
///
/// Set [isPassword] for a masked field with a show/hide toggle. Use
/// [highlightError] to paint the red border without a message (e.g. when a
/// banner above the form already explains the problem).
class AarthaTextField extends StatefulWidget {
  const AarthaTextField({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.hint,
    this.errorText,
    this.highlightError = false,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? errorText;
  final bool highlightError;
  final bool isPassword;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AarthaTextField> createState() => _AarthaTextFieldState();
}

class _AarthaTextFieldState extends State<AarthaTextField> {
  FocusNode? _ownNode;
  bool _focused = false;
  bool _hidden = true;

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
    final hasMessage = widget.errorText != null && widget.errorText!.isNotEmpty;
    final hasError = hasMessage || widget.highlightError;
    final focused = _focused && !hasError;
    final borderColor = hasError
        ? AppColors.loss
        : focused
            ? AppColors.brass
            : AppColors.border;

    return Opacity(
      opacity: widget.enabled ? 1 : .6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTypography.label),
          const SizedBox(height: AppSpacing.s),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: AppSpacing.controlHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: borderColor),
              boxShadow: focused
                  ? [
                      BoxShadow(
                        color: AppColors.brass.withValues(alpha: .22),
                        spreadRadius: 4,
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _node,
                      enabled: widget.enabled,
                      obscureText: widget.isPassword && _hidden,
                      enableSuggestions: !widget.isPassword,
                      autocorrect: !widget.isPassword,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      autofillHints: widget.autofillHints,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      style: AppTypography.input,
                      cursorColor: AppColors.brass,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                        hintText: widget.hint,
                        hintStyle: AppTypography.input.copyWith(
                          color: AppColors.muted.withValues(alpha: .6),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.isPassword)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: widget.enabled
                          ? () => setState(() => _hidden = !_hidden)
                          : null,
                      tooltip: _hidden ? 'Show password' : 'Hide password',
                      constraints:
                          const BoxConstraints.tightFor(width: 44, height: 44),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        _hidden
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topLeft,
            child: hasMessage
                ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: AarthaInlineError(widget.errorText!),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
