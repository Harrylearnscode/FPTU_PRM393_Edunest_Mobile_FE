import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edunest_mobile/core/network/api_client.dart';
import 'package:edunest_mobile/features/auth/providers/auth_provider.dart';
import 'package:edunest_mobile/features/booking/providers/booking_provider.dart';
import 'package:edunest_mobile/features/booking/services/booking_service.dart';
import 'package:edunest_mobile/features/chat/providers/chat_provider.dart';
import 'package:edunest_mobile/features/chat/services/chat_service.dart';
import 'package:edunest_mobile/features/lesson/providers/lesson_provider.dart';
import 'package:edunest_mobile/features/lesson/services/lesson_service.dart';
import 'package:edunest_mobile/features/materials/providers/material_provider.dart';
import 'package:edunest_mobile/features/materials/services/material_service.dart';
import 'package:edunest_mobile/features/notification/providers/notification_provider.dart';
import 'package:edunest_mobile/features/notification/services/notification_service.dart';
import 'package:edunest_mobile/features/payment/providers/payment_provider.dart';
import 'package:edunest_mobile/features/payment/services/payment_service.dart';
import 'package:edunest_mobile/features/profile/providers/profile_provider.dart';
import 'package:edunest_mobile/features/profile/services/profile_service.dart';
import 'package:edunest_mobile/main.dart';

void main() {
  testWidgets('EduNest app shell builds', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final api = ApiClient(prefs: prefs);
    final authProvider = AuthProvider(api: api);
    await authProvider.bootstrap();

    await tester.pumpWidget(
      EduNestApp(
        apiClient: api,
        authProvider: authProvider,
        bookingProvider: BookingProvider(
          bookingService: BookingService(api),
        ),
        chatProvider: ChatProvider(chatService: ChatService(api)),
        lessonProvider: LessonProvider(
          lessonService: LessonService(api),
        ),
        materialProvider: MaterialProvider(
          materialService: MaterialService(api),
        ),
        notificationProvider: NotificationProvider(
          notificationService: NotificationService(api),
        ),
        paymentProvider: PaymentProvider(
          paymentService: PaymentService(api),
        ),
        profileProvider: ProfileProvider(
          profileService: ProfileService(api),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('EduNest'), findsWidgets);
  });
}
