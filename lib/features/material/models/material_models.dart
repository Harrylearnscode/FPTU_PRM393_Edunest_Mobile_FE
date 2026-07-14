class MaterialItemModel {
  final int materialId;
  final int? sectionId;
  final int availabilityId;
  final String title;
  final String? description;
  final String? fileUrl;
  final String? fileName;
  final String? contentType;
  final int? fileSize;
  final String materialType;
  final DateTime createdAt;

  MaterialItemModel({
    required this.materialId,
    required this.sectionId,
    required this.availabilityId,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.fileName,
    required this.contentType,
    required this.fileSize,
    required this.materialType,
    required this.createdAt,
  });

  factory MaterialItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialItemModel(
      materialId: _asInt(json['materialId'] ?? json['id']),
      sectionId: _asOptionalInt(json['sectionId']),
      availabilityId: _asInt(json['availabilityId']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      fileUrl: json['fileUrl']?.toString(),
      fileName: json['fileName']?.toString(),
      contentType: json['contentType']?.toString(),
      fileSize: _asOptionalInt(json['fileSize']),
      materialType: json['materialType']?.toString() ?? 'File',
      createdAt: _asDate(json['createdAt']),
    );
  }
}

class MaterialSectionModel {
  final int sectionId;
  final int availabilityId;
  final String title;
  final String? description;
  final int displayOrder;
  final DateTime createdAt;
  final List<MaterialItemModel> items;

  MaterialSectionModel({
    required this.sectionId,
    required this.availabilityId,
    required this.title,
    required this.description,
    required this.displayOrder,
    required this.createdAt,
    required this.items,
  });

  factory MaterialSectionModel.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'] ?? json['materials'] ?? json['Items'];
    return MaterialSectionModel(
      sectionId: _asInt(json['sectionId'] ?? json['id']),
      availabilityId: _asInt(json['availabilityId']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      displayOrder: _asInt(json['displayOrder']),
      createdAt: _asDate(json['createdAt']),
      items: itemsRaw is List
          ? itemsRaw
              .whereType<Map>()
              .map((e) => MaterialItemModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <MaterialItemModel>[],
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _asOptionalInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

DateTime _asDate(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
