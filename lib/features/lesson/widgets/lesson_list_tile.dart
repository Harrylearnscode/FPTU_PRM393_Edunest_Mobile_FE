import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/ui_text.dart';
import '../models/lesson_models.dart';
import 'lesson_status_badge.dart';
import 'meeting_link_card.dart';

class LessonListTile extends StatelessWidget {
  final LessonModel lesson;

  const LessonListTile({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;
    final dateFormat = DateFormat('EEE, MMM d - HH:mm');
    final canQuickOpen = lesson.timeState == LessonTimeState.ongoing &&
        (lesson.meetingLink ?? '').trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.go('/lessons/${lesson.lessonId}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.lessonWithTutor(
                        (lesson.subjectName ?? '').isEmpty
                            ? t.lesson
                            : lesson.subjectName!,
                        lesson.tutorName,
                      ),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateFormat.format(lesson.startTime),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    LessonStatusBadge(lesson: lesson),
                  ],
                ),
              ),
              if (canQuickOpen)
                IconButton(
                  tooltip: t.open,
                  onPressed: () =>
                      MeetingLinkCard.openMeetingLink(context, lesson.meetingLink),
                  icon: Icon(Icons.videocam_rounded, color: theme.colorScheme.primary),
                )
              else
                const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
