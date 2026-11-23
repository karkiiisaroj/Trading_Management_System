import 'package:flutter/material.dart';

class InvestorTradesScreen extends StatelessWidget {
  const InvestorTradesScreen({super.key});

  static const Color background = Color(0xFF18372B);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color navColor = Color(0xFF12291F);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color primaryText = Color(0xFFF4F1E9);
  static const Color mutedText = Color(0xFFB5C3B9);
  static const Color positive = Color(0xFF7BE0B0);

  static const List<Map<String, String>> trades = [
    {
      'symbol': 'ABCD',
      'type': 'Buy',
      'status': 'Executed',
      'quantity': '30 units at Rs. 510.00',
      'date': '08 Oct',
    },
    {
      'symbol': 'EFGH',
      'type': 'Sell',
      'status': 'Executed',
      'quantity': '120 units at Rs. 298.40',
      'date': '07 Oct',
    },
    {
      'symbol': 'IJKL',
      'type': 'Buy',
      'status': 'Partial',
      'quantity': '10 of 30 units at Rs. 905.10',
      'date': '07 Oct',
    },
    {
      'symbol': 'MNOP',
      'type': 'Buy',
      'status': 'Executed',
      'quantity': '200 units at Rs. 221.00',
      'date': '06 Oct',
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
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 34,
                            minHeight: 44,
                          ),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryText,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Trades',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: primaryText,
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 34, top: 2),
                      child: Text(
                        'Executed trades',
                        style: TextStyle(fontSize: 13, color: mutedText),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Trade list
                    ...trades.map(
                      (trade) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _TradeCard(trade: trade),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Sample data',
                      style: TextStyle(fontSize: 11, color: mutedText),
                    ),
                  ],
                ),
              ),
            ),

            const InvestorTradesBottomNav(),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// TRADE CARD
// --------------------------------------------------

class _TradeCard extends StatelessWidget {
  final Map<String, String> trade;

  const _TradeCard({required this.trade});

  @override
  Widget build(BuildContext context) {
    final bool isPartial = trade['status'] == 'Partial';

    final Color statusColor = isPartial
        ? InvestorTradesScreen.gold
        : InvestorTradesScreen.positive;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: InvestorTradesScreen.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: InvestorTradesScreen.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${trade['symbol']} · ${trade['type']}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: InvestorTradesScreen.primaryText,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: statusColor),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  trade['status']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  trade['quantity']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: InvestorTradesScreen.mutedText,
                  ),
                ),
              ),
              Text(
                trade['date']!,
                style: const TextStyle(
                  fontSize: 12,
                  color: InvestorTradesScreen.mutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// BOTTOM NAVIGATION
// --------------------------------------------------

class InvestorTradesBottomNav extends StatelessWidget {
  const InvestorTradesBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: InvestorTradesScreen.navColor,
        border: Border(
          top: BorderSide(color: InvestorTradesScreen.borderColor),
        ),
      ),
      child: Row(
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home', onTap: () {}),
          _NavItem(
            icon: Icons.pie_chart_outline,
            label: 'Portfolio',
            onTap: () {},
          ),
          _NavItem(icon: Icons.show_chart, label: 'Market', onTap: () {}),
          _NavItem(icon: Icons.swap_vert, label: 'Trade', onTap: () {}),
          _NavItem(
            icon: Icons.more_horiz,
            label: 'More',
            selected: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? InvestorTradesScreen.gold
        : InvestorTradesScreen.mutedText;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
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
  }
}
