import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../models/booking_models.dart';
import '../services/booking_service.dart';
import '../../chat/models/chat_models.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService bookingService;

  BookingProvider({required this.bookingService});

  bool loading = false;
  String? error;

  List<SubjectModel> subjects = [];
  List<AvailabilityModel> availabilities = [];
  List<AvailabilityModel> myAvailabilities = [];
  List<BookingModel> bookings = [];
  TutorPublicModel? selectedTutor;
  List<AvailabilityModel> selectedTutorAvailabilities = [];

  void clearSessionData() {
    loading = false;
    error = null;
    availabilities = [];
    myAvailabilities = [];
    bookings = [];
    selectedTutor = null;
    selectedTutorAvailabilities = [];
    notifyListeners();
  }

  String subjectNameById(int? subjectId,
      {String fallback = 'Unknown subject'}) {
    if (subjectId == null) return fallback;
    for (final subject in subjects) {
      if (subject.subjectId == subjectId) return subject.name;
    }
    return 'Subject #$subjectId';
  }

  String availabilitySubjectName(AvailabilityModel availability) {
    final directName = availability.subjectName;
    if (directName != null && directName.trim().isNotEmpty) return directName;
    return subjectNameById(availability.subjectId);
  }

  AvailabilityModel? availabilityForBooking(BookingModel booking) {
    for (final availability in availabilities) {
      if (availability.availabilityId == booking.availabilityId) {
        return availability;
      }
    }
    return null;
  }

  Future<void> loadSubjects() async {
    await _guard(() async {
      subjects = await bookingService.getSubjects();
    });
  }

  Future<void> loadHome() async {
    await _guard(() async {
      subjects = await bookingService.getSubjects();
      availabilities = await bookingService.getAvailabilities();
    });
  }

  Future<void> refreshAll() async {
    await _guard(() async {
      subjects = await bookingService.getSubjects();
      availabilities = await bookingService.getAvailabilities();
      bookings = await bookingService.getMyBookings();
    });
  }

  Future<void> refreshAfterPayment() async {
    await _guard(() async {
      bookings = await bookingService.getMyBookings();
      availabilities = await bookingService.getAvailabilities();
    });
  }

  Future<void> loadTutorDetail(int tutorId) async {
    await _guard(() async {
      final results = await Future.wait([
        bookingService.getTutorById(tutorId),
        bookingService.getAvailabilitiesByTutor(tutorId),
      ]);

      selectedTutor = results[0] as TutorPublicModel;
      selectedTutorAvailabilities = results[1] as List<AvailabilityModel>;

      for (final availability in selectedTutorAvailabilities) {
        final index = availabilities.indexWhere(
          (item) => item.availabilityId == availability.availabilityId,
        );
        if (index >= 0) {
          availabilities[index] = availability;
        } else {
          availabilities.add(availability);
        }
      }
    });
  }

  Future<BookingModel> book(int availabilityId) async {
    late BookingModel booking;
    await _guard(() async {
      booking = await bookingService.createBooking(availabilityId);
      bookings = await bookingService.getMyBookings();
      availabilities = await bookingService.getAvailabilities();
    });
    return booking;
  }

  Future<void> loadBookings() async {
    await _guard(() async {
      final results = await Future.wait([
        bookingService.getSubjects(),
        bookingService.getMyBookings(),
        bookingService.getAvailabilities(),
      ]);
      subjects = results[0] as List<SubjectModel>;
      bookings = results[1] as List<BookingModel>;
      availabilities = results[2] as List<AvailabilityModel>;
    });
  }

  Future<void> loadMyAvailability() async {
    await _guard(() async {
      subjects = await bookingService.getSubjects();
      myAvailabilities = await bookingService.getMyAvailabilities();
    });
  }

  Future<void> createAvailability({
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
    await _guard(() async {
      await bookingService.createAvailability(
        subjectId: subjectId,
        daysOfWeek: daysOfWeek,
        mode: mode,
        offlineAreas: offlineAreas,
        level: level,
        startCourseTime: startCourseTime,
        endCourseTime: endCourseTime,
        startTime: startTime,
        endTime: endTime,
        pricePerSlot: pricePerSlot,
      );
      subjects = await bookingService.getSubjects();
      myAvailabilities = await bookingService.getMyAvailabilities();
      availabilities = await bookingService.getAvailabilities();
    });
  }

  Future<void> toggleAvailabilityStatus({
    required int availabilityId,
    required String status,
  }) async {
    await _guard(() async {
      await bookingService.updateAvailabilityStatus(
        availabilityId: availabilityId,
        status: status,
      );
      myAvailabilities = await bookingService.getMyAvailabilities();
    });
  }

  Future<void> cancelBooking(int bookingId) async {
    await _guard(() async {
      await bookingService.cancelBooking(bookingId);
      bookings = await bookingService.getMyBookings();
    });
  }

  Future<void> ensureChatRestrictionContext() async {
    await _guard(() async {
      bookings = await bookingService.getMyBookings();
      if (availabilities.isEmpty) {
        availabilities = await bookingService.getAvailabilities();
      }
    });
  }

  bool hasBookedTutor(int tutorId) {
    return bookings.any(
      (booking) =>
          booking.tutorId == tutorId && _isBookedChatStatus(booking.status),
    );
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

  static bool _isBookedChatStatus(String status) {
    final normalized = status.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'cancelled' &&
        normalized != 'canceled' &&
        normalized != 'expired' &&
        normalized != 'rejected';
  }

  int? tutorIdForConversation(ConversationModel conversation) {
    for (final availability in availabilities) {
      if (availability.tutorUserId == conversation.otherUserId) {
        return availability.tutorId;
      }
    }
    return null;
  }
}
