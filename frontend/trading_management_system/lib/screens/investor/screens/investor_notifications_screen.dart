import 'package:flutter/material.dart';

class InvestorNotificationsScreen extends StatefulWidget {
  const InvestorNotificationsScreen({super.key});

  @override
  State<InvestorNotificationsScreen> createState() =>
      _InvestorNotificationsScreenState();
}

class _InvestorNotificationsScreenState
    extends State<InvestorNotificationsScreen> {
  static const Color background = Color(0xFF18372B);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color navColor = Color(0xFF12291F);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color primaryText = Color(0xFFF4F1E9);
  static const Color mutedText = Color(0xFFB5C3B9);

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Order filled',
      'message': 'Your buy order for ABCD was filled.',
      'time': '2 hours ago',
      'icon': Icons.format_list_bulleted,
      'isRead': false,
    },
    {
      'title': 'Trade executed',
      'message': '30 units of ABCD were bought at Rs. 510.00.',
      'time': '2 hours ago',
      'icon': Icons.sync,
      'isRead': false,
    },
    {
      'title': 'IPO open',
      'message': 'Sample Bank IPO is open for applications.',
      'time': 'Yesterday',
      'icon': Icons.flag_outlined,
      'isRead': true,
    },
    {
      'title': 'Transaction completed',
      'message': 'Settlement for your EFGH sale is complete.',
      'time': '07 Oct',
      'icon': Icons.receipt_long_outlined,
      'isRead': true,
    },
    {
      'title': 'System notice',
      'message': 'Welcome to AARTHA.',
      'time': '03 Oct',
      'icon': Icons.notifications_none,
      'isRead': true,
    },
  ];

  int get unreadCount =>
      notifications.where((item) => item['isRead'] == false).length;

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'Unread') {
      return notifications.where((item) => item['isRead'] == false).toList();
    }

    return notifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        backgroundColor: cardColor,
      ),
    );
  }

  void _markAsRead(Map<String, dynamic> notification) {
    if (notification['isRead'] == true) return;

    setState(() {
      notification['isRead'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedNotifications = filteredNotifications;

    return Scaffold(
      backgroundColor: background,
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
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: primaryText,
                            size: 28,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 34,
                            minHeight: 40,
                          ),
                        ),

                        const Expanded(
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: primaryText,
                              height: 1.1,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: unreadCount > 0 ? _markAllAsRead : null,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              'Mark all as read',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: unreadCount > 0 ? gold : mutedText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Filter tabs
                    Row(
                      children: [
                        _buildFilterButton('All'),
                        const SizedBox(width: 8),
                        _buildFilterButton('Unread'),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Notifications list
                    if (displayedNotifications.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 45),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_none,
                                color: mutedText,
                                size: 34,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No unread notifications',
                                style: TextStyle(
                                  color: mutedText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...displayedNotifications.map(
                        (notification) => _buildNotificationItem(notification),
                      ),

                    const SizedBox(height: 14),

                    const Text(
                      'Sample data',
                      style: TextStyle(color: mutedText, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),

            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final bool isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? gold : Colors.transparent,
          border: Border.all(color: isSelected ? gold : borderColor),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF12241C) : primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final bool isRead = notification['isRead'] as bool;

    return InkWell(
      onTap: () => _markAsRead(notification),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: borderColor, width: 1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: navColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification['icon'] as IconData,
                color: gold,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // Notification details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'] as String,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    notification['message'] as String,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification['time'] as String,
                    style: const TextStyle(color: mutedText, fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Unread indicator
            SizedBox(
              width: 9,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: isRead
                    ? const SizedBox(width: 9, height: 9)
                    : Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: gold,
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.pie_chart_outline, 'label': 'Portfolio'},
      {'icon': Icons.trending_up, 'label': 'Market'},
      {'icon': Icons.swap_vert, 'label': 'Trade'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: navColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final bool isSelected = index == 4;
          final Color itemColor = isSelected ? gold : mutedText;

          return Expanded(
            child: InkWell(
              onTap: () {
                if (!isSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${items[index]['label']} screen is not connected yet.',
                      ),
                      backgroundColor: cardColor,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[index]['icon'] as IconData,
                    color: itemColor,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index]['label'] as String,
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
