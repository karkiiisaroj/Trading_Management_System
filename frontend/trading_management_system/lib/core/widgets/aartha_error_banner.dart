import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Form-level error (e.g. "Incorrect username or password").
class AarthaErrorBanner extends StatelessWidget {
  const AarthaErrorBanner(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.loss.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.loss),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: AppColors.loss,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTypography.label.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
