import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class InvestorMoreScreen extends StatelessWidget {
  const InvestorMoreScreen({
    super.key,
    this.investorName = 'Investor',
    this.clientId = 'C001',
    this.notificationCount = 2,
    this.onDestinationSelected,
    this.onSignOut,
  });

  final String investorName;
  final String clientId;
  final int notificationCount;

  final ValueChanged<String>? onDestinationSelected;
  final VoidCallback? onSignOut;


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
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'More',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInvestorCard(),
                    const SizedBox(height: 12),
                    _buildMenuCard(),
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

  Widget _buildInvestorCard() {
    final initials = _getInitials(investorName);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.deep,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.brass,
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investorName,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Client ID $clientId',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard() {
    final items = [
      _MoreMenuItem(label: 'Orders', icon: Icons.format_list_bulleted),
      _MoreMenuItem(label: 'Trades', icon: Icons.sync),
      _MoreMenuItem(label: 'Transactions', icon: Icons.receipt_long_outlined),
      _MoreMenuItem(label: 'IPO', icon: Icons.flag_outlined),
      _MoreMenuItem(
        label: 'Notifications',
        icon: Icons.notifications_none,
        badge: notificationCount,
      ),
      _MoreMenuItem(label: 'Profile', icon: Icons.person_outline),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (int index = 0; index < items.length; index++)
            _buildMenuRow(item: items[index], showDivider: true),
          _buildSignOutRow(),
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required _MoreMenuItem item,
    required bool showDivider,
  }) {
    return InkWell(
      onTap: () => onDestinationSelected?.call(item.label),
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border, width: 1))
              : null,
        ),
        child: Row(
          children: [
            Icon(item.icon, color: AppColors.brass, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (item.badge > 0) ...[
              Container(
                constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brass,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  item.badge.toString(),
                  style: const TextStyle(
                    color: AppColors.onBrass,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutRow() {
    return InkWell(
      onTap: onSignOut,
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        child: const Row(
          children: [
            Icon(Icons.logout, color: AppColors.loss, size: 22),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Sign out',
                style: TextStyle(
                  color: AppColors.loss,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          _buildNavItem(icon: Icons.home_outlined, label: 'Home', index: 0),
          _buildNavItem(
            icon: Icons.pie_chart_outline,
            label: 'Portfolio',
            index: 1,
          ),
          _buildNavItem(icon: Icons.show_chart, label: 'Market', index: 2),
          _buildNavItem(icon: Icons.swap_vert, label: 'Trade', index: 3),
          _buildNavItem(
            icon: Icons.more_horiz,
            label: 'More',
            index: 4,
            selected: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool selected = false,
  }) {
    final color = selected ? AppColors.brass : AppColors.muted;

    return Expanded(
      child: InkWell(
        onTap: () {
          // The parent can connect this navigation index to routes.
          onDestinationSelected?.call('NAV:$index');
        },
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'IN';

    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _MoreMenuItem {
  const _MoreMenuItem({
    required this.label,
    required this.icon,
    this.badge = 0,
  });

  final String label;
  final IconData icon;
  final int badge;
}
