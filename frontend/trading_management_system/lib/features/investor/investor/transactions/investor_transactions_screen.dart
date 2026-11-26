import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/animations.dart';

class InvestorTransactionsScreen extends StatelessWidget {
  const InvestorTransactionsScreen({
    super.key,
    this.onBack,
    this.onDestinationSelected,
  });

  final VoidCallback? onBack;
  final ValueChanged<int>? onDestinationSelected;


  static const List<_TransactionRecord> _transactions = [
    _TransactionRecord(
      type: 'Buy',
      symbol: 'ABCD',
      date: '08 Oct',
      amount: '15,300.00',
      isCredit: false,
      status: 'Pending',
    ),
    _TransactionRecord(
      type: 'Sell',
      symbol: 'EFGH',
      date: '07 Oct',
      amount: '35,808.00',
      isCredit: true,
      status: 'Completed',
    ),
    _TransactionRecord(
      type: 'Buy',
      symbol: 'IJKL',
      date: '07 Oct',
      amount: '9,051.00',
      isCredit: false,
      status: 'Completed',
    ),
    _TransactionRecord(
      type: 'Buy',
      symbol: 'MNOP',
      date: '06 Oct',
      amount: '44,200.00',
      isCredit: false,
      status: 'Completed',
    ),
    _TransactionRecord(
      type: 'Sell',
      symbol: 'ABCD',
      date: '03 Oct',
      amount: '21,000.00',
      isCredit: true,
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    _buildHeader().fadeUp(0),
                    const SizedBox(height: 2),
                    const Padding(
                      padding: EdgeInsets.only(left: 34),
                      child: Text(
                        'Settlement of your trades',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ).fadeUp(1),
                    const SizedBox(height: 12),
                    for (final (i, transaction) in _transactions.indexed)
                      _buildTransactionRow(transaction).fadeUp(i + 2, 100),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.text, size: 28),
          tooltip: 'Back',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
        ),
        const SizedBox(width: 4),
        const Text(
          'Transactions',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(_TransactionRecord transaction) {
    final amountColor = transaction.isCredit ? AppColors.gain : AppColors.loss;
    final statusColor = transaction.status == 'Pending' ? AppColors.brass : AppColors.gain;

    final amountPrefix = transaction.isCredit ? '+' : '−';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.type} · ${transaction.symbol}',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.date,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  '$amountPrefix Rs. ${transaction.amount}',
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
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
                  transaction.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      _NavItem(Icons.home_outlined, 'Home'),
      _NavItem(Icons.pie_chart_outline_rounded, 'Portfolio'),
      _NavItem(Icons.show_chart_rounded, 'Market'),
      _NavItem(Icons.swap_vert_rounded, 'Trade'),
      _NavItem(Icons.more_horiz_rounded, 'More'),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == 4;

          return Expanded(
            child: InkWell(
              onTap: () => onDestinationSelected?.call(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 22, color: selected ? AppColors.brass : AppColors.muted),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.brass : AppColors.muted,
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

class _TransactionRecord {
  const _TransactionRecord({
    required this.type,
    required this.symbol,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.status,
  });

  final String type;
  final String symbol;
  final String date;
  final String amount;
  final bool isCredit;
  final String status;
}

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
