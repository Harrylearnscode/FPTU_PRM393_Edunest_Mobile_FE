import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../models/material_models.dart';
import '../services/material_service.dart';

class MaterialProvider extends ChangeNotifier {
  final MaterialService materialService;

  MaterialProvider({required this.materialService});

  bool loading = false;
  String? error;

  Map<int, List<MaterialSectionModel>> sectionsByAvailability = {};
  int? selectedAvailabilityId;

  List<MaterialSectionModel> get selectedSections =>
      sectionsByAvailability[selectedAvailabilityId] ?? const [];

  void clearSessionData() {
    loading = false;
    error = null;
    sectionsByAvailability = {};
    selectedAvailabilityId = null;
    notifyListeners();
  }

  void selectAvailability(int availabilityId) {
    selectedAvailabilityId = availabilityId;
    notifyListeners();
    loadSections(availabilityId);
  }

  void clearSelection() {
    selectedAvailabilityId = null;
    notifyListeners();
  }

  Future<void> loadSections(int availabilityId) async {
    await _guard(() async {
      sectionsByAvailability[availabilityId] =
          await materialService.getSections(availabilityId);
    });
  }

  Future<void> addSection({
    required int availabilityId,
    required String title,
    String? description,
  }) async {
    await _guard(() async {
      await materialService.createSection(
        availabilityId: availabilityId,
        title: title,
        description: description,
      );
      sectionsByAvailability[availabilityId] =
          await materialService.getSections(availabilityId);
    });
  }

  Future<void> editSection({
    required int availabilityId,
    required int sectionId,
    required String title,
    String? description,
  }) async {
    await _guard(() async {
      await materialService.updateSection(
        sectionId: sectionId,
        title: title,
        description: description,
      );
      sectionsByAvailability[availabilityId] =
          await materialService.getSections(availabilityId);
    });
  }

  Future<void> removeSection({
    required int availabilityId,
    required int sectionId,
  }) async {
    await _guard(() async {
      await materialService.deleteSection(sectionId);
      sectionsByAvailability[availabilityId] =
          await materialService.getSections(availabilityId);
    });
  }

  Future<void> addMaterialItem({
    required int availabilityId,
    required int sectionId,
    required String title,
    String? description,
    String? fileUrl,
    String? filePath,
  }) async {
    await _guard(() async {
      await materialService.createMaterialItem(
        sectionId: sectionId,
        title: title,
        description: description,
        fileUrl: fileUrl,
        filePath: filePath,
      );
      sectionsByAvailability[availabilityId] =
          await materialService.getSections(availabilityId);
    });
  }

  Future<void> editMaterialItem({
    required int availabilityId,
    required int materialId,
    required String title,
    String? description,
    String? fileUrl,
    String? filePath,
  }) async {
    await _guard(() async {
      await materialService.updateMaterialItem(
        materialId: materialId,
        title: title,
        description: description,
        fileUrl: fileUrl,
        filePath: filePath,
      );
      sectionsByAvailability[availabilityId] =
          await materialService.getSections(availabilityId);
    });
  }

  Future<void> removeMaterialItem({
    required int availabilityId,
    required int materialId,
  }) async {
    await _guard(() async {
      await materialService.deleteMaterialItem(materialId);
      sectionsByAvailability[availabilityId] =
          await materialService.getSections(availabilityId);
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
