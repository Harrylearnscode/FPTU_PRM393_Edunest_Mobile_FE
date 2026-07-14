import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/lesson_models.dart';
import '../providers/lesson_provider.dart';

const List<String> _attendanceOptions = ['Present', 'Absent', 'Late'];

class AttendanceList extends StatelessWidget {
  final LessonModel lesson;

  const AttendanceList({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;
    final auth = context.watch<AuthProvider>();

    if (lesson.students.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.students(lesson.students.length),
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...lesson.students.map((student) {
            final isSelf = auth.userId == student.studentUserId;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      student.studentName,
                      style: TextStyle(
                        fontWeight: isSelf ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (auth.isTutor)
                    DropdownButton<String>(
                      value: _attendanceOptions.contains(student.status)
                          ? student.status
                          : null,
                      hint: Text(t.status(student.status)),
                      underline: const SizedBox.shrink(),
                      items: _attendanceOptions
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(t.status(option)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<LessonProvider>().markAttendance(
                              lessonId: lesson.lessonId,
                              studentUserId: student.studentUserId,
                              status: value,
                            );
                      },
                    )
                  else
                    _AttendanceChip(status: student.status),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AttendanceChip extends StatelessWidget {
  final String status;

  const _AttendanceChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(t.status(status), style: theme.textTheme.labelSmall),
    );
  }
}
