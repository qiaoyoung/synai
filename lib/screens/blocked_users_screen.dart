import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_action_provider.dart';
import '../models/user_action.dart';
import 'dart:math';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  @override
  void initState() {
    super.initState();
    // Load blocked users when screen is opened
    Future.microtask(() {
      Provider.of<UserActionProvider>(context, listen: false).loadUserActions();
    });
  }

  // Generate a username based on user ID (same as in PostCard)
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

  // Generate a random color based on user ID (same as in PostCard)
  Color _generateAvatarColor(String userId) {
    final random = Random(userId.hashCode);
    return Color.fromRGBO(
      random.nextInt(200) + 55, // Avoid too dark colors
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
      ),
      body: Consumer<UserActionProvider>(
        builder: (context, userActionProvider, child) {
          if (userActionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userActionProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${userActionProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => userActionProvider.loadUserActions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final blockedUsers = userActionProvider.blockedUsers;

          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text('You haven\'t blocked any users yet'),
            );
          }

          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final userAction = blockedUsers[index];
              final username = _generateUsername(userAction.targetUserId);
              final avatarColor = _generateAvatarColor(userAction.targetUserId);
              final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: avatarColor,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(username),
                subtitle: Text('Blocked on ${userAction.timestamp.toLocal().toString().split('.')[0]}'),
                trailing: TextButton(
                  onPressed: () async {
                    await userActionProvider.unblockUser(userAction.targetUserId);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$username has been unblocked')),
                      );
                    }
                  },
                  child: const Text('Unblock'),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 