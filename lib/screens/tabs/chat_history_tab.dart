import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ai_user.dart';
import '../../providers/ai_user_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat_session_item.dart';
import '../chat_screen.dart';

class ChatHistoryTab extends StatefulWidget {
  const ChatHistoryTab({Key? key}) : super(key: key);

  @override
  State<ChatHistoryTab> createState() => _ChatHistoryTabState();
}

class _ChatHistoryTabState extends State<ChatHistoryTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToChatScreen(AIUser aiUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(aiUser: aiUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final aiUserProvider = Provider.of<AIUserProvider>(context);
    
    // Get all chat sessions
    final chatSessions = chatProvider.chatSessions;
    
    // Filter AI users based on search
    final filteredAIUsers = _searchQuery.isEmpty
        ? aiUserProvider.aiUsers
        : aiUserProvider.searchAIUsers(_searchQuery);
    
    // Filter AI users with chat history
    final aiUsersWithChat = filteredAIUsers.where(
      (aiUser) => chatSessions.containsKey(aiUser.id),
    ).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF8A79F9), // Fully opaque theme color
                Color(0x008A79F9), // Fully transparent theme color
              ],
            ),
          ),
        ),
        toolbarHeight: 90,
        title: const Text(
          'Chat History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: chatProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Loading failed: ${chatProvider.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => chatProvider.loadAllChatSessions(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : aiUsersWithChat.isEmpty
                  ? _buildEmptyState()
                  : _buildChatList(aiUsersWithChat, chatProvider),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return const Center(
        child: Text('No matching chats found'),
      );
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No chat history yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Go to the AI Assistant page to start a new conversation',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Switch to AI Assistant tab
              // This needs to be done through HomeScreen
              // For simplicity, just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please switch to the AI Assistant tab')),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<AIUser> aiUsers, ChatProvider chatProvider) {
    return ListView.separated(
      itemCount: aiUsers.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final aiUser = aiUsers[index];
        final messages = chatProvider.chatSessions[aiUser.id] ?? [];
        
        return ChatSessionItem(
          aiUser: aiUser,
          messages: messages,
          unreadCount: 0, // Always set to 0 to hide the red dot
          onTap: () => _navigateToChatScreen(aiUser),
        );
      },
    );
  }
}

class ChatSearchDelegate extends SearchDelegate<String> {
  final AIUserProvider aiUserProvider;
  final ChatProvider chatProvider;
  final Function(AIUser) navigateToChatScreen;

  ChatSearchDelegate({
    required this.aiUserProvider,
    required this.chatProvider,
    required this.navigateToChatScreen,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Please enter search keywords'),
      );
    }

    final filteredAIUsers = aiUserProvider.searchAIUsers(query);
    final chatSessions = chatProvider.chatSessions;
    
    // Filter AI users with chat history
    final aiUsersWithChat = filteredAIUsers.where(
      (aiUser) => chatSessions.containsKey(aiUser.id),
    ).toList();

    if (aiUsersWithChat.isEmpty) {
      return const Center(
        child: Text('No matching chats found'),
      );
    }

    return ListView.separated(
      itemCount: aiUsersWithChat.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final aiUser = aiUsersWithChat[index];
        final messages = chatProvider.chatSessions[aiUser.id] ?? [];
        
        return ChatSessionItem(
          aiUser: aiUser,
          messages: messages,
          unreadCount: 0, // Always set to 0 to hide the red dot
          onTap: () {
            close(context, '');
            navigateToChatScreen(aiUser);
          },
        );
      },
    );
  }
} 