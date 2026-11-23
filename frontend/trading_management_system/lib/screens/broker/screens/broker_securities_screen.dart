import 'package:flutter/material.dart';

class SecuritiesScreen extends StatefulWidget {
  const SecuritiesScreen({super.key});

  @override
  State<SecuritiesScreen> createState() => _SecuritiesScreenState();
}

class _SecuritiesScreenState extends State<SecuritiesScreen> {
  static const Color bg = Color(0xFF18372B);
  static const Color sidebarBg = Color(0xFF12291F);
  static const Color cardBg = Color(0xFF1F4435);
  static const Color border = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color muted = Color(0xFFB5C3B9);
  static const Color cream = Color(0xFFF4F1E9);
  static const Color activeGreen = Color(0xFF7BE0B0);

  static const String fontFamily = 'AARTHA';

  final TextEditingController searchController = TextEditingController();

  String selectedType = 'All';

  final List<Map<String, String>> securities = [
    {
      'symbol': 'ABCD',
      'company': 'Sample Bank Ltd',
      'type': 'Equity',
      'isin': 'INE000000001',
      'price': 'Rs. 512.00',
      'status': 'Active',
    },
    {
      'symbol': 'EFGH',
      'company': 'Sample Hydropower Ltd',
      'type': 'Equity',
      'isin': 'INE000000002',
      'price': 'Rs. 298.40',
      'status': 'Active',
    },
    {
      'symbol': 'IJKL',
      'company': 'Sample Insurance Ltd',
      'type': 'Equity',
      'isin': 'INE000000003',
      'price': 'Rs. 905.10',
      'status': 'Active',
    },
    {
      'symbol': 'MNOP',
      'company': 'Sample Finance Ltd',
      'type': 'Equity',
      'isin': 'INE000000004',
      'price': 'Rs. 221.00',
      'status': 'Active',
    },
    {
      'symbol': 'QRST',
      'company': 'Sample Hotels Ltd',
      'type': 'Equity',
      'isin': 'INE000000005',
      'price': 'Rs. 149.80',
      'status': 'Inactive',
    },
  ];

  TextStyle get body => const TextStyle(fontFamily: fontFamily, color: cream);

  TextStyle get heading => const TextStyle(
    fontFamily: fontFamily,
    color: cream,
    fontWeight: FontWeight.w600,
  );

  List<Map<String, String>> get filteredSecurities {
    final query = searchController.text.toLowerCase();

    return securities.where((security) {
      final matchesSearch =
          security['symbol']!.toLowerCase().contains(query) ||
          security['company']!.toLowerCase().contains(query);

      final matchesType =
          selectedType == 'All' || security['type'] == selectedType;

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 860;

          return Row(
            children: [
              if (isDesktop) const SecuritiesSidebar(),

              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 20,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(),
                        const SizedBox(height: 24),
                        _filters(),
                        const SizedBox(height: 16),
                        _securitiesTable(),
                        const SizedBox(height: 14),
                        Text(
                          'Sample data',
                          style: body.copyWith(color: muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // HEADER

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Securities',
              style: heading.copyWith(fontSize: 34, height: 1.1),
            ),
            const SizedBox(height: 4),
            Text(
              'Securities assigned to you',
              style: body.copyWith(fontSize: 14, color: muted),
            ),
          ],
        ),
        Row(
          children: [
            _circleButton(
              const Icon(Icons.notifications_none, color: cream, size: 20),
            ),
            const SizedBox(width: 12),
            _circleButton(
              Text(
                'BR',
                style: body.copyWith(
                  color: gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _circleButton(Widget child) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cardBg,
        shape: BoxShape.circle,
        border: Border.all(color: border),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  // SEARCH AND FILTER

  Widget _filters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 420,
          height: 46,
          child: TextField(
            controller: searchController,
            style: body.copyWith(fontSize: 14),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by symbol or company',
              hintStyle: body.copyWith(color: muted, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: muted, size: 20),
              filled: true,
              fillColor: cardBg,
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
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedType,
              dropdownColor: sidebarBg,
              icon: const Icon(Icons.keyboard_arrow_down, color: muted),
              style: body.copyWith(fontSize: 14),
              items: ['All', 'Equity']
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text('Type: $type'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // SECURITIES TABLE

  Widget _securitiesTable() {
    const double minTableWidth = 900;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: minTableWidth,
            child: Column(
              children: [
                _tableHeader(),

                if (filteredSecurities.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No securities found',
                      style: body.copyWith(color: muted),
                    ),
                  )
                else
                  ...filteredSecurities.map((security) => _tableRow(security)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          _column('Symbol', 1, header: true),
          _column('Company', 2, header: true),
          _column('Type', 1, header: true),
          _column('ISIN', 2, header: true),
          _column('Last close', 1, header: true),
          _column('Status', 1, header: true),
        ],
      ),
    );
  }

  Widget _tableRow(Map<String, String> security) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          _column(security['symbol']!, 1),
          _column(security['company']!, 2),
          _column(security['type']!, 1),
          _column(security['isin']!, 2),
          _column(security['price']!, 1),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _statusBadge(security['status']!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _column(String text, int flex, {bool header = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: body.copyWith(
          fontSize: header ? 12 : 14,
          color: header ? muted : cream,
          fontWeight: header ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
    );
  }

  // STATUS BADGE

  Widget _statusBadge(String status) {
    final bool active = status == 'Active';
    final Color statusColor = active ? activeGreen : muted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: body.copyWith(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// SIDEBAR

class SecuritiesSidebar extends StatelessWidget {
  const SecuritiesSidebar({super.key});

  static const Color sidebarBg = Color(0xFF12291F);
  static const Color cardBg = Color(0xFF1F4435);
  static const Color border = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color muted = Color(0xFFB5C3B9);
  static const Color cream = Color(0xFFF4F1E9);

  static const String fontFamily = 'AARTHA';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: sidebarBg,
        border: Border(right: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _logo(),
          const SizedBox(height: 4),

          _navItem(Icons.home_outlined, 'Dashboard'),
          _navItem(Icons.people_outline, 'Investors'),
          _navItem(Icons.work_outline, 'Trading accounts'),
          _navItem(Icons.list, 'Orders'),
          _navItem(Icons.sync, 'Trades'),
          _navItem(Icons.trending_up, 'Market'),
          _navItem(Icons.layers_outlined, 'Securities', active: true),
          _navItem(Icons.notifications_none, 'Notifications'),
          _navItem(Icons.person_outline, 'Profile'),

          const Spacer(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 14, left: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '[Broker name]',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: cream,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Broker',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // LOGO

  Widget _logo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 24),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF18372B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Image.asset('assets/aartha_logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          const Text(
            'AARTHA',
            style: TextStyle(
              fontFamily: fontFamily,
              color: cream,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }

  // NAVIGATION ITEMS

  Widget _navItem(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: active ? cardBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Icon(icon, size: 20, color: active ? gold : muted),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ).copyWith(color: active ? gold : muted),
        ),
        onTap: () {},
      ),
    );
  }
}
