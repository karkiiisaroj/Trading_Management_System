import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';

/// Stat cards + the latest orders of this broker's investors.
class BrokerDashboardScreen extends StatelessWidget {
  const BrokerDashboardScreen({
    super.key,
    required this.repository,
    required this.onViewOrders,
    required this.onViewActivity,
  });

  final BrokerRepository repository;
  final VoidCallback onViewOrders;
  final VoidCallback onViewActivity;

  @override
  Widget build(BuildContext context) {
    return BrokerFutureBuilder<DashboardSummary>(
      load: repository.dashboard,
      loadingLabel: 'Loading dashboard\u2026',
      errorTitle: "Couldn't load the dashboard",
      builder: (context, d) {
        final stats = <(String, int)>[
          ('Assigned investors', d.assignedInvestors),
          ('Trading accounts', d.tradingAccounts),
          ('Pending orders', d.pendingOrders),
          ('Assigned securities', d.assignedSecurities),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, box) {
                const gap = 16.0;
                final perRow = box.maxWidth >= 900
                    ? 4
                    : box.maxWidth >= 480
                        ? 2
                        : 1;
                final width = (box.maxWidth - gap * (perRow - 1)) / perRow;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final s in stats)
                      SizedBox(
                        width: width,
                        child: BrokerStatCard(
                          label: s.$1,
                          value: s.$2.toString(),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            BrokerDataTable<BrokerOrder>(
              title: 'Recent orders',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrokerLink('Activity history', onTap: onViewActivity),
                  const SizedBox(width: 16),
                  BrokerLink('View all', onTap: onViewOrders),
                ],
              ),
              rows: d.recentOrders,
              columns: [
                BrokerColumn.text('Client ID', (o) => o.clientId),
                BrokerColumn.text('Security', (o) => o.symbol),
                BrokerColumn.text('Type', (o) => o.action, minWidth: 70),
                BrokerColumn.text('Quantity', (o) => '${o.quantity}'),
                BrokerColumn.text(
                  'Price',
                  (o) => BrokerFormat.rs(o.price),
                  minWidth: 110,
                ),
                BrokerColumn<BrokerOrder>(
                  label: 'Status',
                  minWidth: 110,
                  cell: (o) => BrokerStatusPill.order(o.status),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
