import 'package:flutter/material.dart';
import '../models/user_action.dart';
import '../services/user_action_service.dart';

class UserActionProvider extends ChangeNotifier {
  final UserActionService _userActionService = UserActionService();
  
  List<UserAction> _blockedUsers = [];
  List<UserAction> _reportedUsers = [];
  bool _isLoading = false;
  String? _error;

  List<UserAction> get blockedUsers => _blockedUsers;
  List<UserAction> get reportedUsers => _reportedUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserActionProvider() {
    loadUserActions();
  }

  Future<void> loadUserActions() async {
    _setLoading(true);
    try {
      _blockedUsers = await _userActionService.getBlockedUsers();
      _reportedUsers = await _userActionService.getReportedUsers();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> blockUser(String targetUserId) async {
    _setLoading(true);
    try {
      await _userActionService.blockUser(targetUserId);
      await loadUserActions();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> unblockUser(String targetUserId) async {
    _setLoading(true);
    try {
      await _userActionService.unblockUser(targetUserId);
      await loadUserActions();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> reportUser(String targetUserId, String reason) async {
    _setLoading(true);
    try {
      await _userActionService.reportUser(targetUserId, reason);
      await loadUserActions();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> isUserBlocked(String targetUserId) async {
    return await _userActionService.isUserBlocked(targetUserId);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 