import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../../core/widgets/money_text.dart';
import '../../booking/models/booking_models.dart';
import '../../booking/providers/booking_provider.dart';

class TutorAvailabilityCard extends StatelessWidget {
  final AvailabilityModel availability;

  const TutorAvailabilityCard({super.key, required this.availability});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;
    final data = context.watch<BookingProvider>();
    final total = availability.totalCoursePrice > 0
        ? availability.totalCoursePrice
        : availability.pricePerSlot * availability.slot;
    final subjectName = (availability.subjectName ?? '').isNotEmpty
        ? availability.subjectName!
        : data.subjectNameById(availability.subjectId);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subjectName,
            style:
                theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _Tag(icon: Icons.calendar_today_rounded, text: availability.dayOfWeek),
              _Tag(
                icon: Icons.access_time_rounded,
                text: '${availability.startTime} - ${availability.endTime}',
              ),
              _Tag(
                icon: Icons.layers_rounded,
                text: '${t.mode(availability.mode)} - ${t.level(availability.level)}',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.fullTuitionPackage,
                      style: TextStyle(
                          fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    MoneyText(
                      total,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed:
                    data.loading ? null : () => _book(context, availability),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(t.enrollNow,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _book(BuildContext context, AvailabilityModel availability) async {
    try {
      await context.read<BookingProvider>().book(availability.availabilityId);
      if (context.mounted) {
        final t = UiText.of(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.enrolledSuccessfully)),
        );
        context.go('/bookings');
      }
    } catch (_) {}
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
