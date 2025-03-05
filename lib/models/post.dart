import 'package:uuid/uuid.dart';

enum PostType {
  text,
  image,
  aiChat,
}

class Post {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;
  final PostType type;
  final List<String> mediaUrls;
  final int likeCount;
  final int commentCount;
  final String? aiUserId;
  final List<String> tags;
  final bool isPublic;

  Post({
    String? id,
    required this.userId,
    required this.content,
    required this.type,
    DateTime? timestamp,
    this.mediaUrls = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.aiUserId,
    this.tags = const [],
    this.isPublic = true,
  }) : 
    this.id = id ?? const Uuid().v4(),
    this.timestamp = timestamp ?? DateTime.now();

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: PostType.values.byName(json['type']),
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      aiUserId: json['aiUserId'],
      tags: List<String>.from(json['tags'] ?? []),
      isPublic: json['isPublic'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'mediaUrls': mediaUrls,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'aiUserId': aiUserId,
      'tags': tags,
      'isPublic': isPublic,
    };
  }

  Post copyWith({
    String? id,
    String? userId,
    String? content,
    DateTime? timestamp,
    PostType? type,
    List<String>? mediaUrls,
    int? likeCount,
    int? commentCount,
    String? aiUserId,
    List<String>? tags,
    bool? isPublic,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      aiUserId: aiUserId ?? this.aiUserId,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
    );
  }
} 