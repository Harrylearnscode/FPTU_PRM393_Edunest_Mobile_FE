import 'package:flutter/material.dart';

import '../../../core/ui_text.dart';

class SectionFormResult {
  final String title;
  final String? description;

  SectionFormResult({required this.title, this.description});
}

Future<SectionFormResult?> showAddSectionDialog(
  BuildContext context, {
  String? initialTitle,
  String? initialDescription,
}) {
  final t = UiText.of(context, listen: false);
  final titleController = TextEditingController(text: initialTitle ?? '');
  final descriptionController = TextEditingController(text: initialDescription ?? '');
  final isEdit = initialTitle != null;

  return showDialog<SectionFormResult>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.section),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(t.cancel),
        ),
        FilledButton(
          onPressed: () {
            final title = titleController.text.trim();
            if (title.isEmpty) return;
            Navigator.pop(
              dialogContext,
              SectionFormResult(
                title: title,
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              ),
            );
          },
          child: Text(isEdit ? t.saveChanges : t.submit),
        ),
      ],
    ),
  );
}
