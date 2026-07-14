import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/ui_text.dart';

class MaterialFormResult {
  final String title;
  final String? description;
  final String? fileUrl;
  final String? filePath;

  MaterialFormResult({
    required this.title,
    this.description,
    this.fileUrl,
    this.filePath,
  });
}

Future<MaterialFormResult?> showAddMaterialDialog(
  BuildContext context, {
  String? initialTitle,
  String? initialDescription,
  String? initialFileUrl,
}) {
  final t = UiText.of(context, listen: false);
  final titleController = TextEditingController(text: initialTitle ?? '');
  final descriptionController = TextEditingController(text: initialDescription ?? '');
  final linkController = TextEditingController(text: initialFileUrl ?? '');
  final isEdit = initialTitle != null;

  return showDialog<MaterialFormResult>(
    context: context,
    builder: (dialogContext) => _AddMaterialDialogContent(
      isEdit: isEdit,
      t: t,
      titleController: titleController,
      descriptionController: descriptionController,
      linkController: linkController,
    ),
  );
}

class _AddMaterialDialogContent extends StatefulWidget {
  final bool isEdit;
  final UiText t;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController linkController;

  const _AddMaterialDialogContent({
    required this.isEdit,
    required this.t,
    required this.titleController,
    required this.descriptionController,
    required this.linkController,
  });

  @override
  State<_AddMaterialDialogContent> createState() => _AddMaterialDialogContentState();
}

class _AddMaterialDialogContentState extends State<_AddMaterialDialogContent> {
  bool _useLink = false;
  PlatformFile? _pickedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return AlertDialog(
      title: Text(t.materials),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: widget.descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Upload'), icon: Icon(Icons.upload_file)),
                ButtonSegment(value: true, label: Text('Link'), icon: Icon(Icons.link)),
              ],
              selected: {_useLink},
              onSelectionChanged: (value) => setState(() => _useLink = value.first),
            ),
            const SizedBox(height: 12),
            if (_useLink)
              TextField(
                controller: widget.linkController,
                decoration: const InputDecoration(labelText: 'File URL'),
              )
            else
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file_rounded),
                label: Text(_pickedFile?.name ?? 'Choose file'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        FilledButton(
          onPressed: () {
            final title = widget.titleController.text.trim();
            if (title.isEmpty) return;
            Navigator.pop(
              context,
              MaterialFormResult(
                title: title,
                description: widget.descriptionController.text.trim().isEmpty
                    ? null
                    : widget.descriptionController.text.trim(),
                fileUrl: _useLink && widget.linkController.text.trim().isNotEmpty
                    ? widget.linkController.text.trim()
                    : null,
                filePath: !_useLink ? _pickedFile?.path : null,
              ),
            );
          },
          child: Text(widget.isEdit ? t.saveChanges : t.submit),
        ),
      ],
    );
  }
}
