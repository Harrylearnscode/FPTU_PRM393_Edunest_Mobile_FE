import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/material_models.dart';

class MaterialService {
  final ApiClient apiClient;

  MaterialService(this.apiClient);

  Future<List<CourseMaterialSectionModel>> getCourseMaterials(
      int availabilityId) async {
    try {
      final res = await ApiUtils.tryRequests([
        () => apiClient.dio.get('/api/material/availability/$availabilityId'),
        () => apiClient.dio.get('/api/materials/availability/$availabilityId'),
        () => apiClient.dio
            .get('/api/course-materials/availability/$availabilityId'),
        () => apiClient.dio.get('/api/material',
            queryParameters: {'availabilityId': availabilityId}),
      ]);
      return _materialSectionsFromResponse(res.data,
          availabilityId: availabilityId);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404)
        return <CourseMaterialSectionModel>[];
      rethrow;
    }
  }

  Future<CourseMaterialSectionModel> createMaterialSection({
    required int availabilityId,
    required String title,
    String? description,
  }) async {
    final body = {'title': title.trim(), 'description': description?.trim()}
      ..removeWhere((_, value) => value == null || value.toString().isEmpty);

    final res = await ApiUtils.tryRequests([
      () => apiClient.dio.post(
          '/api/material/availability/$availabilityId/sections',
          data: body),
      () => apiClient.dio.post(
          '/api/materials/availability/$availabilityId/sections',
          data: body),
      () => apiClient.dio.post(
          '/api/course-materials/availability/$availabilityId/sections',
          data: body),
    ]);
    return CourseMaterialSectionModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<CourseMaterialSectionModel> updateMaterialSection({
    required int sectionId,
    required String title,
    String? description,
  }) async {
    final body = {'title': title.trim(), 'description': description?.trim()}
      ..removeWhere((_, value) => value == null || value.toString().isEmpty);

    final res = await ApiUtils.tryRequests([
      () => apiClient.dio.put('/api/material/sections/$sectionId', data: body),
      () => apiClient.dio.put('/api/materials/sections/$sectionId', data: body),
      () => apiClient.dio
          .put('/api/course-materials/sections/$sectionId', data: body),
    ]);
    return CourseMaterialSectionModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<void> deleteMaterialSection(int sectionId) async {
    await ApiUtils.tryRequests([
      () => apiClient.dio.delete('/api/material/sections/$sectionId'),
      () => apiClient.dio.delete('/api/materials/sections/$sectionId'),
      () => apiClient.dio.delete('/api/course-materials/sections/$sectionId'),
    ]);
  }

  Future<CourseMaterialItemModel> createMaterialItem({
    required int availabilityId,
    required int sectionId,
    required String title,
    String? description,
    String? linkUrl,
    String? filePath,
  }) async {
    final hasFile = filePath != null && filePath.trim().isNotEmpty;
    Future<FormData> data() async => FormData.fromMap({
          'availabilityId': availabilityId,
          'sectionId': sectionId,
          'title': title.trim(),
          if (description != null && description.trim().isNotEmpty)
            'description': description.trim(),
          if (linkUrl != null && linkUrl.trim().isNotEmpty)
            'fileUrl': linkUrl.trim(),
          if (linkUrl != null && linkUrl.trim().isNotEmpty)
            'linkUrl': linkUrl.trim(),
          if (hasFile) 'file': await MultipartFile.fromFile(filePath.trim()),
        });

    final res = await ApiUtils.tryRequests([
      () async => apiClient.dio.post('/api/material/sections/$sectionId/items',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
      () async => apiClient.dio.post('/api/materials/sections/$sectionId/items',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
      () async => apiClient.dio.post(
          '/api/course-materials/sections/$sectionId/items',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
      () async => apiClient.dio.post(
          '/api/material/availability/$availabilityId',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
    ]);
    return CourseMaterialItemModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<CourseMaterialItemModel> updateMaterialItem({
    required int materialId,
    required String title,
    String? description,
    String? linkUrl,
    String? filePath,
    int? sectionId,
  }) async {
    final hasFile = filePath != null && filePath.trim().isNotEmpty;
    Future<FormData> data() async => FormData.fromMap({
          'title': title.trim(),
          if (sectionId != null) 'sectionId': sectionId,
          if (description != null && description.trim().isNotEmpty)
            'description': description.trim(),
          if (linkUrl != null && linkUrl.trim().isNotEmpty)
            'fileUrl': linkUrl.trim(),
          if (linkUrl != null && linkUrl.trim().isNotEmpty)
            'linkUrl': linkUrl.trim(),
          if (hasFile) 'file': await MultipartFile.fromFile(filePath.trim()),
        });

    final res = await ApiUtils.tryRequests([
      () async => apiClient.dio.put('/api/material/items/$materialId',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
      () async => apiClient.dio.put('/api/materials/items/$materialId',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
      () async => apiClient.dio.put('/api/course-materials/items/$materialId',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
      () async => apiClient.dio.put('/api/material/$materialId',
          data: await data(),
          options: Options(contentType: 'multipart/form-data')),
    ]);
    return CourseMaterialItemModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<void> deleteMaterialItem(int materialId) async {
    await ApiUtils.tryRequests([
      () => apiClient.dio.delete('/api/material/items/$materialId'),
      () => apiClient.dio.delete('/api/materials/items/$materialId'),
      () => apiClient.dio.delete('/api/course-materials/items/$materialId'),
      () => apiClient.dio.delete('/api/material/$materialId'),
    ]);
  }

  List<CourseMaterialSectionModel> _materialSectionsFromResponse(dynamic data,
      {required int availabilityId}) {
    final map = ApiUtils.asMap(data);
    final rawSections =
        map['sections'] ?? map['Sections'] ?? map['data'] ?? map['items'];
    if (rawSections is List) {
      final rows = rawSections.map((item) => ApiUtils.asMap(item)).toList();
      final sectionLike = rows.any((row) =>
          row.containsKey('items') ||
          row.containsKey('materials') ||
          row.containsKey('sectionId') ||
          row.containsKey('materialSectionId') ||
          row.containsKey('courseMaterialSectionId'));
      if (sectionLike) {
        return rows
            .map((row) => CourseMaterialSectionModel.fromJson(row))
            .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      }
    }
    final flatItems = ApiUtils.list(data)
        .map((item) => CourseMaterialItemModel.fromJson(item))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (flatItems.isEmpty) return <CourseMaterialSectionModel>[];
    return [
      CourseMaterialSectionModel.flat(
          availabilityId: availabilityId, items: flatItems)
    ];
  }
}
