import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../models/material_models.dart';
import '../services/material_service.dart';

class MaterialProvider extends ChangeNotifier {
  final MaterialService materialService;

  MaterialProvider({required this.materialService});

  bool loading = false;
  String? error;

  final Map<int, List<CourseMaterialSectionModel>> courseMaterials = {};
  final Map<int, DateTime> _loadedAt = {};
  final Map<int, Future<void>> _loads = {};
  static const Duration cacheDuration = Duration(seconds: 45);

  void clearSessionData() {
    loading = false;
    error = null;
    courseMaterials.clear();
    _loadedAt.clear();
    _loads.clear();
    notifyListeners();
  }

  Future<void> loadCourseMaterials(int availabilityId, {bool force = false}) {
    if (!force && _loads[availabilityId] != null) {
      return _loads[availabilityId]!;
    }
    if (!force &&
        courseMaterials.containsKey(availabilityId) &&
        _isFresh(_loadedAt[availabilityId])) {
      return Future.value();
    }

    final load = _guard(() async {
      courseMaterials[availabilityId] =
          await materialService.getCourseMaterials(availabilityId);
      _loadedAt[availabilityId] = DateTime.now();
    });
    _loads[availabilityId] = load;
    return load.whenComplete(() {
      if (_loads[availabilityId] == load) _loads.remove(availabilityId);
    });
  }

  Future<void> createMaterialSection({
    required int availabilityId,
    required String title,
    String? description,
  }) async {
    await _guard(() async {
      await materialService.createMaterialSection(
        availabilityId: availabilityId,
        title: title,
        description: description,
      );
      await _reload(availabilityId);
    });
  }

  Future<void> updateMaterialSection({
    required int availabilityId,
    required int sectionId,
    required String title,
    String? description,
  }) async {
    await _guard(() async {
      await materialService.updateMaterialSection(
        sectionId: sectionId,
        title: title,
        description: description,
      );
      await _reload(availabilityId);
    });
  }

  Future<void> deleteMaterialSection({
    required int availabilityId,
    required int sectionId,
  }) async {
    await _guard(() async {
      await materialService.deleteMaterialSection(sectionId);
      await _reload(availabilityId);
    });
  }

  Future<void> createMaterialItem({
    required int availabilityId,
    required int sectionId,
    required String title,
    String? description,
    String? linkUrl,
    String? filePath,
  }) async {
    await _guard(() async {
      await materialService.createMaterialItem(
        availabilityId: availabilityId,
        sectionId: sectionId,
        title: title,
        description: description,
        linkUrl: linkUrl,
        filePath: filePath,
      );
      await _reload(availabilityId);
    });
  }

  Future<void> updateMaterialItem({
    required int availabilityId,
    required int materialId,
    required String title,
    String? description,
    String? linkUrl,
    String? filePath,
    int? sectionId,
  }) async {
    await _guard(() async {
      await materialService.updateMaterialItem(
        materialId: materialId,
        title: title,
        description: description,
        linkUrl: linkUrl,
        filePath: filePath,
        sectionId: sectionId,
      );
      await _reload(availabilityId);
    });
  }

  Future<void> deleteMaterialItem({
    required int availabilityId,
    required int materialId,
  }) async {
    await _guard(() async {
      await materialService.deleteMaterialItem(materialId);
      await _reload(availabilityId);
    });
  }

  Future<void> _reload(int availabilityId) async {
    courseMaterials[availabilityId] =
        await materialService.getCourseMaterials(availabilityId);
    _loadedAt[availabilityId] = DateTime.now();
  }

  bool _isFresh(DateTime? loadedAt) {
    if (loadedAt == null) return false;
    return DateTime.now().difference(loadedAt) < cacheDuration;
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
