import 'package:flutter/material.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_table.dart';
import '../../widgets/broker_widgets.dart';
import 'broker_order_update_dialog.dart';

/// Orders of the broker's investors. Open orders can have their status
/// updated; final ones open read-only (BR-B14, BR-B15, BR-I29).
class BrokerOrdersScreen extends StatefulWidget {
  const BrokerOrdersScreen({super.key, required this.repository});

  final BrokerRepository repository;

  @override
  State<BrokerOrdersScreen> createState() => _BrokerOrdersScreenState();
}

class _BrokerOrdersScreenState extends State<BrokerOrdersScreen> {
  final GlobalKey<BrokerListPageState<BrokerOrder>> _list =
      GlobalKey<BrokerListPageState<BrokerOrder>>();

  Future<void> _open(BrokerOrder order) async {
    final updated = await showBrokerOrderUpdateDialog(
      context,
      repository: widget.repository,
      order: order,
    );
    if (updated == null || !mounted) return;
    _list.currentState?.reload();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order #${updated.orderNumber} is now ${updated.status.label}.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BrokerListPage<BrokerOrder>(
      key: _list,
      load: widget.repository.orders,
      searchHint: 'Search by order, client or security',
      searchText: (o) => '${o.orderNumber} ${o.clientId} ${o.symbol}',
      loadingLabel: 'Loading orders\u2026',
      errorTitle: "Couldn't load orders",
      emptyIcon: Icons.format_list_bulleted_rounded,
      emptyTitle: 'No orders yet',
      emptyMessage: 'Orders from your assigned investors will appear here.',
      noMatchTitle: 'No orders match your search',
      noMatchMessage: 'Check the order number, client ID or security, or '
          'clear the search.',
      filterLabel: 'Status',
      filterValueOf: (o) => o.status.label,
      columns: [
        BrokerColumn.text('Order', (o) => '#${o.orderNumber}', minWidth: 80),
        BrokerColumn.text('Client ID', (o) => o.clientId),
        BrokerColumn.text('Security', (o) => o.symbol),
        BrokerColumn.text('Type', (o) => o.action, minWidth: 70),
        BrokerColumn.text('Quantity', (o) => '${o.quantity}'),
        BrokerColumn.text('Price', (o) => BrokerFormat.rs(o.price), minWidth: 110),
        BrokerColumn<BrokerOrder>(
          label: 'Status',
          minWidth: 110,
          cell: (o) => BrokerStatusPill.order(o.status),
        ),
        BrokerColumn<BrokerOrder>(
          label: '',
          minWidth: 110,
          cell: (o) => BrokerLink(
            o.status.isFinal ? 'View' : 'Update status',
            onTap: () => _open(o),
          ),
        ),
      ],
    );
  }
}
