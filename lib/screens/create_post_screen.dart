import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ai_user.dart';
import '../providers/ai_user_provider.dart';
import '../providers/post_provider.dart';
import '../utils/app_theme.dart';
import '../models/post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedTags = [];
  AIUser? _selectedAIUser;
  bool _isPublic = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _showTagSelectionDialog() {
    final List<String> availableTags = [
      'Technology', 'Lifestyle', 'Learning', 'Work', 'Entertainment', 'Food', 'Travel', 'Health',
      'Tech', 'Art', 'Music', 'Movies', 'Books', 'Games', 'Sports', 'Fashion',
      'Pets', 'Parenting', 'Finance', 'Career', 'Psychology', 'History', 'Science', 'Nature'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Tags'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Select up to 5 tags'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableTags.map((tag) {
                          final isSelected = _selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected && _selectedTags.length >= 5) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('You can select up to 5 tags')),
                                );
                                return;
                              }
                              setState(() {
                                if (selected) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                              this.setState(() {});
                            },
                            selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                            checkmarkColor: AppTheme.primaryColor,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAIUserSelectionDialog() {
    final aiUserProvider = Provider.of<AIUserProvider>(context, listen: false);
    final aiUsers = aiUserProvider.aiUsers;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select AI Assistant'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: aiUserProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: aiUsers.length,
                    itemBuilder: (context, index) {
                      final aiUser = aiUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(aiUser.avatarPath),
                        ),
                        title: Text(aiUser.name),
                        subtitle: Text(aiUser.specialty),
                        trailing: _selectedAIUser?.id == aiUser.id
                            ? const Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryColor,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedAIUser = aiUser;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedAIUser = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Clear Selection'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _publishPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter content')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final postProvider = Provider.of<PostProvider>(context, listen: false);

      // Create a Post object
      final post = Post(
        id: '', // Server will generate ID
        userId: 'current_user_id', // Should get from UserProvider
        content: content,
        type: PostType.text,
        mediaUrls: [],
        tags: _selectedTags,
        aiUserId: _selectedAIUser?.id,
        isPublic: _isPublic,
      );

      await postProvider.createPost(post);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post published successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          _isSubmitting
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _publishPost,
                  child: const Text(
                    'Publish',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Share your thoughts...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  minLines: 5,
                ),
                const SizedBox(height: 16),
                _buildActionButtons(),
                const SizedBox(height: 16),
                _buildTagsSection(),
                const SizedBox(height: 16),
                _buildAIUserSection(),
                const SizedBox(height: 16),
                _buildPrivacySection(),
                // Add extra space at the bottom to prevent overflow
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.tag,
          label: 'Tags',
          onTap: _showTagSelectionDialog,
        ),
        _buildActionButton(
          icon: Icons.smart_toy,
          label: 'AI Assistant',
          onTap: _showAIUserSelectionDialog,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _selectedTags.isEmpty
            ? Text(
                'Add tags to help others discover your post',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _selectedTags.remove(tag);
                      });
                    },
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppTheme.primaryColor),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildAIUserSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _selectedAIUser == null
            ? Text(
                'Select an AI assistant to associate with your post',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              )
            : ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: AssetImage(_selectedAIUser!.avatarPath),
                ),
                title: Text(_selectedAIUser!.name),
                subtitle: Text(_selectedAIUser!.specialty),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedAIUser = null;
                    });
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Row(
      children: [
        const Text(
          'Public Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Switch(
          value: _isPublic,
          onChanged: (value) {
            setState(() {
              _isPublic = value;
            });
          },
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }
} 