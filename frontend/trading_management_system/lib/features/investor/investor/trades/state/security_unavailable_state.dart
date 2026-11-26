import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';

class SecurityUnavailableState extends StatelessWidget {
  const SecurityUnavailableState({
    super.key,
    this.symbol = 'ABCD',
    this.companyName = 'Sample Bank Ltd',
    this.accountStatus = 'Inactive',
    this.onBack,
    this.onChooseAnotherSecurity,
    this.onContactBroker,
    this.onDestinationSelected,
  });

  final String symbol;
  final String companyName;
  final String accountStatus;

  final VoidCallback? onBack;
  final VoidCallback? onChooseAnotherSecurity;
  final VoidCallback? onContactBroker;
  final ValueChanged<int>? onDestinationSelected;


  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleChooseSecurity(BuildContext context) {
    if (onChooseAnotherSecurity != null) {
      onChooseAnotherSecurity!();
    } else {
      _showMessage(
        context,
        'Connect this action to the security selection screen.',
      );
    }
  }

  void _handleContactBroker(BuildContext context) {
    if (onContactBroker != null) {
      onContactBroker!();
    } else {
      _showMessage(
        context,
        'Connect this action to your broker contact details.',
      );
    }
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSecurityCard(),
                    const SizedBox(height: 48),
                    _buildUnavailableContent(context),
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
        SizedBox(
          width: 34,
          height: 44,
          child: IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.text,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'Order ticket',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  companyName,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.muted),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              accountStatus,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.do_not_disturb_on_outlined,
              color: AppColors.muted,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Not available to trade',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$symbol isn't available through your broker right now. "
              'Choose another security or contact your broker.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 14, height: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _buildActions(context),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => _handleChooseSecurity(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brass,
              foregroundColor: AppColors.onBrass,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Choose another security',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => _handleContactBroker(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.text,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Contact your broker',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
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
          final isSelected = index == 3;
          final itemColor = isSelected ? AppColors.brass : AppColors.muted;

          return Expanded(
            child: InkWell(
              onTap: () {
                onDestinationSelected?.call(index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: itemColor, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
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

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
