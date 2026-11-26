import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

import '../data/broker_models.dart';
import 'broker_widgets.dart';

/// The ten sidebar destinations, in design order.
enum BrokerSection {
  dashboard('Dashboard', Icons.home_outlined),
  investors('Investors', Icons.people_outline_rounded),
  accounts('Trading accounts', Icons.work_outline_rounded),
  orders('Orders', Icons.format_list_bulleted_rounded),
  trades('Trades', Icons.sync_alt_rounded),
  transactions('Transactions', Icons.receipt_long_outlined),
  market('Market', Icons.trending_up_rounded),
  securities('Securities', Icons.layers_outlined),
  notifications('Notifications', Icons.notifications_none_rounded),
  profile('Profile', Icons.person_outline_rounded);

  const BrokerSection(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Frame for every signed-in broker page.
///
/// Wide (>= 850): permanent 248px sidebar, page header with bell + avatar.
/// Narrow: app bar with a drawer holding the same sidebar.
class BrokerShell extends StatelessWidget {
  const BrokerShell({
    super.key,
    required this.selected,
    required this.onNavigate,
    required this.brokerName,
    required this.title,
    required this.subtitle,
    required this.child,
    this.leading,
  });

  final BrokerSection selected;
  final ValueChanged<BrokerSection> onNavigate;
  final String brokerName;
  final String title;
  final String subtitle;

  /// Shown above the title, e.g. a [BrokerBackLink].
  final Widget? leading;
  final Widget child;

  static const double sidebarWidth = 248;
  static const double desktopBreakpoint = 850;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= desktopBreakpoint) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  SizedBox(
                    width: sidebarWidth,
                    child: _Sidebar(
                      selected: selected,
                      brokerName: brokerName,
                      onSelected: onNavigate,
                    ),
                  ),
                  Expanded(child: _content(wide: true)),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          drawer: Drawer(
            backgroundColor: AppColors.deep,
            width: 280,
            child: SafeArea(
              child: Builder(
                builder: (drawerContext) => _Sidebar(
                  selected: selected,
                  brokerName: brokerName,
                  onSelected: (s) {
                    Navigator.of(drawerContext).pop();
                    onNavigate(s);
                  },
                ),
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.text,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'AARTHA',
              style: AppTypography.wordmark.copyWith(
                fontSize: 20,
                letterSpacing: 4,
              ),
            ),
            actions: [
              _bell(),
              const SizedBox(width: 8),
              _avatar(),
              const SizedBox(width: 16),
            ],
          ),
          body: SafeArea(child: _content(wide: false)),
        );
      },
    );
  }

  Widget _bell() => BrokerCircleButton(
        tooltip: 'Notifications',
        onTap: () => onNavigate(BrokerSection.notifications),
        child: const Icon(
          Icons.notifications_none_rounded,
          size: 20,
          color: AppColors.text,
        ),
      );

  Widget _avatar() => BrokerCircleButton(
        tooltip: 'Profile',
        onTap: () => onNavigate(BrokerSection.profile),
        child: Text(
          BrokerFormat.initials(brokerName),
          style: AppTypography.label.copyWith(
            color: AppColors.brass,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  Widget _content({required bool wide}) {
    return LayoutBuilder(
      builder: (context, box) {
        final small = box.maxWidth < 600;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: small ? 20 : 40,
            vertical: small ? 16 : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(height: 4),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.display.copyWith(
                            fontSize: small ? 30 : 36,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppTypography.caption.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (wide) ...[
                    const SizedBox(width: 12),
                    _bell(),
                    const SizedBox(width: 12),
                    _avatar(),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              child,
            ],
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selected,
    required this.brokerName,
    required this.onSelected,
  });

  final BrokerSection selected;
  final String brokerName;
  final ValueChanged<BrokerSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 24),
            child: Row(
              children: [
                AarthaLogoMark(size: 38),
                SizedBox(width: 12),
                Text(
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
          ).fadeLeft(0),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (final (i, s) in BrokerSection.values.indexed)
                  _NavItem(
                    section: s,
                    selected: s == selected,
                    onTap: () => onSelected(s),
                  ).fadeLeft(i + 1, 100),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brokerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text('Broker', style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final BrokerSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brass : AppColors.muted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              if (selected)
                Positioned(
                  left: 0,
                  top: 10,
                  bottom: 10,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: AppColors.brass,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    Icon(section.icon, size: 20, color: color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        section.label,
                        style: AppTypography.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
