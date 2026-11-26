import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';

/// Assigned investors only (BR-B05). Tap a row for details.
class BrokerInvestorsScreen extends StatelessWidget {
  const BrokerInvestorsScreen({
    super.key,
    required this.repository,
    required this.onOpenInvestor,
  });

  final BrokerRepository repository;
  final ValueChanged<String> onOpenInvestor;

  static final RegExp _clientIdPattern = RegExp(r'^[Cc]\d{3,}$');

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<BrokerInvestor>(
      load: repository.investors,
      searchHint: 'Search by client ID or name',
      searchText: (i) => '${i.clientId} ${i.name}',
      loadingLabel: 'Loading investors\u2026',
      errorTitle: "Couldn't load investors",
      emptyIcon: Icons.people_outline_rounded,
      emptyTitle: 'No investors assigned yet',
      emptyMessage: 'Investors assigned to you by an administrator will '
          'appear here.',
      noMatchTitle: 'No investors match your search',
      noMatchMessage: 'Check the client ID or name, or clear the search to '
          'see all assigned investors.',
      filterLabel: 'Status',
      filterValueOf: (i) => i.isActive ? 'Active' : 'Inactive',
      onRowTap: (i) => onOpenInvestor(i.clientId),
      // Pressing Enter on a client ID that is not in the list asks the
      // backend for it. For an unassigned investor the backend answers 403,
      // which shows the "no access" state (BR-B09).
      onSearchSubmitted: (query, visible) {
        if (visible == 0 && _clientIdPattern.hasMatch(query)) {
          onOpenInvestor(query.toUpperCase());
        }
      },
      columns: [
        BrokerColumn.text('Client ID', (i) => i.clientId),
        BrokerColumn.text('Name', (i) => i.name, flex: 2, minWidth: 150),
        BrokerColumn.text('Trading account', (i) => i.accountNumber, minWidth: 120),
        BrokerColumn.text('Holdings', (i) => '${i.holdingsCount}'),
        BrokerColumn<BrokerInvestor>(
          label: 'Status',
          minWidth: 100,
          cell: (i) => BrokerStatusPill.active(i.isActive),
        ),
        BrokerColumn<BrokerInvestor>(
          label: '',
          minWidth: 60,
          cell: (i) => BrokerLink('View', onTap: () => onOpenInvestor(i.clientId)),
        ),
      ],
    );
  }
}
