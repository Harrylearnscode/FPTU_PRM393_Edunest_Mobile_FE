import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../models/lesson_model.dart';
import '../services/lesson_service.dart';

class LessonProvider extends ChangeNotifier {
  final LessonService lessonService;

  LessonProvider({required this.lessonService});

  bool loading = false;
  String? error;

  List<LessonModel> lessons = [];
  final Map<int, LessonDetailModel> lessonDetails = {};

  void clearSessionData() {
    loading = false;
    error = null;
    lessons = [];
    lessonDetails.clear();
    notifyListeners();
  }

  Future<void> loadLessons() async {
    await _guard(() async {
      lessons = await lessonService.getMyLessons();
    });
  }

  Future<void> completeLesson(int lessonId) async {
    await _guard(() async {
      await lessonService.completeLesson(lessonId);
      lessons = await lessonService.getMyLessons();
    });
  }

  Future<void> loadLessonDetail(int lessonId) async {
    await _guard(() async {
      lessonDetails[lessonId] = await lessonService.getLessonDetail(lessonId);
    });
  }

  Future<void> setLessonMeetingLink({
    required int lessonId,
    required String meetingLink,
  }) async {
    await _guard(() async {
      lessonDetails[lessonId] = await lessonService.setMeetingLink(
        lessonId: lessonId,
        meetingLink: meetingLink,
      );
    });
  }

  Future<void> completeLessonGroup(int lessonId) async {
    await _guard(() async {
      final detail = await lessonService.completeLessonGroup(lessonId);
      lessonDetails[lessonId] = detail;
      lessons = await lessonService.getMyLessons();
    });
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
