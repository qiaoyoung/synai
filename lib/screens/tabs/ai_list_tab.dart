import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ai_user.dart';
import '../../providers/ai_user_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/ai_user_card.dart';
import '../chat_screen.dart';

class AIListTab extends StatefulWidget {
  const AIListTab({Key? key}) : super(key: key);

  @override
  State<AIListTab> createState() => _AIListTabState();
}

class _AIListTabState extends State<AIListTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isRefreshing = false;

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

  // Refresh data method with simulated network delay
  Future<void> _refreshData() async {
    final aiUserProvider = Provider.of<AIUserProvider>(context, listen: false);
    
    setState(() {
      _isRefreshing = true;
    });
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Refreshing data...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    // Reset AI user data
    await aiUserProvider.resetAIUsers();
    
    // Close loading dialog
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    
    setState(() {
      _isRefreshing = false;
    });
    
    // Show refresh success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data refreshed successfully, AI ratings and chat data updated'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiUserProvider = Provider.of<AIUserProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    
    final filteredAIUsers = _searchQuery.isEmpty
        ? aiUserProvider.aiUsers
        : aiUserProvider.searchAIUsers(_searchQuery);

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
          'AI Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
            onPressed: () {
              showSearch(
                context: context,
                delegate: AISearchDelegate(
                  aiUserProvider: aiUserProvider,
                  userProvider: userProvider,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: _isRefreshing 
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.refresh, color: Colors.white, size: 26),
              onPressed: _isRefreshing ? null : _refreshData,
            ),
          ),
        ],
      ),
      body: aiUserProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : aiUserProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Loading failed: ${aiUserProvider.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => aiUserProvider.loadAIUsers(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildAIUserList(aiUserProvider, userProvider),
    );
  }

  Widget _buildSearchResults(List<AIUser> aiUsers, UserProvider userProvider) {
    if (aiUsers.isEmpty) {
      return const Center(
        child: Text('No matching AI assistants found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: aiUsers.length,
      itemBuilder: (context, index) {
        final aiUser = aiUsers[index];
        final isFavorite = userProvider.isAIFavorited(aiUser.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AIUserCard(
            aiUser: aiUser,
            isFavorite: isFavorite,
            onToggleFavorite: () => userProvider.toggleFavoriteAIUser(aiUser.id),
          ),
        );
      },
    );
  }

  Widget _buildAIUserList(AIUserProvider aiUserProvider, UserProvider userProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('Recommended AI Assistants'),
        const SizedBox(height: 8),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: aiUserProvider.recommendedAIUsers.length,
            itemBuilder: (context, index) {
              final aiUser = aiUserProvider.recommendedAIUsers[index];
              final isFavorite = userProvider.isAIFavorited(aiUser.id);

              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: AIUserCard(
                  aiUser: aiUser,
                  isFavorite: isFavorite,
                  onToggleFavorite: () => userProvider.toggleFavoriteAIUser(aiUser.id),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Popular AI Assistants'),
        const SizedBox(height: 8),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: aiUserProvider.popularAIUsers.length,
            itemBuilder: (context, index) {
              final aiUser = aiUserProvider.popularAIUsers[index];
              final isFavorite = userProvider.isAIFavorited(aiUser.id);

              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: AIUserCard(
                  aiUser: aiUser,
                  isFavorite: isFavorite,
                  onToggleFavorite: () => userProvider.toggleFavoriteAIUser(aiUser.id),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('All AI Assistants'),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: aiUserProvider.aiUsers.length,
          itemBuilder: (context, index) {
            final aiUser = aiUserProvider.aiUsers[index];
            final isFavorite = userProvider.isAIFavorited(aiUser.id);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AIUserCard(
                aiUser: aiUser,
                isFavorite: isFavorite,
                onToggleFavorite: () => userProvider.toggleFavoriteAIUser(aiUser.id),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AISearchDelegate extends SearchDelegate<String> {
  final AIUserProvider aiUserProvider;
  final UserProvider userProvider;

  AISearchDelegate({
    required this.aiUserProvider,
    required this.userProvider,
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

    if (filteredAIUsers.isEmpty) {
      return const Center(
        child: Text('No matching AI assistants found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAIUsers.length,
      itemBuilder: (context, index) {
        final aiUser = filteredAIUsers[index];
        final isFavorite = userProvider.isAIFavorited(aiUser.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AIUserCard(
            aiUser: aiUser,
            isFavorite: isFavorite,
            onToggleFavorite: () => userProvider.toggleFavoriteAIUser(aiUser.id),
          ),
        );
      },
    );
  }
} 