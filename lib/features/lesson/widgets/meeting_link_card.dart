import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ui_text.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/lesson_models.dart';
import '../providers/lesson_provider.dart';

class MeetingLinkCard extends StatelessWidget {
  final LessonModel lesson;

  const MeetingLinkCard({super.key, required this.lesson});

  static Future<void> openMeetingLink(BuildContext context, String? link) async {
    final t = UiText.of(context, listen: false);
    final trimmed = link?.trim() ?? '';
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.meetingLinkNotAdded)));
      return;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.invalidMeetingLink)));
      return;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.couldNotOpenMeeting)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;
    final isTutor = context.watch<AuthProvider>().isTutor;
    final hasLink = (lesson.meetingLink ?? '').trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.videocam_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hasLink ? lesson.meetingLink! : t.meetingLinkNotAdded,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hasLink)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => openMeetingLink(context, lesson.meetingLink),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(t.openMeeting),
                  ),
                ),
              if (hasLink && isTutor) const SizedBox(width: 10),
              if (isTutor)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editMeetingLink(context),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(hasLink ? t.saveChanges : t.openMeeting),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editMeetingLink(BuildContext context) async {
    final t = UiText.of(context, listen: false);
    final controller = TextEditingController(text: lesson.meetingLink ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.openMeeting),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'https://meet.example.com/...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(t.saveChanges),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty || !context.mounted) return;
    await context.read<LessonProvider>().updateMeetingLink(lesson.lessonId, result);
  }
}
