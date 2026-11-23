import 'package:flutter/material.dart';
import 'investor_ipo_apply_screen.dart';

class InvestorIpoScreen extends StatefulWidget {
  const InvestorIpoScreen({super.key});

  @override
  State<InvestorIpoScreen> createState() => _InvestorIpoScreenState();
}

class _InvestorIpoScreenState extends State<InvestorIpoScreen> {
  String selectedFilter = 'Open';

  static const Color background = Color(0xFF18372B);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color navColor = Color(0xFF12291F);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color primaryText = Color(0xFFF4F1E9);
  static const Color mutedText = Color(0xFFB5C3B9);
  static const Color positive = Color(0xFF7BE0B0);

  final List<Map<String, String>> ipoList = [
    {
      'name': 'Sample Bank IPO',
      'symbol': 'ABCD',
      'status': 'Open',
      'price': 'Rs. 100.00',
      'units': '10 to 100',
      'opens': '12 Oct',
      'closes': '16 Oct',
    },
    {
      'name': 'Sample Hydropower IPO',
      'symbol': 'EFGH',
      'status': 'Upcoming',
      'price': 'Rs. 100.00',
      'units': '10 to 100',
      'opens': '25 Oct',
      'closes': '29 Oct',
    },
  ];

  List<Map<String, String>> get filteredIpos {
    return ipoList.where((ipo) => ipo['status'] == selectedFilter).toList();
  }

  void _showApplyDialog(String ipoName) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: borderColor),
          ),
          title: const Text(
            'Apply for IPO',
            style: TextStyle(color: primaryText, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'You selected $ipoName.\n\nIPO application functionality will be connected to your backend later.',
            style: const TextStyle(color: mutedText, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close', style: TextStyle(color: gold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 14),
                        _buildFilters(),
                        const SizedBox(height: 10),
                        ...filteredIpos.map(
                          (ipo) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildIpoCard(ipo),
                          ),
                        ),
                        if (filteredIpos.isEmpty) _buildEmptyState(),
                        const SizedBox(height: 4),
                        const Text(
                          'Sample data',
                          style: TextStyle(fontSize: 11, color: mutedText),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const InvestorIpoBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.chevron_left,
                color: primaryText,
                size: 28,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 34, minHeight: 44),
            ),
            const SizedBox(width: 4),
            const Text(
              'IPO',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: primaryText,
                height: 1.1,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 34),
          child: Text(
            'Public offerings',
            style: TextStyle(fontSize: 13, color: mutedText),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    const filters = ['Open', 'Upcoming', 'Closed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? gold : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: isSelected ? gold : borderColor),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? navColor : primaryText,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIpoCard(Map<String, String> ipo) {
    final isOpen = ipo['status'] == 'Open';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  ipo['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: isOpen ? positive : gold),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  ipo['status']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isOpen ? positive : gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            ipo['symbol']!,
            style: const TextStyle(fontSize: 12, color: mutedText),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildDetail('Price per unit', ipo['price']!)),
              Expanded(
                child: _buildDetail(
                  'Units per applicant',
                  ipo['units']!,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Opens ${ipo['opens']} · Closes ${ipo['closes']}',
            style: const TextStyle(fontSize: 12, color: mutedText),
          ),
          if (isOpen) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InvestorIpoApplyScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: navColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(fontSize: 12, color: mutedText),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 32, color: mutedText),
          SizedBox(height: 10),
          Text(
            'No IPOs available',
            style: TextStyle(
              color: primaryText,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'There are no offerings in this category right now.',
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Bottom navigation matching the supplied HTML.
// Navigation destinations can be connected when the other screens are ready.

class InvestorIpoBottomNav extends StatelessWidget {
  const InvestorIpoBottomNav({super.key});

  static const Color navColor = Color(0xFF12291F);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color mutedText = Color(0xFFB5C3B9);

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, 'Home'),
      (Icons.pie_chart_outline, 'Portfolio'),
      (Icons.show_chart, 'Market'),
      (Icons.swap_vert, 'Trade'),
      (Icons.more_horiz, 'More'),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: navColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: items.map((item) {
          final isSelected = item.$2 == 'More';
          final color = isSelected ? gold : mutedText;

          return Expanded(
            child: InkWell(
              onTap: () {
                // Connect navigation destinations here later.
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.$1, size: 22, color: color),
                  const SizedBox(height: 4),
                  Text(
                    item.$2,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
