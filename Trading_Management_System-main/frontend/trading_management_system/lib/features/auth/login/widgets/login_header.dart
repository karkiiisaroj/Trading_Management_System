import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../auth_session.dart';

/// Floating logo lockup at the top of the login.
class LoginBrandHeader extends StatelessWidget {
  const LoginBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Floating(child: AarthaBrand()),
    );
  }
}

/// Sign-in title and instruction line for the portal.
class LoginWelcome extends StatelessWidget {
  const LoginWelcome({super.key, this.role = UserRole.investor});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final broker = role == UserRole.broker;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(broker ? 'Broker sign in' : 'Investor sign in',
            style: AppTypography.display),
        const SizedBox(height: AppSpacing.s),
        Text(
          broker
              ? 'Sign in with the credentials from your administrator.'
              : 'Sign in with the credentials provided by your broker.',
          style: AppTypography.bodyMuted,
        ),
      ],
    );
  }
}

/// Link to the other portal's login.
class LoginRoleSwitch extends StatelessWidget {
  const LoginRoleSwitch({super.key, required this.role, this.onSwitch});

  final UserRole role;
  final VoidCallback? onSwitch;

  @override
  Widget build(BuildContext context) {
    if (onSwitch == null) return const SizedBox.shrink();
    return Center(
      child: TextButton(
        onPressed: onSwitch,
        child: Text(
          role == UserRole.broker
              ? 'Are you an investor? Investor sign in'
              : 'Are you a broker? Broker sign in',
        ),
      ),
    );
  }
}
