import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';

/// Settlement records, one per trade (BR-I34).
class BrokerTransactionsScreen extends StatelessWidget {
  const BrokerTransactionsScreen({super.key, required this.repository});

  final BrokerRepository repository;

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<BrokerTransaction>(
      load: repository.transactions,
      searchHint: 'Search by transaction, client or security',
      searchText: (t) => '${t.transactionNumber} ${t.tradeNumber} ${t.clientId} ${t.symbol}',
      loadingLabel: 'Loading transactions\u2026',
      errorTitle: "Couldn't load transactions",
      emptyIcon: Icons.receipt_long_outlined,
      emptyTitle: 'No transactions yet',
      emptyMessage: 'Settlement records appear here once trades are recorded.',
      noMatchTitle: 'No transactions match your search',
      noMatchMessage: 'Check the transaction, client ID or security, or clear '
          'the search.',
      filterLabel: 'Status',
      filterValueOf: (t) => t.statusLabel,
      columns: [
        BrokerColumn.text('Transaction', (t) => '#${t.transactionNumber}', minWidth: 100),
        BrokerColumn.text('Trade', (t) => t.tradeNumber, minWidth: 80),
        BrokerColumn.text('Client ID', (t) => t.clientId),
        BrokerColumn.text('Security', (t) => t.symbol),
        BrokerColumn.text('Type', (t) => t.typeLabel, minWidth: 70),
        BrokerColumn.text(
          'Amount',
          (t) => BrokerFormat.signedRs(t.amount),
          flex: 2,
          minWidth: 140,
        ),
        BrokerColumn<BrokerTransaction>(
          label: 'Status',
          minWidth: 110,
          cell: (t) => BrokerStatusPill(
            t.statusLabel,
            tone: t.isCompleted ? PillTone.good : PillTone.warn,
          ),
        ),
        BrokerColumn.text('Date', (t) => t.date, minWidth: 80),
      ],
    );
  }
}
