import '../models/chat_message.dart';
import 'zhipu_ai_service.dart';

class ChatService {
  final ZhipuAIService _zhipuAIService = ZhipuAIService();
  
  // Store chat history for each AI user
  final Map<String, List<Map<String, String>>> _chatHistories = {};
  
  // Get chat history from local storage or mock data
  Future<List<ChatMessage>> getChatHistory(String aiUserId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Based on AI user ID return different chat history
    switch (aiUserId) {
      case '1': // Sophia
        return [
          ChatMessage(
            aiUserId: '1',
            content: 'Hello! I\'m Sophia. How can I help you today?',
            type: MessageType.text,
            sender: MessageSender.ai,
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          ),
          ChatMessage(
            aiUserId: '1',
            content: 'I want to know about today\'s weather',
            type: MessageType.text,
            sender: MessageSender.user,
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 55)),
          ),
          ChatMessage(
            aiUserId: '1',
            content: 'Based on my search, today\'s weather is sunny with temperatures between 20-25°C, perfect for outdoor activities.',
            type: MessageType.text,
            sender: MessageSender.ai,
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 50)),
          ),
        ];
      case '2': // Amy
        return [
          ChatMessage(
            aiUserId: '2',
            content: 'Hello! I\'m Amy, I can help you create various types of content.',
            type: MessageType.text,
            sender: MessageSender.ai,
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
          ),
          ChatMessage(
            aiUserId: '2',
            content: 'Can you write a poem about spring for me?',
            type: MessageType.text,
            sender: MessageSender.user,
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2, minutes: 55)),
          ),
          ChatMessage(
            aiUserId: '2',
            content: 'Of course! Here\'s a poem about spring:\n\nGentle breeze awakens the earth,\nFlowers bloom in colorful birth.\nGreen spreads across hills and streams,\nBirds sing sweet melodies in dreams.',
            type: MessageType.text,
            sender: MessageSender.ai,
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2, minutes: 50)),
          ),
        ];
      default:
        return [];
    }
  }

  // Send message to AI and get response
  Future<ChatMessage> sendMessage(String aiUserId, String content, MessageType type) async {
    // Create user message
    final userMessage = ChatMessage(
      aiUserId: aiUserId,
      content: content,
      type: type,
      sender: MessageSender.user,
    );
    
    // Initialize chat history for this AI if it doesn't exist
    if (!_chatHistories.containsKey(aiUserId)) {
      _chatHistories[aiUserId] = [];
    }
    
    // Add user message to history for context
    _chatHistories[aiUserId]!.add({
      'role': 'user',
      'content': content,
    });
    
    // Simulate network delay for user message processing
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get AI response from Zhipu AI
    String aiReply = await _zhipuAIService.sendMessage(content, _chatHistories[aiUserId]!);
    
    // Add AI response to history for future context
    _chatHistories[aiUserId]!.add({
      'role': 'assistant',
      'content': aiReply,
    });
    
    // Limit history size to prevent token limit issues (keep last 10 messages)
    if (_chatHistories[aiUserId]!.length > 20) {
      _chatHistories[aiUserId] = _chatHistories[aiUserId]!.sublist(_chatHistories[aiUserId]!.length - 20);
    }
    
    // Create AI message
    final aiMessage = ChatMessage(
      aiUserId: aiUserId,
      content: aiReply,
      type: MessageType.text,
      sender: MessageSender.ai,
    );
    
    return aiMessage;
  }

  // Get all chat sessions
  Future<Map<String, List<ChatMessage>>> getAllChatSessions() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final Map<String, List<ChatMessage>> sessions = {};
    
    // Get chat with Sophia
    sessions['1'] = await getChatHistory('1');
    
    // Get chat with Amy
    sessions['2'] = await getChatHistory('2');
    
    return sessions;
  }

  // Mark message as read
  Future<void> markAsRead(String messageId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real application, this would call an API to update message status
    print('Message $messageId marked as read');
  }
  
  // Clear chat history
  Future<void> clearChatHistory(String aiUserId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Clear the chat history for this AI
    if (_chatHistories.containsKey(aiUserId)) {
      _chatHistories[aiUserId] = [];
    }
    
    print('Chat history with AI $aiUserId cleared');
  }
} 