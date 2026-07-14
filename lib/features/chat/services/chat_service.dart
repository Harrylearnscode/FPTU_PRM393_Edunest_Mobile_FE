import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/chat_models.dart';

class ChatService {
  final ApiClient apiClient;

  ChatService(this.apiClient);

  Future<ConversationModel> startConversation(int otherUserId) async {
    final res = await apiClient.dio
        .post('/api/chat/conversation', data: {'otherUserId': otherUserId});
    return ConversationModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<ConversationModel> startConversationByEmail(String email) async {
    final res = await apiClient.dio
        .post('/api/chat/conversation', data: {'otherUserEmail': email.trim()});
    return ConversationModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<List<ConversationModel>> getConversations() async {
    final res = await apiClient.dio.get('/api/chat/conversation');
    return ApiUtils.list(res.data)
        .map((e) => ConversationModel.fromJson(e))
        .toList();
  }

  Future<List<MessageModel>> getMessages(int conversationId) async {
    final res = await apiClient.dio
        .get('/api/chat/conversation/$conversationId/message');
    return ApiUtils.list(res.data)
        .map((e) => MessageModel.fromJson(e))
        .toList();
  }

  Future<MessageModel> sendMessage(int conversationId, String content) async {
    final res = await apiClient.dio.post(
      '/api/chat/conversation/$conversationId/message',
      data: {'content': content},
    );
    return MessageModel.fromJson(ApiUtils.asMap(res.data));
  }
}
