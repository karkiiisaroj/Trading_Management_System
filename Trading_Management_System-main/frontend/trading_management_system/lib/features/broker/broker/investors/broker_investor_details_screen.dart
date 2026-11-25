import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';

/// One assigned investor: profile, holdings, recent orders (BR-B17).
///
/// If the investor is not assigned to this broker the backend answers with
/// [BrokerAccessDenied]; [onAccessDenied] lets the flow swap in the
/// "no access" state (BR-B09).
class BrokerInvestorDetailsScreen extends StatelessWidget {
  const BrokerInvestorDetailsScreen({
    super.key,
    required this.repository,
    required this.clientId,
    required this.onAccessDenied,
  });

  final BrokerRepository repository;
  final String clientId;
  final VoidCallback onAccessDenied;

  @override
  Widget build(BuildContext context) {
    return BrokerFutureBuilder<InvestorDetails>(
      load: () => repository.investorDetails(clientId),
      loadingLabel: 'Loading investor\u2026',
      errorTitle: "Couldn't load this investor",
      errorBuilder: (context, error) {
        if (error is BrokerAccessDenied) {
          WidgetsBinding.instance.addPostFrameCallback((_) => onAccessDenied());
          return const SizedBox.shrink();
        }
        return null;
      },
      builder: (context, d) {
        final profile = _ProfileCard(investor: d.investor);
        final stats = Row(
          children: [
            Expanded(
              child: BrokerStatCard(
                compact: true,
                label: 'Portfolio value',
                value: BrokerFormat.rsCompact(d.portfolioValue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BrokerStatCard(
                compact: true,
                label: 'Holdings',
                value: '${d.holdings.length}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BrokerStatCard(
                compact: true,
                label: 'Open orders',
                value: '${d.openOrders}',
              ),
            ),
          ],
        );
        final holdings = _holdingsTable(d.holdings);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, box) {
                if (box.maxWidth >= 1000) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [profile, const SizedBox(height: 12), stats],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(child: holdings),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    profile,
                    const SizedBox(height: 12),
                    stats,
                    const SizedBox(height: 24),
                    holdings,
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            if (d.recentOrders.isEmpty)
              const BrokerStatePanel(
                icon: Icons.format_list_bulleted_rounded,
                title: 'No orders yet',
                message: 'Orders from this investor will appear here.',
              )
            else
              BrokerDataTable<BrokerOrder>(
                title: 'Recent orders',
                rows: d.recentOrders,
                columns: [
                  BrokerColumn.text('Order', (o) => '#${o.orderNumber}', minWidth: 80),
                  BrokerColumn.text('Security', (o) => o.symbol),
                  BrokerColumn.text('Type', (o) => o.action, minWidth: 70),
                  BrokerColumn.text('Quantity', (o) => '${o.quantity}'),
                  BrokerColumn.text('Price', (o) => BrokerFormat.rs(o.price), minWidth: 110),
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

  Widget _holdingsTable(List<BrokerHolding> holdings) {
    if (holdings.isEmpty) {
      return const BrokerStatePanel(
        icon: Icons.pie_chart_outline_rounded,
        title: 'No holdings',
        message: 'This investor does not hold any securities yet.',
      );
    }
    return BrokerDataTable<BrokerHolding>(
      title: 'Holdings',
      rows: holdings,
      columns: [
        BrokerColumn.text('Security', (h) => h.symbol),
        BrokerColumn.text('Quantity', (h) => '${h.quantity}'),
        BrokerColumn.text('Avg cost', (h) => BrokerFormat.rs(h.averageCost), minWidth: 110),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.investor});

  final BrokerInvestor investor;

  @override
  Widget build(BuildContext context) {
    return BrokerCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              BrokerAvatar(name: investor.name),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(investor.name, style: AppTypography.heading),
                    const SizedBox(height: 4),
                    Text(
                      'Client ID ${investor.clientId}',
                      style: AppTypography.caption.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    BrokerStatusPill.active(investor.isActive),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BrokerKeyValueRow(label: 'Email', value: investor.email),
          BrokerKeyValueRow(label: 'Phone', value: investor.phone),
          BrokerKeyValueRow(label: 'Trading account', value: investor.accountNumber),
          BrokerKeyValueRow(
            label: 'Assigned since',
            value: investor.assignedSince,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
