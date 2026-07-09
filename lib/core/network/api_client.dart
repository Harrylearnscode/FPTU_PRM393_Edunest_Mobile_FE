import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = String.fromEnvironment(
    'EDUNEST_API_BASE_URL',
    defaultValue: 'https://edunest-backend-prm.onrender.com',
  );
  static const String appVersion = String.fromEnvironment(
    'EDUNEST_APP_VERSION',
    defaultValue: '0.2.0+2',
  );
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';

  final SharedPreferences prefs;
  late final Dio dio;

  VoidCallback? onUnauthorized;
  bool _unauthorizedHandled = false;

  ApiClient({required this.prefs}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: const {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = prefs.getString(tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final statusCode = error.response?.statusCode;
          final path = error.requestOptions.path;

          final isAuthEndpoint = path.contains('/api/auth/login') ||
              path.contains('/api/auth/register') ||
              path.contains('/api/auth/verify-email') ||
              path.contains('/api/auth/resend-code');

          if (statusCode == 401 && !isAuthEndpoint) {
            final currentToken = prefs.getString(tokenKey);
            if (currentToken != null &&
                currentToken.isNotEmpty &&
                !_unauthorizedHandled) {
              _unauthorizedHandled = true;
              onUnauthorized?.call();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  String? get token => prefs.getString(tokenKey);
  String? get refreshTokenValue => prefs.getString(refreshTokenKey);

  bool get isLoggedIn {
    final value = token;
    return value != null && value.isNotEmpty;
  }

  Future<void> setToken(String? value) async {
    if (value == null || value.isEmpty) {
      await prefs.remove(tokenKey);
      dio.options.headers.remove('Authorization');
    } else {
      await prefs.setString(tokenKey, value);
      dio.options.headers['Authorization'] = 'Bearer $value';
      _unauthorizedHandled = false;
    }
  }

  Future<void> setRefreshToken(String? value) async {
    if (value == null || value.isEmpty) {
      await prefs.remove(refreshTokenKey);
    } else {
      await prefs.setString(refreshTokenKey, value);
    }
  }

  Future<void> clearTokens() async {
    await prefs.remove(tokenKey);
    await prefs.remove(refreshTokenKey);
    dio.options.headers.remove('Authorization');
  }
}
