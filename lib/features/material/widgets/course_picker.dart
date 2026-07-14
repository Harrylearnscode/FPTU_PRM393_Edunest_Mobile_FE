import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../booking/models/booking_models.dart';
import '../../booking/providers/booking_provider.dart';

class CoursePicker extends StatelessWidget {
  final List<AvailabilityModel> courses;
  final ValueChanged<AvailabilityModel> onSelected;
  final bool loading;

  const CoursePicker({
    super.key,
    required this.courses,
    required this.onSelected,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;

    if (loading && courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Text(
          t.noCoursesAvailableYet,
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: courses.map((course) => _CourseRow(course: course, onSelected: onSelected)).toList(),
    );
  }
}

class _CourseRow extends StatelessWidget {
  final AvailabilityModel course;
  final ValueChanged<AvailabilityModel> onSelected;

  const _CourseRow({required this.course, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;
    final subjectName = (course.subjectName ?? '').isNotEmpty
        ? course.subjectName!
        : context.read<BookingProvider>().subjectNameById(course.subjectId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.35)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(Icons.folder_copy_outlined, color: theme.colorScheme.primary),
        title: Text(subjectName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${course.tutorName.isEmpty ? t.tutorId : course.tutorName} - ${course.dayOfWeek}',
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => onSelected(course),
      ),
    );
  }
}
