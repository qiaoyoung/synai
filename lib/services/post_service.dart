import '../models/post.dart';
import 'local_storage_service.dart';

class PostService {
  final LocalStorageService _localStorageService = LocalStorageService();
  
  // Get all posts
  Future<List<Post>> getPosts() async {
    // Try to get posts from local storage
    final posts = await _localStorageService.getPosts();
    
    // If there are no posts in local storage, create default ones and save them
    if (posts.isEmpty) {
      final defaultPosts = _createDefaultPosts();
      await _localStorageService.savePosts(defaultPosts);
      return defaultPosts;
    }
    
    return posts;
  }

  // Get posts by a specific user
  Future<List<Post>> getUserPosts(String userId) async {
    final posts = await getPosts();
    return posts.where((post) => post.userId == userId).toList();
  }

  // Get posts related to a specific AI
  Future<List<Post>> getPostsByAI(String aiUserId) async {
    final posts = await getPosts();
    return posts.where((post) => post.aiUserId == aiUserId).toList();
  }

  // Create a new post
  Future<Post> createPost(Post post) async {
    // Save to local storage
    await _localStorageService.addPost(post);
    return post;
  }

  // Like a post
  Future<void> likePost(String postId) async {
    final posts = await getPosts();
    final index = posts.indexWhere((post) => post.id == postId);
    
    if (index != -1) {
      final post = posts[index];
      final updatedPost = post.copyWith(likeCount: post.likeCount + 1);
      posts[index] = updatedPost;
      await _localStorageService.savePosts(posts);
    }
  }

  // Comment on a post
  Future<void> commentPost(String postId, String comment) async {
    final posts = await getPosts();
    final index = posts.indexWhere((post) => post.id == postId);
    
    if (index != -1) {
      final post = posts[index];
      final updatedPost = post.copyWith(commentCount: post.commentCount + 1);
      posts[index] = updatedPost;
      await _localStorageService.savePosts(posts);
    }
  }
  
  // Create default posts
  List<Post> _createDefaultPosts() {
    return [
      Post(
        id: '1',
        userId: 'user1',
        content: 'I had a great chat with Sophia today! She really understands me. I recommend everyone to try chatting with her.',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        aiUserId: '1',
        tags: ['AI Assistant', 'Daily'],
      ),
      Post(
        id: '2',
        userId: 'user2',
        content: 'Amy helped me write a poem, sharing it with everyone:\n\nStarry night with gentle breeze,\nThoughts drift away with ease.\nMoonlight shines upon my heart,\nWaiting for the day to start.',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        aiUserId: '2',
        tags: ['Creative Writing', 'Poetry'],
      ),
      Post(
        id: '3',
        userId: 'user3',
        content: 'Feeling good today! The weather is beautiful, planning to go for a walk.',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        tags: ['Mood', 'Daily'],
      ),
      Post(
        id: '4',
        userId: 'user4',
        content: 'The fitness coach created a workout plan for me. I\'ve been following it for a week now and feeling great!',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        aiUserId: '6',
        tags: ['Fitness', 'Lifestyle'],
      ),
      Post(
        id: '5',
        userId: 'user5',
        content: 'This book recommended by the Study Mentor is truly inspiring. Highly recommend!',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 24)),
        aiUserId: '5',
        tags: ['Books', 'Learning'],
      ),
      Post(
        id: '6',
        userId: 'user6',
        content: 'The Travel Advisor helped me plan a perfect trip itinerary. Looking forward to my vacation next month!',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 36)),
        aiUserId: '7',
        tags: ['Travel', 'Planning'],
      ),
      Post(
        id: '7',
        userId: 'user7',
        content: 'This restaurant recommended by the Food Expert is amazing! The dishes are exquisite and delicious.',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 48)),
        aiUserId: '9',
        tags: ['Food', 'Recommendations'],
      ),
      Post(
        id: '8',
        userId: 'user8',
        content: 'The movie recommended by the Film Expert has an intriguing plot and excellent acting performances.',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 60)),
        aiUserId: '10',
        tags: ['Movies', 'Recommendations'],
      ),
      Post(
        id: '9',
        userId: 'user9',
        content: 'The song shared by the Music Advisor has a beautiful melody and touching lyrics. I\'ve been playing it on repeat all day.',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 72)),
        aiUserId: '11',
        tags: ['Music', 'Sharing'],
      ),
      Post(
        id: '10',
        userId: 'user9',
        content: 'Had a deep conversation with the Philosopher about the meaning of life today. Got many insights.',
        type: PostType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 96)),
        aiUserId: '21',
        tags: ['Philosophy', 'Life'],
      ),
    ];
  }
} 