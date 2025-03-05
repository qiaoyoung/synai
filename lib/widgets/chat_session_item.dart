import 'package:flutter/material.dart';
import '../models/ai_user.dart';
import '../models/chat_message.dart';
import '../utils/date_formatter.dart';

class ChatSessionItem extends StatelessWidget {
  final AIUser aiUser;
  final List<ChatMessage> messages;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatSessionItem({
    Key? key,
    required this.aiUser,
    required this.messages,
    required this.unreadCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastMessage = messages.isNotEmpty ? messages.last : null;

    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(aiUser.avatarPath),
          ),
          if (aiUser.isPremium)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(
                  Icons.verified,
                  size: 12,
                  color: aiUser.themeColor,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        aiUser.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: lastMessage != null
          ? Text(
              lastMessage.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: unreadCount > 0 ? Colors.black : Colors.grey[600],
                fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
            )
          : Text(
              aiUser.specialty,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastMessage != null
                ? DateFormatter.formatChatTime(lastMessage.timestamp)
                : '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: aiUser.themeColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}