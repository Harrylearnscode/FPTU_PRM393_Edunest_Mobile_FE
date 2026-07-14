import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/routes/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/booking/providers/booking_provider.dart';
import 'features/booking/services/booking_service.dart';
import 'features/notification/providers/notification_provider.dart';
import 'features/notification/services/notification_service.dart';
import 'features/payment/providers/payment_provider.dart';
import 'features/payment/services/payment_service.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/profile/services/profile_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiClient = ApiClient(prefs: prefs);

  final authProvider = AuthProvider(api: apiClient);
  await authProvider.bootstrap();

  final bookingService = BookingService(apiClient);
  final notificationService = NotificationService(apiClient);
  final paymentService = PaymentService(apiClient);
  final profileService = ProfileService(apiClient);

  final bookingProvider = BookingProvider(
    bookingService: bookingService,
  );
  final notificationProvider = NotificationProvider(
    notificationService: notificationService,
  );
  final paymentProvider = PaymentProvider(
    paymentService: paymentService,
  );
  final profileProvider = ProfileProvider(
    profileService: profileService,
  );

  runApp(
    EduNestApp(
      apiClient: apiClient,
      authProvider: authProvider,
      bookingProvider: bookingProvider,
      notificationProvider: notificationProvider,
      paymentProvider: paymentProvider,
      profileProvider: profileProvider,
    ),
  );
}

class EduNestApp extends StatefulWidget {
  final ApiClient apiClient;
  final AuthProvider authProvider;
  final BookingProvider bookingProvider;
  final NotificationProvider notificationProvider;
  final PaymentProvider paymentProvider;
  final ProfileProvider profileProvider;

  const EduNestApp({
    super.key,
    required this.apiClient,
    required this.authProvider,
    required this.bookingProvider,
    required this.notificationProvider,
    required this.paymentProvider,
    required this.profileProvider,
  });

  @override
  State<EduNestApp> createState() => _EduNestAppState();
}

class _EduNestAppState extends State<EduNestApp> {
  late final GoRouter _router;
  int? _activeUserId;

  @override
  void initState() {
    super.initState();
    _activeUserId =
        widget.authProvider.isAuthenticated ? widget.authProvider.userId : null;

    widget.authProvider.addListener(_handleAuthChanged);

    widget.apiClient.onUnauthorized = () {
      widget.authProvider.handleUnauthorized();
    };

    _router = AppRouter.build(widget.authProvider);
  }

  @override
  void dispose() {
    widget.authProvider.removeListener(_handleAuthChanged);
    super.dispose();
  }

  void _handleAuthChanged() {
    final nextUserId =
        widget.authProvider.isAuthenticated ? widget.authProvider.userId : null;

    if (_activeUserId == nextUserId) {
      return;
    }

    _activeUserId = nextUserId;
    widget.bookingProvider.clearSessionData();
    widget.notificationProvider.clearSessionData();
    widget.paymentProvider.clearSessionData();
    widget.profileProvider.clearSessionData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(
          value: widget.apiClient,
        ),
        ChangeNotifierProvider<AuthProvider>.value(
          value: widget.authProvider,
        ),
        ChangeNotifierProvider<BookingProvider>.value(
          value: widget.bookingProvider,
        ),
        ChangeNotifierProvider<NotificationProvider>.value(
          value: widget.notificationProvider,
        ),
        ChangeNotifierProvider<PaymentProvider>.value(
          value: widget.paymentProvider,
        ),
        ChangeNotifierProvider<ProfileProvider>.value(
          value: widget.profileProvider,
        ),
      ],
      child: MaterialApp.router(
        title: 'EduNest',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        locale: const Locale('en'),
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        routerConfig: _router,
      ),
    );
  }
}
