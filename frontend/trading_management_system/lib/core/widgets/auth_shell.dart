import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'animations.dart';
import 'aartha_wave_background.dart';

/// Page frame shared by every signed-out screen (login, session expired,
/// no access, ...).
///
/// Phone: content runs full width on the green background.
/// Tablet / desktop (>= [Breakpoints.card]): content sits in a centred card.
/// Either way it scrolls when the keyboard or a short window needs the room,
/// keeps the tagline footer at the bottom, and draws the wave behind.
class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.child,
    this.footerNote = 'Accounts are created by your broker.',
    this.maxContentWidth = 440,
    this.tagline = 'Clarity in every decision.',
  });

  final Widget child;
  final String? footerNote;
  final double maxContentWidth;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AarthaWaveBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, box) {
                final wide = Breakpoints.isCard(box.maxWidth);
                return CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          if (wide) ...[
                            const Spacer(),
                            _Card(maxWidth: maxContentWidth, child: child),
                            const Spacer(),
                          ] else ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.xxl - 4,
                                AppSpacing.xl,
                                AppSpacing.xxl - 4,
                                0,
                              ),
                              child: child,
                            ),
                            const Spacer(),
                          ],
                          const SizedBox(height: AppSpacing.xl),
                          _Footer(note: footerNote, tagline: tagline),
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.maxWidth, required this.child});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xxl + 4),
          decoration: BoxDecoration(
            color: AppColors.deep,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 40,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.note, required this.tagline});

  final String? note;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      delay: const Duration(milliseconds: 600),
      duration: const Duration(milliseconds: 900),
      offset: Offset.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tagline,
            textAlign: TextAlign.center,
            style: AppTypography.tagline,
          ),
          if (note != null) ...[
            const SizedBox(height: AppSpacing.m),
            Text(note!, textAlign: TextAlign.center, style: AppTypography.caption),
          ],
        ],
      ),
    );
  }
}
