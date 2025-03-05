import '../models/user.dart';
import 'local_storage_service.dart';

class UserService {
  final LocalStorageService _localStorageService = LocalStorageService();
  
  // 获取当前用户信息
  Future<User> getCurrentUser() async {
    // 尝试从本地存储获取用户
    final user = await _localStorageService.getUser();
    
    // 如果本地没有用户数据，创建一个默认用户并保存
    if (user == null) {
      final defaultUser = User(
        id: 'current_user',
        username: '当前用户',
        email: 'user@example.com',
        avatarUrl: 'assets/images/user_avatar.png',
        bio: '热爱科技和AI的普通用户',
        isPremium: false,
        favoriteAIs: ['1', '2', '5'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastActive: DateTime.now(),
      );
      
      await _localStorageService.saveUser(defaultUser);
      return defaultUser;
    }
    
    return user;
  }

  // 更新用户信息
  Future<User> updateUserProfile(User user) async {
    // 保存到本地存储
    await _localStorageService.saveUser(user);
    return user;
  }

  // 添加AI到收藏
  Future<void> addFavoriteAI(String aiUserId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 700));
    
    await _localStorageService.addFavoriteAI(aiUserId);
    
    // 同时更新用户对象中的收藏列表
    final user = await getCurrentUser();
    if (!user.favoriteAIs.contains(aiUserId)) {
      final updatedFavorites = List<String>.from(user.favoriteAIs)..add(aiUserId);
      final updatedUser = user.copyWith(favoriteAIs: updatedFavorites);
      await updateUserProfile(updatedUser);
    }
  }

  // 从收藏中移除AI
  Future<void> removeFavoriteAI(String aiUserId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 700));
    
    await _localStorageService.removeFavoriteAI(aiUserId);
    
    // 同时更新用户对象中的收藏列表
    final user = await getCurrentUser();
    if (user.favoriteAIs.contains(aiUserId)) {
      final updatedFavorites = List<String>.from(user.favoriteAIs)..remove(aiUserId);
      final updatedUser = user.copyWith(favoriteAIs: updatedFavorites);
      await updateUserProfile(updatedUser);
    }
  }

  // 会员相关功能暂时注释掉，后续版本再添加
  /*
  // 检查用户是否为高级会员
  Future<bool> checkPremiumStatus() async {
    final user = await getCurrentUser();
    return user.isPremium;
  }

  // 升级为高级会员
  Future<void> upgradeToPremium() async {
    final user = await getCurrentUser();
    final updatedUser = user.copyWith(isPremium: true);
    await updateUserProfile(updatedUser);
  }
  */
} 