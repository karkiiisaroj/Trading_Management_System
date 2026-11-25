import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

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

/// "Welcome back" + instruction line.
class LoginWelcome extends StatelessWidget {
  const LoginWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back', style: AppTypography.display),
        SizedBox(height: AppSpacing.s),
        Text(
          'Sign in with the credentials provided by your broker.',
          style: AppTypography.bodyMuted,
        ),
      ],
    );
  }
}
