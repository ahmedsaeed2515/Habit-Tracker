import 'package:flutter/material.dart';
import '../models/ai_message.dart';

class MessageBubble extends StatelessWidget {

  const MessageBubble({super.key, required this.message, this.onDelete});
  final AIMessage message;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isFromUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(theme),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onLongPress: onDelete,
              child: Container(
                decoration: BoxDecoration(
                  color: isUser
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) _buildMessageHeader(theme),
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isUser
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildMessageFooter(theme, isUser),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildUserAvatar(theme),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: theme.colorScheme.secondary,
      child: Icon(
        _getMessageIcon(),
        size: 16,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: theme.colorScheme.primary,
      child: Icon(Icons.person, size: 16, color: theme.colorScheme.onPrimary),
    );
  }

  Widget _buildMessageHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(_getMessageIcon(), size: 14, color: _getMessageColor(theme)),
          const SizedBox(width: 4),
          Text(
            _getMessageTypeLabel(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _getMessageColor(theme),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (message.confidence != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getConfidenceColor(theme),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(message.confidence! * 100).round()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageFooter(ThemeData theme, bool isUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          _formatTime(message.timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                (isUser
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant)
                    .withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  IconData _getMessageIcon() {
    switch (message.type) {
      case AIMessageType.text:
        return Icons.chat_bubble_outline;
      case AIMessageType.suggestion:
        return Icons.lightbulb_outline;
      case AIMessageType.reminder:
        return Icons.notifications_outlined;
      case AIMessageType.insight:
        return Icons.analytics_outlined;
      case AIMessageType.motivational:
        return Icons.favorite_outline;
      case AIMessageType.warning:
        return Icons.warning_outlined;
      case AIMessageType.celebration:
        return Icons.celebration_outlined;
    }
  }

  String _getMessageTypeLabel() {
    switch (message.type) {
      case AIMessageType.text:
        return 'رسالة';
      case AIMessageType.suggestion:
        return 'اقتراح';
      case AIMessageType.reminder:
        return 'تذكير';
      case AIMessageType.insight:
        return 'رؤية';
      case AIMessageType.motivational:
        return 'تحفيز';
      case AIMessageType.warning:
        return 'تحذير';
      case AIMessageType.celebration:
        return 'تهنئة';
    }
  }

  Color _getMessageColor(ThemeData theme) {
    switch (message.type) {
      case AIMessageType.text:
        return theme.colorScheme.onSurfaceVariant;
      case AIMessageType.suggestion:
        return Colors.amber.shade700;
      case AIMessageType.reminder:
        return theme.colorScheme.primary;
      case AIMessageType.insight:
        return Colors.blue.shade700;
      case AIMessageType.motivational:
        return Colors.pink.shade700;
      case AIMessageType.warning:
        return Colors.orange.shade700;
      case AIMessageType.celebration:
        return Colors.green.shade700;
    }
  }

  Color _getConfidenceColor(ThemeData theme) {
    if (message.confidence == null) return theme.colorScheme.secondary;

    if (message.confidence! >= 0.8) {
      return Colors.green.shade600;
    } else if (message.confidence! >= 0.6) {
      return Colors.orange.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}س';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}د';
    } else {
      return 'الآن';
    }
  }
}
