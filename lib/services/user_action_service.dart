import '../models/user_action.dart';
import 'local_storage_service.dart';

class UserActionService {
  final LocalStorageService _localStorageService = LocalStorageService();
  final String _blockedUsersKey = 'blocked_users';
  final String _reportedUsersKey = 'reported_users';

  // Get all blocked users
  Future<List<UserAction>> getBlockedUsers() async {
    final List<dynamic> data = await _localStorageService.getList(_blockedUsersKey) ?? [];
    return data.map((item) => UserAction.fromJson(item)).toList();
  }

  // Get all reported users
  Future<List<UserAction>> getReportedUsers() async {
    final List<dynamic> data = await _localStorageService.getList(_reportedUsersKey) ?? [];
    return data.map((item) => UserAction.fromJson(item)).toList();
  }

  // Block a user
  Future<void> blockUser(String targetUserId) async {
    final String currentUserId = 'current_user_id'; // Should get from UserProvider
    final userAction = UserAction.block(
      userId: currentUserId,
      targetUserId: targetUserId,
    );

    final blockedUsers = await getBlockedUsers();
    
    // Check if already blocked
    final alreadyBlocked = blockedUsers.any((action) => 
      action.targetUserId == targetUserId && action.userId == currentUserId);
    
    if (!alreadyBlocked) {
      blockedUsers.add(userAction);
      await _saveBlockedUsers(blockedUsers);
    }
  }

  // Unblock a user
  Future<void> unblockUser(String targetUserId) async {
    final String currentUserId = 'current_user_id'; // Should get from UserProvider
    final blockedUsers = await getBlockedUsers();
    
    final updatedList = blockedUsers.where((action) => 
      !(action.targetUserId == targetUserId && action.userId == currentUserId)).toList();
    
    await _saveBlockedUsers(updatedList);
  }

  // Report a user
  Future<void> reportUser(String targetUserId, String reason) async {
    final String currentUserId = 'current_user_id'; // Should get from UserProvider
    final userAction = UserAction.report(
      userId: currentUserId,
      targetUserId: targetUserId,
      reason: reason,
    );

    final reportedUsers = await getReportedUsers();
    reportedUsers.add(userAction);
    await _saveReportedUsers(reportedUsers);
  }

  // Check if a user is blocked
  Future<bool> isUserBlocked(String targetUserId) async {
    final String currentUserId = 'current_user_id'; // Should get from UserProvider
    final blockedUsers = await getBlockedUsers();
    
    return blockedUsers.any((action) => 
      action.targetUserId == targetUserId && action.userId == currentUserId);
  }

  // Save blocked users to local storage
  Future<void> _saveBlockedUsers(List<UserAction> blockedUsers) async {
    final List<Map<String, dynamic>> data = blockedUsers.map((action) => action.toJson()).toList();
    await _localStorageService.saveList(_blockedUsersKey, data);
  }

  // Save reported users to local storage
  Future<void> _saveReportedUsers(List<UserAction> reportedUsers) async {
    final List<Map<String, dynamic>> data = reportedUsers.map((action) => action.toJson()).toList();
    await _localStorageService.saveList(_reportedUsersKey, data);
  }
} 