import 'package:flutter/material.dart';
import '../models/ai_user.dart';
import 'local_storage_service.dart';

class AIUserService {
  final LocalStorageService _localStorageService = LocalStorageService();
  
  // Get AI user list
  Future<List<AIUser>> getAIUsers() async {
    // Try to get AI user list from local storage
    final aiUsers = await _localStorageService.getAIUsers();
    
    // If there is no AI user data in local storage, create default list and save
    if (aiUsers.isEmpty) {
      final defaultAIUsers = _createDefaultAIUsers();
      await _localStorageService.saveAIUsers(defaultAIUsers);
      return defaultAIUsers;
    }
    
    return aiUsers;
  }

  // Get AI user by ID
  Future<AIUser?> getAIUserById(String id) async {
    final users = await getAIUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get recommended AI users
  Future<List<AIUser>> getRecommendedAIUsers() async {
    final users = await getAIUsers();
    users.shuffle();
    return users.take(5).toList();
  }

  // Get popular AI users
  Future<List<AIUser>> getPopularAIUsers() async {
    final users = await getAIUsers();
    // Sort by popularity
    users.sort((a, b) => b.messageCount.compareTo(a.messageCount));
    return users.take(5).toList();
  }
  
  // Reset AI user data
  Future<void> resetAIUsers() async {
    final defaultAIUsers = _createDefaultAIUsers();
    await _localStorageService.saveAIUsers(defaultAIUsers);
  }
  
  // Create default AI user list
  List<AIUser> _createDefaultAIUsers() {
    return [
      AIUser(
        id: '1',
        name: 'Sophia',
        avatarPath: 'assets/images/ai_avatars/1.png',
        description: 'I am a friendly AI assistant who can help you solve various problems.',
        specialty: 'Daily Assistant',
        themeColor: Colors.blue,
        isPremium: false,
        rating: 4.8,
        messageCount: 12563,
        chatCount: 4328,
        userCount: 2150,
        tags: ['Task Management', 'Reminders', 'Daily Planning', 'Information Lookup', 'General Knowledge'],
      ),
      AIUser(
        id: '2',
        name: 'Amy',
        avatarPath: 'assets/images/ai_avatars/2.png',
        description: 'An AI partner focused on creative writing and storytelling.',
        specialty: 'Creative Writing',
        themeColor: Colors.purple,
        isPremium: true,
        rating: 4.9,
        messageCount: 18742,
        chatCount: 6254,
        userCount: 3421,
        tags: ['Story Development', 'Character Creation', 'Plot Ideas', 'Poetry', 'Creative Prompts'],
      ),
      AIUser(
        id: '3',
        name: 'Tech Master',
        avatarPath: 'assets/images/ai_avatars/3.png',
        description: 'Stay updated with the latest tech trends and get answers to tech questions.',
        specialty: 'Technology News',
        themeColor: Colors.green,
        isPremium: false,
        rating: 4.7,
        messageCount: 9876,
        chatCount: 3245,
        userCount: 1876,
        tags: ['Tech News', 'Gadget Reviews', 'Programming Help', 'Tech Troubleshooting', 'Digital Trends'],
      ),
      AIUser(
        id: '4',
        name: 'Life Coach',
        avatarPath: 'assets/images/ai_avatars/4.png',
        description: 'Providing life advice and solutions to everyday problems.',
        specialty: 'Life Guidance',
        themeColor: Colors.pink,
        isPremium: true,
        rating: 4.6,
        messageCount: 7654,
        chatCount: 2543,
        userCount: 1432,
        tags: ['Personal Growth', 'Goal Setting', 'Motivation', 'Habit Formation', 'Work-Life Balance'],
      ),
      AIUser(
        id: '5',
        name: 'Study Mentor',
        avatarPath: 'assets/images/ai_avatars/5.png',
        description: 'Assisting in learning various knowledge and answering academic questions.',
        specialty: 'Educational Tutoring',
        themeColor: Colors.orange,
        isPremium: false,
        rating: 4.9,
        messageCount: 21345,
        chatCount: 7123,
        userCount: 4532,
        tags: ['Math', 'Science', 'History', 'Literature', 'Study Techniques', 'Exam Preparation'],
      ),
      AIUser(
        id: '6',
        name: 'Fitness Trainer',
        avatarPath: 'assets/images/ai_avatars/6.png',
        description: 'Providing fitness advice and diet plans to help you stay healthy.',
        specialty: 'Health & Fitness',
        themeColor: Colors.red,
        isPremium: false,
        rating: 4.5,
        messageCount: 6543,
        chatCount: 2187,
        userCount: 1098,
        tags: ['Workout Plans', 'Nutrition Advice', 'Weight Management', 'Fitness Goals', 'Healthy Recipes'],
      ),
      AIUser(
        id: '7',
        name: 'Travel Advisor',
        avatarPath: 'assets/images/ai_avatars/7.png',
        description: 'Recommending travel destinations and planning travel routes.',
        specialty: 'Travel Planning',
        themeColor: Colors.teal,
        isPremium: true,
        rating: 4.7,
        messageCount: 8765,
        chatCount: 2912,
        userCount: 1456,
        tags: ['Destination Guides', 'Itinerary Planning', 'Budget Travel', 'Local Cuisine', 'Cultural Experiences'],
      ),
      AIUser(
        id: '8',
        name: 'Financial Advisor',
        avatarPath: 'assets/images/ai_avatars/8.png',
        description: 'Providing financial advice to help you manage your finances.',
        specialty: 'Financial Management',
        themeColor: Colors.amber,
        isPremium: true,
        rating: 4.8,
        messageCount: 10987,
        chatCount: 3654,
        userCount: 1827,
        tags: ['Budgeting', 'Investing', 'Saving Strategies', 'Debt Management', 'Financial Planning'],
      ),
      AIUser(
        id: '9',
        name: 'Food Expert',
        avatarPath: 'assets/images/ai_avatars/9.png',
        description: 'Sharing food recipes and recommending restaurants.',
        specialty: 'Food & Cooking',
        themeColor: Colors.deepOrange,
        isPremium: false,
        rating: 4.6,
        messageCount: 7654,
        chatCount: 2543,
        userCount: 1276,
        tags: ['Recipes', 'Cooking Techniques', 'Meal Planning', 'Restaurant Recommendations', 'Food Pairing'],
      ),
      AIUser(
        id: '10',
        name: 'Movie Expert',
        avatarPath: 'assets/images/ai_avatars/10.png',
        description: 'Recommending movies and discussing films.',
        specialty: 'Movie Recommendations',
        themeColor: Colors.indigo,
        isPremium: false,
        rating: 4.5,
        messageCount: 6543,
        chatCount: 2187,
        userCount: 1098,
        tags: ['Film Reviews', 'Movie Recommendations', 'Film History', 'Directors & Actors', 'Genre Analysis'],
      ),
      AIUser(
        id: '11',
        name: 'Music Advisor',
        avatarPath: 'assets/images/ai_avatars/11.png',
        description: 'Recommending music and discussing musical works.',
        specialty: 'Music Recommendations',
        themeColor: Colors.deepPurple,
        isPremium: false,
        rating: 4.4,
        messageCount: 5432,
        chatCount: 1812,
        userCount: 906,
        tags: ['Music Discovery', 'Artist Profiles', 'Genre Exploration', 'Playlist Creation', 'Music History'],
      ),
      AIUser(
        id: '12',
        name: 'Career Mentor',
        avatarPath: 'assets/images/ai_avatars/12.png',
        description: 'Providing career development advice to help you plan your career path.',
        specialty: 'Career Planning',
        themeColor: Colors.brown,
        isPremium: true,
        rating: 4.8,
        messageCount: 9876,
        chatCount: 3292,
        userCount: 1646,
        tags: ['Resume Building', 'Interview Preparation', 'Job Search', 'Skill Development', 'Career Transitions'],
      ),
      AIUser(
        id: '13',
        name: 'Fashion Advisor',
        avatarPath: 'assets/images/ai_avatars/13.png',
        description: 'Providing fashion matching advice and tracking fashion trends.',
        specialty: 'Fashion Styling',
        themeColor: Colors.pinkAccent,
        isPremium: false,
        rating: 4.3,
        messageCount: 4321,
        chatCount: 1437,
        userCount: 723,
        tags: ['Style Advice', 'Outfit Coordination', 'Fashion Trends', 'Wardrobe Planning', 'Shopping Tips'],
      ),
      AIUser(
        id: '14',
        name: 'Gaming Buddy',
        avatarPath: 'assets/images/ai_avatars/14.png',
        description: 'Discussing games and providing game strategies.',
        specialty: 'Gaming & Entertainment',
        themeColor: Colors.lightBlue,
        isPremium: false,
        rating: 4.7,
        messageCount: 8765,
        chatCount: 2912,
        userCount: 1456,
        tags: ['Game Reviews', 'Gaming Strategies', 'Game Recommendations', 'Gaming News', 'Esports'],
      ),
      AIUser(
        id: '15',
        name: 'Home Designer',
        avatarPath: 'assets/images/ai_avatars/15.png',
        description: 'Providing home decoration and design advice to help you create your ideal home.',
        specialty: 'Home Design',
        themeColor: Colors.cyan,
        isPremium: true,
        rating: 4.6,
        messageCount: 7654,
        chatCount: 2543,
        userCount: 1276,
        tags: ['Interior Design', 'Furniture Selection', 'Color Schemes', 'Space Planning', 'DIY Projects'],
      ),
      AIUser(
        id: '16',
        name: 'Pet Advisor',
        avatarPath: 'assets/images/ai_avatars/16.png',
        description: 'Providing daily pet care advice and sharing pet stories.',
        specialty: 'Pet Companion',
        themeColor: Colors.lime,
        isPremium: false,
        rating: 4.5,
        messageCount: 6543,
        chatCount: 2187,
        userCount: 1098,
        tags: ['Pet Care', 'Training Tips', 'Pet Health', 'Pet Behavior', 'Pet Products'],
      ),
      AIUser(
        id: '17',
        name: 'Gardening Expert',
        avatarPath: 'assets/images/ai_avatars/17.png',
        description: 'Providing plant care advice and sharing gardening knowledge.',
        specialty: 'Gardening & Plants',
        themeColor: Colors.lightGreen,
        isPremium: false,
        rating: 4.4,
        messageCount: 5432,
        chatCount: 1812,
        userCount: 906,
        tags: ['Plant Care', 'Garden Planning', 'Indoor Plants', 'Seasonal Gardening', 'Sustainable Gardening'],
      ),
      AIUser(
        id: '18',
        name: 'Life Encyclopedia',
        avatarPath: 'assets/images/ai_avatars/18.png',
        description: 'Answering various life knowledge questions and providing practical tips.',
        specialty: 'Life Knowledge',
        themeColor: Colors.blueGrey,
        isPremium: true,
        rating: 4.9,
        messageCount: 15678,
        chatCount: 5226,
        userCount: 2613,
        tags: ['Life Hacks', 'DIY Solutions', 'Practical Knowledge', 'Everyday Tips', 'Problem Solving'],
      ),
      AIUser(
        id: '19',
        name: 'Language Teacher',
        avatarPath: 'assets/images/ai_avatars/19.png',
        description: 'Helping you learn foreign languages and providing language practice.',
        specialty: 'Language Learning',
        themeColor: Colors.indigoAccent,
        isPremium: false,
        rating: 4.7,
        messageCount: 8765,
        chatCount: 2912,
        userCount: 1456,
        tags: ['Language Practice', 'Grammar Help', 'Vocabulary Building', 'Pronunciation', 'Cultural Context'],
      ),
      AIUser(
        id: '20',
        name: 'History Scholar',
        avatarPath: 'assets/images/ai_avatars/20.png',
        description: 'Discussing historical events and sharing historical knowledge.',
        specialty: 'Historical Knowledge',
        themeColor: Colors.brown,
        isPremium: false,
        rating: 4.5,
        messageCount: 6543,
        chatCount: 2187,
        userCount: 1098,
        tags: ['World History', 'Ancient Civilizations', 'Historical Figures', 'War History', 'Cultural History'],
      ),
      AIUser(
        id: '21',
        name: 'Philosopher',
        avatarPath: 'assets/images/ai_avatars/21.png',
        description: 'Exploring life questions and sharing thinking methods.',
        specialty: 'Thinking Methods',
        themeColor: Colors.grey,
        isPremium: true,
        rating: 4.8,
        messageCount: 9876,
        chatCount: 3292,
        userCount: 1646,
        tags: ['Critical Thinking', 'Philosophical Concepts', 'Ethical Dilemmas', 'Logic & Reasoning', 'Mindfulness'],
      ),
    ];
  }
} 