import 'package:flutter/material.dart';

class EmptyConversationsView extends StatelessWidget {
  const EmptyConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 48,
            color: colors.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 12),
          Text(
            'No conversations yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start a conversation using a user email above.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}
