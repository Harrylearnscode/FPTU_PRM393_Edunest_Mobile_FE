import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/notification/providers/notification_provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../ui_text.dart';
import 'course_quick_switch_bar.dart';
import 'course_tools_sheet.dart';

class MainShell extends StatelessWidget {
  final AuthProvider auth;
  final String location;
  final Widget child;

  const MainShell({
    super.key,
    required this.auth,
    required this.location,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final unreadNotifications =
        context.watch<NotificationProvider>().unreadNotificationCount;
    final items = <_NavItem>[
      _NavItem(
        '/home',
        Icons.home_outlined,
        Icons.home,
        t.home,
      ),
      if (!auth.isTutor)
        _NavItem(
          '/bookings',
          Icons.event_note_outlined,
          Icons.event_note,
          t.booking,
        ),
      if (auth.isLearner || auth.isTutor)
        _NavItem(
          '/course-tools',
          Icons.auto_stories_outlined,
          Icons.auto_stories,
          t.course,
          opensCourseTools: true,
        ),
      _NavItem(
        '/chat',
        Icons.chat_bubble_outline,
        Icons.chat_bubble,
        t.chat,
      ),
      _NavItem(
        '/notifications',
        Icons.notifications_none_rounded,
        Icons.notifications_rounded,
        t.text('Notifications'),
        badgeCount: unreadNotifications,
      ),
      _NavItem(
        '/profile',
        Icons.person_outline,
        Icons.person,
        t.profile,
      ),
    ];

    final current = items.indexWhere(
          (item) {
        if (item.opensCourseTools) return isCourseLocation(location);
        return location == item.path || location.startsWith('${item.path}/');
      },
    );
    final index = current < 0 ? 0 : current;

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCourseLocation(location))
            CourseQuickSwitchBar(location: location),
          NavigationBar(
            height: 66,
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 10,
                height: 1,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            selectedIndex: index,
            onDestinationSelected: (i) {
              if (items[i].opensCourseTools) {
                showCourseToolsSheet(context, location);
                return;
              }

              context.push(items[i].path);
            },
            destinations: items.map((item) {
              return NavigationDestination(
                icon: _navIcon(item.icon, item.badgeCount),
                selectedIcon: _navIcon(item.selectedIcon, item.badgeCount),
                label: item.label,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int badgeCount) {
    final child = Icon(icon);
    if (badgeCount <= 0) return child;
    return Badge(
      label: Text(badgeCount > 99 ? '99+' : '$badgeCount'),
      child: child,
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool opensCourseTools;
  final int badgeCount;

  const _NavItem(
      this.path,
      this.icon,
      this.selectedIcon,
      this.label, {
        this.opensCourseTools = false,
        this.badgeCount = 0,
      });
}
