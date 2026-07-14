import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../../booking/providers/booking_provider.dart';
import '../models/chat_models.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  static const restrictedChatWarning =
      'For your safety, keep communication and payment inside EduNest.';

  final ChatService chatService;

  ChatProvider({required this.chatService});

  bool loading = false;
  String? error;

  List<ConversationModel> conversations = [];
  final Map<int, List<MessageModel>> messages = {};

  void clearSessionData() {
    loading = false;
    error = null;
    conversations = [];
    messages.clear();
    notifyListeners();
  }

  void showRestrictedChatWarning() {
    error = restrictedChatWarning;
    notifyListeners();
  }

  Future<void> loadConversations() async {
    await _guard(() async {
      conversations = await chatService.getConversations();
    });
  }

  Future<ConversationModel> startConversation(int otherUserId) async {
    late ConversationModel conversation;
    await _guard(() async {
      conversation = await chatService.startConversation(otherUserId);
      conversations = await chatService.getConversations();
    });
    return conversation;
  }

  Future<ConversationModel> startConversationByEmail(String email) async {
    late ConversationModel conversation;
    await _guard(() async {
      conversation = await chatService.startConversationByEmail(email);
      final index = conversations.indexWhere(
            (item) => item.conversationId == conversation.conversationId,
      );
      if (index >= 0) {
        conversations[index] = conversation;
      } else {
        conversations.insert(0, conversation);
      }
    });
    return conversation;
  }

  Future<void> loadMessages(int conversationId) async {
    await _guard(() async {
      messages[conversationId] = await chatService.getMessages(conversationId);
    });
  }

  Future<void> sendMessage(int conversationId, String content) async {
    await _guard(() async {
      await chatService.sendMessage(conversationId, content);
      messages[conversationId] = await chatService.getMessages(conversationId);
      conversations = await chatService.getConversations();
    });
  }

  Future<bool> shouldBlockRestrictedChatMessage({
    required ConversationModel? conversation,
    required String content,
    required BookingProvider bookingProvider,
  }) async {
    final text = content.trim();
    if (conversation == null || text.isEmpty) return false;
    if (!_containsRestrictedChatContent(text)) return false;

    try {
      await bookingProvider.ensureChatRestrictionContext();
    } catch (_) {
      return false;
    }

    final tutorId = bookingProvider.tutorIdForConversation(conversation);
    if (tutorId == null) return false;
    return !bookingProvider.hasBookedTutor(tutorId);
  }

  Future<void> _guard(Future<void> Function() task) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await task();
    } catch (e) {
      error = ApiUtils.apiErrorMessage(e);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  static bool _containsRestrictedChatContent(String content) {
    final text = content.trim();
    final lower = text.toLowerCase();
    final patterns = [
      RegExp(
        r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
        caseSensitive: false,
      ),
      RegExp(
        r'\b((https?:\/\/|www\.)\S+|[A-Z0-9-]+\.(com|vn|net|org|io|me|app|edu|info)\b\S*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:^|[^\d])(?:\+?84|0)(?:[\s.\-()]?\d){8,10}(?:$|[^\d])',
        caseSensitive: false,
      ),
      RegExp(
        r'\b(zalo|facebook|fb|messenger|m\.me|telegram|whatsapp|gmail|email|e-mail|qr|vietqr|bank|banking|stk|so\s*tai\s*khoan|tai\s*khoan\s*ngan\s*hang|chuyen\s*khoan|ngan\s*hang|momo|vietcombank|vcb|techcombank|tcb|mbbank|mb\s*bank|acb|bidv|vietinbank|vpbank|tpbank)\b',
        caseSensitive: false,
      ),
    ];
    if (patterns.any((pattern) => pattern.hasMatch(text))) return true;
    final hasLongNumber =
    RegExp(r'(?:^|[^\d])(?:\d[\s.\-]*){8,20}(?:$|[^\d])').hasMatch(text);
    if (!hasLongNumber) return false;
    return lower.contains('account') ||
        lower.contains('bank') ||
        lower.contains('stk') ||
        lower.contains('tai khoan') ||
        lower.contains('ngan hang') ||
        lower.contains('chuyen khoan');
  }
}
