enum LessonTimeState { upcoming, ongoing, endedNeedsAction, completed }

class LessonAttendanceModel {
  final int studentUserId;
  final String studentName;
  final String status;

  LessonAttendanceModel({
    required this.studentUserId,
    required this.studentName,
    required this.status,
  });

  factory LessonAttendanceModel.fromJson(Map<String, dynamic> json) {
    return LessonAttendanceModel(
      studentUserId: _asInt(
        json['studentUserId'] ?? json['userId'] ?? json['StudentUserId'],
      ),
      studentName:
          json['studentName']?.toString() ?? json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? json['attendanceStatus']?.toString() ?? '',
    );
  }
}

class LessonModel {
  final int lessonId;
  final int availabilityId;
  final int? subjectId;
  final String? subjectName;
  final int tutorId;
  final int tutorUserId;
  final String tutorName;
  final String mode;
  final String level;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetingLink;
  final String status;
  final List<LessonAttendanceModel> students;

  LessonModel({
    required this.lessonId,
    required this.availabilityId,
    required this.subjectId,
    required this.subjectName,
    required this.tutorId,
    required this.tutorUserId,
    required this.tutorName,
    required this.mode,
    required this.level,
    required this.startTime,
    required this.endTime,
    required this.meetingLink,
    required this.status,
    required this.students,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final studentsRaw = json['students'] ?? json['attendances'] ?? json['Students'];
    return LessonModel(
      lessonId: _asInt(json['lessonId'] ?? json['id']),
      availabilityId: _asInt(json['availabilityId']),
      subjectId: json['subjectId'] == null ? null : _asInt(json['subjectId']),
      subjectName: json['subjectName']?.toString(),
      tutorId: _asInt(json['tutorId']),
      tutorUserId: _asInt(json['tutorUserId'] ?? json['tutorId']),
      tutorName: json['tutorName']?.toString() ?? '',
      mode: json['mode']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      startTime: _asDate(json['startTime'] ?? json['startAt']),
      endTime: _asDate(json['endTime'] ?? json['endAt']),
      meetingLink: json['meetingLink']?.toString(),
      status: json['status']?.toString() ?? '',
      students: studentsRaw is List
          ? studentsRaw
              .whereType<Map>()
              .map((e) => LessonAttendanceModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : <LessonAttendanceModel>[],
    );
  }

  LessonTimeState get timeState {
    if (status.trim().toLowerCase() == 'completed') {
      return LessonTimeState.completed;
    }
    final now = DateTime.now();
    if (now.isBefore(startTime)) return LessonTimeState.upcoming;
    if (now.isBefore(endTime)) return LessonTimeState.ongoing;
    return LessonTimeState.endedNeedsAction;
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime _asDate(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
