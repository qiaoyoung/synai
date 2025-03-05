import 'package:flutter/foundation.dart';
import 'user_service.dart';
import 'ai_user_service.dart';
import 'post_service.dart';
import 'local_storage_service.dart';

class DataInitializationService {
  final UserService _userService;
  final AIUserService _aiUserService;
  final PostService _postService;
  final LocalStorageService _localStorageService;
  
  DataInitializationService({
    UserService? userService,
    AIUserService? aiUserService,
    PostService? postService,
    LocalStorageService? localStorageService,
  }) : 
    _userService = userService ?? UserService(),
    _aiUserService = aiUserService ?? AIUserService(),
    _postService = postService ?? PostService(),
    _localStorageService = localStorageService ?? LocalStorageService();
  
  // 初始化应用数据
  Future<void> initializeAppData() async {
    try {
      // 初始化用户数据
      await _initializeUserData();
      
      // 初始化AI用户数据
      await _initializeAIUserData();
      
      // 初始化动态数据
      await _initializePostData();
      
      debugPrint('应用数据初始化完成');
    } catch (e) {
      debugPrint('应用数据初始化失败: $e');
    }
  }
  
  // 初始化用户数据
  Future<void> _initializeUserData() async {
    try {
      // 尝试获取用户数据，如果不存在会创建默认用户
      await _userService.getCurrentUser();
      debugPrint('用户数据初始化完成');
    } catch (e) {
      debugPrint('用户数据初始化失败: $e');
    }
  }
  
  // 初始化AI用户数据
  Future<void> _initializeAIUserData() async {
    try {
      // 尝试获取AI用户数据，如果不存在会创建默认AI用户列表
      await _aiUserService.getAIUsers();
      debugPrint('AI用户数据初始化完成');
    } catch (e) {
      debugPrint('AI用户数据初始化失败: $e');
    }
  }
  
  // 初始化动态数据
  Future<void> _initializePostData() async {
    try {
      // 尝试获取动态数据，如果不存在会创建默认动态列表
      await _postService.getPosts();
      debugPrint('动态数据初始化完成');
    } catch (e) {
      debugPrint('动态数据初始化失败: $e');
    }
  }
  
  // 重置所有数据（用于测试或重置应用）
  Future<void> resetAllData() async {
    try {
      await _localStorageService.clearAllData();
      debugPrint('所有数据已重置');
      
      // 重新初始化数据
      await initializeAppData();
    } catch (e) {
      debugPrint('数据重置失败: $e');
    }
  }
} 