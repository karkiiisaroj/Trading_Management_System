import 'package:flutter/material.dart';

class _BrokerColors {
  static const background = Color(0xFF18372B);
  static const card = Color(0xFF1F4435);
  static const navigation = Color(0xFF12291F);
  static const border = Color(0xFF34584A);
  static const gold = Color(0xFFC4A76C);
  static const primaryText = Color(0xFFF4F1E9);
  static const mutedText = Color(0xFFB5C3B9);
  static const positive = Color(0xFF7BE0B0);
}

class BrokerDashboardScreen extends StatelessWidget {
  const BrokerDashboardScreen({super.key});

  static const List<_BrokerOrder> _orders = [
    _BrokerOrder(
      clientId: 'C001',
      security: 'ABCD',
      type: 'Buy',
      quantity: '50',
      price: 'Rs. 512.00',
      status: 'Pending',
    ),
    _BrokerOrder(
      clientId: 'C002',
      security: 'EFGH',
      type: 'Sell',
      quantity: '120',
      price: 'Rs. 298.40',
      status: 'Filled',
    ),
    _BrokerOrder(
      clientId: 'C001',
      security: 'IJKL',
      type: 'Buy',
      quantity: '30',
      price: 'Rs. 905.10',
      status: 'Filled',
    ),
    _BrokerOrder(
      clientId: 'C004',
      security: 'MNOP',
      type: 'Buy',
      quantity: '200',
      price: 'Rs. 221.00',
      status: 'Cancelled',
    ),
    _BrokerOrder(
      clientId: 'C003',
      security: 'ABCD',
      type: 'Sell',
      quantity: '10',
      price: 'Rs. 512.00',
      status: 'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 860;

        return Scaffold(
          backgroundColor: _BrokerColors.background,
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: _BrokerColors.navigation,
                  foregroundColor: _BrokerColors.primaryText,
                  title: const Text(
                    'AARTHA',
                    style: TextStyle(
                      color: _BrokerColors.gold,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => _showMessage(
                        context,
                        'Notifications will be available soon.',
                      ),
                      icon: const Icon(Icons.notifications_none),
                    ),
                  ],
                ),
          drawer: isDesktop
              ? null
              : Drawer(
                  backgroundColor: _BrokerColors.navigation,
                  child: _buildSidebar(context),
                ),
          body: Row(
            children: [
              if (isDesktop)
                SizedBox(width: 240, child: _buildSidebar(context)),
              Expanded(child: _buildDashboardContent(context, isDesktop)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _BrokerColors.navigation,
        border: Border(right: BorderSide(color: _BrokerColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _BrokerColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _BrokerColors.border),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: _BrokerColors.gold,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AARTHA',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: _BrokerColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          _navItem(
            context,
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            selected: true,
          ),
          _navItem(context, icon: Icons.people_outline, label: 'Investors'),
          _navItem(
            context,
            icon: Icons.work_outline,
            label: 'Trading accounts',
          ),
          _navItem(context, icon: Icons.list_alt, label: 'Orders'),
          _navItem(context, icon: Icons.swap_horiz, label: 'Trades'),
          _navItem(context, icon: Icons.show_chart, label: 'Market'),
          _navItem(context, icon: Icons.layers_outlined, label: 'Securities'),
          _navItem(
            context,
            icon: Icons.notifications_none,
            label: 'Notifications',
          ),
          _navItem(context, icon: Icons.person_outline, label: 'Profile'),
          const Spacer(),
          const Divider(color: _BrokerColors.border),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[Broker name]',
                  style: TextStyle(
                    color: _BrokerColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Broker',
                  style: TextStyle(
                    color: _BrokerColors.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (Scaffold.of(context).isDrawerOpen) {
            Navigator.pop(context);
          }

          if (!selected) {
            _showMessage(context, '$label screen will be connected later.');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? _BrokerColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? _BrokerColors.gold : _BrokerColors.mutedText,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? _BrokerColors.gold
                      : _BrokerColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, bool isDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 28),
          _buildSummaryCards(context),
          const SizedBox(height: 24),
          _buildRecentOrders(context),
          const SizedBox(height: 14),
          const Text(
            'Sample data',
            style: TextStyle(fontSize: 11, color: _BrokerColors.mutedText),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Broker dashboard',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: _BrokerColors.primaryText,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Overview of your assigned investors',
                style: TextStyle(fontSize: 14, color: _BrokerColors.mutedText),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _circleIcon(
          icon: Icons.notifications_none,
          onTap: () =>
              _showMessage(context, 'Notifications will be available soon.'),
        ),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _BrokerColors.card,
            shape: BoxShape.circle,
            border: Border.all(color: _BrokerColors.border),
          ),
          alignment: Alignment.center,
          child: const Text(
            'BR',
            style: TextStyle(
              color: _BrokerColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _BrokerColors.card,
          shape: BoxShape.circle,
          border: Border.all(color: _BrokerColors.border),
        ),
        child: Icon(icon, color: _BrokerColors.primaryText, size: 20),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1000
            ? 4
            : constraints.maxWidth > 550
            ? 2
            : 2;

        final cardWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _summaryCard(
              width: cardWidth,
              label: 'Assigned investors',
              value: '24',
            ),
            _summaryCard(
              width: cardWidth,
              label: 'Trading accounts',
              value: '31',
            ),
            _summaryCard(width: cardWidth, label: 'Pending orders', value: '6'),
            _summaryCard(
              width: cardWidth,
              label: 'Assigned securities',
              value: '18',
            ),
          ],
        );
      },
    );
  }

  Widget _summaryCard({
    required double width,
    required String label,
    required String value,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _BrokerColors.card,
        border: Border.all(color: _BrokerColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: _BrokerColors.mutedText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: _BrokerColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _BrokerColors.card,
        border: Border.all(color: _BrokerColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent orders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _BrokerColors.primaryText,
                  ),
                ),
                InkWell(
                  onTap: () => _showMessage(
                    context,
                    'All orders screen will be connected later.',
                  ),
                  child: const Text(
                    'View all',
                    style: TextStyle(fontSize: 13, color: _BrokerColors.gold),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 760,
              child: Column(
                children: [
                  _buildTableHeader(),
                  ..._orders.map((order) => _buildOrderRow(order)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return const _OrderTableRow(
      isHeader: true,
      cells: ['Client ID', 'Security', 'Type', 'Quantity', 'Price', 'Status'],
    );
  }

  Widget _buildOrderRow(_BrokerOrder order) {
    return _OrderTableRow(
      cells: [
        order.clientId,
        order.security,
        order.type,
        order.quantity,
        order.price,
        order.status,
      ],
      status: order.status,
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _BrokerOrder {
  final String clientId;
  final String security;
  final String type;
  final String quantity;
  final String price;
  final String status;

  const _BrokerOrder({
    required this.clientId,
    required this.security,
    required this.type,
    required this.quantity,
    required this.price,
    required this.status,
  });
}

class _OrderTableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;
  final String? status;

  const _OrderTableRow({
    required this.cells,
    this.isHeader = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    const widths = [110.0, 130.0, 90.0, 100.0, 140.0, 110.0];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _BrokerColors.border)),
      ),
      child: Row(
        children: List.generate(cells.length, (index) {
          if (index == 5 && !isHeader) {
            return SizedBox(
              width: widths[index],
              child: Align(
                alignment: Alignment.centerLeft,
                child: _StatusBadge(status: status ?? ''),
              ),
            );
          }

          return SizedBox(
            width: widths[index],
            child: Text(
              cells[index],
              style: TextStyle(
                fontSize: isHeader ? 12 : 14,
                color: isHeader
                    ? _BrokerColors.mutedText
                    : _BrokerColors.primaryText,
                fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case 'Filled':
        color = _BrokerColors.positive;
        break;
      case 'Pending':
        color = _BrokerColors.gold;
        break;
      default:
        color = _BrokerColors.mutedText;
    }

    return Container(
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
    );
  }
}
