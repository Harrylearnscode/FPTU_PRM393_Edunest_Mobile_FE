import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../models/lesson_models.dart';
import '../services/lesson_service.dart';

class LessonProvider extends ChangeNotifier {
  final LessonService lessonService;

  LessonProvider({required this.lessonService});

  bool loading = false;
  String? error;

  List<LessonModel> lessons = [];
  LessonModel? selectedLesson;

  void clearSessionData() {
    loading = false;
    error = null;
    lessons = [];
    selectedLesson = null;
    notifyListeners();
  }

  List<LessonModel> get lessonsNeedingAttention => lessons
      .where((lesson) => lesson.timeState == LessonTimeState.endedNeedsAction)
      .toList();

  Future<void> loadLessons() async {
    await _guard(() async {
      lessons = await lessonService.getMyLessons();
    });
  }

  Future<void> loadLessonDetail(int lessonId) async {
    await _guard(() async {
      selectedLesson = await lessonService.getLessonById(lessonId);
    });
  }

  Future<void> updateMeetingLink(int lessonId, String meetingLink) async {
    await _guard(() async {
      final updated = await lessonService.updateMeetingLink(
        lessonId: lessonId,
        meetingLink: meetingLink,
      );
      _applyUpdatedLesson(updated);
    });
  }

  Future<void> markAttendance({
    required int lessonId,
    required int studentUserId,
    required String status,
  }) async {
    await _guard(() async {
      final updated = await lessonService.markAttendance(
        lessonId: lessonId,
        studentUserId: studentUserId,
        status: status,
      );
      _applyUpdatedLesson(updated);
    });
  }

  Future<void> completeLesson(int lessonId) async {
    await _guard(() async {
      final updated = await lessonService.completeLesson(lessonId);
      _applyUpdatedLesson(updated);
    });
  }

  void _applyUpdatedLesson(LessonModel updated) {
    selectedLesson = updated;
    final index = lessons.indexWhere((l) => l.lessonId == updated.lessonId);
    if (index >= 0) {
      lessons[index] = updated;
    } else {
      lessons.add(updated);
    }
  }

  Future<void> _guard(Future<void> Function() task) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await task();
    } catch (e) {
      error = ApiUtils.apiErrorMessage(e);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
