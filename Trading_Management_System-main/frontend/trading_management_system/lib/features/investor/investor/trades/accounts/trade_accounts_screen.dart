import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class TradeAccount {
  const TradeAccount({
    required this.accountNumber,
    required this.brokerName,
    required this.isActive,
  });

  final String accountNumber;
  final String brokerName;
  final bool isActive;
}

class TradeAccountsScreen extends StatefulWidget {
  const TradeAccountsScreen({
    super.key,
    this.accounts = const [
      TradeAccount(
        accountNumber: 'A001',
        brokerName: 'Broker name',
        isActive: true,
      ),
      TradeAccount(
        accountNumber: 'A002',
        brokerName: 'Second broker name',
        isActive: true,
      ),
      TradeAccount(
        accountNumber: 'A003',
        brokerName: 'Broker name',
        isActive: false,
      ),
    ],
    this.selectedAccount = 'A001',
    this.onAccountSelected,
    this.onClose,
  });

  final List<TradeAccount> accounts;
  final String selectedAccount;
  final ValueChanged<TradeAccount>? onAccountSelected;
  final VoidCallback? onClose;

  @override
  State<TradeAccountsScreen> createState() => _TradeAccountsScreenState();
}

class _TradeAccountsScreenState extends State<TradeAccountsScreen> {

  late String selectedAccount;

  @override
  void initState() {
    super.initState();
    selectedAccount = widget.selectedAccount;
  }

  TradeAccount? get selectedAccountData {
    for (final account in widget.accounts) {
      if (account.accountNumber == selectedAccount) {
        return account;
      }
    }
    return null;
  }

  void _confirmSelection() {
    final account = selectedAccountData;

    if (account == null || !account.isActive) {
      return;
    }

    widget.onAccountSelected?.call(account);

    if (widget.onAccountSelected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected trading account ${account.accountNumber}'),
          backgroundColor: AppColors.surface,
        ),
      );
    }

    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trade',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Place and track orders',
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trading account',
                          style: TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.selectedAccount,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dimmed dashboard AppColors.background.
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(color: AppColors.scrim),
            ),
          ),

          // Account selection bottom sheet.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                24,
                28,
                24,
                32 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose trading account',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Each account is managed by one broker.',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                      const SizedBox(height: 8),

                      ...widget.accounts.map(_buildAccountOption),

                      const SizedBox(height: 12),
                      const Text(
                        "Inactive accounts can't be used to place orders.",
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: selectedAccountData?.isActive == true
                              ? _confirmSelection
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brass,
                            disabledBackgroundColor: AppColors.brass.withOpacity(0.35),
                            foregroundColor: AppColors.deep,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Use this account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOption(TradeAccount account) {
    final isSelected = selectedAccount == account.accountNumber;

    final isActive = account.isActive;

    return Opacity(
      opacity: isActive ? 1 : 0.55,
      child: GestureDetector(
        onTap: isActive
            ? () {
                setState(() {
                  selectedAccount = account.accountNumber;
                });
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brass.withOpacity(0.12) : Colors.transparent,
            border: Border.all(color: isSelected ? AppColors.brass : AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _radioIndicator(isSelected && isActive),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.accountNumber,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.brokerName,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),

              _statusBadge(
                isActive ? 'Active' : 'Inactive',
                isActive ? AppColors.gain : AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioIndicator(bool selected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? AppColors.brass : AppColors.muted, width: 2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.brass,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
