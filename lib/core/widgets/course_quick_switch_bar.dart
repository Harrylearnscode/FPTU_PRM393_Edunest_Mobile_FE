import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui_text.dart';

class CourseQuickSwitchBar extends StatelessWidget {
  final String location;

  const CourseQuickSwitchBar({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final t = context.strings;

    return Material(
      color: colors.surface,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.55),
              width: 0.5,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        child: Row(
          children: [
            _QuickCourseButton(
              icon: Icons.school_outlined,
              label: t.lesson,
              selected:
                  location == '/lessons' || location.startsWith('/lessons/'),
              onTap: () => context.push('/lessons'),
            ),
            const SizedBox(width: 8),
            _QuickCourseButton(
              icon: Icons.folder_copy_outlined,
              label: t.materials,
              selected: location == '/materials' ||
                  location.startsWith('/materials/'),
              onTap: () => context.push('/materials'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickCourseButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _QuickCourseButton({
    required this.icon,
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
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected
                ? colors.primaryContainer.withValues(alpha: 0.78)
                : colors.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? colors.primary.withValues(alpha: 0.28)
                  : colors.outlineVariant.withValues(alpha: 0.45),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isCourseLocation(String location) {
  return location == '/lessons' ||
      location.startsWith('/lessons/') ||
      location == '/materials' ||
      location.startsWith('/materials/');
}
