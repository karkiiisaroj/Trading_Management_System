import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';

/// Trades generated from the broker's investors' orders (BR-B16).
class BrokerTradesScreen extends StatelessWidget {
  const BrokerTradesScreen({super.key, required this.repository});

  final BrokerRepository repository;

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<BrokerTrade>(
      load: repository.trades,
      searchHint: 'Search by trade, order or client',
      searchText: (t) => '${t.tradeNumber} ${t.orderNumber} ${t.clientId} ${t.symbol}',
      loadingLabel: 'Loading trades\u2026',
      errorTitle: "Couldn't load trades",
      emptyIcon: Icons.sync_alt_rounded,
      emptyTitle: 'No trades yet',
      emptyMessage: 'Trades appear here once your investors\u2019 orders are '
          'executed.',
      noMatchTitle: 'No trades match your search',
      noMatchMessage: 'Check the trade, order or client ID, or clear the '
          'search.',
      filterLabel: 'Date',
      filterValueOf: (t) => t.date,
      columns: [
        BrokerColumn.text('Trade', (t) => t.tradeNumber, minWidth: 80),
        BrokerColumn.text('Order', (t) => '#${t.orderNumber}', minWidth: 80),
        BrokerColumn.text('Client ID', (t) => t.clientId),
        BrokerColumn.text('Security', (t) => t.symbol),
        BrokerColumn.text('Quantity', (t) => '${t.quantity}'),
        BrokerColumn.text('Execution price', (t) => BrokerFormat.rs(t.price), minWidth: 120),
        BrokerColumn<BrokerTrade>(
          label: 'Status',
          minWidth: 110,
          cell: (t) => BrokerStatusPill.order(t.status),
        ),
        BrokerColumn.text('Executed on', (t) => t.date, minWidth: 100),
      ],
    );
  }
}
