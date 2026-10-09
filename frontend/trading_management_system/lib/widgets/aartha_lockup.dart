import 'package:flutter/material.dart';

import '../theme/aartha_theme.dart';

/// Logo tile + "AARTHA / FINANCIAL TECHNOLOGY" lockup.
class AarthaLockup extends StatelessWidget {
  const AarthaLockup({super.key, this.markSize = 52});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: markSize,
          height: markSize,
          decoration: BoxDecoration(
            color: AarthaColors.forestDeep,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AarthaColors.outline),
          ),
          padding: EdgeInsets.all(markSize * 0.16),
          child: Image.asset(
            AarthaAssets.logo,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            semanticLabel: 'AARTHA logo',
          ),
        ),
        const SizedBox(width: 14),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AARTHA', style: AarthaType.wordmark(24)),
              const SizedBox(height: 6),
              const Text(
                'FINANCIAL TECHNOLOGY',
                style: AarthaType.caps,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
