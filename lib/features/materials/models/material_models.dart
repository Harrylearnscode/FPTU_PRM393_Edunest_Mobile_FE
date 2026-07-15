class CourseMaterialSectionModel {
  final int sectionId;
  final int availabilityId;
  final String title;
  final String? description;
  final int displayOrder;
  final DateTime createdAt;
  final List<CourseMaterialItemModel> items;

  CourseMaterialSectionModel({
    required this.sectionId,
    required this.availabilityId,
    required this.title,
    required this.description,
    required this.displayOrder,
    required this.createdAt,
    required this.items,
  });

  factory CourseMaterialSectionModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] ?? json['materials'] ?? json['Materials'];

    return CourseMaterialSectionModel(
      sectionId: _asInt(
        json['sectionId'] ??
            json['materialSectionId'] ??
            json['courseMaterialSectionId'] ??
            json['id'],
      ),
      availabilityId: _asInt(json['availabilityId']),
      title: json['title']?.toString() ??
          json['sectionTitle']?.toString() ??
          'Materials',
      description: _blankToNull(
        json['description'] ?? json['sectionDescription'],
      ),
      displayOrder: _asInt(json['displayOrder'] ?? json['order']),
      createdAt: _asDate(json['createdAt']),
      items: _asObjectList(rawItems)
          .map((item) => CourseMaterialItemModel.fromJson(item))
          .toList(),
    );
  }

  factory CourseMaterialSectionModel.flat({
    required int availabilityId,
    required List<CourseMaterialItemModel> items,
  }) {
    return CourseMaterialSectionModel(
      sectionId: 0,
      availabilityId: availabilityId,
      title: 'Materials',
      description: null,
      displayOrder: 0,
      createdAt: items.isEmpty ? DateTime.now() : items.first.createdAt,
      items: items,
    );
  }
}

class CourseMaterialItemModel {
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
  final DateTime? updatedAt;

  CourseMaterialItemModel({
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
    required this.updatedAt,
  });

  factory CourseMaterialItemModel.fromJson(Map<String, dynamic> json) {
    final url = _blankToNull(
      json['fileUrl'] ??
          json['FileUrl'] ??
          json['url'] ??
          json['Url'] ??
          json['downloadUrl'] ??
          json['DownloadUrl'] ??
          json['externalUrl'] ??
          json['ExternalUrl'] ??
          json['linkUrl'],
    );

    return CourseMaterialItemModel(
      materialId: _asInt(
        json['materialId'] ??
            json['MaterialId'] ??
            json['courseMaterialId'] ??
            json['CourseMaterialId'] ??
            json['id'] ??
            json['Id'],
      ),
      sectionId: _asNullableInt(
        json['sectionId'] ??
            json['SectionId'] ??
            json['materialSectionId'] ??
            json['MaterialSectionId'] ??
            json['courseMaterialSectionId'],
      ),
      availabilityId: _asInt(json['availabilityId'] ?? json['AvailabilityId']),
      title: json['title']?.toString() ??
          json['Title']?.toString() ??
          'Untitled material',
      description: _blankToNull(json['description'] ?? json['Description']),
      fileUrl: url,
      fileName: _blankToNull(
        json['fileName'] ?? json['FileName'] ?? json['originalFileName'],
      ),
      contentType: _blankToNull(
        json['contentType'] ?? json['ContentType'] ?? json['mimeType'],
      ),
      fileSize: _asNullableInt(
        json['fileSize'] ?? json['FileSize'] ?? json['sizeInBytes'],
      ),
      materialType: json['materialType']?.toString() ??
          json['MaterialType']?.toString() ??
          json['type']?.toString() ??
          _inferMaterialType(url),
      createdAt:
          _asDate(json['createdAt'] ?? json['CreatedAt'] ?? json['uploadedAt']),
      updatedAt: (json['updatedAt'] ?? json['UpdatedAt']) == null
          ? null
          : _asDate(json['updatedAt'] ?? json['UpdatedAt']),
    );
  }

  bool get canOpen => fileUrl != null && fileUrl!.trim().isNotEmpty;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();

  final text = value.toString().trim();
  if (text.isEmpty) return null;

  return int.tryParse(text);
}

DateTime _asDate(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value == null) return <String, dynamic>{};
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _asObjectList(dynamic value) {
  if (value is List) {
    return value.map((item) => _asMap(item)).toList();
  }

  if (value is Map) {
    final map = _asMap(value);
    final items = map['data'] ?? map['items'] ?? map['materials'];

    if (items is List) {
      return items.map((item) => _asMap(item)).toList();
    }
  }

  return <Map<String, dynamic>>[];
}

String? _blankToNull(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

String _inferMaterialType(String? url) {
  final text = url?.toLowerCase() ?? '';

  if (text.endsWith('.pdf')) return 'Pdf';
  if (text.endsWith('.png') ||
      text.endsWith('.jpg') ||
      text.endsWith('.jpeg') ||
      text.endsWith('.webp')) {
    return 'Image';
  }
  if (text.endsWith('.mp4') || text.endsWith('.mov') || text.endsWith('.avi')) {
    return 'Video';
  }
  if (text.startsWith('http')) return 'Link';

  return 'File';
}
