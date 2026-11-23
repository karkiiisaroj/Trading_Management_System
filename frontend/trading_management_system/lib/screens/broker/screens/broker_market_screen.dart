import 'package:flutter/material.dart';

class _MarketColors {
  static const background = Color(0xFF18372B);
  static const card = Color(0xFF1F4435);
  static const navigation = Color(0xFF12291F);
  static const border = Color(0xFF34584A);
  static const gold = Color(0xFFC4A76C);
  static const primaryText = Color(0xFFF4F1E9);
  static const mutedText = Color(0xFFB5C3B9);
}

class BrokerMarketScreen extends StatefulWidget {
  const BrokerMarketScreen({
    super.key,
    this.brokerName = '[Broker name]',
    this.profileInitials = 'BR',
  });

  final String brokerName;
  final String profileInitials;

  @override
  State<BrokerMarketScreen> createState() => _BrokerMarketScreenState();
}

class _BrokerMarketScreenState extends State<BrokerMarketScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const List<_MarketRecord> _marketRecords = [
    _MarketRecord(
      security: 'ABCD',
      date: '08 Oct',
      open: '506.00',
      high: '515.00',
      low: '503.50',
      close: '512.00',
      volume: '12,400',
    ),
    _MarketRecord(
      security: 'EFGH',
      date: '08 Oct',
      open: '300.80',
      high: '302.00',
      low: '296.10',
      close: '298.40',
      volume: '31,250',
    ),
    _MarketRecord(
      security: 'IJKL',
      date: '08 Oct',
      open: '886.50',
      high: '909.00',
      low: '884.00',
      close: '905.10',
      volume: '4,980',
    ),
    _MarketRecord(
      security: 'MNOP',
      date: '08 Oct',
      open: '221.70',
      high: '223.00',
      low: '219.50',
      close: '221.00',
      volume: '58,100',
    ),
    _MarketRecord(
      security: 'QRST',
      date: '08 Oct',
      open: '147.00',
      high: '150.40',
      low: '146.20',
      close: '149.80',
      volume: '22,760',
    ),
  ];

  List<_MarketRecord> get _filteredRecords {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _marketRecords;

    return _marketRecords
        .where((record) => record.security.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 860;

        return Scaffold(
          backgroundColor: _MarketColors.background,
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: _MarketColors.navigation,
                  foregroundColor: _MarketColors.primaryText,
                  title: const Text(
                    'AARTHA',
                    style: TextStyle(
                      color: _MarketColors.gold,
                      fontFamily: 'Georgia',
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          drawer: isDesktop
              ? null
              : Drawer(
                  backgroundColor: _MarketColors.navigation,
                  child: Builder(
                    builder: (drawerContext) =>
                        _buildSidebar(drawerContext, closeDrawer: true),
                  ),
                ),
          body: Row(
            children: [
              if (isDesktop)
                SizedBox(width: 240, child: _buildSidebar(context)),
              Expanded(child: _buildContent(isDesktop)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, {bool closeDrawer = false}) {
    return Container(
      color: _MarketColors.navigation,
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
                    color: _MarketColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _MarketColors.border),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: _MarketColors.gold,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AARTHA',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: _MarketColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          _navItem(
            context,
            Icons.dashboard_outlined,
            'Dashboard',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.people_outline,
            'Investors',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.work_outline,
            'Trading accounts',
            closeDrawer: closeDrawer,
          ),
          _navItem(context, Icons.list_alt, 'Orders', closeDrawer: closeDrawer),
          _navItem(
            context,
            Icons.swap_horiz,
            'Trades',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.show_chart,
            'Market',
            selected: true,
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.layers_outlined,
            'Securities',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.notifications_none,
            'Notifications',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.person_outline,
            'Profile',
            closeDrawer: closeDrawer,
          ),
          const Spacer(),
          const Divider(color: _MarketColors.border),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.brokerName,
                  style: const TextStyle(
                    color: _MarketColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Broker',
                  style: TextStyle(
                    color: _MarketColors.mutedText,
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
    bool closeDrawer = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (closeDrawer) Navigator.of(context).pop();

          if (!selected) {
            ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(content: Text('$label screen will be connected later.')),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? _MarketColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? _MarketColors.gold : _MarketColors.mutedText,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: selected
                      ? _MarketColors.gold
                      : _MarketColors.mutedText,
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
          _buildFilters(),
          const SizedBox(height: 16),
          _buildMarketTable(),
          const SizedBox(height: 14),
          const Text(
            'Sample data',
            style: TextStyle(fontSize: 11, color: _MarketColors.mutedText),
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
                'Market',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: _MarketColors.primaryText,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Historical market data. Not live.',
                style: TextStyle(fontSize: 14, color: _MarketColors.mutedText),
              ),
            ],
          ),
        ),
        _circleIcon(
          icon: Icons.notifications_none,
          onTap: () => _showMessage('Notifications will be available soon.'),
        ),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _MarketColors.card,
            shape: BoxShape.circle,
            border: Border.all(color: _MarketColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.profileInitials,
            style: const TextStyle(
              color: _MarketColors.gold,
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
          color: _MarketColors.card,
          shape: BoxShape.circle,
          border: Border.all(color: _MarketColors.border),
        ),
        child: Icon(icon, size: 20, color: _MarketColors.primaryText),
      ),
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        Container(
          width: 420,
          constraints: const BoxConstraints(maxWidth: double.infinity),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _MarketColors.card,
            border: Border.all(color: _MarketColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                size: 18,
                color: _MarketColors.mutedText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    color: _MarketColors.primaryText,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search securities',
                    hintStyle: TextStyle(
                      color: _MarketColors.mutedText,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  tooltip: 'Clear search',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.close,
                    size: 17,
                    color: _MarketColors.mutedText,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
            ],
          ),
        ),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _MarketColors.card,
            border: Border.all(color: _MarketColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Date: 08 Oct 2026',
            style: TextStyle(color: _MarketColors.primaryText, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketTable() {
    final records = _filteredRecords;

    return Container(
      decoration: BoxDecoration(
        color: _MarketColors.card,
        border: Border.all(color: _MarketColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 900,
            child: Column(
              children: [
                const _MarketTableRow(
                  cells: [
                    'Security',
                    'Date',
                    'Open',
                    'High',
                    'Low',
                    'Close',
                    'Volume',
                  ],
                  isHeader: true,
                ),
                if (records.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No securities found.',
                      style: TextStyle(color: _MarketColors.mutedText),
                    ),
                  )
                else
                  ...records.map(
                    (record) => _MarketTableRow(
                      cells: [
                        record.security,
                        record.date,
                        record.open,
                        record.high,
                        record.low,
                        record.close,
                        record.volume,
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MarketRecord {
  final String security;
  final String date;
  final String open;
  final String high;
  final String low;
  final String close;
  final String volume;

  const _MarketRecord({
    required this.security,
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class _MarketTableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;

  const _MarketTableRow({required this.cells, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    const widths = [140.0, 120.0, 110.0, 110.0, 110.0, 110.0, 130.0];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _MarketColors.border)),
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
                    ? _MarketColors.mutedText
                    : _MarketColors.primaryText,
                fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
