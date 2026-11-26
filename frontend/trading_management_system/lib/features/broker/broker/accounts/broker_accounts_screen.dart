import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';

/// Trading accounts of the broker's investors (BR-B10).
class BrokerAccountsScreen extends StatelessWidget {
  const BrokerAccountsScreen({
    super.key,
    required this.repository,
    required this.onOpenInvestor,
  });

  final BrokerRepository repository;
  final ValueChanged<String> onOpenInvestor;

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<BrokerAccount>(
      load: repository.accounts,
      searchHint: 'Search by account or client ID',
      searchText: (a) => '${a.accountNumber} ${a.clientId} ${a.investorName}',
      loadingLabel: 'Loading trading accounts\u2026',
      errorTitle: "Couldn't load trading accounts",
      emptyIcon: Icons.work_outline_rounded,
      emptyTitle: 'No trading accounts yet',
      emptyMessage: 'Accounts of your assigned investors will appear here.',
      noMatchTitle: 'No accounts match your search',
      noMatchMessage: 'Check the account number or client ID, or clear the '
          'search.',
      filterLabel: 'Status',
      filterValueOf: (a) => a.isActive ? 'Active' : 'Inactive',
      onRowTap: (a) => onOpenInvestor(a.clientId),
      columns: [
        BrokerColumn.text('Account no.', (a) => a.accountNumber),
        BrokerColumn.text('Investor', (a) => a.investorName, flex: 2, minWidth: 150),
        BrokerColumn.text('Client ID', (a) => a.clientId),
        BrokerColumn.text('Open orders', (a) => '${a.openOrders}', minWidth: 100),
        BrokerColumn<BrokerAccount>(
          label: 'Status',
          minWidth: 100,
          cell: (a) => BrokerStatusPill.active(a.isActive),
        ),
        BrokerColumn<BrokerAccount>(
          label: '',
          minWidth: 60,
          cell: (a) => BrokerLink('View', onTap: () => onOpenInvestor(a.clientId)),
        ),
      ],
    );
  }
}
