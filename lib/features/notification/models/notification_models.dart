class NotificationModel {
  final int notificationId;
  final String type;
  final String title;
  final String message;
  final int? bookingId;
  final int? lessonId;
  final int? availabilityId;
  final int? materialId;
  final int? paymentId;
  final DateTime createdAt;
  final bool isRead;
  final DateTime? readAt;

  const NotificationModel({
    required this.notificationId,
    required this.type,
    required this.title,
    required this.message,
    required this.bookingId,
    required this.lessonId,
    required this.availabilityId,
    required this.materialId,
    required this.paymentId,
    required this.createdAt,
    required this.isRead,
    required this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: _asInt(json['notificationId']),
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      bookingId: _asNullableInt(json['bookingId']),
      lessonId: _asNullableInt(json['lessonId']),
      availabilityId: _asNullableInt(json['availabilityId']),
      materialId: _asNullableInt(json['materialId']),
      paymentId: _asNullableInt(json['paymentId']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isRead: json['isRead'] == true,
      readAt: DateTime.tryParse(json['readAt']?.toString() ?? ''),
    );
  }

  NotificationModel copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return NotificationModel(
      notificationId: notificationId,
      type: type,
      title: title,
      message: message,
      bookingId: bookingId,
      lessonId: lessonId,
      availabilityId: availabilityId,
      materialId: materialId,
      paymentId: paymentId,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }
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
