
import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class BrokerAccessScreen extends StatelessWidget {
  final VoidCallback? onBackToInvestors;
  final ValueChanged<String>? onNavigate;

  const BrokerAccessScreen({
    super.key,
    this.onBackToInvestors,
    this.onNavigate,
  });


  static const List<_NavigationItem> navigationItems = [
    _NavigationItem(
      title: 'Dashboard',
      icon: Icons.home_outlined,
    ),
    _NavigationItem(
      title: 'Investors',
      icon: Icons.people_outline_rounded,
    ),
    _NavigationItem(
      title: 'Trading accounts',
      icon: Icons.work_outline_rounded,
    ),
    _NavigationItem(
      title: 'Orders',
      icon: Icons.format_list_bulleted_rounded,
    ),
    _NavigationItem(
      title: 'Trades',
      icon: Icons.sync_alt_rounded,
    ),
    _NavigationItem(
      title: 'Transactions',
      icon: Icons.receipt_long_outlined,
    ),
    _NavigationItem(
      title: 'Market',
      icon: Icons.trending_up_rounded,
    ),
    _NavigationItem(
      title: 'Securities',
      icon: Icons.layers_outlined,
    ),
    _NavigationItem(
      title: 'Notifications',
      icon: Icons.notifications_none_rounded,
    ),
    _NavigationItem(
      title: 'Profile',
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 850;

        if (isDesktop) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Row(
                children: [
                  SizedBox(
                    width: 248,
                    child: _buildSidebar(),
                  ),
                  Expanded(
                    child: _buildMainContent(context),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: Drawer(
            backgroundColor: AppColors.deep,
            width: 280,
            child: SafeArea(
              child: _buildSidebar(),
            ),
          ),
          appBar: AppBar(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.text,
            elevation: 0,
            title: const Text(
              'AARTHA',
              style: TextStyle(
                fontFamily: AppFonts.serif,
                fontSize: 23,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
              ),
            ),
          ),
          body: _buildMainContent(context),
        );
      },
    );
  }

  // --------------------------------------------------
  // SIDEBAR
  // --------------------------------------------------

  Widget _buildSidebar() {
    return Container(
      color: AppColors.deep,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrand(),
          const SizedBox(height: 4),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final item = navigationItems[index];

                return _buildNavigationItem(
                  item,
                  selected: item.title == 'Investors',
                );
              },
            ),
          ),

          const Divider(
            color: AppColors.border,
            height: 25,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[Broker name]',
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Broker',
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 24,
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: AppColors.brass,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'AARTHA',
            style: TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.5,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    _NavigationItem item, {
    required bool selected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected
            ? AppColors.surface
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onNavigate?.call(item.title);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? const Border(
                      left: BorderSide(
                        color: AppColors.brass,
                        width: 2,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: selected ? AppColors.brass : AppColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.brass : AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // MAIN CONTENT
  // --------------------------------------------------

  Widget _buildMainContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: isMobile ? 20 : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageHeader(context),
              const SizedBox(height: 24),
              _buildAccessDeniedCard(isMobile),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // PAGE HEADER
  // --------------------------------------------------

  Widget _buildPageHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Investors',
                style: TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Investors assigned to you',
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: 13,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        _buildHeaderIcon(
          Icons.notifications_none_rounded,
        ),

        const SizedBox(width: 12),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'BR',
            style: TextStyle(
              fontFamily: AppFonts.sans,
              color: AppColors.brass,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Icon(
        icon,
        color: AppColors.text,
        size: 20,
      ),
    );
  }

  // --------------------------------------------------
  // ACCESS DENIED CARD
  // --------------------------------------------------

  Widget _buildAccessDeniedCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 24,
        vertical: isMobile ? 65 : 96,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAccessDeniedIcon(),

          const SizedBox(height: 24),

          const Text(
            "You don't have access to this investor",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 8),

          const ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 420,
            ),
            child: Text(
              'You can only view investors assigned to your '
              'broker account. If you think this is a mistake, '
              'contact your administrator.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 13,
                height: 1.6,
                color: AppColors.muted,
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildAccessDeniedIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.block_rounded,
        color: AppColors.loss,
        size: 42,
      ),
    );
  }

  // --------------------------------------------------
  // BACK TO INVESTORS BUTTON
  // --------------------------------------------------

  Widget _buildBackButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          onBackToInvestors?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: AppColors.onBrass,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Back to investors',
          style: TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// NAVIGATION ITEM MODEL
// --------------------------------------------------

class _NavigationItem {
  final String title;
  final IconData icon;

  const _NavigationItem({
    required this.title,
    required this.icon,
  });
}
