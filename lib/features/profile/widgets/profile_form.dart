import 'package:flutter/material.dart';
import '../../../core/ui_text.dart';
import '../models/profile_models.dart';

/// Editable form with the user's personal information (name, phone, bio).
class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ProfileModel? profile;
  final bool isTutor;
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController tutorBio;
  final bool loading;
  final VoidCallback onSave;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.profile,
    required this.isTutor,
    required this.name,
    required this.phone,
    required this.tutorBio,
    required this.loading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.strings;

    InputDecoration inputStyle(
      String label,
      IconData icon, {
      bool enabled = true,
    }) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: enabled ? theme.colorScheme.primary : Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.2)
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_pin_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  t.personalInformation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            TextFormField(
              initialValue: profile?.email ?? '',
              enabled: false,
              decoration: inputStyle(
                t.emailAddress,
                Icons.email_outlined,
                enabled: false,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: name,
              decoration: inputStyle(t.fullName, Icons.person_outline),
              validator: (value) => _required(context, value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phone,
              decoration: inputStyle(t.phoneNumber, Icons.phone_outlined),
              keyboardType: TextInputType.phone,
            ),
            if (isTutor) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: tutorBio,
                decoration: inputStyle(
                  t.biographyTutor,
                  Icons.description_outlined,
                ),
                minLines: 3,
                maxLines: 5,
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: loading ? null : onSave,
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  t.saveChanges,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _required(BuildContext context, String? value) {
  if (value == null || value.trim().isEmpty) {
    return UiText.of(context, listen: false).thisFieldRequired;
  }
  return null;
}
