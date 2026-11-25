import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import 'core/theme/theme.dart';
import 'features/auth/auth_session.dart';
import 'features/auth/login/login_screen.dart';
import 'features/investor/investor_flow.dart';

/// Testing switch: when true the app skips login and opens the investor
/// flow straight away. Set to false to restore the normal login routing.
const bool kInvestorOnly = true;

void main() => runApp(const AarthaApp());

/// App shell. All styling comes from `core/theme` through [AppTheme.dark],
/// so every screen below inherits colours, fonts and snack bars from here.
class AarthaApp extends StatelessWidget {
  const AarthaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AARTHA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      // Mouse / trackpad drag-scrolling on desktop and web, like touch.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      home: const AppRoot(),
    );
  }
}

/// Decides what the user sees from the authenticated session:
///
/// ```
/// no session ──► LoginScreen (BR-01)
/// investor   ──► InvestorFlow        (BR-02, BR-08)
/// broker     ──► broker area         (built next)
/// ```
/// Signing out clears the session, which returns to login.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  AuthSession? _session = kInvestorOnly
      ? const AuthSession(
          username: 'investor',
          role: UserRole.investor,
          displayName: 'Aarav Sharma',
          clientId: 'C001',
        )
      : null;

  Future<void> _signIn(String username, String password) async {
    // Throws AuthFailure on bad credentials; LoginForm shows the message.
    final session = await DemoAuthBackend.authenticate(username, password);
    if (!mounted) return;
    setState(() => _session = session);
  }

  void _signOut() => setState(() => _session = null);

  @override
  Widget build(BuildContext context) {
    final session = _session;

    final Widget child;
    if (session == null) {
      child = LoginScreen(
        key: const ValueKey('login'),
        onSignIn: _signIn,
      );
    } else {
      switch (session.role) {
        case UserRole.investor:
          child = InvestorFlow(
            key: const ValueKey('investor'),
            session: session,
            onSignOut: _signOut,
          );
        case UserRole.broker:
          child = _BrokerPlaceholder(
            key: const ValueKey('broker'),
            session: session,
            onSignOut: _signOut,
          );
        case UserRole.administrator:
          // Admins use Django Admin (BR-A01); the backend rejects them above.
          child = LoginScreen(
            key: const ValueKey('login'),
            onSignIn: _signIn,
          );
      }
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: child,
    );
  }
}

/// Temporary landing page for brokers until the broker flow is built.
class _BrokerPlaceholder extends StatelessWidget {
  const _BrokerPlaceholder({
    super.key,
    required this.session,
    required this.onSignOut,
  });

  final AuthSession session;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Broker area', style: AppTypography.heading),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Signed in as ${session.displayName} '
                  '(${session.brokerCode}).\nThe broker flow comes next.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMuted,
                ),
                const SizedBox(height: AppSpacing.xl),
                TextButton(onPressed: onSignOut, child: const Text('Sign out')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}