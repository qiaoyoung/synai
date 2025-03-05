import 'package:flutter/material.dart';
import '../models/ai_user.dart';
import '../services/ai_user_service.dart';

class AIUserProvider extends ChangeNotifier {
  final AIUserService _aiUserService = AIUserService();
  
  List<AIUser> _aiUsers = [];
  List<AIUser> _recommendedAIUsers = [];
  List<AIUser> _popularAIUsers = [];
  bool _isLoading = false;
  String? _error;

  List<AIUser> get aiUsers => _aiUsers;
  List<AIUser> get recommendedAIUsers => _recommendedAIUsers;
  List<AIUser> get popularAIUsers => _popularAIUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 加载所有AI用户
  Future<void> loadAIUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _aiUsers = await _aiUserService.getAIUsers();
      _error = null;
    } catch (e) {
      _error = '加载AI用户失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 加载推荐的AI用户
  Future<void> loadRecommendedAIUsers() async {
    try {
      _recommendedAIUsers = await _aiUserService.getRecommendedAIUsers();
      notifyListeners();
    } catch (e) {
      print('加载推荐AI用户失败: ${e.toString()}');
    }
  }

  // 加载热门的AI用户
  Future<void> loadPopularAIUsers() async {
    try {
      _popularAIUsers = await _aiUserService.getPopularAIUsers();
      notifyListeners();
    } catch (e) {
      print('加载热门AI用户失败: ${e.toString()}');
    }
  }

  // 根据ID获取AI用户
  Future<AIUser?> getAIUserById(String id) async {
    try {
      return await _aiUserService.getAIUserById(id);
    } catch (e) {
      print('获取AI用户失败: ${e.toString()}');
      return null;
    }
  }

  // 搜索AI用户
  List<AIUser> searchAIUsers(String query) {
    if (query.isEmpty) {
      return _aiUsers;
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _aiUsers.where((user) {
      return user.name.toLowerCase().contains(lowercaseQuery) ||
             user.specialty.toLowerCase().contains(lowercaseQuery) ||
             user.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
  
  // 重置AI用户数据
  Future<void> resetAIUsers() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _aiUserService.resetAIUsers();
      await loadAIUsers();
      await loadRecommendedAIUsers();
      await loadPopularAIUsers();
    } catch (e) {
      _error = '重置AI用户数据失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 