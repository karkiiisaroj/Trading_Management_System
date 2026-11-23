import 'package:flutter/material.dart';

class _BrokerDetailsColors {
  static const background = Color(0xFF18372B);
  static const card = Color(0xFF1F4435);
  static const navigation = Color(0xFF12291F);
  static const border = Color(0xFF34584A);
  static const gold = Color(0xFFC4A76C);
  static const primaryText = Color(0xFFF4F1E9);
  static const mutedText = Color(0xFFB5C3B9);
  static const positive = Color(0xFF7BE0B0);
}

class BrokerInvestorDetailsScreen extends StatelessWidget {
  const BrokerInvestorDetailsScreen({super.key});

  static const List<_Holding> holdings = [
    _Holding('ABCD', '50', 'Rs. 420.00'),
    _Holding('EFGH', '120', 'Rs. 310.50'),
    _Holding('IJKL', '30', 'Rs. 890.00'),
    _Holding('MNOP', '200', 'Rs. 215.25'),
  ];

  static const List<_InvestorOrder> orders = [
    _InvestorOrder(
      order: '#1042',
      security: 'ABCD',
      type: 'Buy',
      quantity: '50',
      price: 'Rs. 512.00',
      status: 'Pending',
    ),
    _InvestorOrder(
      order: '#1040',
      security: 'IJKL',
      type: 'Buy',
      quantity: '30',
      price: 'Rs. 905.10',
      status: 'Partial',
    ),
    _InvestorOrder(
      order: '#1033',
      security: 'EFGH',
      type: 'Sell',
      quantity: '20',
      price: 'Rs. 301.00',
      status: 'Filled',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 860;

        return Scaffold(
          backgroundColor: _BrokerDetailsColors.background,
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: _BrokerDetailsColors.navigation,
                  foregroundColor: _BrokerDetailsColors.primaryText,
                  title: const Text(
                    'AARTHA',
                    style: TextStyle(
                      color: _BrokerDetailsColors.gold,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          drawer: isDesktop
              ? null
              : Drawer(
                  backgroundColor: _BrokerDetailsColors.navigation,
                  child: _buildSidebar(context),
                ),
          body: Row(
            children: [
              if (isDesktop)
                SizedBox(width: 240, child: _buildSidebar(context)),
              Expanded(child: _buildContent(context, isDesktop)),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // Sidebar
  // ------------------------------------------------------------

  Widget _buildSidebar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: _BrokerDetailsColors.navigation,
        border: Border(right: BorderSide(color: _BrokerDetailsColors.border)),
      ),
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
                    color: _BrokerDetailsColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _BrokerDetailsColors.border),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: _BrokerDetailsColors.gold,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AARTHA',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: _BrokerDetailsColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          _navItem(context, Icons.dashboard_outlined, 'Dashboard'),
          _navItem(context, Icons.people_outline, 'Investors', selected: true),
          _navItem(context, Icons.work_outline, 'Trading accounts'),
          _navItem(context, Icons.list_alt, 'Orders'),
          _navItem(context, Icons.swap_horiz, 'Trades'),
          _navItem(context, Icons.show_chart, 'Market'),
          _navItem(context, Icons.layers_outlined, 'Securities'),
          _navItem(context, Icons.notifications_none, 'Notifications'),
          _navItem(context, Icons.person_outline, 'Profile'),
          const Spacer(),
          const Divider(color: _BrokerDetailsColors.border),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[Broker name]',
                  style: TextStyle(
                    color: _BrokerDetailsColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Broker',
                  style: TextStyle(
                    color: _BrokerDetailsColors.mutedText,
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
    BuildContext context,
    IconData icon,
    String label, {
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
            color: selected ? _BrokerDetailsColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? _BrokerDetailsColors.gold
                    : _BrokerDetailsColors.mutedText,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: selected
                      ? _BrokerDetailsColors.gold
                      : _BrokerDetailsColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Main content
  // ------------------------------------------------------------

  Widget _buildContent(BuildContext context, bool isDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),

          // Investor profile and holdings
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 760) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildInvestorColumn()),
                    const SizedBox(width: 16),
                    Expanded(flex: 5, child: _buildHoldings()),
                  ],
                );
              }

              return Column(
                children: [
                  _buildInvestorColumn(),
                  const SizedBox(height: 16),
                  _buildHoldings(),
                ],
              );
            },
          ),

          const SizedBox(height: 16),
          _buildRecentOrders(),
          const SizedBox(height: 14),
          const Text(
            'Sample data',
            style: TextStyle(
              fontSize: 11,
              color: _BrokerDetailsColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.maybePop(context),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: _BrokerDetailsColors.gold,
                      ),
                      Text(
                        'Investors',
                        style: TextStyle(
                          color: _BrokerDetailsColors.gold,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                'Investor details',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: _BrokerDetailsColors.primaryText,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Assigned investor',
                style: TextStyle(
                  fontSize: 14,
                  color: _BrokerDetailsColors.mutedText,
                ),
              ),
            ],
          ),
        ),
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
            color: _BrokerDetailsColors.card,
            shape: BoxShape.circle,
            border: Border.all(color: _BrokerDetailsColors.border),
          ),
          alignment: Alignment.center,
          child: const Text(
            'BR',
            style: TextStyle(
              color: _BrokerDetailsColors.gold,
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
          color: _BrokerDetailsColors.card,
          shape: BoxShape.circle,
          border: Border.all(color: _BrokerDetailsColors.border),
        ),
        child: Icon(icon, size: 20, color: _BrokerDetailsColors.primaryText),
      ),
    );
  }

  // ------------------------------------------------------------
  // Investor profile and summary
  // ------------------------------------------------------------

  Widget _buildInvestorColumn() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _BrokerDetailsColors.navigation,
                      shape: BoxShape.circle,
                      border: Border.all(color: _BrokerDetailsColors.border),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'IN',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: _BrokerDetailsColors.gold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[Investor name]',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: _BrokerDetailsColors.primaryText,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Client ID C001',
                          style: TextStyle(
                            fontSize: 13,
                            color: _BrokerDetailsColors.mutedText,
                          ),
                        ),
                        SizedBox(height: 8),
                        _ActiveBadge(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _DetailRow(label: 'Email', value: '[email]'),
              const _DetailRow(label: 'Phone', value: '[phone]'),
              const _DetailRow(label: 'Trading account', value: 'A001'),
              const _DetailRow(
                label: 'Assigned since',
                value: '[date]',
                showDivider: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - 24) / 3;

            return Row(
              children: [
                SizedBox(
                  width: width,
                  child: _metricCard('Portfolio value', 'Rs. 1.25M'),
                ),
                const SizedBox(width: 12),
                SizedBox(width: width, child: _metricCard('Holdings', '8')),
                const SizedBox(width: 12),
                SizedBox(width: width, child: _metricCard('Open orders', '2')),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _metricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _BrokerDetailsColors.mutedText,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _BrokerDetailsColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Holdings
  // ------------------------------------------------------------

  Widget _buildHoldings() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Text(
              'Holdings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _BrokerDetailsColors.primaryText,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 420,
              child: Column(
                children: [
                  const _HoldingTableRow(
                    cells: ['Security', 'Quantity', 'Avg cost'],
                    isHeader: true,
                  ),
                  ...holdings.map(
                    (holding) => _HoldingTableRow(
                      cells: [
                        holding.security,
                        holding.quantity,
                        holding.avgCost,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Recent orders
  // ------------------------------------------------------------

  Widget _buildRecentOrders() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Text(
              'Recent orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _BrokerDetailsColors.primaryText,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 760,
              child: Column(
                children: [
                  const _OrderTableRow(
                    cells: [
                      'Order',
                      'Security',
                      'Type',
                      'Quantity',
                      'Price',
                      'Status',
                    ],
                    isHeader: true,
                  ),
                  ...orders.map(
                    (order) => _OrderTableRow(
                      cells: [
                        order.order,
                        order.security,
                        order.type,
                        order.quantity,
                        order.price,
                        order.status,
                      ],
                      status: order.status,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: _BrokerDetailsColors.card,
      border: Border.all(color: _BrokerDetailsColors.border),
      borderRadius: BorderRadius.circular(18),
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

// ------------------------------------------------------------
// Supporting widgets
// ------------------------------------------------------------

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _BrokerDetailsColors.positive),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Active',
        style: TextStyle(
          color: _BrokerDetailsColors.positive,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _DetailRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: _BrokerDetailsColors.border),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _BrokerDetailsColors.mutedText,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: _BrokerDetailsColors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Holding {
  final String security;
  final String quantity;
  final String avgCost;

  const _Holding(this.security, this.quantity, this.avgCost);
}

class _InvestorOrder {
  final String order;
  final String security;
  final String type;
  final String quantity;
  final String price;
  final String status;

  const _InvestorOrder({
    required this.order,
    required this.security,
    required this.type,
    required this.quantity,
    required this.price,
    required this.status,
  });
}

class _HoldingTableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;

  const _HoldingTableRow({required this.cells, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    const widths = [140.0, 130.0, 150.0];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _BrokerDetailsColors.border)),
      ),
      child: Row(
        children: List.generate(
          cells.length,
          (index) => SizedBox(
            width: widths[index],
            child: Text(
              cells[index],
              style: TextStyle(
                fontSize: isHeader ? 12 : 14,
                color: isHeader
                    ? _BrokerDetailsColors.mutedText
                    : _BrokerDetailsColors.primaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
        border: Border(bottom: BorderSide(color: _BrokerDetailsColors.border)),
      ),
      child: Row(
        children: List.generate(cells.length, (index) {
          if (index == 5 && !isHeader) {
            return SizedBox(
              width: widths[index],
              child: Align(
                alignment: Alignment.centerLeft,
                child: _OrderStatusBadge(status: status ?? ''),
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
                    ? _BrokerDetailsColors.mutedText
                    : _BrokerDetailsColors.primaryText,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OrderStatusBadge extends StatelessWidget {
  final String status;

  const _OrderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;

    switch (status) {
      case 'Filled':
        color = _BrokerDetailsColors.positive;
        break;
      case 'Pending':
      case 'Partial':
        color = _BrokerDetailsColors.gold;
        break;
      default:
        color = _BrokerDetailsColors.mutedText;
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
