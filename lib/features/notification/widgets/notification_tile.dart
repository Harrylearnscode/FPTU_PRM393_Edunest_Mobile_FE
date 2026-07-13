import 'package:flutter/material.dart';
import '../models/notification_models.dart';

/// Single notification row shown in the notifications list.
class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
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
          : colors.primaryContainer.withOpacity(0.45),
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
