import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/ai_user.dart';
import '../models/post.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';
  static const String _aiUsersKey = 'ai_users_data';
  static const String _postsKey = 'posts_data';
  static const String _favoriteAIsKey = 'favorite_ais';
  
  // 用户相关操作
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
  
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }
  
  // AI用户相关操作
  Future<void> saveAIUsers(List<AIUser> aiUsers) async {
    final prefs = await SharedPreferences.getInstance();
    final aiUsersJson = aiUsers.map((aiUser) => aiUser.toJson()).toList();
    await prefs.setString(_aiUsersKey, jsonEncode(aiUsersJson));
  }
  
  Future<List<AIUser>> getAIUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final aiUsersJson = prefs.getString(_aiUsersKey);
    if (aiUsersJson == null) return [];
    
    try {
      final List<dynamic> decodedList = jsonDecode(aiUsersJson);
      return decodedList.map((json) => AIUser.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing AI users data: $e');
      return [];
    }
  }
  
  // 收藏的AI用户
  Future<void> saveFavoriteAIs(List<String> favoriteAIs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteAIsKey, favoriteAIs);
  }
  
  Future<List<String>> getFavoriteAIs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteAIsKey) ?? [];
  }
  
  Future<void> addFavoriteAI(String aiUserId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));
    
    final favoriteAIs = await getFavoriteAIs();
    if (!favoriteAIs.contains(aiUserId)) {
      favoriteAIs.add(aiUserId);
      await saveFavoriteAIs(favoriteAIs);
    }
  }
  
  Future<void> removeFavoriteAI(String aiUserId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));
    
    final favoriteAIs = await getFavoriteAIs();
    favoriteAIs.remove(aiUserId);
    await saveFavoriteAIs(favoriteAIs);
  }
  
  // 动态相关操作
  Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => post.toJson()).toList();
    await prefs.setString(_postsKey, jsonEncode(postsJson));
  }
  
  Future<List<Post>> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString(_postsKey);
    if (postsJson == null) return [];
    
    try {
      final List<dynamic> decodedList = jsonDecode(postsJson);
      return decodedList.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing posts data: $e');
      return [];
    }
  }
  
  Future<void> addPost(Post post) async {
    final posts = await getPosts();
    posts.insert(0, post);
    await savePosts(posts);
  }
  
  Future<void> updatePost(Post updatedPost) async {
    final posts = await getPosts();
    final index = posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      posts[index] = updatedPost;
      await savePosts(posts);
    }
  }
  
  // 通用列表数据操作
  Future<List<dynamic>?> getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (e) {
      print('Error parsing list data for key $key: $e');
      return null;
    }
  }
  
  Future<void> saveList(String key, List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }
  
  // 清除所有数据（用于退出登录或重置应用）
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
} 