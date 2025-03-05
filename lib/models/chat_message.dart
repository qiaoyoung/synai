import 'package:uuid/uuid.dart';

enum MessageType {
  text,
  image,
  audio,
  video,
  file,
}

enum MessageSender {
  user,
  ai,
}

class ChatMessage {
  final String id;
  final String aiUserId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageSender sender;
  final bool isRead;
  final String? mediaUrl;

  ChatMessage({
    String? id,
    required this.aiUserId,
    required this.content,
    required this.type,
    required this.sender,
    DateTime? timestamp,
    this.isRead = false,
    this.mediaUrl,
  }) : 
    this.id = id ?? const Uuid().v4(),
    this.timestamp = timestamp ?? DateTime.now();

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      aiUserId: json['aiUserId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.byName(json['type']),
      sender: MessageSender.values.byName(json['sender']),
      isRead: json['isRead'] ?? false,
      mediaUrl: json['mediaUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aiUserId': aiUserId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'sender': sender.name,
      'isRead': isRead,
      'mediaUrl': mediaUrl,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? aiUserId,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    MessageSender? sender,
    bool? isRead,
    String? mediaUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      aiUserId: aiUserId ?? this.aiUserId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }
} 