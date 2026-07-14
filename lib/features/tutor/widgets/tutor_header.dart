import 'package:flutter/material.dart';

import '../../../core/ui_text.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../booking/models/booking_models.dart';

class TutorHeader extends StatelessWidget {
  final TutorPublicModel tutor;
  final String? avatarUrl;

  const TutorHeader({
    super.key,
    required this.tutor,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          UserAvatar(
            imageUrl: avatarUrl,
            name: tutor.name,
            radius: 40,
          ),
          const SizedBox(height: 14),
          Text(
            tutor.name.isEmpty ? 'Tutor #${tutor.tutorId}' : tutor.name,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          if (tutor.email.isNotEmpty)
            _ContactRow(icon: Icons.email_outlined, text: tutor.email),
          if (tutor.phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            _ContactRow(icon: Icons.phone_outlined, text: tutor.phone),
          ],
          if (tutor.bio.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                t.tutorBio,
                style: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tutor.bio,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
