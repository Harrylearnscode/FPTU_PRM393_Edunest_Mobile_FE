import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/user_avatar.dart';
import '../models/chat_models.dart';

class ConversationItemCard extends StatelessWidget {
  final ConversationModel conversation;
  final String displayName;
  final VoidCallback onTap;

  const ConversationItemCard({
    super.key,
    required this.conversation,
    required this.displayName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final roleText = conversation.otherUserRole.trim().isEmpty
        ? ''
        : ' • ${conversation.otherUserRole}';
    final time = DateFormat('dd/MM HH:mm').format(
      conversation.lastMessageAt.toLocal(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: UserAvatar(
          imageUrl: conversation.otherUserAvatarUrl,
          name: displayName,
          radius: 24,
        ),
        title: Text(
          displayName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            '$time$roleText',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: colors.onSurface.withValues(alpha: 0.4),
        ),
        onTap: onTap,
      ),
    );
  }
}
