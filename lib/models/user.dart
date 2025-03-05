class User {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final bool isPremium;
  final List<String> favoriteAIs;
  final DateTime createdAt;
  final DateTime lastActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.isPremium = false,
    this.favoriteAIs = const [],
    required this.createdAt,
    required this.lastActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      isPremium: json['isPremium'] ?? false,
      favoriteAIs: List<String>.from(json['favoriteAIs'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      lastActive: DateTime.parse(json['lastActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'isPremium': isPremium,
      'favoriteAIs': favoriteAIs,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    bool? isPremium,
    List<String>? favoriteAIs,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isPremium: isPremium ?? this.isPremium,
      favoriteAIs: favoriteAIs ?? this.favoriteAIs,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
} 