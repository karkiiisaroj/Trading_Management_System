import 'package:flutter/material.dart';

class _NotificationColors {
  static const background = Color(0xFF18372B);
  static const card = Color(0xFF1F4435);
  static const navigation = Color(0xFF12291F);
  static const border = Color(0xFF34584A);
  static const gold = Color(0xFFC4A76C);
  static const primaryText = Color(0xFFF4F1E9);
  static const mutedText = Color(0xFFB5C3B9);
}

class BrokerNotificationsScreen extends StatelessWidget {
  const BrokerNotificationsScreen({
    super.key,
    this.brokerName = '[Broker name]',
    this.profileInitials = 'BR',
  });

  final String brokerName;
  final String profileInitials;

  static const List<_BrokerNotification> notifications = [
    _BrokerNotification(
      title: 'New order',
      message: 'C001 placed a buy order for 50 units of ABCD.',
      time: '2 hours ago',
      icon: Icons.format_list_bulleted,
      unread: true,
    ),
    _BrokerNotification(
      title: 'Trade executed',
      message: 'Order #1041 for EFGH was executed.',
      time: '3 hours ago',
      icon: Icons.sync_alt,
      unread: true,
    ),
    _BrokerNotification(
      title: 'Transaction completed',
      message: 'Settlement for C002 is complete.',
      time: 'Yesterday',
      icon: Icons.receipt_long_outlined,
    ),
    _BrokerNotification(
      title: 'IPO open',
      message: 'Sample Bank IPO is open for your investors.',
      time: '07 Oct',
      icon: Icons.flag_outlined,
    ),
    _BrokerNotification(
      title: 'System notice',
      message: 'Welcome to AARTHA.',
      time: '03 Oct',
      icon: Icons.notifications_none,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 860;

        return Scaffold(
          backgroundColor: _NotificationColors.background,
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: _NotificationColors.navigation,
                  foregroundColor: _NotificationColors.primaryText,
                  title: const Text(
                    'AARTHA',
                    style: TextStyle(
                      color: _NotificationColors.gold,
                      fontFamily: 'Georgia',
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          drawer: isDesktop
              ? null
              : Drawer(
                  backgroundColor: _NotificationColors.navigation,
                  child: Builder(
                    builder: (drawerContext) =>
                        _buildSidebar(drawerContext, closeDrawer: true),
                  ),
                ),
          body: Row(
            children: [
              if (isDesktop)
                SizedBox(width: 240, child: _buildSidebar(context)),
              Expanded(child: _buildContent(context, isDesktop)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, {bool closeDrawer = false}) {
    return Container(
      color: _NotificationColors.navigation,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _NotificationColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _NotificationColors.border),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: _NotificationColors.gold,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AARTHA',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: _NotificationColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          _navItem(
            context,
            Icons.dashboard_outlined,
            'Dashboard',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.people_outline,
            'Investors',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.work_outline,
            'Trading accounts',
            closeDrawer: closeDrawer,
          ),
          _navItem(context, Icons.list_alt, 'Orders', closeDrawer: closeDrawer),
          _navItem(
            context,
            Icons.swap_horiz,
            'Trades',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.show_chart,
            'Market',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.layers_outlined,
            'Securities',
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.notifications_none,
            'Notifications',
            selected: true,
            closeDrawer: closeDrawer,
          ),
          _navItem(
            context,
            Icons.person_outline,
            'Profile',
            closeDrawer: closeDrawer,
          ),
          const Spacer(),
          const Divider(color: _NotificationColors.border),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brokerName,
                  style: const TextStyle(
                    color: _NotificationColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Broker',
                  style: TextStyle(
                    color: _NotificationColors.mutedText,
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

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool selected = false,
    bool closeDrawer = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (closeDrawer) Navigator.of(context).pop();

          if (!selected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label screen will be connected later.')),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? _NotificationColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? _NotificationColors.gold
                    : _NotificationColors.mutedText,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: selected
                      ? _NotificationColors.gold
                      : _NotificationColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildNotificationList(),
          const SizedBox(height: 14),
          const Text(
            'Sample data',
            style: TextStyle(
              fontSize: 11,
              color: _NotificationColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: _NotificationColors.primaryText,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Activity from your investors and the system',
                style: TextStyle(
                  fontSize: 14,
                  color: _NotificationColors.mutedText,
                ),
              ),
            ],
          ),
        ),
        _circleIcon(
          icon: Icons.notifications_none,
          onTap: () =>
              _showMessage(context, 'You are viewing your notifications.'),
        ),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _NotificationColors.card,
            shape: BoxShape.circle,
            border: Border.all(color: _NotificationColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            profileInitials,
            style: const TextStyle(
              color: _NotificationColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _NotificationColors.card,
          shape: BoxShape.circle,
          border: Border.all(color: _NotificationColors.border),
        ),
        child: Icon(icon, size: 20, color: _NotificationColors.primaryText),
      ),
    );
  }

  Widget _buildNotificationList() {
    return Container(
      decoration: BoxDecoration(
        color: _NotificationColors.card,
        border: Border.all(color: _NotificationColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: List.generate(
            notifications.length,
            (index) => _NotificationTile(
              notification: notifications[index],
              showDivider: index != notifications.length - 1,
            ),
          ),
        ),
      ),
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _BrokerNotification {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool unread;

  const _BrokerNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    this.unread = false,
  });
}

class _NotificationTile extends StatelessWidget {
  final _BrokerNotification notification;
  final bool showDivider;

  const _NotificationTile({
    required this.notification,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: _NotificationColors.border),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: _NotificationColors.navigation,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              notification.icon,
              size: 20,
              color: _NotificationColors.gold,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: notification.unread
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: _NotificationColors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _NotificationColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            notification.time,
            style: const TextStyle(
              fontSize: 12,
              color: _NotificationColors.mutedText,
            ),
          ),
          if (notification.unread) ...[
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: _NotificationColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
