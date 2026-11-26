import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';

/// Recent actions on the broker's investors' accounts.
class BrokerActivityScreen extends StatelessWidget {
  const BrokerActivityScreen({super.key, required this.repository});

  final BrokerRepository repository;

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<BrokerActivity>(
      load: repository.activity,
      searchHint: 'Search activity',
      searchText: (a) => '${a.action} ${a.clientId} ${a.details}',
      loadingLabel: 'Loading activity\u2026',
      errorTitle: "Couldn't load activity",
      emptyIcon: Icons.history_rounded,
      emptyTitle: 'No activity yet',
      emptyMessage: 'Actions on your investors\u2019 accounts will appear here.',
      noMatchTitle: 'No activity matches your search',
      noMatchMessage: 'Try another word, or clear the search.',
      filterLabel: 'Type',
      filterValueOf: (a) => a.action,
      columns: [
        BrokerColumn.text('Time', (a) => a.time, minWidth: 90),
        BrokerColumn.text('Action', (a) => a.action, flex: 2, minWidth: 140),
        BrokerColumn.text('Client ID', (a) => a.clientId),
        BrokerColumn.text('Details', (a) => a.details, flex: 4, minWidth: 260),
      ],
    );
  }
}
