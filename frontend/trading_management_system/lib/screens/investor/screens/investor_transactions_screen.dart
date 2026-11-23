import 'package:flutter/material.dart';

class InvestorTransactionsScreen extends StatelessWidget {
  const InvestorTransactionsScreen({super.key});

  static const Color background = Color(0xFF18372B);
  static const Color navColor = Color(0xFF12291F);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color primaryText = Color(0xFFF4F1E9);
  static const Color mutedText = Color(0xFFB5C3B9);
  static const Color positive = Color(0xFF7BE0B0);
  static const Color negative = Color(0xFFFF8A80);

  static const List<Map<String, String>> transactions = [
    {
      'type': 'Buy',
      'symbol': 'ABCD',
      'date': '08 Oct',
      'amount': '− Rs. 15,300.00',
      'status': 'Pending',
    },
    {
      'type': 'Sell',
      'symbol': 'EFGH',
      'date': '07 Oct',
      'amount': '+ Rs. 35,808.00',
      'status': 'Completed',
    },
    {
      'type': 'Buy',
      'symbol': 'IJKL',
      'date': '07 Oct',
      'amount': '− Rs. 9,051.00',
      'status': 'Completed',
    },
    {
      'type': 'Buy',
      'symbol': 'MNOP',
      'date': '06 Oct',
      'amount': '− Rs. 44,200.00',
      'status': 'Completed',
    },
    {
      'type': 'Sell',
      'symbol': 'ABCD',
      'date': '03 Oct',
      'amount': '+ Rs. 21,000.00',
      'status': 'Completed',
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
                          'Transactions',
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
                        'Settlement of your trades',
                        style: TextStyle(fontSize: 13, color: mutedText),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Transaction list
                    ...transactions.map(
                      (transaction) =>
                          _TransactionRow(transaction: transaction),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Sample data',
                      style: TextStyle(fontSize: 11, color: mutedText),
                    ),
                  ],
                ),
              ),
            ),

            const InvestorTransactionsBottomNav(),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// TRANSACTION ROW
// --------------------------------------------------

class _TransactionRow extends StatelessWidget {
  final Map<String, String> transaction;

  const _TransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isPending = transaction['status'] == 'Pending';
    final bool isSell = transaction['type'] == 'Sell';

    final Color amountColor = isSell
        ? InvestorTransactionsScreen.positive
        : InvestorTransactionsScreen.negative;

    final Color statusColor = isPending
        ? InvestorTransactionsScreen.gold
        : InvestorTransactionsScreen.positive;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: InvestorTransactionsScreen.borderColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Transaction information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction['type']} · ${transaction['symbol']}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: InvestorTransactionsScreen.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction['date']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: InvestorTransactionsScreen.mutedText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Amount and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction['amount']!,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 6),
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
                  transaction['status']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
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

class InvestorTransactionsBottomNav extends StatelessWidget {
  const InvestorTransactionsBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: InvestorTransactionsScreen.navColor,
        border: Border(
          top: BorderSide(color: InvestorTransactionsScreen.borderColor),
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
        ? InvestorTransactionsScreen.gold
        : InvestorTransactionsScreen.mutedText;

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
