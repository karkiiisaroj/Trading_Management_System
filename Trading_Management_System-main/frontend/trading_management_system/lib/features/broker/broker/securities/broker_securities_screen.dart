import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';

/// Securities assigned to this broker (BR-B19, BR-B22).
class BrokerSecuritiesScreen extends StatelessWidget {
  const BrokerSecuritiesScreen({super.key, required this.repository});

  final BrokerRepository repository;

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<BrokerSecurity>(
      load: repository.securities,
      searchHint: 'Search by symbol or company',
      searchText: (s) => '${s.symbol} ${s.company}',
      loadingLabel: 'Loading securities\u2026',
      errorTitle: "Couldn't load securities",
      emptyIcon: Icons.layers_outlined,
      emptyTitle: 'No securities assigned yet',
      emptyMessage: 'Securities assigned to you by an administrator will '
          'appear here.',
      noMatchTitle: 'No securities match your search',
      noMatchMessage: 'Check the symbol or company, or clear the search.',
      filterLabel: 'Type',
      filterValueOf: (s) => s.type,
      columns: [
        BrokerColumn.text('Symbol', (s) => s.symbol, minWidth: 80),
        BrokerColumn.text('Company', (s) => s.company, flex: 2, minWidth: 160),
        BrokerColumn.text('Type', (s) => s.type, minWidth: 80),
        BrokerColumn.text('ISIN', (s) => s.isin, flex: 2, minWidth: 130),
        BrokerColumn.text('Last close', (s) => BrokerFormat.rs(s.lastClose), minWidth: 110),
        BrokerColumn<BrokerSecurity>(
          label: 'Status',
          minWidth: 100,
          cell: (s) => BrokerStatusPill.active(s.isActive),
        ),
      ],
    );
  }
}
