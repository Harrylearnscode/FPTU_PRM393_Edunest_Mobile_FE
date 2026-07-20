// lib/features/lesson/models/lesson_model.dart

class LessonModel {
  final int lessonId;
  final int bookingId;
  final DateTime scheduleTime;
  final int duration;
  final String status;
  final String? meetingLink;
  final int availabilityId;
  final int availabilitySlot;
  final DateTime startCourseTime;
  final DateTime endCourseTime;
  final String level;
  final String mode;
  final int tutorId;
  final int tutorUserId;
  final String tutorName;
  final int? subjectId;
  final String? subjectName;
  final String? tutorAvatarUrl;
  final String? studentName;

  LessonModel({
    required this.lessonId,
    required this.bookingId,
    required this.scheduleTime,
    required this.duration,
    required this.status,
    required this.meetingLink,
    required this.availabilityId,
    required this.availabilitySlot,
    required this.startCourseTime,
    required this.endCourseTime,
    required this.level,
    required this.mode,
    required this.tutorId,
    required this.tutorUserId,
    required this.tutorName,
    required this.subjectId,
    required this.subjectName,
    this.tutorAvatarUrl,
    this.studentName,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      lessonId: _asInt(json['lessonId']),
      bookingId: _asInt(json['bookingId']),
      scheduleTime: _asDate(json['scheduleTime']),
      duration: _asInt(json['duration']),
      status: json['status']?.toString() ?? '',
      meetingLink: json['meetingLink']?.toString(),
      availabilityId: _asInt(json['availabilityId']),
      availabilitySlot: _asInt(
        json['availabilitySlot'] ??
            json['AvailabilitySlot'] ??
            json['slot'] ??
            json['Slot'] ??
            json['availability']?['slot'] ??
            json['Availability']?['Slot'],
      ),
      startCourseTime: _asDate(
        json['startCourseTime'] ??
            json['StartCourseTime'] ??
            json['availability']?['startCourseTime'] ??
            json['Availability']?['StartCourseTime'],
      ),
      endCourseTime: _asDate(
        json['endCourseTime'] ??
            json['EndCourseTime'] ??
            json['availability']?['endCourseTime'] ??
            json['Availability']?['EndCourseTime'],
      ),
      level: (json['level'] ??
                  json['Level'] ??
                  json['availability']?['level'] ??
                  json['Availability']?['Level'])
              ?.toString() ??
          '',
      mode: (json['mode'] ??
                  json['Mode'] ??
                  json['availability']?['mode'] ??
                  json['Availability']?['Mode'])
              ?.toString() ??
          '',
      tutorId: _asInt(json['tutorId']),
      tutorUserId: _asInt(json['tutorUserId']),
      tutorName:
          json['tutorName']?.toString() ?? 'Tutor #${_asInt(json['tutorId'])}',
      subjectId: json['subjectId'] == null ? null : _asInt(json['subjectId']),
      subjectName: json['subjectName']?.toString(),
      tutorAvatarUrl: json['tutorAvatarUrl']?.toString(),
      studentName:
          json['studentName']?.toString() ?? json['StudentName']?.toString(),
    );
  }
}

class LessonDetailModel {
  final int mainLessonId;
  final int availabilityId;
  final int tutorId;
  final int? subjectId;
  final DateTime scheduleTime;
  final int duration;
  final DateTime endTime;
  final String status;
  final String meetingLink;
  final bool canComplete;
  final List<LessonStudentModel> students;

  LessonDetailModel({
    required this.mainLessonId,
    required this.availabilityId,
    required this.tutorId,
    required this.subjectId,
    required this.scheduleTime,
    required this.duration,
    required this.endTime,
    required this.status,
    required this.meetingLink,
    required this.canComplete,
    required this.students,
  });

  factory LessonDetailModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailModel(
      mainLessonId: _asInt(json['mainLessonId']),
      availabilityId: _asInt(json['availabilityId']),
      tutorId: _asInt(json['tutorId']),
      subjectId: json['subjectId'] == null ? null : _asInt(json['subjectId']),
      scheduleTime: _asDate(json['scheduleTime']),
      duration: _asInt(json['duration']),
      endTime: _asDate(json['endTime']),
      status: json['status']?.toString() ?? '',
      meetingLink: json['meetingLink']?.toString() ?? '',
      canComplete: json['canComplete'] == true,
      students: (json['students'] as List? ?? [])
          .map((e) => LessonStudentModel.fromJson(_asMap(e)))
          .toList(),
    );
  }
}

class LessonStudentModel {
  final int lessonId;
  final int bookingId;
  final int userId;
  final String studentName;
  final String lessonStatus;

  LessonStudentModel({
    required this.lessonId,
    required this.bookingId,
    required this.userId,
    required this.studentName,
    required this.lessonStatus,
  });

  factory LessonStudentModel.fromJson(Map<String, dynamic> json) {
    return LessonStudentModel(
      lessonId: _asInt(json['lessonId']),
      bookingId: _asInt(json['bookingId']),
      userId: _asInt(json['userId']),
      studentName: json['studentName']?.toString() ?? '',
      lessonStatus: json['lessonStatus']?.toString() ?? '',
    );
  }
}

// Helpers
int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
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
