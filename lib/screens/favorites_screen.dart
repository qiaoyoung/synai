import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_user_provider.dart';
import '../models/ai_user.dart';
import '../utils/app_theme.dart';
import '../widgets/ai_user_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<AIUser> _favoriteAIUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteAIUsers();
  }

  Future<void> _loadFavoriteAIUsers() async {
    // 模拟加载收藏的AI用户
    // 实际应用中，这里应该从本地存储或服务器获取用户收藏的AI用户
    await Future.delayed(const Duration(milliseconds: 800));
    
    final aiUserProvider = Provider.of<AIUserProvider>(context, listen: false);
    
    // 获取所有AI用户
    if (aiUserProvider.aiUsers.isEmpty) {
      await aiUserProvider.loadAIUsers();
    }
    
    // 模拟从所有AI用户中随机选择3-5个作为收藏
    // 实际应用中，这里应该根据用户的收藏记录来筛选
    final allAIUsers = aiUserProvider.aiUsers;
    if (allAIUsers.isNotEmpty) {
      // 为了演示，我们选择前3个AI用户作为收藏
      _favoriteAIUsers = allAIUsers.take(3).toList();
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'My Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteAIUsers.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your favorite AI users will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteAIUsers.length,
      itemBuilder: (context, index) {
        final aiUser = _favoriteAIUsers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildFavoriteCard(aiUser),
        );
      },
    );
  }

  Widget _buildFavoriteCard(AIUser aiUser) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI用户信息头部
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: aiUser.themeColor.withOpacity(0.2),
                  backgroundImage: AssetImage(aiUser.avatarPath),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            aiUser.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (aiUser.isPremium) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        aiUser.specialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    // 取消收藏
                    setState(() {
                      _favoriteAIUsers.remove(aiUser);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${aiUser.name} removed from favorites'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            setState(() {
                              _favoriteAIUsers.insert(0, aiUser);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // AI用户描述
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              aiUser.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 标签和统计信息
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...aiUser.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: aiUser.themeColor.withOpacity(0.1),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
              ],
            ),
          ),
          // 操作按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${aiUser.chatCount} chats',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${aiUser.userCount} users',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // 开始聊天
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Chat with ${aiUser.name} coming soon')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: aiUser.themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(80, 36),
                  ),
                  child: const Text('Chat'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 