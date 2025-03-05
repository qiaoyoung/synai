import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../utils/date_formatter.dart';
import '../models/ai_user.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Color aiColor;
  final String? aiAvatarPath;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.aiColor,
    this.aiAvatarPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: aiColor.withOpacity(0.2),
              radius: 16,
              child: aiAvatarPath != null
                ? ClipOval(
                    child: Image.asset(
                      aiAvatarPath!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading AI avatar in chat bubble: $aiAvatarPath, Error: $error');
                        return Icon(
                          Icons.smart_toy,
                          size: 16,
                          color: aiColor,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.smart_toy,
                    size: 16,
                    color: aiColor,
                  ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? aiColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: isUser ? const Radius.circular(0) : null,
                      bottomLeft: !isUser ? const Radius.circular(0) : null,
                    ),
                  ),
                  child: _buildMessageContent(),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatChatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.2),
              radius: 16,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.blue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            color: message.sender == MessageSender.user ? Colors.white : Colors.black,
          ),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.content.isNotEmpty) ...[
              Text(
                message.content,
                style: TextStyle(
                  color: message.sender == MessageSender.user ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                message.mediaUrl ?? '',
                width: 200,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case MessageType.audio:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.audiotrack,
              color: message.sender == MessageSender.user ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              '语音消息',
              style: TextStyle(
                color: message.sender == MessageSender.user ? Colors.white : Colors.black,
              ),
            ),
          ],
        );
      case MessageType.video:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.content.isNotEmpty) ...[
              Text(
                message.content,
                style: TextStyle(
                  color: message.sender == MessageSender.user ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ],
        );
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file,
              color: message.sender == MessageSender.user ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              '文件: ${message.content}',
              style: TextStyle(
                color: message.sender == MessageSender.user ? Colors.white : Colors.black,
              ),
            ),
          ],
        );
      default:
        return Text(
          message.content,
          style: TextStyle(
            color: message.sender == MessageSender.user ? Colors.white : Colors.black,
          ),
        );
    }
  }
} 