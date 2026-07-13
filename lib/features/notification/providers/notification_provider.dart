import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../models/notification_models.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService notificationService;

  NotificationProvider({required this.notificationService});

  bool loading = false;
  String? error;

  List<NotificationModel> notifications = [];
  int unreadNotificationCount = 0;

  void clearSessionData() {
    loading = false;
    error = null;
    notifications = [];
    unreadNotificationCount = 0;
    notifyListeners();
  }

  Future<void> loadNotifications({bool unreadOnly = false}) async {
    await _guard(() async {
      notifications = await notificationService.getMyNotifications(
        unreadOnly: unreadOnly,
      );
      unreadNotificationCount = await notificationService.getUnreadCount();
    });
  }

  Future<void> loadUnreadNotificationCount() async {
    try {
      unreadNotificationCount = await notificationService.getUnreadCount();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    await _guard(() async {
      await notificationService.markAsRead(notificationId);
      notifications = notifications.map((item) {
        if (item.notificationId != notificationId) return item;
        return item.copyWith(isRead: true, readAt: DateTime.now());
      }).toList();
      unreadNotificationCount = await notificationService.getUnreadCount();
    });
  }

  Future<void> markAllNotificationsAsRead() async {
    await _guard(() async {
      await notificationService.markAllAsRead();
      notifications = notifications
          .map((item) => item.copyWith(isRead: true, readAt: DateTime.now()))
          .toList();
      unreadNotificationCount = 0;
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
