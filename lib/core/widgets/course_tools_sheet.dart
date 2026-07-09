import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui_text.dart';

Future<void> showCourseToolsSheet(
  BuildContext shellContext,
  String location,
) {
  final theme = Theme.of(shellContext);
  final colors = theme.colorScheme;
  final t = UiText.of(shellContext, listen: false);

  return showGeneralDialog<void>(
    context: shellContext,
    barrierDismissible: true,
    barrierLabel: t.courseTools,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 160),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(dialogContext).pop(),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 74,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: 0.6),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      _CourseToolAction(
                        icon: Icons.school_outlined,
                        selectedIcon: Icons.school,
                        label: t.lesson,
                        selected: location == '/lessons' ||
                            location.startsWith('/lessons/'),
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          shellContext.go('/lessons');
                        },
                      ),
                      _CourseToolAction(
                        icon: Icons.folder_copy_outlined,
                        selectedIcon: Icons.folder_copy,
                        label: t.materials,
                        selected: location == '/materials' ||
                            location.startsWith('/materials/'),
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          shellContext.go('/materials');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

class _CourseToolAction extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CourseToolAction({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: selected
                ? colors.primaryContainer.withValues(alpha: 0.75)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? selectedIcon : icon,
                color: selected ? colors.onPrimaryContainer : colors.primary,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: selected
                      ? colors.onPrimaryContainer
                      : colors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
