import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  Map<String, List<ChatMessage>> _chatSessions = {};
  String? _currentAiUserId;
  bool _isLoading = false;
  String? _error;

  Map<String, List<ChatMessage>> get chatSessions => _chatSessions;
  String? get currentAiUserId => _currentAiUserId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set current AI user ID for chat
  void setCurrentAiUserId(String aiUserId) {
    _currentAiUserId = aiUserId;
    notifyListeners();
  }

  // Get current chat messages
  List<ChatMessage> get currentChatMessages {
    if (_currentAiUserId == null) {
      return [];
    }
    return _chatSessions[_currentAiUserId] ?? [];
  }

  // Load all chat sessions
  Future<void> loadAllChatSessions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _chatSessions = await _chatService.getAllChatSessions();
      _error = null;
    } catch (e) {
      _error = 'Failed to load chat sessions: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load chat history for specific AI user
  Future<void> loadChatHistory(String aiUserId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final messages = await _chatService.getChatHistory(aiUserId);
      _chatSessions[aiUserId] = messages;
      _error = null;
    } catch (e) {
      _error = 'Failed to load chat history: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send message
  Future<void> sendMessage(String content, {MessageType type = MessageType.text}) async {
    if (_currentAiUserId == null) {
      return;
    }

    try {
      // Create user message
      final userMessage = ChatMessage(
        aiUserId: _currentAiUserId!,
        content: content,
        type: type,
        sender: MessageSender.user,
      );

      // Add to current session
      if (!_chatSessions.containsKey(_currentAiUserId)) {
        _chatSessions[_currentAiUserId!] = [];
      }
      _chatSessions[_currentAiUserId]!.add(userMessage);
      notifyListeners();

      // Send message and get AI reply
      final aiMessage = await _chatService.sendMessage(_currentAiUserId!, content, type);
      
      // Add AI reply to current session
      _chatSessions[_currentAiUserId]!.add(aiMessage);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to send message: ${e.toString()}';
      notifyListeners();
    }
  }

  // Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _chatService.markAsRead(messageId);
      
      // Update local message status
      for (final aiUserId in _chatSessions.keys) {
        for (int i = 0; i < _chatSessions[aiUserId]!.length; i++) {
          if (_chatSessions[aiUserId]![i].id == messageId) {
            final updatedMessage = _chatSessions[aiUserId]![i].copyWith(isRead: true);
            _chatSessions[aiUserId]![i] = updatedMessage;
            notifyListeners();
            return;
          }
        }
      }
    } catch (e) {
      print('Failed to mark message as read: ${e.toString()}');
    }
  }

  // Get unread message count
  int getUnreadMessageCount(String aiUserId) {
    if (!_chatSessions.containsKey(aiUserId)) {
      return 0;
    }
    
    return _chatSessions[aiUserId]!
        .where((message) => !message.isRead && message.sender == MessageSender.ai)
        .length;
  }

  // Get total unread message count
  int get totalUnreadMessageCount {
    int count = 0;
    for (final aiUserId in _chatSessions.keys) {
      count += getUnreadMessageCount(aiUserId);
    }
    return count;
  }
  
  // Clear messages for specific AI user
  Future<void> clearMessages(String aiUserId) async {
    try {
      await _chatService.clearChatHistory(aiUserId);
      
      // Update local state
      if (_chatSessions.containsKey(aiUserId)) {
        _chatSessions[aiUserId] = [];
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to clear chat history: ${e.toString()}';
      notifyListeners();
    }
  }
} 