import 'package:flutter/material.dart';

class AIUser {
  final String id;
  final String name;
  final String avatarPath;
  final String description;
  final String specialty;
  final Color themeColor;
  final bool isPremium;
  final int messageCount;
  final double rating;
  final List<String> tags;
  final int chatCount;
  final int userCount;

  AIUser({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.description,
    required this.specialty,
    required this.themeColor,
    this.isPremium = false,
    this.messageCount = 0,
    this.rating = 5.0,
    this.tags = const [],
    this.chatCount = 0,
    this.userCount = 0,
  });

  factory AIUser.fromJson(Map<String, dynamic> json) {
    return AIUser(
      id: json['id'],
      name: json['name'],
      avatarPath: json['avatarPath'],
      description: json['description'],
      specialty: json['specialty'],
      themeColor: Color(json['themeColor']),
      isPremium: json['isPremium'] ?? false,
      messageCount: json['messageCount'] ?? 0,
      rating: json['rating'] ?? 5.0,
      tags: List<String>.from(json['tags'] ?? []),
      chatCount: json['chatCount'] ?? 0,
      userCount: json['userCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarPath': avatarPath,
      'description': description,
      'specialty': specialty,
      'themeColor': themeColor.value,
      'isPremium': isPremium,
      'messageCount': messageCount,
      'rating': rating,
      'tags': tags,
      'chatCount': chatCount,
      'userCount': userCount,
    };
  }
} 