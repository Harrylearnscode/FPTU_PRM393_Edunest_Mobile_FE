import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/notification_models.dart';

class NotificationService {
  final ApiClient apiClient;

  NotificationService(this.apiClient);

  Future<List<NotificationModel>> getMyNotifications({
    bool unreadOnly = false,
    int take = 50,
  }) async {
    final res = await apiClient.dio.get(
      '/api/notification/me',
      queryParameters: {
        'unreadOnly': unreadOnly,
        'take': take,
      },
    );
    return ApiUtils.list(res.data)
        .map((item) => NotificationModel.fromJson(item))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final res = await apiClient.dio.get('/api/notification/unread-count');
    return _asInt(ApiUtils.asMap(res.data)['unreadCount']);
  }

  Future<void> markAsRead(int notificationId) async {
    await apiClient.dio.post('/api/notification/$notificationId/read');
  }

  Future<void> markAllAsRead() async {
    await apiClient.dio.post('/api/notification/read-all');
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
