import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/ui_text.dart';
import '../../../core/widgets/error_banner.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_input_section.dart';
import '../widgets/conversation_item_card.dart';
import '../widgets/empty_conversations_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final otherUserEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ChatProvider>().loadConversations(),
    );
  }

  @override
  void dispose() {
    otherUserEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final t = context.strings;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Text(t.chat,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600, letterSpacing: -0.3)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.outlined(
              onPressed: data.loading ? null : data.loadConversations,
              icon: const Icon(Icons.refresh_rounded),
              style: IconButton.styleFrom(
                  side: BorderSide(color: colors.outlineVariant, width: 0.5)),
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
      body: RefreshIndicator(
        onRefresh: data.loadConversations,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            ErrorBanner(data.error),
            ChatInputSection(
              controller: otherUserEmail,
              enabled: !data.loading,
              hintText: t.userEmail,
              startLabel: t.start,
              onStart: () => _startConversation(data, t),
            ),
            ...data.conversations.map((conversation) {
              final otherIds = conversation.userIds
                  .where((id) => id != auth.userId)
                  .toList();
              final fallbackName = otherIds.isEmpty
                  ? t.conversationNumber(conversation.conversationId)
                  : otherIds.map(profile.userName).join(', ');
              final displayName = conversation.otherUserName.trim().isNotEmpty
                  ? conversation.otherUserName
                  : fallbackName;
              return ConversationItemCard(
                conversation: conversation,
                displayName: displayName,
                onTap: () =>
                    context.push('/chat/${conversation.conversationId}'),
              );
            }),
            if (data.loading && data.conversations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!data.loading && data.conversations.isEmpty)
              const EmptyConversationsView(),
          ],
        ),
      ),
    );
  }

  Future<void> _startConversation(ChatProvider data, UiText t) async {
    final email = otherUserEmail.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.enterValidUserEmail)));
      return;
    }
    try {
      final conversation = await data.startConversationByEmail(email);
      if (!mounted) return;
      otherUserEmail.clear();
      context.push('/chat/${conversation.conversationId}');
    } catch (_) {
      // ErrorBanner will show provider error.
    }
  }
}
