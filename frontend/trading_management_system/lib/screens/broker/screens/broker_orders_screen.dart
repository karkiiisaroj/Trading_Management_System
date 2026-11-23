import 'package:flutter/material.dart';

const Color _background = Color(0xFF18372B);
const Color _card = Color(0xFF1F4435);
const Color _navigation = Color(0xFF12291F);
const Color _border = Color(0xFF34584A);
const Color _gold = Color(0xFFC4A76C);
const Color _primaryText = Color(0xFFF4F1E9);
const Color _mutedText = Color(0xFFB5C3B9);
const Color _positive = Color(0xFF7BE0B0);

class BrokerOrdersScreen extends StatefulWidget {
  const BrokerOrdersScreen({super.key});

  @override
  State<BrokerOrdersScreen> createState() => _BrokerOrdersScreenState();
}

class _BrokerOrdersScreenState extends State<BrokerOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  final List<_Order> _orders = [
    _Order(
      order: '#1042',
      clientId: 'C001',
      security: 'ABCD',
      type: 'Buy',
      quantity: '50',
      price: 'Rs. 512.00',
      status: 'Pending',
    ),
    _Order(
      order: '#1041',
      clientId: 'C002',
      security: 'EFGH',
      type: 'Sell',
      quantity: '120',
      price: 'Rs. 298.40',
      status: 'Filled',
    ),
    _Order(
      order: '#1040',
      clientId: 'C001',
      security: 'IJKL',
      type: 'Buy',
      quantity: '30',
      price: 'Rs. 905.10',
      status: 'Partial',
    ),
    _Order(
      order: '#1039',
      clientId: 'C003',
      security: 'MNOP',
      type: 'Buy',
      quantity: '200',
      price: 'Rs. 221.00',
      status: 'Cancelled',
    ),
    _Order(
      order: '#1038',
      clientId: 'C005',
      security: 'ABCD',
      type: 'Sell',
      quantity: '10',
      price: 'Rs. 512.00',
      status: 'Pending',
    ),
    _Order(
      order: '#1037',
      clientId: 'C002',
      security: 'IJKL',
      type: 'Buy',
      quantity: '15',
      price: 'Rs. 905.10',
      status: 'Filled',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Order> get _filteredOrders {
    final query = _searchController.text.trim().toLowerCase();
    return _orders.where((order) {
      final matchesQuery =
          query.isEmpty ||
          order.order.toLowerCase().contains(query) ||
          order.clientId.toLowerCase().contains(query) ||
          order.security.toLowerCase().contains(query);
      final matchesStatus =
          _selectedStatus == 'All' || order.status == _selectedStatus;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 860;
        return Scaffold(
          backgroundColor: _background,
          drawer: isMobile
              ? Drawer(
                  backgroundColor: _navigation,
                  child: SafeArea(
                    child: _buildSidebar(context, inDrawer: true),
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isMobile)
                SizedBox(width: 240, child: _buildSidebar(context)),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      if (isMobile)
                        _buildMobileBar(context)
                      else
                        const SizedBox.shrink(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 18 : 40,
                            vertical: 28,
                          ),
                          child: _buildContent(isMobile),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, {bool inDrawer = false}) {
    final navItems = [
      _NavItem('Dashboard', Icons.grid_view_rounded),
      _NavItem('Investors', Icons.people_outline),
      _NavItem('Trading accounts', Icons.account_balance_wallet_outlined),
      _NavItem('Orders', Icons.format_list_bulleted, active: true),
      _NavItem('Trades', Icons.sync_alt),
      _NavItem('Market', Icons.show_chart),
      _NavItem('Securities', Icons.layers_outlined),
      _NavItem('Notifications', Icons.notifications_none),
      _NavItem('Profile', Icons.person_outline),
    ];

    return Container(
      color: _navigation,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _background,
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance, color: _gold),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AARTHA',
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
          ...navItems.map((item) {
            final active = item.active;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (inDrawer) Navigator.of(context).pop();
                  if (!active) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item.label} screen is not connected here yet.',
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: active ? _card : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: active ? _gold : _mutedText,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: active ? _gold : _mutedText,
                          fontSize: 14,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          const Divider(color: _border),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[Broker name]',
                  style: TextStyle(
                    color: _primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Broker',
                  style: TextStyle(color: _mutedText, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: _navigation,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Builder(
            builder: (drawerContext) => IconButton(
              onPressed: () => Scaffold.of(drawerContext).openDrawer(),
              icon: const Icon(Icons.menu, color: _primaryText),
            ),
          ),
          const Text(
            'AARTHA',
            style: TextStyle(
              color: _primaryText,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            backgroundColor: _card,
            child: Text('BR', style: TextStyle(color: _gold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    final orders = _filteredOrders;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: TextStyle(
                      color: _primaryText,
                      fontSize: isMobile ? 30 : 34,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Monitor and manage orders from your investors',
                    style: TextStyle(color: _mutedText, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (!isMobile) ...[
              _roundIcon(Icons.notifications_none),
              const SizedBox(width: 12),
              _roundAvatar(),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: isMobile ? double.infinity : 420,
              height: 46,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: _primaryText, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by order, client or security',
                  hintStyle: const TextStyle(color: _mutedText, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: _mutedText,
                    size: 19,
                  ),
                  filled: true,
                  fillColor: _card,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _gold),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isMobile ? double.infinity : 190,
              height: 46,
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                dropdownColor: _card,
                style: const TextStyle(color: _primaryText, fontSize: 14),
                iconEnabledColor: _mutedText,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: const TextStyle(color: _mutedText),
                  filled: true,
                  fillColor: _card,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _gold),
                  ),
                ),
                items:
                    const ['All', 'Pending', 'Filled', 'Partial', 'Cancelled']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedStatus = value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _card,
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: orders.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(
                    child: Text(
                      'No orders found.',
                      style: TextStyle(color: _mutedText),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 900),
                    child: Column(
                      children: [
                        _buildTableHeader(),
                        ...orders.map((order) => _buildOrderRow(order)),
                      ],
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Sample data',
          style: TextStyle(color: _mutedText, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return const _OrderGrid(
      isHeader: true,
      cells: [
        'Order',
        'Client ID',
        'Security',
        'Type',
        'Quantity',
        'Price',
        'Status',
        '',
      ],
    );
  }

  Widget _buildOrderRow(_Order order) {
    return _OrderGrid(
      cells: [
        order.order,
        order.clientId,
        order.security,
        order.type,
        order.quantity,
        order.price,
        null,
        null,
      ],
      status: order.status,
      onAction: () => _showOrderDialog(order),
      actionLabel: order.status == 'Filled' || order.status == 'Cancelled'
          ? 'View'
          : 'Update status',
    );
  }

  Future<void> _showOrderDialog(_Order order) async {
    if (order.status == 'Filled' || order.status == 'Cancelled') {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: _navigation,
          title: Text(
            'Order ${order.order}',
            style: const TextStyle(color: _primaryText),
          ),
          content: Text(
            '${order.type} ${order.quantity} units of ${order.security} for ${order.price}.\n\nClient: ${order.clientId}\nStatus: ${order.status}',
            style: const TextStyle(color: _mutedText, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close', style: TextStyle(color: _gold)),
            ),
          ],
        ),
      );
      return;
    }

    String newStatus = order.status;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _navigation,
          title: Text(
            'Update ${order.order}',
            style: const TextStyle(color: _primaryText),
          ),
          content: DropdownButtonFormField<String>(
            value: newStatus,
            dropdownColor: _card,
            style: const TextStyle(color: _primaryText),
            decoration: const InputDecoration(
              labelText: 'Order status',
              labelStyle: TextStyle(color: _mutedText),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _border),
              ),
            ),
            items: const ['Pending', 'Partial', 'Filled', 'Cancelled']
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setDialogState(() => newStatus = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: _mutedText)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: _navigation,
              ),
              onPressed: () {
                setState(() => order.status = newStatus);
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _card,
        shape: BoxShape.circle,
        border: Border.all(color: _border),
      ),
      child: Icon(icon, color: _primaryText, size: 20),
    );
  }

  Widget _roundAvatar() {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _card,
        shape: BoxShape.circle,
        border: Border.all(color: _border),
      ),
      child: const Text(
        'BR',
        style: TextStyle(color: _gold, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _OrderGrid extends StatelessWidget {
  const _OrderGrid({
    this.isHeader = false,
    required this.cells,
    this.status,
    this.actionLabel,
    this.onAction,
  });

  final bool isHeader;
  final List<String?> cells;
  final String? status;
  final String? actionLabel;
  final VoidCallback? onAction;

  static const List<double> _widths = [90, 100, 110, 75, 85, 120, 100, 140];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _border.withOpacity(0.9))),
      ),
      child: Row(
        children: List.generate(cells.length, (index) {
          Widget child;
          if (index == 6 && !isHeader && status != null) {
            child = _StatusPill(status: status!);
          } else if (index == 7 && !isHeader) {
            child = Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: _gold,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          } else {
            child = Text(
              cells[index] ?? '',
              style: TextStyle(
                color: isHeader ? _mutedText : _primaryText,
                fontSize: isHeader ? 12 : 14,
                fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
              ),
            );
          }
          return SizedBox(width: _widths[index], child: child);
        }),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color color = status == 'Filled'
        ? _positive
        : status == 'Cancelled'
        ? _mutedText
        : _gold;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _Order {
  _Order({
    required this.order,
    required this.clientId,
    required this.security,
    required this.type,
    required this.quantity,
    required this.price,
    required this.status,
  });

  final String order;
  final String clientId;
  final String security;
  final String type;
  final String quantity;
  final String price;
  String status;
}

class _NavItem {
  const _NavItem(this.label, this.icon, {this.active = false});

  final String label;
  final IconData icon;
  final bool active;
}
