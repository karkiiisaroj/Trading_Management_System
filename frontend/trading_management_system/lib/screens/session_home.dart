import 'package:flutter/material.dart';

import '../auth/auth_models.dart';
import '../theme/aartha_theme.dart';
import '../widgets/aartha_lockup.dart';
import '../widgets/brass_button.dart';

/// Landing screen after a successful sign-in. Swap this for the real
/// admin / broker dashboards: branch on [session.role].
class SessionHome extends StatelessWidget {
  const SessionHome({super.key, required this.session, required this.onSignOut});

  final AuthSession session;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: AarthaLockup()),
                const SizedBox(height: 32),
                Text(
                  session.username,
                  textAlign: TextAlign.center,
                  style: AarthaType.heading(32),
                ),
                const SizedBox(height: 6),
                Text(
                  session.role.label,
                  textAlign: TextAlign.center,
                  style: AarthaType.tagline(20),
                ),
                const SizedBox(height: 32),
                BrassButton(label: 'Sign out', onPressed: onSignOut),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
