import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_widgets.dart';

/// The broker's own account (BR-B02).
class BrokerProfileScreen extends StatelessWidget {
  const BrokerProfileScreen({
    super.key,
    required this.repository,
    required this.onSignOut,
  });

  final BrokerRepository repository;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return BrokerFutureBuilder<BrokerProfile>(
      load: repository.profile,
      loadingLabel: 'Loading profile\u2026',
      errorTitle: "Couldn't load your profile",
      builder: (context, p) {
        return Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: BrokerCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      BrokerAvatar(name: p.name),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: AppTypography.heading),
                            const SizedBox(height: 4),
                            Text(
                              'Broker code ${p.brokerCode}',
                              style: AppTypography.caption.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BrokerKeyValueRow(label: 'Username', value: p.username),
                  BrokerKeyValueRow(label: 'Email', value: p.email),
                  BrokerKeyValueRow(label: 'Phone', value: p.phone),
                  BrokerKeyValueRow(
                    label: 'Assigned investors',
                    value: '${p.assignedInvestors}',
                    showDivider: false,
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, box) {
                      final change = AarthaButton(
                        label: 'Change password',
                        variant: AarthaButtonVariant.secondary,
                        // TODO: call the backend password-change endpoint.
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Password changes are handled by your '
                              'administrator.',
                            ),
                          ),
                        ),
                      );
                      final out = AarthaButton(
                        label: 'Sign out',
                        variant: AarthaButtonVariant.destructive,
                        onPressed: onSignOut,
                      );
                      if (box.maxWidth < 420) {
                        return Column(
                          children: [change, const SizedBox(height: 12), out],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: change),
                          const SizedBox(width: 12),
                          Expanded(child: out),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
