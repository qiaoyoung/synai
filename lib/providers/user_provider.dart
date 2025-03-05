import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // 加载当前用户信息
  Future<void> loadCurrentUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userService.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = '加载用户信息失败: ${e.toString()}';
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 更新用户信息
  Future<void> updateUserProfile({
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
  }) async {
    if (_currentUser == null) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = _currentUser!.copyWith(
        username: username,
        email: email,
        avatarUrl: avatarUrl,
        bio: bio,
      );
      
      _currentUser = await _userService.updateUserProfile(updatedUser);
      _error = null;
    } catch (e) {
      _error = '更新用户信息失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 添加AI到收藏
  Future<void> addFavoriteAI(String aiUserId) async {
    if (_currentUser == null) {
      return;
    }

    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 800));
      
      await _userService.addFavoriteAI(aiUserId);
      
      // 更新本地用户状态
      final updatedFavorites = List<String>.from(_currentUser!.favoriteAIs);
      if (!updatedFavorites.contains(aiUserId)) {
        updatedFavorites.add(aiUserId);
        _currentUser = _currentUser!.copyWith(favoriteAIs: updatedFavorites);
        notifyListeners();
      }
    } catch (e) {
      print('添加收藏失败: ${e.toString()}');
    }
  }

  // 从收藏中移除AI
  Future<void> removeFavoriteAI(String aiUserId) async {
    if (_currentUser == null) {
      return;
    }

    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 800));
      
      await _userService.removeFavoriteAI(aiUserId);
      
      // 更新本地用户状态
      final updatedFavorites = List<String>.from(_currentUser!.favoriteAIs);
      updatedFavorites.remove(aiUserId);
      _currentUser = _currentUser!.copyWith(favoriteAIs: updatedFavorites);
      notifyListeners();
    } catch (e) {
      print('移除收藏失败: ${e.toString()}');
    }
  }

  // 检查AI是否已收藏
  bool isAIFavorited(String aiUserId) {
    if (_currentUser == null) {
      return false;
    }
    return _currentUser!.favoriteAIs.contains(aiUserId);
  }

  // 别名方法，与isAIFavorited功能相同
  bool isFavoriteAIUser(String aiUserId) {
    return isAIFavorited(aiUserId);
  }

  // 切换AI收藏状态
  Future<void> toggleFavoriteAIUser(String aiUserId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (isAIFavorited(aiUserId)) {
      await removeFavoriteAI(aiUserId);
    } else {
      await addFavoriteAI(aiUserId);
    }
  }

  // 升级为高级会员功能暂时注释掉，后续版本再添加
  /*
  Future<void> upgradeToPremium() async {
    if (_currentUser == null) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.upgradeToPremium();
      
      // 更新本地用户状态
      _currentUser = _currentUser!.copyWith(isPremium: true);
      _error = null;
    } catch (e) {
      _error = '升级会员失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  */
} 