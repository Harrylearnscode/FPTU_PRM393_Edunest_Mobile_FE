import 'package:flutter/material.dart';

import '../../../core/ui_text.dart';
import '../../booking/models/booking_models.dart';
import 'tutor_availability_card.dart';

class TutorAvailabilityList extends StatelessWidget {
  final List<AvailabilityModel> availabilities;

  const TutorAvailabilityList({super.key, required this.availabilities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;
    final openCourses =
        availabilities.where((a) => a.status.toLowerCase() == 'active').toList();

    if (openCourses.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.menu_book_rounded, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(t.noCoursesAvailableYet,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          t.coursesN(openCourses.length),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...openCourses.map(
          (availability) => TutorAvailabilityCard(availability: availability),
        ),
      ],
    );
  }
}
