import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/booking_models.dart';

class BookingService {
  final ApiClient apiClient;

  BookingService(this.apiClient);

  Future<List<SubjectModel>> getSubjects() async {
    final res = await apiClient.dio.get('/api/subject');
    return ApiUtils.list(res.data)
        .map((e) => SubjectModel.fromJson(e))
        .toList();
  }

  Future<List<AvailabilityModel>> getAvailabilities() async {
    final res = await apiClient.dio.get('/api/availability');
    return ApiUtils.list(res.data)
        .map((e) => AvailabilityModel.fromJson(e))
        .toList();
  }

  Future<List<AvailabilityModel>> getAvailabilitiesByTutor(int tutorId) async {
    final res = await apiClient.dio.get('/api/availability/tutor/$tutorId');
    return ApiUtils.list(res.data)
        .map((e) => AvailabilityModel.fromJson(e))
        .toList();
  }

  Future<List<AvailabilityModel>> getMyAvailabilities() async {
    final res = await apiClient.dio.get('/api/availability/me');
    return ApiUtils.list(res.data)
        .map((e) => AvailabilityModel.fromJson(e))
        .toList();
  }

  Future<AvailabilityModel> createAvailability({
    required int subjectId,
    required List<String> daysOfWeek,
    required String mode,
    String? offlineAreas,
    required String level,
    required DateTime startCourseTime,
    required DateTime endCourseTime,
    required String startTime,
    required String endTime,
    required double pricePerSlot,
  }) async {
    final normalizedDays = daysOfWeek
        .map((day) => day.trim())
        .where((day) => day.isNotEmpty)
        .toList();
    final res = await apiClient.dio.post(
      '/api/availability',
      data: {
        'subjectId': subjectId,
        'dayOfWeek': normalizedDays.join(','),
        'daysOfWeek': normalizedDays,
        'mode': mode,
        'offlineAreas': offlineAreas?.trim(),
        'level': level,
        'startCourseTime': ApiUtils.dateOnlyIso(startCourseTime),
        'endCourseTime': ApiUtils.dateOnlyIso(endCourseTime),
        'startTime': ApiUtils.normalizeTime(startTime),
        'endTime': ApiUtils.normalizeTime(endTime),
        'pricePerSlot': pricePerSlot,
      },
    );
    return AvailabilityModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<AvailabilityModel> updateAvailabilityStatus({
    required int availabilityId,
    required String status,
  }) async {
    final res = await apiClient.dio.patch(
      '/api/availability/$availabilityId/status',
      data: {'status': status},
    );
    return AvailabilityModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<BookingModel> createBooking(int availabilityId, {String? note}) async {
    final body = <String, dynamic>{
      'availabilityId': availabilityId,
      'note': note
    };
    body.removeWhere((key, value) =>
        value == null || (value is String && value.trim().isEmpty));

    final res = await apiClient.dio.post('/api/booking', data: body);
    return BookingModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<List<BookingModel>> getMyBookings() async {
    final res = await apiClient.dio.get('/api/booking/me');
    return ApiUtils.list(res.data)
        .map((e) => BookingModel.fromJson(e))
        .toList();
  }

  Future<BookingModel> cancelBooking(int bookingId) async {
    final res = await apiClient.dio.post('/api/booking/$bookingId/cancel');
    return BookingModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<TutorPublicModel> getTutorById(int tutorId) async {
    final res = await apiClient.dio.get('/api/tutor/$tutorId');
    return TutorPublicModel.fromJson(ApiUtils.asMap(res.data));
  }
}
