import 'package:flutter/material.dart';

class InvestorMarketScreen extends StatefulWidget {
  const InvestorMarketScreen({super.key});

  @override
  State<InvestorMarketScreen> createState() => _InvestorMarketScreenState();
}

class _InvestorMarketScreenState extends State<InvestorMarketScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const Color background = Color(0xFF18372B);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color navColor = Color(0xFF12291F);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color primaryText = Color(0xFFF4F1E9);
  static const Color mutedText = Color(0xFFB5C3B9);
  static const Color positive = Color(0xFF7BE0B0);
  static const Color negative = Color(0xFFFF8A80);

  final List<Map<String, dynamic>> securities = [
    {
      'symbol': 'ABCD',
      'company': 'Sample Bank Ltd',
      'price': '512.00',
      'change': '1.2%',
      'date': '08 Oct',
      'isPositive': true,
    },
    {
      'symbol': 'EFGH',
      'company': 'Sample Hydropower Ltd',
      'price': '298.40',
      'change': '0.8%',
      'date': '08 Oct',
      'isPositive': false,
    },
    {
      'symbol': 'IJKL',
      'company': 'Sample Insurance Ltd',
      'price': '905.10',
      'change': '2.1%',
      'date': '08 Oct',
      'isPositive': true,
    },
    {
      'symbol': 'MNOP',
      'company': 'Sample Finance Ltd',
      'price': '221.00',
      'change': '0.3%',
      'date': '08 Oct',
      'isPositive': false,
    },
  ];

  List<Map<String, dynamic>> get filteredSecurities {
    final query = _searchController.text.toLowerCase().trim();

    if (query.isEmpty) return securities;

    return securities.where((security) {
      return security['symbol'].toString().toLowerCase().contains(query) ||
          security['company'].toString().toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredSecurities;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Market',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Historical data label
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: gold),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Historical data · not live',
                        style: TextStyle(
                          color: gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Search field
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: cardColor,
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          color: primaryText,
                          fontSize: 14,
                        ),
                        cursorColor: gold,
                        decoration: InputDecoration(
                          hintText: 'Search securities',
                          hintStyle: const TextStyle(
                            color: mutedText,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: mutedText,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: mutedText,
                                    size: 18,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Closing prices by trading date',
                      style: TextStyle(color: mutedText, fontSize: 12),
                    ),

                    const SizedBox(height: 2),

                    // Securities list
                    if (results.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No securities found',
                            style: TextStyle(color: mutedText, fontSize: 14),
                          ),
                        ),
                      )
                    else
                      ...results.map((security) => _buildSecurityRow(security)),

                    const SizedBox(height: 14),

                    const Text(
                      'Sample data',
                      style: TextStyle(color: mutedText, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),

            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityRow(Map<String, dynamic> security) {
    final bool isPositive = security['isPositive'] as bool;
    final Color changeColor = isPositive ? positive : negative;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Company details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  security['symbol'],
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  security['company'],
                  style: const TextStyle(color: mutedText, fontSize: 12),
                ),
              ],
            ),
          ),

          // Price and daily change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${security['price']}',
                style: const TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: changeColor,
                  ),
                  Text(
                    ' ${security['change']}',
                    style: TextStyle(color: changeColor, fontSize: 12),
                  ),
                  const Text(
                    ' · ',
                    style: TextStyle(color: mutedText, fontSize: 12),
                  ),
                  Text(
                    security['date'],
                    style: const TextStyle(color: mutedText, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.pie_chart_outline, 'label': 'Portfolio'},
      {'icon': Icons.trending_up, 'label': 'Market'},
      {'icon': Icons.swap_vert, 'label': 'Trade'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: navColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final bool isSelected = index == 2;
          final Color itemColor = isSelected ? gold : mutedText;

          return Expanded(
            child: InkWell(
              onTap: () {
                if (!isSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${items[index]['label']} screen is not connected yet.',
                      ),
                      backgroundColor: cardColor,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[index]['icon'] as IconData,
                    color: itemColor,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index]['label'] as String,
                    style: TextStyle(
                      color: itemColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
