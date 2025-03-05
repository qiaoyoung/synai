import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ai_user.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/post_card.dart';
import 'chat_screen.dart';

class AIUserDetailScreen extends StatefulWidget {
  final AIUser aiUser;

  const AIUserDetailScreen({
    Key? key,
    required this.aiUser,
  }) : super(key: key);

  @override
  State<AIUserDetailScreen> createState() => _AIUserDetailScreenState();
}

class _AIUserDetailScreenState extends State<AIUserDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.loadPostsByAI(widget.aiUser.id);
      
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        _isFavorite = userProvider.isFavoriteAIUser(widget.aiUser.id);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    // 设置加载状态
    setState(() {
      _isLoading = true;
    });
    
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.toggleFavoriteAIUser(widget.aiUser.id);
    
    // 更新状态
    setState(() {
      _isFavorite = !_isFavorite;
      _isLoading = false;
    });
    
    // 显示操作成功的提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(aiUser: widget.aiUser),
      ),
    );
  }

  void _showReportDialog() {
    final reportReasons = [
      'Inappropriate content',
      'Inaccurate information',
      'Poor response quality',
      'Harmful advice',
      'Other issues'
    ];
    
    String? selectedReason;
    final TextEditingController detailsController = TextEditingController();
    bool isSubmitting = false;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Report AI Assistant'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please select a reason for reporting:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...reportReasons.map((reason) {
                      return RadioListTile<String>(
                        title: Text(reason),
                        value: reason,
                        groupValue: selectedReason,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    const Text(
                      'Additional details (optional):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: detailsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Please provide more information...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                isSubmitting
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: selectedReason == null
                            ? null
                            : () async {
                                setState(() {
                                  isSubmitting = true;
                                });
                                
                                // 模拟网络延迟
                                await Future.delayed(const Duration(milliseconds: 1500));
                                
                                // 关闭对话框
                                Navigator.of(context).pop();
                                
                                // 显示提交成功的提示
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Thank you for your report. We will review ${widget.aiUser.name} based on your feedback.'),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.aiUser.themeColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Submit Report'),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.posts.where((post) => post.aiUserId == widget.aiUser.id).toList();
    final userProvider = Provider.of<UserProvider>(context);
    // Premium related features temporarily commented out, will be added in future versions
    // final isPremium = userProvider.currentUser?.isPremium ?? false;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.aiUser.themeColor.withOpacity(0.8),
                        widget.aiUser.themeColor.withOpacity(0.4),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              widget.aiUser.avatarPath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Avatar path: ${widget.aiUser.avatarPath}');
                                print('Error loading image: ${widget.aiUser.avatarPath}, Error: $error');
                                print('Stacktrace: $stackTrace');
                                return Icon(
                                  Icons.person,
                                  size: 60,
                                  color: widget.aiUser.themeColor,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.aiUser.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.aiUser.specialty,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                IconButton(
                  icon: const Icon(
                    Icons.flag_outlined,
                    color: Colors.white,
                  ),
                  onPressed: _showReportDialog,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _startChat,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.aiUser.themeColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Start Chat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Premium related features temporarily commented out, will be added in future versions
                  /*
                  if (widget.aiUser.isPremium && !isPremium)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Premium AI Assistant',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Subscribe to premium for unlimited access to ${widget.aiUser.name}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Premium feature coming soon')),
                              );
                            },
                            child: const Text('Subscribe Now'),
                          ),
                        ],
                      ),
                    ),
                  */
                  _buildInfoSection(),
                  TabBar(
                    controller: _tabController,
                    labelColor: widget.aiUser.themeColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: widget.aiUser.themeColor,
                    tabs: const [
                      Tab(text: 'About'),
                      Tab(text: 'Related Posts'),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAboutTab(),
            _buildPostsTab(posts, postProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.star,
            value: widget.aiUser.rating.toString(),
            label: 'Rating',
          ),
          _buildInfoItem(
            icon: Icons.chat_bubble,
            value: widget.aiUser.chatCount.toString(),
            label: 'Chats',
          ),
          _buildInfoItem(
            icon: Icons.people,
            value: widget.aiUser.userCount.toString(),
            label: 'Users',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: widget.aiUser.themeColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(widget.aiUser.description),
          const SizedBox(height: 24),
          const Text(
            'Expertise',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.aiUser.tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: widget.aiUser.themeColor.withOpacity(0.1),
                labelStyle: TextStyle(color: widget.aiUser.themeColor),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Example Conversation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildExampleConversation(),
          const SizedBox(height: 24),
          const Text(
            'User Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildReviews(),
        ],
      ),
    );
  }

  Widget _buildExampleConversation() {
    final List<Map<String, dynamic>> examples = [
      {
        'isUser': true,
        'content': 'Can you explain the basic principles of quantum computing?',
      },
      {
        'isUser': false,
        'content': 'Quantum computing uses quantum mechanics principles like superposition and entanglement to process information. Unlike classical computers that use bits (0 or 1), quantum computers use qubits that can exist in multiple states simultaneously. This makes quantum computers more efficient for certain problems.',
      },
      {
        'isUser': true,
        'content': 'What are some practical applications of quantum computers?',
      },
      {
        'isUser': false,
        'content': 'Quantum computers have potential applications in cryptography, drug discovery, materials science, and optimization problems. For example, they can simulate molecular behavior to accelerate new drug development or solve complex optimization problems like logistics route planning.',
      },
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: examples.map((example) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (example['isUser'])
                    const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 16),
                    )
                  else
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          widget.aiUser.avatarPath,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image in conversation: ${widget.aiUser.avatarPath}, Error: $error');
                            return Icon(
                              Icons.smart_toy,
                              size: 16,
                              color: widget.aiUser.themeColor,
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: example['isUser']
                            ? Colors.grey[100]
                            : widget.aiUser.themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(example['content']),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReviews() {
    // Generate dynamic reviews based on AI user ID to ensure different AIs have different reviews
    final List<Map<String, dynamic>> reviews = _generateReviewsForAI(widget.aiUser);

    return Column(
      children: reviews.map((review) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review['rating'] ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(review['content']),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Generate unique reviews for each AI based on their specialty and ID
  List<Map<String, dynamic>> _generateReviewsForAI(AIUser aiUser) {
    // Use AI ID to create deterministic but different reviews for each AI
    final int seed = int.parse(aiUser.id);
    
    // List of possible review templates
    final List<Map<String, dynamic>> reviewTemplates = [
      {
        'positive': [
          'Incredibly helpful with ${aiUser.specialty.toLowerCase()}. Saved me hours of research!',
          'The responses are detailed and well-explained. Exactly what I needed for ${aiUser.specialty.toLowerCase()}.',
          'I\'ve tried several AI assistants, but ${aiUser.name} is by far the best for ${aiUser.specialty.toLowerCase()}.',
          'Provides thoughtful and nuanced answers. Really impressed with the depth of knowledge.',
          'Exceeded my expectations! The advice on ${aiUser.specialty.toLowerCase()} was practical and easy to follow.',
        ],
        'neutral': [
          'Generally helpful, though sometimes takes a few attempts to get the exact information I need.',
          'Good for basic questions about ${aiUser.specialty.toLowerCase()}, but struggles with more complex topics.',
          'Useful assistant, but response times can be inconsistent during peak hours.',
          'Decent knowledge base, but occasionally provides outdated information that needs fact-checking.',
          'Helpful for most ${aiUser.specialty.toLowerCase()} questions, though the interface could be more intuitive.',
        ],
        'negative': [
          'Sometimes misunderstands my questions about ${aiUser.specialty.toLowerCase()}. Needs improvement.',
          'Responses can be too generic. I expected more specialized knowledge for an expert in ${aiUser.specialty.toLowerCase()}.',
          'Occasionally provides contradictory information, which is frustrating when trying to learn.',
          'The response quality varies significantly from day to day.',
          'Too many generic answers that feel like they could apply to any topic, not just ${aiUser.specialty.toLowerCase()}.',
        ]
      }
    ];
    
    // Generate 3-5 reviews based on AI rating
    int reviewCount = aiUser.rating >= 4.7 ? 5 : (aiUser.rating >= 4.5 ? 4 : 3);
    
    List<Map<String, dynamic>> generatedReviews = [];
    
    // Distribution of ratings based on AI's overall rating
    List<int> ratings = [];
    if (aiUser.rating >= 4.8) {
      // Mostly 5 stars, some 4 stars
      ratings = [5, 5, 5, 5, 4];
    } else if (aiUser.rating >= 4.5) {
      // Mix of 5 and 4 stars
      ratings = [5, 5, 4, 4, 3];
    } else if (aiUser.rating >= 4.0) {
      // More 4 stars, some 5 and 3
      ratings = [5, 4, 4, 3, 3];
    } else {
      // More mixed ratings
      ratings = [5, 4, 3, 3, 2];
    }
    
    // Generate the reviews
    for (int i = 0; i < reviewCount; i++) {
      int rating = ratings[i % ratings.length];
      String content;
      
      // Select content based on rating
      if (rating >= 5) {
        content = reviewTemplates[0]['positive'][(seed + i * 7) % reviewTemplates[0]['positive'].length];
      } else if (rating >= 4) {
        content = reviewTemplates[0]['neutral'][(seed + i * 11) % reviewTemplates[0]['neutral'].length];
      } else {
        content = reviewTemplates[0]['negative'][(seed + i * 13) % reviewTemplates[0]['negative'].length];
      }
      
      generatedReviews.add({
        'rating': rating,
        'content': content,
      });
    }
    
    return generatedReviews;
  }

  Widget _buildPostsTab(List<Post> posts, PostProvider postProvider) {
    return postProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : posts.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.post_add,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No related posts yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(
                    post: post,
                    onLike: () => postProvider.likePost(post.id),
                    onComment: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment feature coming soon')),
                      );
                    },
                    onShare: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing feature coming soon')),
                      );
                    },
                  );
                },
              );
  }
} 