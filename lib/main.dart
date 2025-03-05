import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ai_user_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/post_provider.dart';
import 'providers/user_provider.dart';
import 'providers/user_action_provider.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'utils/app_theme.dart';
import 'services/data_initialization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app data
  final dataInitializationService = DataInitializationService();
  await dataInitializationService.initializeAppData();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadCurrentUser()),
        ChangeNotifierProvider(create: (_) => AIUserProvider()..loadAIUsers()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()..loadPosts()),
        ChangeNotifierProvider(create: (_) => UserActionProvider()),
      ],
      child: MaterialApp(
        title: 'Synai AI',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Use light theme by default
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      ),
    );
  }
}
