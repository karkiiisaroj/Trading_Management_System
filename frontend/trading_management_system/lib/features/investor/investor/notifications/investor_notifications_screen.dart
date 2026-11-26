import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/animations.dart';

class InvestorNotificationsScreen extends StatefulWidget {
  const InvestorNotificationsScreen({
    super.key,
    this.onBack,
    this.onDestinationSelected,
    this.onNotificationSelected,
  });

  final VoidCallback? onBack;
  final ValueChanged<int>? onDestinationSelected;
  final ValueChanged<String>? onNotificationSelected;

  @override
  State<InvestorNotificationsScreen> createState() =>
      _InvestorNotificationsScreenState();
}

class _InvestorNotificationsScreenState
    extends State<InvestorNotificationsScreen> {

  int _selectedFilter = 0;

  late final List<_NotificationItem> _notifications = [
    _NotificationItem(
      title: 'Order filled',
      message: 'Your buy order for ABCD was filled.',
      time: '2 hours ago',
      icon: Icons.list_alt_rounded,
      isRead: false,
    ),
    _NotificationItem(
      title: 'Trade executed',
      message: '30 units of ABCD were bought at Rs. 510.00.',
      time: '2 hours ago',
      icon: Icons.swap_horiz_rounded,
      isRead: false,
    ),
    _NotificationItem(
      title: 'IPO open',
      message: 'Sample Bank IPO is open for applications.',
      time: 'Yesterday',
      icon: Icons.flag_outlined,
      isRead: true,
    ),
    _NotificationItem(
      title: 'Transaction completed',
      message: 'Settlement for your EFGH sale is complete.',
      time: '07 Oct',
      icon: Icons.receipt_long_outlined,
      isRead: true,
    ),
    _NotificationItem(
      title: 'System notice',
      message: 'Welcome to AARTHA.',
      time: '03 Oct',
      icon: Icons.notifications_none_rounded,
      isRead: true,
    ),
  ];

  List<_NotificationItem> get _visibleNotifications {
    if (_selectedFilter == 1) {
      return _notifications.where((item) => !item.isRead).toList();
    }

    return _notifications;
  }

  int get _unreadCount => _notifications.where((item) => !item.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (final item in _notifications) {
        item.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  void _markAsRead(_NotificationItem item) {
    if (item.isRead) return;

    setState(() {
      item.isRead = true;
    });
  }

  void _selectNotification(_NotificationItem item) {
    _markAsRead(item);
    widget.onNotificationSelected?.call(item.title);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(item.title), backgroundColor: AppColors.surface));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader().fadeUp(0),
            _buildFilters().fadeUp(1),
            Expanded(child: _buildNotificationList()),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 22, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: widget.onBack ?? () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.text,
              size: 30,
            ),
            tooltip: 'Back',
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 7),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: GestureDetector(
              onTap: _unreadCount == 0 ? null : _markAllAsRead,
              child: Text(
                'Mark all as read',
                style: TextStyle(
                  color: _unreadCount == 0 ? AppColors.muted : AppColors.brass,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 6),
      child: Row(
        children: [
          _buildFilterChip('All', 0),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Unread${_unreadCount > 0 ? ' ($_unreadCount)' : ''}',
            1,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final bool selected = _selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.brass : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.brass : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.deep : AppColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    final notifications = _visibleNotifications;

    if (notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.deep,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.brass,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'All caught up',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'You have no unread notifications.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 20),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationRow(notifications[index])
            .fadeUp(index + 2, 100);
      },
    );
  }

  Widget _buildNotificationRow(_NotificationItem item) {
    return InkWell(
      onTap: () => _selectNotification(item),
      splashColor: AppColors.brass.withValues(alpha: 0.08),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.deep,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: AppColors.brass, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: item.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.message,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.time,
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: item.isRead ? Colors.transparent : AppColors.brass,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
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
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool selected = index == 4;

          return Expanded(
            child: InkWell(
              onTap: () {
                widget.onDestinationSelected?.call(index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: selected ? AppColors.brass : AppColors.muted, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? AppColors.brass : AppColors.muted,
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

class _NotificationItem {
  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.isRead,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  bool isRead;
}

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
