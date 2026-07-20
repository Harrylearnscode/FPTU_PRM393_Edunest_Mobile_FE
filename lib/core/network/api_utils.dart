import 'package:dio/dio.dart';

class ApiUtils {
  static String apiErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final validationMessage = _validationErrorMessage(data['errors']);
        if (validationMessage != null) {
          final message = data['message']?.toString();
          return message == null || message.trim().isEmpty
              ? validationMessage
              : '$message $validationMessage';
        }
        if (data['message'] != null) return data['message'].toString();
        if (data['title'] != null) return data['title'].toString();
        return data.toString();
      }
      if (data is String && data.trim().isNotEmpty) return data;
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return 'Request failed with status code $statusCode';
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }

  static String? _validationErrorMessage(dynamic errors) {
    if (errors == null) return null;
    if (errors is Map) {
      final messages = <String>[];
      for (final entry in errors.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        final detail = value is List ? value.join(', ') : value.toString();
        if (detail.trim().isNotEmpty) messages.add('$key: $detail');
      }
      return messages.isEmpty ? null : messages.join(' ');
    }
    if (errors is List) {
      final text = errors.map((item) => item.toString()).join(' ');
      return text.trim().isEmpty ? null : text;
    }
    final text = errors.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String dateOnlyIso(DateTime value) {
    final dateOnly = DateTime(value.year, value.month, value.day);
    return dateOnly.toIso8601String();
  }

  static String normalizeTime(String value) {
    final text = value.trim();
    if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(text)) return text;
    if (RegExp(r'^\d{2}:\d{2}$').hasMatch(text)) return '$text:00';
    return text;
  }

  static Map<String, dynamic> asMap(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) return {'message': data};
    return {'data': data};
  }

  static List<Map<String, dynamic>> list(dynamic data) {
    if (data == null) return <Map<String, dynamic>>[];
    if (data is List) return data.map((e) => asMap(e)).toList();
    if (data is Map) {
      final map = asMap(data);
      final items = map['data'] ?? map['items'] ?? map['result'];
      if (items is List) return items.map((e) => asMap(e)).toList();
      return <Map<String, dynamic>>[map];
    }
    return <Map<String, dynamic>>[];
  }

  static List<dynamic> asList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final possibleKeys = ['data', 'items', 'result', 'results', r'$values'];
      for (final key in possibleKeys) {
        final value = data[key];
        if (value is List) return value;
        if (value is Map<String, dynamic> && value[r'$values'] is List) {
          return value[r'$values'] as List;
        }
      }
    }
    return [];
  }

  static Future<Response<dynamic>> tryRequests(
    List<Future<Response<dynamic>> Function()> requests,
  ) async {
    DioException? fallbackError;
    for (final request in requests) {
      try {
        return await request();
      } on DioException catch (error) {
        final statusCode = error.response?.statusCode;
        if (statusCode != 404 && statusCode != 405) rethrow;
        fallbackError = error;
      }
    }
    if (fallbackError != null) throw fallbackError;
    throw Exception('No API request was configured.');
  }
}
