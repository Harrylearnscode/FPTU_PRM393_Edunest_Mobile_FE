import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../../core/widgets/error_banner.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/lesson_provider.dart';
import '../widgets/attendance_reminder_banner.dart';
import '../widgets/lesson_list_tile.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().loadLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<LessonProvider>();
    final auth = context.watch<AuthProvider>();
    final t = context.strings;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(auth.isTutor ? t.myTeachingLessons : t.myLearningLessons),
        actions: [
          IconButton(
            onPressed: data.loading ? null : () => context.read<LessonProvider>().loadLessons(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<LessonProvider>().loadLessons(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ErrorBanner(data.error),
            AttendanceReminderBanner(lessons: data.lessonsNeedingAttention),
            if (data.loading && data.lessons.isEmpty)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!data.loading && data.lessons.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                alignment: Alignment.center,
                child: Text(
                  t.noLessonsYet,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
            ...data.lessons.map((lesson) => LessonListTile(lesson: lesson)),
          ],
        ),
      ),
    );
  }
}
