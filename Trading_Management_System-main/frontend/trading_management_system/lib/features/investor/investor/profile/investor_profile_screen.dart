import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class InvestorProfileScreen extends StatelessWidget {
  const InvestorProfileScreen({
    super.key,
    this.investorName = 'Investor',
    this.clientId = 'C001',
    this.username = 'username',
    this.email = 'email@example.com',
    this.phone = '98XXXXXXXX',
    this.brokerName = 'Broker name',
    this.tradingAccount = 'A001',
    this.onBack,
    this.onDestinationSelected,
    this.onChangePassword,
    this.onNotificationSettings,
    this.onContactBroker,
    this.onSignOut,
  });

  final String investorName;
  final String clientId;
  final String username;
  final String email;
  final String phone;
  final String brokerName;
  final String tradingAccount;

  final VoidCallback? onBack;
  final ValueChanged<int>? onDestinationSelected;
  final VoidCallback? onChangePassword;
  final VoidCallback? onNotificationSettings;
  final VoidCallback? onContactBroker;
  final VoidCallback? onSignOut;


  String get _initials {
    final parts = investorName.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return 'IN';
    }

    if (parts.length == 1) {
      return parts.first.length >= 2
          ? parts.first.substring(0, 2).toUpperCase()
          : parts.first.toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Sign out?',
            style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Are you sure you want to sign out of your AARTHA account?',
            style: TextStyle(color: AppColors.muted, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: AppColors.muted)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                if (onSignOut != null) {
                  onSignOut!();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sign out is not connected yet.'),
                    ),
                  );
                }
              },
              child: const Text(
                'Sign out',
                style: TextStyle(color: AppColors.loss, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

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
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    _buildAccountInformation(),
                    const SizedBox(height: 12),
                    _buildSettingsMenu(context),
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
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.text,
                  size: 28,
                ),
                tooltip: 'Back',
              ),
            ],
          ),
        ),
        Container(
          width: 84,
          height: 84,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            _initials,
            style: const TextStyle(
              color: AppColors.brass,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          investorName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Client ID $clientId',
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildAccountInformation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      child: Column(
        children: [
          _infoRow('Username', username),
          _infoRow('Email', email),
          _infoRow('Phone', phone),
          _infoRow('Broker', brokerName),
          _infoRow('Trading account', tradingAccount, showDivider: false),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool showDivider = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.lock_outline_rounded,
            title: 'Change password',
            onTap: onChangePassword,
          ),
          _menuItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notification settings',
            onTap: onNotificationSettings,
          ),
          _menuItem(
            icon: Icons.help_outline_rounded,
            title: 'Contact your broker',
            onTap: onContactBroker,
          ),
          _menuItem(
            icon: Icons.logout_rounded,
            title: 'Sign out',
            color: AppColors.loss,
            showDivider: false,
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    Color color = AppColors.text,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            // The parent can provide navigation callbacks.
          },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 21),
          ],
        ),
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

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
