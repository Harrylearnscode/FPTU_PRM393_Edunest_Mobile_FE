import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../../core/widgets/error_banner.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/lesson_models.dart';
import '../providers/lesson_provider.dart';
import '../widgets/attendance_list.dart';
import '../widgets/lesson_status_badge.dart';
import '../widgets/meeting_link_card.dart';

class LessonDetailScreen extends StatefulWidget {
  final int lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().loadLessonDetail(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<LessonProvider>();
    final auth = context.watch<AuthProvider>();
    final t = context.strings;
    final lesson = data.selectedLesson;
    final isLoading = data.loading && lesson == null;
    final dateFormat = DateFormat('EEE, MMM d, yyyy - HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text(t.openLessonDetail)),
      body: RefreshIndicator(
        onRefresh: () => context.read<LessonProvider>().loadLessonDetail(widget.lessonId),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ErrorBanner(data.error),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (lesson != null) ...[
              Text(
                t.lessonWithTutor(
                  (lesson.subjectName ?? '').isEmpty ? t.lesson : lesson.subjectName!,
                  lesson.tutorName,
                ),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '${dateFormat.format(lesson.startTime)} - ${DateFormat('HH:mm').format(lesson.endTime)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              LessonStatusBadge(lesson: lesson),
              const SizedBox(height: 16),
              MeetingLinkCard(lesson: lesson),
              const SizedBox(height: 16),
              AttendanceList(lesson: lesson),
              if (auth.isTutor) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: lesson.timeState == LessonTimeState.endedNeedsAction
                        ? () => context.read<LessonProvider>().completeLesson(lesson.lessonId)
                        : null,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      lesson.timeState == LessonTimeState.completed
                          ? t.completed
                          : t.endedTakeAttendance,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
