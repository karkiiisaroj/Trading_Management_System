import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

import '../widgets/broker_widgets.dart';

/// The broker account is inactive (BR-07, BR-B04): nothing can be managed
/// until an administrator reactivates it.
class BrokerInactiveScreen extends StatelessWidget {
  const BrokerInactiveScreen({super.key, required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return BrokerStatePanel(
      icon: Icons.lock_outline_rounded,
      iconColor: AppColors.warning,
      title: 'Your broker account is inactive',
      message: "You can't manage investors, accounts or orders until an "
          'administrator reactivates your account.',
      actionLabel: 'Sign out',
      secondary: true,
      onAction: onSignOut,
    );
  }
}
