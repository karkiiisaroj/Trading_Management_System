import 'package:flutter/material.dart';

class BrokerInvestorsScreen extends StatefulWidget {
  const BrokerInvestorsScreen({
    super.key,
    this.onViewInvestor,
    this.brokerName = '[Broker name]',
    this.profileInitials = 'BR',
  });

  final ValueChanged<BrokerInvestor>? onViewInvestor;
  final String brokerName;
  final String profileInitials;

  @override
  State<BrokerInvestorsScreen> createState() => _BrokerInvestorsScreenState();
}

class _BrokerInvestorsScreenState extends State<BrokerInvestorsScreen> {
  static const Color background = Color(0xFF18372B);
  static const Color card = Color(0xFF1F4435);
  static const Color navigation = Color(0xFF12291F);
  static const Color border = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color primaryText = Color(0xFFF4F1E9);
  static const Color mutedText = Color(0xFFB5C3B9);
  static const Color positive = Color(0xFF7BE0B0);

  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All';

  final List<BrokerInvestor> _investors = [
    BrokerInvestor(
      clientId: 'C001',
      name: 'Sample Investor 1',
      tradingAccount: 'A001',
      holdings: 8,
      status: 'Active',
    ),
    BrokerInvestor(
      clientId: 'C002',
      name: 'Sample Investor 2',
      tradingAccount: 'A002',
      holdings: 5,
      status: 'Active',
    ),
    BrokerInvestor(
      clientId: 'C003',
      name: 'Sample Investor 3',
      tradingAccount: 'A003',
      holdings: 12,
      status: 'Active',
    ),
    BrokerInvestor(
      clientId: 'C004',
      name: 'Sample Investor 4',
      tradingAccount: 'A004',
      holdings: 0,
      status: 'Inactive',
    ),
    BrokerInvestor(
      clientId: 'C005',
      name: 'Sample Investor 5',
      tradingAccount: 'A005',
      holdings: 3,
      status: 'Active',
    ),
    BrokerInvestor(
      clientId: 'C006',
      name: 'Sample Investor 6',
      tradingAccount: 'A006',
      holdings: 7,
      status: 'Active',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BrokerInvestor> get _filteredInvestors {
    final query = _searchController.text.trim().toLowerCase();

    return _investors.where((investor) {
      final matchesSearch =
          investor.clientId.toLowerCase().contains(query) ||
          investor.name.toLowerCase().contains(query);

      final matchesStatus =
          _selectedStatus == 'All' || investor.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 860;

        return Scaffold(
          backgroundColor: background,
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: navigation,
                  foregroundColor: primaryText,
                  title: const Text(
                    'AARTHA',
                    style: TextStyle(
                      color: gold,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          drawer: isDesktop
              ? null
              : Drawer(backgroundColor: navigation, child: _buildSidebar()),
          body: Row(
            children: [
              if (isDesktop) SizedBox(width: 240, child: _buildSidebar()),
              Expanded(child: _buildContent(isDesktop)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: navigation,
        border: Border(right: BorderSide(color: border)),
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
                    color: background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: border),
                  ),
                  child: const Icon(Icons.account_balance, color: gold),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AARTHA',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: primaryText,
                  ),
                ),
              ],
            ),
          ),
          _navItem(Icons.dashboard_outlined, 'Dashboard'),
          _navItem(Icons.people_outline, 'Investors', selected: true),
          _navItem(Icons.work_outline, 'Trading accounts'),
          _navItem(Icons.list_alt, 'Orders'),
          _navItem(Icons.swap_horiz, 'Trades'),
          _navItem(Icons.show_chart, 'Market'),
          _navItem(Icons.layers_outlined, 'Securities'),
          _navItem(Icons.notifications_none, 'Notifications'),
          _navItem(Icons.person_outline, 'Profile'),
          const Spacer(),
          const Divider(color: border),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.brokerName,
                  style: const TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Broker',
                  style: TextStyle(color: mutedText, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (selected) return;

          if (MediaQuery.of(context).size.width <= 860) {
            Navigator.of(context).pop();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label screen will be connected later.')),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: selected ? gold : mutedText),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? gold : mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSearchAndFilter(),
          const SizedBox(height: 16),
          _buildInvestorTable(),
          const SizedBox(height: 14),
          const Text(
            'Sample data',
            style: TextStyle(fontSize: 11, color: mutedText),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assigned investors',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'You see only the investors assigned to you',
                style: TextStyle(fontSize: 14, color: mutedText),
              ),
            ],
          ),
        ),
        _circleIcon(Icons.notifications_none),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: card,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.profileInitials,
            style: const TextStyle(
              color: gold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: card,
        shape: BoxShape.circle,
        border: Border.all(color: border),
      ),
      child: Icon(icon, size: 20, color: primaryText),
    );
  }

  Widget _buildSearchAndFilter() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 420,
          height: 46,
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: primaryText, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search by client ID or name',
              hintStyle: const TextStyle(color: mutedText),
              prefixIcon: const Icon(Icons.search, color: mutedText),
              filled: true,
              fillColor: card,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: gold),
              ),
            ),
          ),
        ),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: card,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              dropdownColor: card,
              style: const TextStyle(color: primaryText, fontSize: 14),
              items: const [
                DropdownMenuItem(value: 'All', child: Text('Status: All')),
                DropdownMenuItem(
                  value: 'Active',
                  child: Text('Status: Active'),
                ),
                DropdownMenuItem(
                  value: 'Inactive',
                  child: Text('Status: Inactive'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvestorTable() {
    final investors = _filteredInvestors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: card,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 850,
            child: Column(
              children: [
                _tableRow(
                  cells: const [
                    'Client ID',
                    'Name',
                    'Trading account',
                    'Holdings',
                    'Status',
                    '',
                  ],
                  isHeader: true,
                ),
                if (investors.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No investors found.',
                      style: TextStyle(color: mutedText),
                    ),
                  )
                else
                  ...investors.map(_investorRow),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _investorRow(BrokerInvestor investor) {
    return _tableRow(
      cells: [
        investor.clientId,
        investor.name,
        investor.tradingAccount,
        investor.holdings.toString(),
        investor.status,
        'View',
      ],
      investor: investor,
    );
  }

  Widget _tableRow({
    required List<String> cells,
    bool isHeader = false,
    BrokerInvestor? investor,
  }) {
    const widths = [110.0, 220.0, 150.0, 100.0, 130.0, 100.0];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: List.generate(cells.length, (index) {
          if (!isHeader && index == 4) {
            return SizedBox(
              width: widths[index],
              child: Align(
                alignment: Alignment.centerLeft,
                child: _statusBadge(cells[index]),
              ),
            );
          }

          if (!isHeader && index == 5) {
            return SizedBox(
              width: widths[index],
              child: TextButton(
                onPressed: investor == null
                    ? null
                    : () => widget.onViewInvestor?.call(investor),
                style: TextButton.styleFrom(
                  foregroundColor: gold,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                child: const Text('View', style: TextStyle(fontSize: 13)),
              ),
            );
          }

          return SizedBox(
            width: widths[index],
            child: Text(
              cells[index],
              style: TextStyle(
                fontSize: isHeader ? 12 : 14,
                color: isHeader ? mutedText : primaryText,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isActive = status == 'Active';
    final color = isActive ? positive : mutedText;

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

class BrokerInvestor {
  final String clientId;
  final String name;
  final String tradingAccount;
  final int holdings;
  final String status;

  const BrokerInvestor({
    required this.clientId,
    required this.name,
    required this.tradingAccount,
    required this.holdings,
    required this.status,
  });
}
