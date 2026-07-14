import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ui_text.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/material_models.dart';
import '../providers/material_provider.dart';
import 'add_material_dialog.dart';

class MaterialItemTile extends StatelessWidget {
  final MaterialItemModel item;
  final int availabilityId;

  const MaterialItemTile({
    super.key,
    required this.item,
    required this.availabilityId,
  });

  IconData get _icon {
    switch (item.materialType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'image':
        return Icons.image_outlined;
      case 'video':
        return Icons.videocam_outlined;
      case 'link':
        return Icons.link_rounded;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTutor = context.watch<AuthProvider>().isTutor;

    return ListTile(
      leading: Icon(_icon, color: theme.colorScheme.primary),
      title: Text(item.title),
      subtitle: item.description == null || item.description!.isEmpty
          ? null
          : Text(item.description!),
      onTap: () => _openFile(context),
      trailing: isTutor
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _editItem(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  onPressed: () => _deleteItem(context),
                ),
              ],
            )
          : Icon(Icons.open_in_new_rounded, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Future<void> _openFile(BuildContext context) async {
    final t = UiText.of(context, listen: false);
    final url = item.fileUrl?.trim() ?? '';
    final uri = url.isEmpty ? null : Uri.tryParse(url);
    final launched = uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.couldNotOpenFile)));
    }
  }

  Future<void> _editItem(BuildContext context) async {
    final result = await showAddMaterialDialog(
      context,
      initialTitle: item.title,
      initialDescription: item.description,
      initialFileUrl: item.materialType.toLowerCase() == 'link' ? item.fileUrl : null,
    );
    if (result == null || !context.mounted) return;
    await context.read<MaterialProvider>().editMaterialItem(
          availabilityId: availabilityId,
          materialId: item.materialId,
          title: result.title,
          description: result.description,
          fileUrl: result.fileUrl,
          filePath: result.filePath,
        );
  }

  Future<void> _deleteItem(BuildContext context) async {
    final t = UiText.of(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.delete),
        content: Text(t.deleteMaterialMessage(item.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<MaterialProvider>().removeMaterialItem(
          availabilityId: availabilityId,
          materialId: item.materialId,
        );
  }
}
