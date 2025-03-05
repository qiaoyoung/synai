import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_action_provider.dart';
import '../models/user_action.dart';
import 'dart:math';

class ReportedUsersScreen extends StatefulWidget {
  const ReportedUsersScreen({Key? key}) : super(key: key);

  @override
  State<ReportedUsersScreen> createState() => _ReportedUsersScreenState();
}

class _ReportedUsersScreenState extends State<ReportedUsersScreen> {
  @override
  void initState() {
    super.initState();
    // Load reported users when screen is opened
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
        title: const Text('Reported Users'),
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

          final reportedUsers = userActionProvider.reportedUsers;

          if (reportedUsers.isEmpty) {
            return const Center(
              child: Text('You haven\'t reported any users yet'),
            );
          }

          return ListView.builder(
            itemCount: reportedUsers.length,
            itemBuilder: (context, index) {
              final userAction = reportedUsers[index];
              final username = _generateUsername(userAction.targetUserId);
              final avatarColor = _generateAvatarColor(userAction.targetUserId);
              final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

              return ExpansionTile(
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
                subtitle: Text('Reported on ${userAction.timestamp.toLocal().toString().split('.')[0]}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reason for reporting:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userAction.reason ?? 'No reason provided',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await userActionProvider.blockUser(userAction.targetUserId);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$username has been blocked')),
                                  );
                                }
                              },
                              child: const Text('Block User'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
} 