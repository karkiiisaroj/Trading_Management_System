import 'package:flutter/material.dart';

class InvestorPortfolioScreen extends StatelessWidget {
  const InvestorPortfolioScreen({super.key});

  static const Color background = Color(0xFF18372B);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color navColor = Color(0xFF12291F);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color primaryText = Color(0xFFF4F1E9);
  static const Color mutedText = Color(0xFFB5C3B9);
  static const Color positive = Color(0xFF7BE0B0);

  static const List<Map<String, String>> holdings = [
    {
      'symbol': 'ABCD',
      'company': 'Sample Bank Ltd',
      'quantity': '50 units',
      'averageCost': 'Avg Rs. 420.00',
    },
    {
      'symbol': 'EFGH',
      'company': 'Sample Hydropower Ltd',
      'quantity': '120 units',
      'averageCost': 'Avg Rs. 310.50',
    },
    {
      'symbol': 'IJKL',
      'company': 'Sample Insurance Ltd',
      'quantity': '30 units',
      'averageCost': 'Avg Rs. 890.00',
    },
    {
      'symbol': 'MNOP',
      'company': 'Sample Finance Ltd',
      'quantity': '200 units',
      'averageCost': 'Avg Rs. 215.25',
    },
  ];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page heading
                    const Text(
                      'Portfolio',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      'Your holdings',
                      style: TextStyle(color: mutedText, fontSize: 13),
                    ),

                    const SizedBox(height: 18),

                    // Portfolio summary card
                    _buildPortfolioSummary(),

                    const SizedBox(height: 22),

                    // Holdings column headings
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SECURITY',
                          style: TextStyle(
                            color: mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          'QUANTITY / AVG COST',
                          style: TextStyle(
                            color: mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Holdings list
                    ...holdings.map((holding) => _buildHoldingRow(holding)),

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

  Widget _buildPortfolioSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total portfolio value
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total value',
                style: TextStyle(color: mutedText, fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                'Rs. 1,245,000',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Portfolio gain
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Gain', style: TextStyle(color: mutedText, fontSize: 12)),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_upward, color: positive, size: 15),
                  Text(
                    ' 5.5%',
                    style: TextStyle(
                      color: positive,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingRow(Map<String, String> holding) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Security details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding['symbol']!,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  holding['company']!,
                  style: const TextStyle(color: mutedText, fontSize: 12),
                ),
              ],
            ),
          ),

          // Quantity and average cost
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                holding['quantity']!,
                style: const TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                holding['averageCost']!,
                style: const TextStyle(color: mutedText, fontSize: 12),
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
          final bool isSelected = index == 1;
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
