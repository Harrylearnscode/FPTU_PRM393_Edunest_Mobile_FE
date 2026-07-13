import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/ui_text.dart';
import '../models/notification_models.dart';
import '../widgets/notification_tile.dart';
import '../widgets/empty_notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<NotificationProvider>();
    final theme = Theme.of(context);
    final t = context.strings;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(t.text('Notifications')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: data.loading ? null : data.markAllNotificationsAsRead,
            icon: const Icon(Icons.done_all_rounded),
            tooltip: t.text('Mark all as read'),
          ),
          IconButton(
            onPressed: data.loading ? null : data.loadNotifications,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: t.text('Refresh'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: data.loadNotifications,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ErrorBanner(data.error),
            if (data.loading && data.notifications.isEmpty)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (data.notifications.isEmpty)
              EmptyNotificationState(text: t.text('No notifications yet'))
            else
              ...data.notifications.map(
                (item) => NotificationTile(
                  notification: item,
                  onTap: () => _openNotification(context, item),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNotification(
    BuildContext context,
    NotificationModel notification,
  ) async {
    final data = context.read<NotificationProvider>();
    if (!notification.isRead) {
      await data.markNotificationAsRead(notification.notificationId);
    }
    if (!context.mounted) return;

    switch (notification.type) {
      case 'StudentCoursePaid':
        break;
      case 'StudentMaterialUploaded':
        context.go('/materials');
        break;
      case 'LessonStartingSoon':
        final lessonId = notification.lessonId;
        if (lessonId == null) {
          context.go('/lessons');
        } else {
          context.go('/lessons/$lessonId');
        }
        break;
      default:
        break;
    }
  }
}
