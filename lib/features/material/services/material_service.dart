import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/material_models.dart';

class MaterialService {
  final ApiClient apiClient;

  MaterialService(this.apiClient);

  Future<List<MaterialSectionModel>> getSections(int availabilityId) async {
    final res = await apiClient.dio.get('/api/material/availability/$availabilityId');
    return ApiUtils.list(res.data)
        .map((e) => MaterialSectionModel.fromJson(e))
        .toList();
  }

  Future<MaterialSectionModel> createSection({
    required int availabilityId,
    required String title,
    String? description,
  }) async {
    final res = await apiClient.dio.post(
      '/api/material/availability/$availabilityId/sections',
      data: {'title': title, 'description': description},
    );
    return MaterialSectionModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<MaterialSectionModel> updateSection({
    required int sectionId,
    required String title,
    String? description,
  }) async {
    final res = await apiClient.dio.put(
      '/api/material/sections/$sectionId',
      data: {'title': title, 'description': description},
    );
    return MaterialSectionModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<void> deleteSection(int sectionId) async {
    await apiClient.dio.delete('/api/material/sections/$sectionId');
  }

  Future<MaterialItemModel> createMaterialItem({
    required int sectionId,
    required String title,
    String? description,
    String? fileUrl,
    String? filePath,
  }) async {
    final formData = FormData.fromMap({
      'Title': title,
      if (description != null) 'Description': description,
      if (fileUrl != null) 'FileUrl': fileUrl,
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    final res = await apiClient.dio.post(
      '/api/material/sections/$sectionId/items',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return MaterialItemModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<MaterialItemModel> updateMaterialItem({
    required int materialId,
    required String title,
    String? description,
    String? fileUrl,
    String? filePath,
  }) async {
    final formData = FormData.fromMap({
      'Title': title,
      if (description != null) 'Description': description,
      if (fileUrl != null) 'FileUrl': fileUrl,
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    final res = await apiClient.dio.put(
      '/api/material/items/$materialId',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return MaterialItemModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<void> deleteMaterialItem(int materialId) async {
    await apiClient.dio.delete('/api/material/items/$materialId');
  }
}
