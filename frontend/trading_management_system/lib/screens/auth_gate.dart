import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../theme/aartha_theme.dart';
import 'login_screen.dart';
import 'session_home.dart';

/// Chooses between login and the signed-in app from [AuthController] state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final Widget page;
        switch (controller.status) {
          case AuthStatus.unknown:
            // Brief: reading the keystore. Same colour as the splash.
            page = const ColoredBox(
              key: ValueKey('unknown'),
              color: AarthaColors.forest,
              child: SizedBox.expand(),
            );
          case AuthStatus.signedOut:
            page = LoginScreen(
              key: const ValueKey('login'),
              onSignIn: controller.signIn,
            );
          case AuthStatus.signedIn:
            page = SessionHome(
              key: const ValueKey('home'),
              session: controller.session!,
              onSignOut: controller.signOut,
            );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: page,
        );
      },
    );
  }
}
