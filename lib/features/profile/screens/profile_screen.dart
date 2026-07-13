import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/ui_text.dart';
import '../providers/profile_provider.dart';
import '../../../core/widgets/error_banner.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/profile_models.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_form.dart';
import '../widgets/legal_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileFormKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();
  final tutorBio = TextEditingController();
  int? filledProfileUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    tutorBio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ProfileProvider>();
    final auth = context.watch<AuthProvider>();
    final profile = data.profile;
    final theme = Theme.of(context);
    final t = context.strings;
    _fillOnce(profile);
    final isTutor = auth.isTutor || profile?.role == 'Tutor';

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          t.personalProfile,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: data.loading
                ? null
                : () async {
                    setState(() => filledProfileUserId = null);
                    await context.read<ProfileProvider>().loadProfile();
                  },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: data.loadProfile,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            ErrorBanner(data.error),
            if (data.loading && profile == null)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              ProfileHeaderCard(
                profile: profile,
                auth: auth,
                loading: data.loading,
                onUploadAvatar: _pickAndUploadAvatar,
                onDeleteAvatar: _deleteAvatar,
              ),
              const SizedBox(height: 20),
              ProfileForm(
                formKey: profileFormKey,
                profile: profile,
                isTutor: isTutor,
                name: name,
                phone: phone,
                tutorBio: tutorBio,
                loading: data.loading,
                onSave: _saveProfile,
              ),
              const SizedBox(height: 20),
              const LegalCard(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(
                      color: theme.colorScheme.error.withOpacity(0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    await context.read<AuthProvider>().logout();
                    if (!context.mounted) return;
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    t.logOut,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  void _fillOnce(ProfileModel? profile) {
    if (profile == null) {
      if (filledProfileUserId != null) {
        name.clear();
        phone.clear();
        tutorBio.clear();
        filledProfileUserId = null;
      }
      return;
    }

    if (filledProfileUserId == profile.userId) return;

    name.text = profile.name;
    phone.text = profile.phone ?? '';
    tutorBio.text = profile.tutorBio ?? '';
    filledProfileUserId = profile.userId;
  }

  Future<void> _saveProfile() async {
    if (!profileFormKey.currentState!.validate()) return;
    try {
      await context.read<ProfileProvider>().updateProfile(
            name: name.text.trim(),
            phone: phone.text.trim(),
            tutorBio: tutorBio.text.trim(),
          );
      if (!mounted) return;
      final t = UiText.of(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.profileUpdated)),
      );
    } catch (_) {}
  }

  Future<void> _pickAndUploadAvatar() async {
    final data = context.read<ProfileProvider>();
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 900,
      );
      if (picked == null) return;
      await data.uploadAvatar(picked.path);
      if (!mounted) return;
      final t = UiText.of(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.avatarUpdated)),
      );
    } catch (e) {
      if (!mounted) return;
      final t = UiText.of(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.couldNotUploadAvatar(e))),
      );
    }
  }

  Future<void> _deleteAvatar() async {
    final data = context.read<ProfileProvider>();
    final profile = data.profile;
    final avatarUrl = profile?.avatarUrl?.trim() ?? '';
    if (avatarUrl.isEmpty) {
      final t = UiText.of(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.noAvatarToDelete)),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final t = UiText.of(dialogContext, listen: false);
        return AlertDialog(
          title: Text(t.deleteAvatarTitle),
          content: Text(t.deleteAvatarMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(t.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(t.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;
    try {
      await data.deleteAvatar();
      if (!mounted) return;
      final t = UiText.of(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.avatarDeleted)),
      );
    } catch (_) {}
  }
}
