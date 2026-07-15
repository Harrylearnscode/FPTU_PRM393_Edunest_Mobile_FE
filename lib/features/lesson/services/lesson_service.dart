import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/lesson_model.dart';

class LessonService {
  final ApiClient apiClient;

  LessonService(this.apiClient);

  Future<List<LessonModel>> getMyLessons() async {
    final res = await apiClient.dio.get('/api/lesson/me');
    return ApiUtils.list(res.data).map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<LessonDetailModel> getLessonDetail(int lessonId) async {
    final res = await apiClient.dio.get('/api/lesson/$lessonId/detail');
    return LessonDetailModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<LessonDetailModel> setMeetingLink(
      {required int lessonId, required String meetingLink}) async {
    final res = await apiClient.dio.post(
      '/api/lesson/$lessonId/meeting-link',
      data: {'meetingLink': meetingLink},
    );
    return LessonDetailModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<LessonDetailModel> completeLessonGroup(int lessonId) async {
    final res =
        await apiClient.dio.post('/api/lesson/$lessonId/complete-group');
    return LessonDetailModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<LessonModel> completeLesson(int lessonId, {String? note}) async {
    final body = <String, dynamic>{'note': note};
    body.removeWhere((key, value) =>
        value == null || (value is String && value.trim().isEmpty));

    final res =
        await apiClient.dio.post('/api/lesson/$lessonId/complete', data: body);
    return LessonModel.fromJson(ApiUtils.asMap(res.data));
  }
}
