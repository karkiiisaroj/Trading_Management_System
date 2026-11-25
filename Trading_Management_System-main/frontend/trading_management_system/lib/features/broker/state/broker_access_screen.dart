import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

import '../widgets/broker_widgets.dart';

/// 403 state: the investor is not assigned to this broker (BR-B05, BR-B09).
///
/// This is the page body only; [BrokerFlow] puts it inside the shared
/// [BrokerShell] (sidebar + header), as in the design.
class BrokerAccessScreen extends StatelessWidget {
  const BrokerAccessScreen({super.key, required this.onBackToInvestors});

  final VoidCallback onBackToInvestors;

  @override
  Widget build(BuildContext context) {
    return BrokerStatePanel(
      icon: Icons.block_rounded,
      iconColor: AppColors.loss,
      title: "You don't have access to this investor",
      message: 'You can only view investors assigned to your broker account. '
          'If you think this is a mistake, contact your administrator.',
      actionLabel: 'Back to investors',
      onAction: onBackToInvestors,
    );
  }
}
