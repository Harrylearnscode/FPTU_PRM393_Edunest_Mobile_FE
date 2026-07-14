import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../../core/widgets/error_banner.dart';
import '../../booking/providers/booking_provider.dart';
import '../widgets/tutor_availability_list.dart';
import '../widgets/tutor_header.dart';

class TutorProfileScreen extends StatefulWidget {
  final int tutorId;

  const TutorProfileScreen({super.key, required this.tutorId});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadTutorDetail(widget.tutorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<BookingProvider>();
    final t = context.strings;
    final tutor = data.selectedTutor;
    final isLoadingTutor = data.loading && tutor == null;

    return Scaffold(
      appBar: AppBar(title: Text(t.viewTutorProfile)),
      body: RefreshIndicator(
        onRefresh: () => context.read<BookingProvider>().loadTutorDetail(widget.tutorId),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ErrorBanner(data.error),
            if (isLoadingTutor)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (tutor != null) ...[
              TutorHeader(
                tutor: tutor,
                avatarUrl: data.selectedTutorAvailabilities.isEmpty
                    ? null
                    : data.selectedTutorAvailabilities.first.tutorAvatarUrl,
              ),
              TutorAvailabilityList(
                availabilities: data.selectedTutorAvailabilities,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
