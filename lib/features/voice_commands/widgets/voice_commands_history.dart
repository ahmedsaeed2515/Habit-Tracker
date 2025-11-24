// lib/features/voice_commands/widgets/voice_commands_history.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voice_command.dart';
import '../providers/voice_commands_provider.dart';

/// سجل الأوامر الصوتية
class VoiceCommandsHistory extends ConsumerWidget {
  const VoiceCommandsHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentCommands = ref.watch(recentCommandsProvider);

    if (recentCommands.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'لا توجد أوامر صوتية سابقة',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recentCommands.length,
      itemBuilder: (context, index) {
        final command = recentCommands[index];
        return VoiceCommandHistoryItem(command: command);
      },
    );
  }
}

/// عنصر في سجل الأوامر الصوتية
class VoiceCommandHistoryItem extends StatelessWidget {

  const VoiceCommandHistoryItem({super.key, required this.command});
  final VoiceCommand command;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة
            Row(
              children: [
                // أيقونة نوع الأمر
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCommandTypeColor(command.type).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCommandTypeIcon(command.type),
                    color: _getCommandTypeColor(command.type),
                    size: 20,
                  ),
                ),

                const const SizedBox(width: 12),

                // تفاصيل الأمر
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getCommandTypeLabel(command.type),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: _getCommandTypeColor(command.type),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimestamp(command.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // مؤشر الحالة
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(command.status).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(command.status),
                        size: 12,
                        color: _getStatusColor(command.status),
                      ),
                      const const SizedBox(width: 4),
                      Text(
                        _getStatusLabel(command.status),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatusColor(command.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const const SizedBox(height: 12),

            // النص الأصلي
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                command.originalText,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),

            // الاستجابة (إن وُجدت)
            if (command.response != null && command.response!.isNotEmpty) ...[
              const const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  command.response!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],

            // شريط الثقة
            if (command.confidence > 0) ...[
              const const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'دقة التعرف:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: command.confidence,
                      backgroundColor: Colors.grey.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getConfidenceColor(command.confidence),
                      ),
                    ),
                  ),
                  const const SizedBox(width: 8),
                  Text(
                    '${(command.confidence * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getConfidenceColor(command.confidence),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper methods for styling
  IconData _getCommandTypeIcon(VoiceCommandType type) {
    switch (type) {
      case VoiceCommandType.habit:
        return Icons.task_alt;
      case VoiceCommandType.task:
        return Icons.checklist;
      case VoiceCommandType.exercise:
        return Icons.fitness_center;
      case VoiceCommandType.navigation:
        return Icons.navigation;
      case VoiceCommandType.settings:
        return Icons.settings;
      case VoiceCommandType.analytics:
        return Icons.analytics;
      case VoiceCommandType.general:
        return Icons.mic;
    }
  }

  Color _getCommandTypeColor(VoiceCommandType type) {
    switch (type) {
      case VoiceCommandType.habit:
        return Colors.green;
      case VoiceCommandType.task:
        return Colors.blue;
      case VoiceCommandType.exercise:
        return Colors.orange;
      case VoiceCommandType.navigation:
        return Colors.purple;
      case VoiceCommandType.settings:
        return Colors.grey;
      case VoiceCommandType.analytics:
        return Colors.teal;
      case VoiceCommandType.general:
        return Colors.blueGrey;
    }
  }

  String _getCommandTypeLabel(VoiceCommandType type) {
    switch (type) {
      case VoiceCommandType.habit:
        return 'عادة';
      case VoiceCommandType.task:
        return 'مهمة';
      case VoiceCommandType.exercise:
        return 'تمرين';
      case VoiceCommandType.navigation:
        return 'تنقل';
      case VoiceCommandType.settings:
        return 'إعدادات';
      case VoiceCommandType.analytics:
        return 'تحليلات';
      case VoiceCommandType.general:
        return 'عام';
    }
  }

  IconData _getStatusIcon(CommandStatus status) {
    switch (status) {
      case CommandStatus.pending:
        return Icons.schedule;
      case CommandStatus.processing:
        return Icons.hourglass_empty;
      case CommandStatus.completed:
        return Icons.check_circle;
      case CommandStatus.failed:
        return Icons.error;
    }
  }

  Color _getStatusColor(CommandStatus status) {
    switch (status) {
      case CommandStatus.pending:
        return Colors.orange;
      case CommandStatus.processing:
        return Colors.blue;
      case CommandStatus.completed:
        return Colors.green;
      case CommandStatus.failed:
        return Colors.red;
    }
  }

  String _getStatusLabel(CommandStatus status) {
    switch (status) {
      case CommandStatus.pending:
        return 'قيد الانتظار';
      case CommandStatus.processing:
        return 'جاري المعالجة';
      case CommandStatus.completed:
        return 'مكتمل';
      case CommandStatus.failed:
        return 'فشل';
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
