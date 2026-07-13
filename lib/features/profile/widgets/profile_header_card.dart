import 'package:flutter/material.dart';
import '../../../core/ui_text.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/profile_models.dart';

/// Avatar, name, email and role card shown at the top of the profile screen.
class ProfileHeaderCard extends StatelessWidget {
  final ProfileModel? profile;
  final AuthProvider auth;
  final bool loading;
  final VoidCallback onUploadAvatar;
  final VoidCallback onDeleteAvatar;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.auth,
    required this.loading,
    required this.onUploadAvatar,
    required this.onDeleteAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = profile?.name ?? auth.email ?? 'User';
    final role = profile?.role ?? auth.role ?? '';
    final avatarUrl = profile?.avatarUrl?.trim() ?? '';
    final hasAvatar = avatarUrl.isNotEmpty;
    final t = context.strings;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 4,
                  ),
                ),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                  child: hasAvatar
                      ? null
                      : Text(
                          displayName.isEmpty
                              ? '?'
                              : displayName[0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: PopupMenuButton<String>(
                  enabled: !loading,
                  onSelected: (value) {
                    if (value == 'upload') onUploadAvatar();
                    if (value == 'delete') onDeleteAvatar();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'upload',
                      child: Row(
                        children: [
                          const Icon(Icons.upload_outlined),
                          const SizedBox(width: 10),
                          Text(t.uploadUpdateAvatar),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      enabled: hasAvatar,
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline),
                          const SizedBox(width: 10),
                          Text(t.deleteAvatar),
                        ],
                      ),
                    ),
                  ],
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary,
                    child: loading
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt_outlined,
                            size: 17,
                            color: theme.colorScheme.onPrimary,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.email ?? auth.email ?? '',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(
              t.role(role),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            side: BorderSide.none,
            labelStyle: TextStyle(color: theme.colorScheme.primary),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
        ],
      ),
    );
  }
}
