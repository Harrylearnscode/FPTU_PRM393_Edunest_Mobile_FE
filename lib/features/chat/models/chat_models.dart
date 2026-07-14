class ConversationModel {
  final int conversationId;
  final DateTime lastMessageAt;
  final bool isActive;
  final List<int> userIds;
  final int otherUserId;
  final String otherUserName;
  final String otherUserRole;
  final String? otherUserAvatarUrl;

  ConversationModel({
    required this.conversationId,
    required this.lastMessageAt,
    required this.isActive,
    required this.userIds,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserRole,
    this.otherUserAvatarUrl,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: _asInt(json['conversationId']),
      lastMessageAt: _asDate(json['lastMessageAt']),
      isActive: json['isActive'] == true,
      userIds: (json['userIds'] as List? ?? []).map(_asInt).toList(),
      otherUserId: _asInt(json['otherUserId']),
      otherUserName: json['otherUserName']?.toString() ?? 'User',
      otherUserRole: json['otherUserRole']?.toString() ?? '',
      otherUserAvatarUrl: json['otherUserAvatarUrl']?.toString(),
    );
  }
}

class MessageModel {
  final int messageId;
  final int conversationId;
  final int userId;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.userId,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: _asInt(json['messageId']),
      conversationId: _asInt(json['conversationId']),
      userId: _asInt(json['userId']),
      content: json['content']?.toString() ?? '',
      isRead: json['isRead'] == true,
      createdAt: _asDate(json['createdAt']),
    );
  }
}

// --- Các hàm Helpers ---
int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime _asDate(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
