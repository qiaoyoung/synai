import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_user_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import 'tabs/ai_list_tab.dart';
import 'tabs/community_tab.dart';
import 'tabs/chat_history_tab.dart';
import 'tabs/settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _tabs = [
    const AIListTab(),
    const CommunityTab(),
    const ChatHistoryTab(),
    const SettingsTab(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load user data
    await Provider.of<UserProvider>(context, listen: false).loadCurrentUser();
    
    // Load AI user data
    await Provider.of<AIUserProvider>(context, listen: false).loadAIUsers();
    await Provider.of<AIUserProvider>(context, listen: false).loadRecommendedAIUsers();
    await Provider.of<AIUserProvider>(context, listen: false).loadPopularAIUsers();
    
    // Load chat session data
    await Provider.of<ChatProvider>(context, listen: false).loadAllChatSessions();
    
    // Load community post data
    await Provider.of<PostProvider>(context, listen: false).loadPosts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _tabs,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
} 