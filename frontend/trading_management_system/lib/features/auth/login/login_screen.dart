import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../auth_session.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
import 'widgets/login_splash.dart';
import 'widgets/login_split_layout.dart';

export 'widgets/login_form.dart' show SignInCallback;

/// One screen per portal. Investors always get the phone/tablet card, and
/// brokers get the split layout on desktop. Each shows a link to the other
/// portal. The backend must also reject a role that doesn't match the portal.
class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.onSignIn,
    this.role = UserRole.investor,
    this.onSwitchRole,
  });

  final SignInCallback onSignIn;
  final UserRole role;
  final VoidCallback? onSwitchRole;

  @override
  Widget build(BuildContext context) {
    final isBroker = role == UserRole.broker;
    return LoginSplash(
      child: LayoutBuilder(
        builder: (context, box) {
          if (isBroker && box.maxWidth >= LoginSplitLayout.desktopBreakpoint) {
            return LoginSplitLayout(
              key: ValueKey(role),
              onSignIn: onSignIn,
              onSwitchRole: onSwitchRole,
            );
          }
          return AuthShell(
            tagline: isBroker
                ? 'Clarity in every decision.'
                : 'Your wealth, in clear view.',
            footerNote: isBroker
                ? 'Accounts are created by your administrator.'
                : 'Accounts are created by your broker.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const FadeSlideIn(
                  delay: Duration(milliseconds: 80),
                  child: LoginBrandHeader(),
                ),
                const SizedBox(height: 36),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 150),
                  child: LoginWelcome(role: role),
                ),
                const SizedBox(height: 24),
                // The key clears the fields when the portal is switched.
                LoginForm(key: ValueKey(role), onSignIn: onSignIn, staggerStart: 2),
                const SizedBox(height: 8),
                LoginRoleSwitch(role: role, onSwitch: onSwitchRole),
              ],
            ),
          );
        },
      ),
    );
  }
}
