import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../widgets/main_shell.dart';

// --- Imports mÃ n hÃ¬nh theo cáº¥u trÃºc má»›i ---
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/auth_flow_type.dart';
import '../../features/auth/screens/verify_email_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/terms_of_service_screen.dart' as legal;
import '../../features/booking/screens/booking_screen.dart';
import '../../features/booking/screens/create_availability_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/chat/screens/chat_detail_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/notification/screens/notification_screen.dart';
import '../../features/payment/screens/payment_screen.dart';

class AppRouter {
  static GoRouter build(AuthProvider auth) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: auth,
      redirect: (context, state) {
        final loggedIn = auth.isAuthenticated;
        final location = state.uri.path;

        final isAuthRoute = location.startsWith('/login') ||
            location.startsWith('/register') ||
            location.startsWith('/verify-email');

        if (!loggedIn && !isAuthRoute) {
          return '/login';
        }

        if (loggedIn && isAuthRoute) {
          return '/home';
        }

        if (loggedIn &&
            location.startsWith('/availability/create') &&
            !auth.isTutor) {
          return '/home';
        }

        if (loggedIn &&
            location == '/materials' &&
            (!auth.isLearner && !auth.isTutor)) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/login/tutor',
          builder: (_, __) => const RoleLoginScreen(
            type: AuthFlowType.tutor,
          ),
        ),
        GoRoute(
          path: '/login/learner',
          builder: (_, __) => const RoleLoginScreen(
            type: AuthFlowType.learner,
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/register/tutor',
          builder: (_, __) => const RoleRegisterScreen(
            type: AuthFlowType.tutor,
          ),
        ),
        GoRoute(
          path: '/register/learner',
          builder: (_, __) => const RoleRegisterScreen(
            type: AuthFlowType.learner,
          ),
        ),
        GoRoute(
          path: '/verify-email',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            final type = state.uri.queryParameters['type'] ?? 'learner';

            return VerifyEmailScreen(
              email: email,
              type: type,
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MainShell(
              auth: auth,
              location: state.uri.path,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => const HomeScreen(),
            ),
            GoRoute(
              path: '/bookings',
              builder: (_, __) => const BookingScreen(),
            ),
            GoRoute(
              path: '/chat',
              builder: (_, __) => const ChatScreen(),
            ),
            GoRoute(
              path: '/notifications',
              builder: (_, __) => const NotificationScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/payment',
          builder: (context, state) {
            final payment = state.extra;

            if (payment == null) {
              return const Scaffold(
                body: Center(
                  child: Text('Payment data is missing'),
                ),
              );
            }

            return PaymentScreen(
              payment: payment as dynamic,
            );
          },
        ),
        GoRoute(
          path: '/availability/create',
          builder: (_, __) => const CreateAvailabilityScreen(),
        ),
        GoRoute(
          path: '/terms-of-service',
          builder: (_, __) => const legal.TermsOfServiceScreen(),
        ),
        GoRoute(
          path: '/chat/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');

            if (id == null) {
              return const Scaffold(
                body: Center(
                  child: Text('Invalid conversation id'),
                ),
              );
            }

            return ChatDetailScreen(
              conversationId: id,
            );
          },
        ),
      ],
    );
  }
}
