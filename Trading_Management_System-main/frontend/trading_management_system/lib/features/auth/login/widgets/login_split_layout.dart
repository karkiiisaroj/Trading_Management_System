import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'login_form.dart';
import 'login_header.dart';

/// Login for desktop (width >= [desktopBreakpoint]). Brokers use desktop.
///
/// Two panels side by side:
///  * left: brand, headline, wave and tagline
///  * right: "Welcome back" and the sign-in form
///
/// It uses the same [LoginForm] and the same [SignInCallback] as the phone
/// layout, so there is one login for brokers and investors. The role comes
/// back from the backend after sign in, never from this screen (BR-08).
class LoginSplitLayout extends StatelessWidget {
  const LoginSplitLayout({super.key, required this.onSignIn});

  final SignInCallback onSignIn;

  /// From this width the broker-style split login is used. Below it, tablets
  /// and phones keep the standard login.
  static const double desktopBreakpoint = 1024;

  /// Inside the split layout, from this width the panels are 50 / 50.
  static const double wideBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, box) {
          final wide = box.maxWidth >= wideBreakpoint;
          return Row(
            children: [
              Expanded(flex: wide ? 1 : 5, child: _BrandPanel(wide: wide)),
              Expanded(
                flex: wide ? 1 : 6,
                child: _FormPanel(onSignIn: onSignIn, wide: wide),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final pad = wide ? 72.0 : 36.0;
    return ColoredBox(
      color: AppColors.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const AarthaWaveBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(pad, wide ? 56 : 40, pad, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoginBrandHeader(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        child: FadeSlideIn(
                          delay: const Duration(milliseconds: 150),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BROKER WORKSPACE',
                                style: AppTypography.overline.copyWith(
                                  color: AppColors.brass,
                                  fontSize: 12,
                                  letterSpacing: 2.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Manage your investors,\norders and trades.',
                                style: AppTypography.display.copyWith(
                                  fontSize: wide ? 54 : 34,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 22),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 440),
                                child: Text(
                                  'Monitor assigned investors, trading accounts '
                                  'and activity in one place.',
                                  style: AppTypography.bodyMuted.copyWith(
                                    fontSize: wide ? 17 : 15,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 900),
                    offset: Offset.zero,
                    child: Text(
                      'Clarity in every decision.',
                      style: AppTypography.tagline.copyWith(
                        fontSize: wide ? 22 : 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({required this.onSignIn, required this.wide});

  final SignInCallback onSignIn;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 48 : 32,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FadeSlideIn(
                          delay: Duration(milliseconds: 80),
                          child: Text(
                            'Welcome back',
                            style: AppTypography.display,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        const FadeSlideIn(
                          delay: Duration(milliseconds: 150),
                          child: Text(
                            'Sign in with your username and password.',
                            style: AppTypography.bodyMuted,
                          ),
                        ),
                        const SizedBox(height: 32),
                        LoginForm(
                          onSignIn: onSignIn,
                          staggerStart: 2,
                          helpText: 'Need help? Contact your administrator.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Text(
                'Accounts are created by your broker or administrator.',
                textAlign: TextAlign.center,
                style: AppTypography.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
