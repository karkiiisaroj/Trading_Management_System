import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';

/// Historical market data for the broker's securities. Never live
/// (BR-I15, BR-M02): the page says so.
class BrokerMarketScreen extends StatelessWidget {
  const BrokerMarketScreen({super.key, required this.repository});

  final BrokerRepository repository;

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<MarketRow>(
      load: repository.market,
      searchHint: 'Search securities',
      searchText: (r) => r.symbol,
      loadingLabel: 'Loading market data\u2026',
      errorTitle: "Couldn't load market data",
      emptyIcon: Icons.trending_up_rounded,
      emptyTitle: 'No market data yet',
      emptyMessage: 'Historical prices for your securities will appear here.',
      noMatchTitle: 'No securities match your search',
      noMatchMessage: 'Check the symbol or clear the search.',
      filterLabel: 'Date',
      filterValueOf: (r) => r.tradingDate,
      includeAllOption: false,
      footnote: 'Historical data from past trading days. This is not a live '
          'exchange feed.',
      columns: [
        BrokerColumn.text('Security', (r) => r.symbol),
        BrokerColumn.text('Date', (r) => r.date, minWidth: 80),
        BrokerColumn.text('Open', (r) => BrokerFormat.rs(r.open).substring(4), minWidth: 80),
        BrokerColumn.text('High', (r) => BrokerFormat.rs(r.high).substring(4), minWidth: 80),
        BrokerColumn.text('Low', (r) => BrokerFormat.rs(r.low).substring(4), minWidth: 80),
        BrokerColumn.text('Close', (r) => BrokerFormat.rs(r.close).substring(4), minWidth: 80),
        BrokerColumn.text('Volume', (r) => BrokerFormat.integer(r.volume), minWidth: 90),
      ],
    );
  }
}
