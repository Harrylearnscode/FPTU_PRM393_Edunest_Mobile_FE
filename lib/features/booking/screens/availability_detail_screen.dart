import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_utils.dart';
import '../../../core/ui_text.dart';
import '../../../core/widgets/money_text.dart';
import '../models/booking_models.dart';
import '../providers/booking_provider.dart';

class AvailabilityDetailScreen extends StatefulWidget {
  final int availabilityId;

  const AvailabilityDetailScreen({
    super.key,
    required this.availabilityId,
  });

  @override
  State<AvailabilityDetailScreen> createState() =>
      _AvailabilityDetailScreenState();
}

class _AvailabilityDetailScreenState extends State<AvailabilityDetailScreen> {
  late Future<AvailabilityModel> _availabilityFuture;

  @override
  void initState() {
    super.initState();
    _availabilityFuture = _loadAvailability();
  }

  Future<AvailabilityModel> _loadAvailability() {
    return context
        .read<BookingProvider>()
        .bookingService
        .getAvailabilityDetail(widget.availabilityId);
  }

  Future<void> _refresh() async {
    setState(() => _availabilityFuture = _loadAvailability());
    await _availabilityFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(t.text('Availability Detail')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<AvailabilityModel>(
        future: _availabilityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _LoadError(
              message: ApiUtils.apiErrorMessage(snapshot.error!),
              onRetry: _refresh,
            );
          }

          final availability = snapshot.data;
          if (availability == null) {
            return _LoadError(message: t.unavailable, onRetry: _refresh);
          }

          return _AvailabilityBody(
              availability: availability, onRefresh: _refresh);
        },
      ),
    );
  }
}

class _AvailabilityBody extends StatelessWidget {
  final AvailabilityModel availability;
  final Future<void> Function() onRefresh;

  const _AvailabilityBody(
      {required this.availability, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final t = context.strings;
    final subject = availability.subjectName?.trim().isNotEmpty == true
        ? availability.subjectName!.trim()
        : context.read<BookingProvider>().availabilitySubjectName(availability);
    final tutorName = availability.tutorName.trim().isEmpty
        ? 'Tutor #${availability.tutorId}'
        : availability.tutorName;
    final total = availability.totalCoursePrice > 0
        ? availability.totalCoursePrice
        : availability.pricePerSlot * availability.slot;
    final offlineAreas = availability.offlineAreas?.trim() ?? '';

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colors.onPrimaryContainer,
                    )),
                const SizedBox(height: 8),
                Text(tutorName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                    )),
                if (availability.tutorEmail.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(availability.tutorEmail,
                      style: TextStyle(color: colors.onPrimaryContainer)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            children: [
              _DetailRow(label: 'Day of week', value: availability.dayOfWeek),
              _DetailRow(
                  label: 'Course starts',
                  value: _date(availability.startCourseTime)),
              _DetailRow(
                  label: 'Course ends',
                  value: _date(availability.endCourseTime)),
              _DetailRow(
                  label: 'Class time',
                  value: '${availability.startTime} - ${availability.endTime}'),
              _DetailRow(label: 'Slots', value: availability.slot.toString()),
              _DetailRow(label: 'Level', value: t.level(availability.level)),
              _DetailRow(label: 'Mode', value: t.mode(availability.mode)),
              if (offlineAreas.isNotEmpty)
                _DetailRow(label: 'Offline areas', value: offlineAreas),
            ],
          ),
          const SizedBox(height: 16),
          _DetailCard(
            children: [
              Text('Total course price', style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              MoneyText(total,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () => _book(context),
              icon: const Icon(Icons.school_rounded),
              label: Text(t.enrollNow,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _book(BuildContext context) async {
    try {
      await context.read<BookingProvider>().book(availability.availabilityId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(UiText.of(context, listen: false).enrolledSuccessfully)),
        );
        // This screen is outside the app's ShellRoute, while /bookings is
        // inside it. Replace this route instead of pushing a second shell
        // navigator onto the stack.
        context.go('/bookings');
      }
    } catch (_) {}
  }

  String _date(DateTime value) {
    if (value.year <= 1970) return '-';
    return DateFormat('dd/MM/yyyy').format(value.toLocal());
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(children: children),
      );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 120,
                child: Text(label,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant))),
            Expanded(
                child: Text(value.isEmpty ? '-' : value,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );
}

class _LoadError extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _LoadError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: onRetry, child: Text(context.strings.refresh)),
          ]),
        ),
      );
}
