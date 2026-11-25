import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
import 'widgets/login_splash.dart';

export 'widgets/login_form.dart' show SignInCallback;

/// Login for brokers and investors. There is no registration: the admin
/// creates the credentials and the broker hands them out.
///
/// Plays the animated splash first, then fades into the form.
/// Pieces live in `widgets/`: [LoginSplash], [LoginBrandHeader],
/// [LoginWelcome] and [LoginForm].
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onSignIn});

  final SignInCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return LoginSplash(
      child: AuthShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const FadeSlideIn(
              delay: Duration(milliseconds: 80),
              child: LoginBrandHeader(),
            ),
            const SizedBox(height: 36),
            const FadeSlideIn(
              delay: Duration(milliseconds: 150),
              child: LoginWelcome(),
            ),
            const SizedBox(height: 24),
            LoginForm(onSignIn: onSignIn, staggerStart: 2),
          ],
        ),
      ),
    );
  }
}
