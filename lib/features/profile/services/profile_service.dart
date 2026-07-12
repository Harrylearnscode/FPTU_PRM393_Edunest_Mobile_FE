import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/profile_models.dart';

class ProfileService {
  final ApiClient apiClient;

  ProfileService(this.apiClient);

  Future<ProfileModel> getMyProfile() async {
    final res = await apiClient.dio.get('/api/profile/me');
    return ProfileModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<ProfileModel> updateMyProfile({
    required String name,
    String? phone,
    String? tutorBio,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'phone': phone,
      'tutorBio': tutorBio,
    };
    body.removeWhere(
      (key, value) =>
          value == null || (value is String && value.trim().isEmpty),
    );

    final res = await apiClient.dio.put('/api/profile/me', data: body);
    return ProfileModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<String?> uploadAvatar(String imagePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(imagePath),
    });
    final res = await apiClient.dio.put(
      '/api/profile/avatar',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return ApiUtils.asMap(res.data)['avatarUrl']?.toString();
  }

  Future<void> deleteAvatar() async {
    await apiClient.dio.delete('/api/profile/avatar');
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    final response = await apiClient.dio.get('/api/User/$userId');
    return response.data as Map<String, dynamic>;
  }
}
