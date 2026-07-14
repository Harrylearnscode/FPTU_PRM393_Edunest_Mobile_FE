import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui_text.dart';
import '../models/lesson_models.dart';

class AttendanceReminderBanner extends StatelessWidget {
  final List<LessonModel> lessons;
  static const int _maxShown = 3;

  const AttendanceReminderBanner({super.key, required this.lessons});

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final t = context.strings;
    final shown = lessons.take(_maxShown).toList();
    final overflow = lessons.length - shown.length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: theme.colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Text(
                t.attendanceReminder,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(t.attendanceReminderMessage, style: theme.textTheme.bodySmall),
          const SizedBox(height: 10),
          ...shown.map(
            (lesson) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () => context.go('/lessons/${lesson.lessonId}'),
                child: Row(
                  children: [
                    Icon(Icons.chevron_right_rounded,
                        size: 16, color: theme.colorScheme.error),
                    Expanded(
                      child: Text(
                        t.lessonWithTutor(
                          (lesson.subjectName ?? '').isEmpty
                              ? t.lesson
                              : lesson.subjectName!,
                          lesson.tutorName,
                        ),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (overflow > 0)
            Text(
              t.moreSessionsNeedAttention(overflow),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
