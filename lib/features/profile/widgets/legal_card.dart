import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/ui_text.dart';

/// Card linking to legal pages (e.g. terms of service) from the profile screen.
class LegalCard extends StatelessWidget {
  const LegalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: _TileIcon(
              icon: Icons.description_outlined,
              color: theme.colorScheme.primaryContainer,
              iconColor: theme.colorScheme.onPrimaryContainer,
            ),
            title: Text(
              t.termsOfService,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(t.termsOfServiceSubtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/terms-of-service'),
          ),
        ],
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;

  const _TileIcon({
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor),
    );
  }
}
