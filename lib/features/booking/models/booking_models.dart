class SubjectModel {
  final int subjectId;
  final String name;
  final String description;

  SubjectModel({
    required this.subjectId,
    required this.name,
    required this.description,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: _asInt(json['subjectId'] ?? json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

class AvailabilityModel {
  final int availabilityId;
  final int tutorId;
  final int? subjectId;
  final String dayOfWeek;
  final String mode;
  final String? offlineAreas;
  final String level;
  final DateTime startCourseTime;
  final DateTime endCourseTime;
  final String startTime;
  final String endTime;
  final int slot;
  final int remainingSlot;
  final double pricePerSlot;
  final String status;
  final String? subjectName;
  final double totalCoursePrice;
  final int tutorUserId;
  final String tutorName;
  final String tutorEmail;
  final bool hasBookings;
  final String? tutorAvatarUrl;

  AvailabilityModel({
    required this.availabilityId,
    required this.tutorId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.mode,
    required this.offlineAreas,
    required this.level,
    required this.startCourseTime,
    required this.endCourseTime,
    required this.startTime,
    required this.endTime,
    required this.slot,
    required this.remainingSlot,
    required this.pricePerSlot,
    required this.status,
    required this.subjectName,
    required this.totalCoursePrice,
    required this.tutorUserId,
    required this.tutorName,
    required this.tutorEmail,
    required this.hasBookings,
    this.tutorAvatarUrl,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      availabilityId: _asInt(json['availabilityId']),
      tutorId: _asInt(json['tutorId']),
      subjectId: json['subjectId'] == null ? null : _asInt(json['subjectId']),
      dayOfWeek: _dayOfWeekText(
        json['daysOfWeek'] ??
            json['DaysOfWeek'] ??
            json['dayOfWeek'] ??
            json['DayOfWeek'],
      ),
      mode: json['mode']?.toString() ?? '',
      offlineAreas: json['offlineAreas']?.toString(),
      level: json['level']?.toString() ?? '',
      startCourseTime: _asDate(json['startCourseTime']),
      endCourseTime: _asDate(json['endCourseTime']),
      startTime: _timeString(json['startTime']),
      endTime: _timeString(json['endTime']),
      slot: _asInt(json['slot']),
      remainingSlot: _asInt(json['remainingSlot']),
      pricePerSlot: _asDouble(json['pricePerSlot']),
      status: json['status']?.toString() ?? '',
      subjectName: _subjectName(json),
      totalCoursePrice: _asDouble(
        json['totalCoursePrice'] ??
            (_asDouble(json['pricePerSlot']) * _asInt(json['slot'])),
      ),
      tutorUserId: _asInt(
        json['tutorUserId'] ?? json['tutor']?['userId'] ?? json['tutorId'],
      ),
      tutorName:
          json['tutorName']?.toString() ?? 'Tutor #${_asInt(json['tutorId'])}',
      tutorEmail: _tutorEmail(json),
      hasBookings: json['hasBookings'] == true,
      tutorAvatarUrl: _avatarUrl(
        json['tutorAvatarUrl'] ??
            json['avatarUrl'] ??
            json['tutor']?['avatarUrl'] ??
            json['tutor']?['user']?['avatarUrl'] ??
            json['tutor']?['user']?['AvatarUrl'],
      ),
    );
  }
}

class BookingModel {
  final int bookingId;
  final int availabilityId;
  final int userId;
  final int tutorId;
  final int? subjectId;
  final double priceAtBooking;
  final String status;
  final DateTime createdAt;

  BookingModel({
    required this.bookingId,
    required this.availabilityId,
    required this.userId,
    required this.tutorId,
    required this.subjectId,
    required this.priceAtBooking,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: _asInt(json['bookingId']),
      availabilityId: _asInt(json['availabilityId']),
      userId: _asInt(json['userId']),
      tutorId: _asInt(json['tutorId']),
      subjectId: json['subjectId'] == null ? null : _asInt(json['subjectId']),
      priceAtBooking: _asDouble(json['priceAtBooking']),
      status: json['status']?.toString() ?? '',
      createdAt: _asDate(json['createdAt']),
    );
  }
}

class TutorPublicModel {
  final int tutorId;
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String bio;

  TutorPublicModel({
    required this.tutorId,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
  });

  factory TutorPublicModel.fromJson(Map<String, dynamic> json) {
    return TutorPublicModel(
      tutorId: _asInt(json['tutorId'] ?? json['TutorId']),
      userId: _asInt(json['userId'] ?? json['UserId']),
      name: json['name']?.toString() ?? json['Name']?.toString() ?? '',
      email: json['email']?.toString() ?? json['Email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['Phone']?.toString() ?? '',
      bio: json['bio']?.toString() ?? json['Bio']?.toString() ?? '',
    );
  }
}

// --- Các hàm Helpers ---
int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime _asDate(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

String _timeString(dynamic value) {
  final raw = value?.toString() ?? '';
  if (raw.length >= 8) return raw.substring(0, 8);
  return raw;
}

String _dayOfWeekText(dynamic value) {
  if (value is List) {
    return value
        .map((day) => day.toString().trim())
        .where((day) => day.isNotEmpty)
        .join(', ');
  }
  return value
          ?.toString()
          .split(',')
          .map((day) => day.trim())
          .where((day) => day.isNotEmpty)
          .join(', ') ??
      '';
}

String? _subjectName(Map<String, dynamic> json) {
  final direct = json['subjectName'];
  if (direct != null && direct.toString().trim().isNotEmpty) {
    return direct.toString();
  }
  final subject = json['subject'];
  if (subject is Map) {
    final name = subject['name'];
    if (name != null && name.toString().trim().isNotEmpty) {
      return name.toString();
    }
  }
  return null;
}

String? _avatarUrl(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

String _tutorEmail(Map<String, dynamic> json) {
  final value = json['tutorEmail'] ??
      json['TutorEmail'] ??
      json['tutor']?['email'] ??
      json['tutor']?['user']?['email'] ??
      json['tutor']?['user']?['Email'];
  return value?.toString().trim() ?? '';
}
