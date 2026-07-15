import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ui_text.dart';
import '../providers/lesson_provider.dart';
import '../../../core/widgets/error_banner.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/lesson_model.dart';

class LessonDetailScreen extends StatefulWidget {
  final int lessonId;

  const LessonDetailScreen({
    super.key,
    required this.lessonId,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final meetingLink = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _reload();
      if (!mounted) return;
      final detail =
          context.read<LessonProvider>().lessonDetails[widget.lessonId];
      if (detail != null && detail.meetingLink.trim().isNotEmpty) {
        meetingLink.text = detail.meetingLink;
      }
    });
  }

  @override
  void dispose() {
    meetingLink.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final data = context.read<LessonProvider>();
    await data.loadLessonDetail(widget.lessonId);
  }

  Future<void> _openMeeting(String link) async {
    final t = UiText.of(context, listen: false);
    final uri = Uri.tryParse(link.trim());
    if (uri == null) {
      if (!mounted) return;
      _showSnack(t.invalidMeetingLink);
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) _showSnack(t.couldNotOpenMeeting);
  }

  Future<void> _saveMeetingLink() async {
    final t = UiText.of(context, listen: false);
    try {
      await context.read<LessonProvider>().setLessonMeetingLink(
            lessonId: widget.lessonId,
            meetingLink: meetingLink.text.trim(),
          );
      if (!mounted) return;
      _showSnack(t.text('Meeting link saved'));
    } catch (_) {}
  }

  Future<void> _completeLesson() async {
    final t = UiText.of(context, listen: false);
    try {
      await context
          .read<LessonProvider>()
          .completeLessonGroup(widget.lessonId);
      if (!mounted) return;
      _showSnack(t.text('Lesson completed'));
    } catch (_) {}
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final data = context.watch<LessonProvider>();
    final auth = context.watch<AuthProvider>();
    final detail = data.lessonDetails[widget.lessonId];
    final isTutor = auth.isTutor;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/lessons');
            }
          },
        ),
        titleSpacing: 4,
        title: Text(
          t.text('Lesson detail'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.outlined(
              onPressed: data.loading ? null : _reload,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              style: IconButton.styleFrom(
                side: BorderSide(color: colors.outlineVariant, width: 0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: colors.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      body: detail == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
                children: [
                  ErrorBanner(data.error),
                  _LessonHeaderCard(detail: detail),
                  const SizedBox(height: 10),
                  _MeetingLinkCard(
                    controller: meetingLink,
                    detail: detail,
                    isTutor: isTutor,
                    loading: data.loading,
                    onOpenMeeting: _openMeeting,
                    onSave: _saveMeetingLink,
                  ),
                  const SizedBox(height: 18),
                  if (isTutor) ...[
                    // Students section label
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            t.text('Students'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              '${detail.students.length}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ...detail.students.map(
                      (student) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _StudentCard(
                          student: student,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    _CompleteLessonButton(
                      detail: detail,
                      loading: data.loading,
                      onComplete: _completeLesson,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

// -----------------------------------------------------------------------------
// Lesson Header Card
// -----------------------------------------------------------------------------

class _LessonHeaderCard extends StatelessWidget {
  final LessonDetailModel detail;
  const _LessonHeaderCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final start = detail.scheduleTime.toLocal();
    final end = start.add(Duration(minutes: detail.duration));
    final dateStr = DateFormat('dd/MM/yyyy').format(start);
    final timeStr =
        '${DateFormat('HH:mm').format(start)} â€” ${DateFormat('HH:mm').format(end)}';

    final (statusBg, statusFg, statusBorder) = _statusColors(detail.status);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Status icon circle
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: statusBg,
              shape: BoxShape.circle,
              border: Border.all(color: statusBorder, width: 0.5),
            ),
            child: Icon(_statusIcon(detail.status), size: 22, color: statusFg),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeStr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${detail.duration} ${t.text('minutes')}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: statusBorder, width: 0.5),
            ),
            child: Text(
              t.status(detail.status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusFg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline_rounded;
      case 'cancelled':
      case 'expired':
      case 'failed':
        return Icons.cancel_outlined;
      default:
        return Icons.schedule_outlined;
    }
  }

  (Color, Color, Color) _statusColors(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return (
          const Color(0xFFEAF3DE),
          const Color(0xFF3B6D11),
          const Color(0xFFC0DD97),
        );
      case 'cancelled':
      case 'expired':
      case 'failed':
        return (
          const Color(0xFFFCEBEB),
          const Color(0xFFA32D2D),
          const Color(0xFFF7C1C1),
        );
      default:
        return (
          const Color(0xFFFAEEDA),
          const Color(0xFF854F0B),
          const Color(0xFFFAC775),
        );
    }
  }
}

// -----------------------------------------------------------------------------
// Meeting Link Card
// -----------------------------------------------------------------------------

class _MeetingLinkCard extends StatelessWidget {
  final TextEditingController controller;
  final LessonDetailModel detail;
  final bool isTutor;
  final bool loading;
  final Future<void> Function(String link) onOpenMeeting;
  final Future<void> Function() onSave;

  const _MeetingLinkCard({
    required this.controller,
    required this.detail,
    required this.isTutor,
    required this.loading,
    required this.onOpenMeeting,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final hasMeetingLink = detail.meetingLink.trim().isNotEmpty;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F1FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.video_call_outlined,
                      size: 18, color: Color(0xFF185FA5)),
                ),
                const SizedBox(width: 10),
                Text(
                  t.text('Google Meet link'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Divider(
              height: 0.5,
              thickness: 0.5,
              color: colors.outlineVariant.withValues(alpha: 0.4)),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                if (isTutor) ...[
                  TextField(
                    controller: controller,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: t.text('Meeting link'),
                      hintText: t.text('Paste Google Meet link here'),
                      prefixIcon: const Icon(Icons.link_rounded, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: colors.outlineVariant, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: colors.outlineVariant, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: colors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ] else if (!hasMeetingLink)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      t.text('No meeting link yet'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    if (isTutor) ...[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: loading ? null : onSave,
                          icon: loading
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.save_outlined, size: 17),
                          label: Text(
                            loading ? t.text('Saving...') : t.text('Save link'),
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 42),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: hasMeetingLink
                            ? () => onOpenMeeting(detail.meetingLink)
                            : null,
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: Text(t.open),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 42),
                          side: BorderSide(
                              color: colors.outlineVariant, width: 0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Student Card
// -----------------------------------------------------------------------------

class _StudentCard extends StatelessWidget {
  final LessonStudentModel student;

  const _StudentCard({
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final initials = _initials(student.studentName);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.studentName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  t.status(student.lessonStatus),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// -----------------------------------------------------------------------------
// Complete Lesson Button
// -----------------------------------------------------------------------------

class _CompleteLessonButton extends StatelessWidget {
  final LessonDetailModel detail;
  final bool loading;
  final Future<void> Function() onComplete;

  const _CompleteLessonButton({
    required this.detail,
    required this.loading,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final status = detail.status.toLowerCase();
    final alreadyCompleted = status == 'completed';
    final allStudentsCompleted = detail.students.isNotEmpty &&
        detail.students
            .every((x) => x.lessonStatus.toLowerCase() == 'completed');
    final canComplete =
        detail.canComplete && !alreadyCompleted && !allStudentsCompleted;

    // Locked state
    if (alreadyCompleted || allStudentsCompleted) {
      return Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3DE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  size: 20, color: Color(0xFF3B6D11)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.text('Lesson completed'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.text(
                      'Actions are now locked.',
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.55),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Not yet available
    if (!detail.canComplete) {
      return Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFAEEDA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.schedule_outlined,
                  size: 20, color: Color(0xFF854F0B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.text('Complete lesson unavailable'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.text(
                      'You can complete this lesson after the lesson end time.',
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.55),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Available
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: !canComplete || loading ? null : onComplete,
        icon: loading
            ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.check_circle_outline_rounded, size: 18),
        label: Text(
          loading ? t.text('Completing...') : t.text('Complete lesson'),
        ),
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
