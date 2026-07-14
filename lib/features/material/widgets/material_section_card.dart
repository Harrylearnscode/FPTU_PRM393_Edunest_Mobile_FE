import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/material_models.dart';
import '../providers/material_provider.dart';
import 'add_material_dialog.dart';
import 'add_section_dialog.dart';
import 'material_item_tile.dart';

class MaterialSectionCard extends StatelessWidget {
  final MaterialSectionModel section;
  final int availabilityId;

  const MaterialSectionCard({
    super.key,
    required this.section,
    required this.availabilityId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;
    final isTutor = context.watch<AuthProvider>().isTutor;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(section.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: section.description == null || section.description!.isEmpty
              ? Text(t.materialsN(section.items.length))
              : Text(section.description!),
          children: [
            ...section.items.map(
              (item) => MaterialItemTile(item: item, availabilityId: availabilityId),
            ),
            if (isTutor)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _addMaterial(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(t.materials),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _editSection(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () => _deleteSection(context),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMaterial(BuildContext context) async {
    final result = await showAddMaterialDialog(context);
    if (result == null || !context.mounted) return;
    await context.read<MaterialProvider>().addMaterialItem(
          availabilityId: availabilityId,
          sectionId: section.sectionId,
          title: result.title,
          description: result.description,
          fileUrl: result.fileUrl,
          filePath: result.filePath,
        );
  }

  Future<void> _editSection(BuildContext context) async {
    final result = await showAddSectionDialog(
      context,
      initialTitle: section.title,
      initialDescription: section.description,
    );
    if (result == null || !context.mounted) return;
    await context.read<MaterialProvider>().editSection(
          availabilityId: availabilityId,
          sectionId: section.sectionId,
          title: result.title,
          description: result.description,
        );
  }

  Future<void> _deleteSection(BuildContext context) async {
    final t = UiText.of(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.delete),
        content: Text(t.deleteSectionMessage(section.title)),
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
    await context.read<MaterialProvider>().removeSection(
          availabilityId: availabilityId,
          sectionId: section.sectionId,
        );
  }
}
