import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../utils/date_formatter.dart';
import '../providers/user_action_provider.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTap;
  final String? aiUserName;
  final String? aiUserAvatar;

  const PostCard({
    Key? key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onTap,
    this.aiUserName,
    this.aiUserAvatar,
  }) : super(key: key);

  // Generate a random username based on user ID
  String _generateUsername(String userId) {
    // List of first names
    final firstNames = [
      'Alex', 'Blake', 'Casey', 'Dana', 'Ellis', 
      'Finley', 'Gray', 'Harper', 'Indigo', 'Jordan',
      'Kelly', 'Logan', 'Morgan', 'Noah', 'Parker',
      'Quinn', 'Riley', 'Sage', 'Taylor', 'Avery'
    ];
    
    // List of last names
    final lastNames = [
      'Smith', 'Johnson', 'Williams', 'Brown', 'Jones',
      'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Wilson',
      'Martinez', 'Anderson', 'Taylor', 'Thomas', 'Moore',
      'Jackson', 'Martin', 'Lee', 'Thompson', 'White'
    ];
    
    // Use the user ID to deterministically select a name
    final random = Random(userId.hashCode);
    final firstName = firstNames[random.nextInt(firstNames.length)];
    final lastName = lastNames[random.nextInt(lastNames.length)];
    
    return '$firstName $lastName';
  }

  // Generate a random color based on user ID
  Color _generateAvatarColor(String userId) {
    final random = Random(userId.hashCode);
    return Color.fromRGBO(
      random.nextInt(200) + 55, // Avoid too dark colors
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
      1.0,
    );
  }

  void _showMoreOptionsMenu(BuildContext context, String userId, String username) {
    final userActionProvider = Provider.of<UserActionProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User'),
                subtitle: Text('You won\'t see posts from $username anymore'),
                onTap: () async {
                  Navigator.pop(context);
                  await userActionProvider.blockUser(userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$username has been blocked')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title: const Text('Report User'),
                subtitle: const Text('Report inappropriate content or behavior'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context, userId, username);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog(BuildContext context, String userId, String username) {
    final userActionProvider = Provider.of<UserActionProvider>(context, listen: false);
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report $username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide a reason for reporting this user:'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: 'Enter reason here',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a reason')),
                  );
                  return;
                }
                
                Navigator.pop(context);
                await userActionProvider.reportUser(userId, reasonController.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$username has been reported')),
                );
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            if (post.mediaUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildMediaContent(),
            ],
            if (post.aiUserId != null && aiUserName != null) ...[
              const SizedBox(height: 12),
              _buildAIReference(),
            ],
            if (post.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildTags(),
            ],
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final username = _generateUsername(post.userId);
    final avatarColor = _generateAvatarColor(post.userId);
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: avatarColor,
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormatter.formatPostTime(post.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showMoreOptionsMenu(context, post.userId, username),
        ),
      ],
    );
  }

  Widget _buildMediaContent() {
    if (post.type == PostType.image) {
      if (post.mediaUrls.length == 1) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            post.mediaUrls.first,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: post.mediaUrls.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                post.mediaUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildAIReference() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (aiUserAvatar != null) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(aiUserAvatar!),
            ),
            const SizedBox(width: 8),
          ] else ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.purple.withOpacity(0.2),
              child: const Icon(
                Icons.smart_toy,
                size: 16,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              'Conversation with ${aiUserName ?? 'AI Assistant'}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: post.tags.map((tag) {
        return Container(
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
        );
      }).toList(),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.favorite_border,
          label: post.likeCount.toString(),
          onPressed: onLike,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 