import 'package:flutter/foundation.dart';

enum UserActionType {
  block,
  report,
}

class UserAction {
  final String id;
  final String userId;
  final String targetUserId;
  final UserActionType type;
  final String? reason;
  final DateTime timestamp;

  UserAction({
    required this.id,
    required this.userId,
    required this.targetUserId,
    required this.type,
    this.reason,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory UserAction.block({
    required String userId,
    required String targetUserId,
  }) {
    return UserAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      targetUserId: targetUserId,
      type: UserActionType.block,
    );
  }

  factory UserAction.report({
    required String userId,
    required String targetUserId,
    required String reason,
  }) {
    return UserAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      targetUserId: targetUserId,
      type: UserActionType.report,
      reason: reason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetUserId': targetUserId,
      'type': type.toString(),
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory UserAction.fromJson(Map<String, dynamic> json) {
    return UserAction(
      id: json['id'],
      userId: json['userId'],
      targetUserId: json['targetUserId'],
      type: UserActionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => UserActionType.block,
      ),
      reason: json['reason'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserAction &&
        other.id == id &&
        other.userId == userId &&
        other.targetUserId == targetUserId &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(id, userId, targetUserId, type);
} 