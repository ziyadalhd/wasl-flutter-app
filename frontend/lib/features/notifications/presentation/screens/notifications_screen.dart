import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final List<NotificationItem> notifications = [
      NotificationItem(
        text: 'تم قبول طلبك للخدمة رقم #1234',
        time: 'منذ 5 دقائق',
        isRead: false,
      ),
      NotificationItem(
        text: 'قام محمد بإرسال رسالة جديدة',
        time: 'منذ ساعة',
        isRead: true,
      ),
      NotificationItem(
        text: 'لا تنسى تقييم الخدمة المقدمة',
        time: 'أمس',
        isRead: true,
      ),
    ];

    // Toggle this to test empty state
    // final List<NotificationItem> notifications = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'لا توجد إشعارات حاليًا',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.subtitleColor),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _NotificationTile(item: item);
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.isRead
          ? Colors.transparent
          : AppTheme.primaryColor.withOpacity(0.05),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: item.isRead
                ? Colors.grey.withOpacity(0.1)
                : AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: item.isRead ? AppTheme.subtitleColor : AppTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          item.text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            item.time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: item.isRead
                  ? AppTheme.subtitleColor
                  : AppTheme.primaryColor,
              fontWeight: item.isRead ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ),
        onTap: () {
          // No navigation needed as per requirements
        },
      ),
    );
  }
}

class NotificationItem {
  final String text;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.text,
    required this.time,
    required this.isRead,
  });
}
