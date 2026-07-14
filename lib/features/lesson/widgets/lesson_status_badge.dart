import 'package:flutter/material.dart';

import '../../../core/ui_text.dart';
import '../models/lesson_models.dart';

class LessonStatusBadge extends StatelessWidget {
  final LessonModel lesson;

  const LessonStatusBadge({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final theme = Theme.of(context);
    final (label, color) = switch (lesson.timeState) {
      LessonTimeState.upcoming => (t.startsLater, Colors.blueGrey),
      LessonTimeState.ongoing => (t.lessonStartedCompletionLater, Colors.blue),
      LessonTimeState.endedNeedsAction => (t.endedTakeAttendance, Colors.orange),
      LessonTimeState.completed => (t.status(lesson.status), Colors.green),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
