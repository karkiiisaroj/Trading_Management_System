import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../auth_failure.dart';

/// Performs the sign in. Throw [AuthFailure] for rejected credentials.
typedef SignInCallback = Future<void> Function(String username, String password);

/// Username + password + Sign in button, and every state the design shows:
///
/// * default / focused
/// * validation errors (empty fields)
/// * incorrect credentials (banner + red password border)
/// * signing in (fields disabled, spinner button)
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSignIn,
    this.staggerStart = 0,
    this.helpText = 'Need help? Contact your broker.',
  });

  final SignInCallback onSignIn;

  /// Slot of the first field in the screen's staggered entrance.
  final int staggerStart;

  /// Line under the button.
  final String helpText;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const _genericError =
      'Something went wrong. Check your connection and try again.';

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

  String? _usernameError;
  String? _passwordError;
  String? _formError;
  bool _loading = false;
  int _shake = 0;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;

    final username = _username.text.trim();
    final password = _password.text;

    setState(() {
      _usernameError = username.isEmpty ? 'Enter your username' : null;
      _passwordError = password.isEmpty ? 'Enter your password' : null;
      _formError = null;
    });
    if (_usernameError != null || _passwordError != null) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    String? failure;
    try {
      await widget.onSignIn(username, password);
    } on AuthFailure catch (e) {
      failure = e.message;
    } catch (_) {
      failure = _genericError;
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (failure != null) {
        _formError = failure;
        _shake++;
      }
    });
  }

  void _clearErrors({bool username = false, bool password = false}) {
    if (_formError == null &&
        !(username && _usernameError != null) &&
        !(password && _passwordError != null)) {
      return;
    }
    setState(() {
      _formError = null;
      if (username) _usernameError = null;
      if (password) _passwordError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var slot = widget.staggerStart;
    Widget step(Widget w) =>
        FadeSlideIn(delay: FadeSlideIn.stagger(slot++), child: w);

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topCenter,
            child: _formError == null
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Shake(
                      trigger: _shake,
                      child: AarthaErrorBanner(_formError!),
                    ),
                  ),
          ),
          step(AarthaTextField(
            label: 'Username',
            hint: 'Your username',
            controller: _username,
            enabled: !_loading,
            errorText: _usernameError,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            onChanged: (_) => _clearErrors(username: true),
            onSubmitted: (_) => _passwordFocus.requestFocus(),
          )),
          const SizedBox(height: 18),
          step(AarthaTextField(
            label: 'Password',
            hint: 'Your password',
            controller: _password,
            focusNode: _passwordFocus,
            isPassword: true,
            enabled: !_loading,
            errorText: _passwordError,
            // Red border without repeating the banner's message.
            highlightError: _formError != null,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onChanged: (_) => _clearErrors(password: true),
            onSubmitted: (_) => _submit(),
          )),
          const SizedBox(height: 26),
          step(Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AarthaButton(
                label: 'Sign in',
                loadingLabel: 'Signing in…',
                loading: _loading,
                onPressed: _submit,
              ),
              const SizedBox(height: 18),
              Text(
                widget.helpText,
                textAlign: TextAlign.center,
                style: AppTypography.label,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
