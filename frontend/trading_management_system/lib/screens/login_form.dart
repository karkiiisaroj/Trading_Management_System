import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/auth_models.dart';
import '../theme/aartha_theme.dart';
import '../widgets/aartha_text_field.dart';
import '../widgets/brass_button.dart';
import '../widgets/reveal.dart';

/// Called with the entered credentials. Throw to signal a failed sign-in.
typedef SignInCallback = Future<void> Function(String username, String password);

/// The credential form shared by the phone, tablet and desktop layouts.
///
/// The parent supplies [stagger] to choreograph how each block enters, and
/// the sizing knobs that differ per form factor.
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSignIn,
    required this.stagger,
    this.fieldHeight = 52,
    this.headingSize = 36,
    this.autofocus = false,
  });

  final SignInCallback onSignIn;
  final Stagger stagger;
  final double fieldHeight;
  final double headingSize;

  /// Focus the username field on first build (desktop only; on phones it
  /// would pop the keyboard over the intro).
  final bool autofocus;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final username = _username.text.trim();
    final password = _password.text;

    if (username.isEmpty) {
      setState(() => _error = 'Enter your username.');
      _usernameFocus.requestFocus();
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Enter your password.');
      _passwordFocus.requestFocus();
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onSignIn(username, password);
      TextInput.finishAutofillContext();
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'We couldn\u2019t sign you in. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.stagger(
            1,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Welcome back',
                    style: AarthaType.heading(widget.headingSize),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in with the credentials provided by your broker.',
                  style: AarthaType.bodyMuted,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          widget.stagger(
            2,
            AarthaTextField(
              label: 'Username',
              hint: 'Your username',
              controller: _username,
              focusNode: _usernameFocus,
              height: widget.fieldHeight,
              autofocus: widget.autofocus,
              enabled: !_loading,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
          ),
          const SizedBox(height: 20),
          widget.stagger(
            3,
            AarthaTextField(
              label: 'Password',
              hint: 'Your password',
              controller: _password,
              focusNode: _passwordFocus,
              height: widget.fieldHeight,
              obscureText: _obscure,
              enabled: !_loading,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _submit(),
              trailing: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                tooltip: _obscure ? 'Show password' : 'Hide password',
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
                padding: EdgeInsets.zero,
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AarthaColors.mist,
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topLeft,
            child: _error == null
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: AarthaType.label.copyWith(
                          color: AarthaColors.error,
                        ),
                      ),
                    ),
                  ),
          ),
          widget.stagger(
            4,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 28),
                BrassButton(
                  label: 'Sign in',
                  height: widget.fieldHeight,
                  loading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Need help? Contact your broker.',
                  textAlign: TextAlign.center,
                  style: AarthaType.label,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
