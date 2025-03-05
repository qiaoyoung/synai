import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 加载所有动态
  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _posts = await _postService.getPosts();
      _error = null;
    } catch (e) {
      _error = '加载动态失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 加载用户的动态
  Future<List<Post>> loadUserPosts(String userId) async {
    try {
      return await _postService.getUserPosts(userId);
    } catch (e) {
      print('加载用户动态失败: ${e.toString()}');
      return [];
    }
  }

  // 加载与特定AI相关的动态
  Future<List<Post>> loadPostsByAI(String aiUserId) async {
    try {
      return await _postService.getPostsByAI(aiUserId);
    } catch (e) {
      print('加载AI相关动态失败: ${e.toString()}');
      return [];
    }
  }

  // 发布新动态
  Future<void> createPost(Post post) async {
    try {
      final newPost = await _postService.createPost(post);
      _posts.insert(0, newPost);
      notifyListeners();
    } catch (e) {
      _error = '发布动态失败: ${e.toString()}';
      notifyListeners();
    }
  }

  // 点赞动态
  Future<void> likePost(String postId) async {
    try {
      await _postService.likePost(postId);
      
      // 更新本地动态状态
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final updatedPost = _posts[index].copyWith(
          likeCount: _posts[index].likeCount + 1,
        );
        _posts[index] = updatedPost;
        notifyListeners();
      }
    } catch (e) {
      print('点赞动态失败: ${e.toString()}');
    }
  }

  // 评论动态
  Future<void> commentPost(String postId, String comment) async {
    try {
      await _postService.commentPost(postId, comment);
      
      // 更新本地动态状态
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final updatedPost = _posts[index].copyWith(
          commentCount: _posts[index].commentCount + 1,
        );
        _posts[index] = updatedPost;
        notifyListeners();
      }
    } catch (e) {
      print('评论动态失败: ${e.toString()}');
    }
  }

  // 按标签筛选动态
  List<Post> filterPostsByTag(String tag) {
    return _posts.where((post) => post.tags.contains(tag)).toList();
  }

  // 搜索动态
  List<Post> searchPosts(String query) {
    if (query.isEmpty) {
      return _posts;
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _posts.where((post) {
      return post.content.toLowerCase().contains(lowercaseQuery) ||
             post.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }
} 