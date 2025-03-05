import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post.dart';
import '../../providers/ai_user_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/post_card.dart';
import '../create_post_screen.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedTag;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );
  }

  Future<void> _refreshPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final aiUserProvider = Provider.of<AIUserProvider>(context);
    
    // Filter posts based on search and tags
    List<Post> filteredPosts = postProvider.posts;
    
    if (_searchQuery.isNotEmpty) {
      filteredPosts = postProvider.searchPosts(_searchQuery);
    }
    
    if (_selectedTag != null) {
      filteredPosts = filteredPosts.where((post) => post.tags.contains(_selectedTag)).toList();
    }

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
        title: const Text(
          'Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_selectedTag != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '#$_selectedTag',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTag = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: postProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : postProvider.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Loading failed: ${postProvider.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => postProvider.loadPosts(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : filteredPosts.isEmpty
                        ? const Center(
                            child: Text('No posts found'),
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshPosts,
                            child: _buildPostList(filteredPosts, aiUserProvider),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostList(List<Post> posts, AIUserProvider aiUserProvider) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        
        // Get AI user information (if available)
        String? aiUserName;
        String? aiUserAvatar;
        
        if (post.aiUserId != null) {
          final aiUser = aiUserProvider.aiUsers.firstWhere(
            (user) => user.id == post.aiUserId,
            orElse: () => throw Exception('AI user does not exist'),
          );
          aiUserName = aiUser.name;
          aiUserAvatar = aiUser.avatarPath;
        }
        
        return PostCard(
          post: post,
          aiUserName: aiUserName,
          aiUserAvatar: aiUserAvatar,
          onLike: () => postProvider.likePost(post.id),
          onComment: null,
          onShare: null,
          onTap: null,
        );
      },
    );
  }

  Widget _buildCommentSheet(Post post) {
    final commentController = TextEditingController();
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      final postProvider = Provider.of<PostProvider>(context, listen: false);
                      postProvider.commentPost(post.id, commentController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSheet(List<String> tags) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tags',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedTag = tag;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PostSearchDelegate extends SearchDelegate<String> {
  final PostProvider postProvider;
  final AIUserProvider aiUserProvider;

  PostSearchDelegate({
    required this.postProvider,
    required this.aiUserProvider,
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

    final filteredPosts = postProvider.searchPosts(query);

    if (filteredPosts.isEmpty) {
      return const Center(
        child: Text('No matching posts found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        final post = filteredPosts[index];
        
        // Get AI user information (if available)
        String? aiUserName;
        String? aiUserAvatar;
        
        if (post.aiUserId != null) {
          final aiUser = aiUserProvider.aiUsers.firstWhere(
            (user) => user.id == post.aiUserId,
            orElse: () => throw Exception('AI user does not exist'),
          );
          aiUserName = aiUser.name;
          aiUserAvatar = aiUser.avatarPath;
        }
        
        return PostCard(
          post: post,
          aiUserName: aiUserName,
          aiUserAvatar: aiUserAvatar,
          onLike: () {
            postProvider.likePost(post.id);
          },
          onComment: () {
            // Close search page
            close(context, '');
            
            // Show comment dialog
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => _buildCommentSheet(context, post),
            );
          },
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sharing feature coming soon')),
            );
          },
          onTap: () {},
        );
      },
    );
  }

  Widget _buildCommentSheet(BuildContext context, Post post) {
    final commentController = TextEditingController();
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      postProvider.commentPost(post.id, commentController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 