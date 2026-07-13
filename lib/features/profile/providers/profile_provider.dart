import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../models/profile_models.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService profileService;

  ProfileProvider({required this.profileService});

  bool loading = false;
  String? error;

  ProfileModel? profile;
  final Map<int, String> _userNameCache = {};

  String userName(int userId) => _userNameCache[userId] ?? 'User #$userId';

  void clearSessionData() {
    loading = false;
    error = null;
    profile = null;
    _userNameCache.clear();
    notifyListeners();
  }

  void cacheUserName(int userId, String name) {
    _userNameCache[userId] = name;
    notifyListeners();
  }

  Future<void> loadUserName(int userId) async {
    if (_userNameCache.containsKey(userId)) return;
    try {
      final user = await profileService.getUserById(userId);
      final name = (user['fullName'] ?? user['name'] ?? '').toString().trim();
      if (name.isNotEmpty) {
        _userNameCache[userId] = name;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> loadProfile() async {
    await _guard(() async {
      profile = await profileService.getMyProfile();
      if (profile != null) _userNameCache[profile!.userId] = profile!.name;
    });
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
    String? tutorBio,
  }) async {
    await _guard(() async {
      profile = await profileService.updateMyProfile(
        name: name,
        phone: phone,
        tutorBio: tutorBio,
      );
    });
  }

  Future<void> uploadAvatar(String imagePath) async {
    await _guard(() async {
      await profileService.uploadAvatar(imagePath);
      profile = await profileService.getMyProfile();
    });
  }

  Future<void> deleteAvatar() async {
    await _guard(() async {
      await profileService.deleteAvatar();
      profile = await profileService.getMyProfile();
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
