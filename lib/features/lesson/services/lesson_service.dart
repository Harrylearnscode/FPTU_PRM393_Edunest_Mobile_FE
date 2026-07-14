import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/lesson_models.dart';

class LessonService {
  final ApiClient apiClient;

  LessonService(this.apiClient);

  Future<List<LessonModel>> getMyLessons() async {
    final res = await apiClient.dio.get('/api/lesson/me');
    return ApiUtils.list(res.data).map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<LessonModel> getLessonById(int lessonId) async {
    final res = await apiClient.dio.get('/api/lesson/$lessonId');
    return LessonModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<LessonModel> updateMeetingLink({
    required int lessonId,
    required String meetingLink,
  }) async {
    final res = await apiClient.dio.patch(
      '/api/lesson/$lessonId/meeting-link',
      data: {'meetingLink': meetingLink},
    );
    return LessonModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<LessonModel> markAttendance({
    required int lessonId,
    required int studentUserId,
    required String status,
  }) async {
    final res = await apiClient.dio.patch(
      '/api/lesson/$lessonId/attendance',
      data: {'studentUserId': studentUserId, 'status': status},
    );
    return LessonModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<LessonModel> completeLesson(int lessonId) async {
    final res = await apiClient.dio.patch('/api/lesson/$lessonId/complete');
    return LessonModel.fromJson(ApiUtils.asMap(res.data));
  }
}
