import 'package:flutter/material.dart';

import '../../../core/widgets/user_avatar.dart';

class MessageBubble extends StatelessWidget {
  final bool mine;
  final String message;
  final String senderName;
  final String? avatarUrl;
  final String time;

  const MessageBubble({
    super.key,
    required this.mine,
    required this.message,
    required this.senderName,
    required this.avatarUrl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 320),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: mine ? const Color(0xFFEAF3DE) : colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(mine ? 18 : 6),
          bottomRight: Radius.circular(mine ? 6 : 18),
        ),
        border: Border.all(
          color: mine
              ? const Color(0xFFC0DD97)
              : colors.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine) ...[
            Text(
              senderName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFF3B6D11),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
          ],
          Text(message,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.4)),
          const SizedBox(height: 4),
          Text(
            '$senderName • $time',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );

    if (mine) return Align(alignment: Alignment.centerRight, child: bubble);
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 6),
            child:
                UserAvatar(imageUrl: avatarUrl, name: senderName, radius: 15),
          ),
          Flexible(child: bubble),
        ],
      ),
    );
  }
}
