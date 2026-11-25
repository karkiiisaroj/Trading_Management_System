import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';
import '../../widgets/broker_widgets.dart';

/// Read-only updates about the broker's investors (BR-I48 types).
class BrokerNotificationsScreen extends StatelessWidget {
  const BrokerNotificationsScreen({super.key, required this.repository});

  final BrokerRepository repository;

  static IconData _icon(NotificationKind kind) {
    switch (kind) {
      case NotificationKind.order:
        return Icons.format_list_bulleted_rounded;
      case NotificationKind.trade:
        return Icons.sync_alt_rounded;
      case NotificationKind.ipo:
        return Icons.flag_outlined;
      case NotificationKind.transaction:
        return Icons.receipt_long_outlined;
      case NotificationKind.system:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrokerFutureBuilder<List<BrokerNotification>>(
      load: repository.notifications,
      loadingLabel: 'Loading notifications\u2026',
      errorTitle: "Couldn't load notifications",
      builder: (context, items) {
        if (items.isEmpty) {
          return const BrokerStatePanel(
            icon: Icons.notifications_none_rounded,
            title: 'No notifications yet',
            message: 'Updates about your investors will appear here.',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final n in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BrokerCard(
                  padding: const EdgeInsets.all(16),
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
                        child: Icon(_icon(n.kind), size: 20, color: AppColors.brass),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              n.message,
                              style: AppTypography.bodyMuted.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(n.time, style: AppTypography.caption),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
