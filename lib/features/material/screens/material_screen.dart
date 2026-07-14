import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../../core/widgets/error_banner.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/models/booking_models.dart';
import '../../booking/providers/booking_provider.dart';
import '../providers/material_provider.dart';
import '../widgets/add_section_dialog.dart';
import '../widgets/course_picker.dart';
import '../widgets/material_section_card.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCourses());
  }

  Future<void> _loadCourses() async {
    final auth = context.read<AuthProvider>();
    final booking = context.read<BookingProvider>();
    if (auth.isTutor) {
      await booking.loadMyAvailability();
    } else {
      await booking.loadBookings();
      if (booking.availabilities.isEmpty) {
        await booking.loadHome();
      }
    }
  }

  List<AvailabilityModel> _courses(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final booking = context.watch<BookingProvider>();
    if (auth.isTutor) return booking.myAvailabilities;

    final bookedAvailabilityIds = booking.bookings
        .where((b) => !['cancelled', 'canceled', 'expired', 'rejected']
            .contains(b.status.trim().toLowerCase()))
        .map((b) => b.availabilityId)
        .toSet();

    return booking.availabilities
        .where((a) => bookedAvailabilityIds.contains(a.availabilityId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final auth = context.watch<AuthProvider>();
    final booking = context.watch<BookingProvider>();
    final materials = context.watch<MaterialProvider>();
    final theme = Theme.of(context);
    final selectedAvailabilityId = materials.selectedAvailabilityId;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(t.materials),
        leading: selectedAvailabilityId == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => materials.clearSelection(),
              ),
        actions: [
          if (selectedAvailabilityId != null && auth.isTutor)
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _addSection(context, selectedAvailabilityId),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: selectedAvailabilityId == null
            ? _loadCourses
            : () => materials.loadSections(selectedAvailabilityId),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ErrorBanner(materials.error),
            ErrorBanner(selectedAvailabilityId == null ? booking.error : null),
            if (selectedAvailabilityId == null)
              CoursePicker(
                courses: _courses(context),
                loading: booking.loading,
                onSelected: (course) =>
                    materials.selectAvailability(course.availabilityId),
              )
            else ...[
              if (materials.loading && materials.selectedSections.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (!materials.loading && materials.selectedSections.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  child: Text(
                    auth.isTutor ? t.noMaterialCoursesTutor : t.noMaterialCoursesLearner,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ),
              ...materials.selectedSections.map(
                (section) => MaterialSectionCard(
                  section: section,
                  availabilityId: selectedAvailabilityId,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _addSection(BuildContext context, int availabilityId) async {
    final result = await showAddSectionDialog(context);
    if (result == null || !context.mounted) return;
    await context.read<MaterialProvider>().addSection(
          availabilityId: availabilityId,
          title: result.title,
          description: result.description,
        );
  }
}
