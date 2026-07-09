import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await apiClient.dio.post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = ApiUtils.asMap(res.data);

    await apiClient.setToken(data['accessToken']?.toString());
    await apiClient.setRefreshToken(data['refreshToken']?.toString());

    return data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    String? school,
    String? bio,
    String? address,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
      'school': school,
      'bio': bio,
      'address': address,
    };

    body.removeWhere((key, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });

    final res = await apiClient.dio.post(
      '/api/auth/register',
      data: body,
    );

    return ApiUtils.asMap(res.data);
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    final res = await apiClient.dio.post(
      '/api/auth/verify-email',
      data: {
        'email': email,
        'code': code,
      },
    );

    return ApiUtils.asMap(res.data);
  }

  Future<Map<String, dynamic>> resendVerificationCode({
    required String email,
  }) async {
    final res = await apiClient.dio.post(
      '/api/auth/resend-code',
      data: {
        'email': email,
      },
    );

    return ApiUtils.asMap(res.data);
  }
}
