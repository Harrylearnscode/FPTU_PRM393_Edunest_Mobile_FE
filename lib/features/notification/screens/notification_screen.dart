import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/ui_text.dart';
import '../models/notification_models.dart';

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
              _EmptyNotificationState(text: t.text('No notifications yet'))
            else
              ...data.notifications.map(
                (item) => _NotificationTile(
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
        context.push('/materials');
        break;
      case 'LessonStartingSoon':
        final lessonId = notification.lessonId;
        if (lessonId == null) {
          context.push('/lessons');
        } else {
          context.push('/lessons/$lessonId');
        }
        break;
      default:
        break;
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: notification.isRead
          ? colors.surface
          : colors.primaryContainer.withValues(alpha: 0.45),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _typeColor(colors, notification.type),
          foregroundColor: colors.onPrimary,
          child: Icon(_typeIcon(notification.type), size: 20),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              const SizedBox(height: 6),
              Text(
                _timeLabel(notification.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        trailing: notification.isRead
            ? null
            : Icon(
                Icons.circle,
                size: 10,
                color: colors.primary,
              ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'StudentCoursePaid':
        return Icons.payments_rounded;
      case 'StudentMaterialUploaded':
        return Icons.upload_file_rounded;
      case 'LessonStartingSoon':
        return Icons.schedule_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _typeColor(ColorScheme colors, String type) {
    switch (type) {
      case 'StudentCoursePaid':
        return Colors.green.shade600;
      case 'StudentMaterialUploaded':
        return colors.tertiary;
      case 'LessonStartingSoon':
        return Colors.orange.shade700;
      default:
        return colors.primary;
    }
  }

  String _timeLabel(DateTime value) {
    if (value.millisecondsSinceEpoch == 0) return '';
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}

class _EmptyNotificationState extends StatelessWidget {
  final String text;

  const _EmptyNotificationState({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 72,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
