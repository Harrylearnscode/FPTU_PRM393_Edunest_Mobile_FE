import 'package:flutter/material.dart';

/// Placeholder shown when the user has no notifications.
class EmptyNotificationState extends StatelessWidget {
  final String text;

  const EmptyNotificationState({super.key, required this.text});

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
