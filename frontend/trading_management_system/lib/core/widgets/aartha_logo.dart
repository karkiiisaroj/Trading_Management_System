import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/theme.dart';

/// The logo in its rounded dark tile.
class AarthaLogoMark extends StatelessWidget {
  const AarthaLogoMark({super.key, this.size = 52});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
        border: Border.all(color: AppColors.border),
      ),
      child: FractionallySizedBox(
        widthFactor: .68,
        heightFactor: .68,
        child: Image.asset(
          AppAssets.logo,
          fit: BoxFit.contain,
          semanticLabel: 'AARTHA logo',
        ),
      ),
    );
  }
}

/// Logo tile + "AARTHA" wordmark + "FINANCIAL TECHNOLOGY".
class AarthaBrand extends StatelessWidget {
  const AarthaBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AarthaLogoMark(),
        SizedBox(width: 14),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('AARTHA', style: AppTypography.wordmark),
              SizedBox(height: 6),
              Text('FINANCIAL TECHNOLOGY', style: AppTypography.overline),
            ],
          ),
        ),
      ],
    );
  }
}
