// lib/features/smart_notifications/widgets/notification_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/smart_notification.dart';
import '../providers/smart_notifications_provider.dart';

class NotificationCard extends ConsumerWidget {

  const NotificationCard({super.key, required this.notification});
  final SmartNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showNotificationDetails(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // أيقونة نوع الإشعار
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notification.type.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // العنوان ونوع الإشعار
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getTypeColor(notification.type),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                notification.type.displayName,
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            if (notification.priority ==
                                    NotificationPriority.high ||
                                notification.priority ==
                                    NotificationPriority.critical)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.priority_high,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // مفتاح التفعيل
                  Switch.adaptive(
                    value: notification.isActive,
                    onChanged: (value) {
                      ref
                          .read(smartNotificationsProvider.notifier)
                          .toggleNotification(notification.id);
                    },
                    activeColor: _getTypeColor(notification.type),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // محتوى الإشعار
              Text(
                notification.body,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // معلومات الوقت والتكرار
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatScheduleTime(notification),
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),

                  const Spacer(),

                  if (notification.repeatDays.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.repeat,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'يومياً',
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // إحصائيات الإرسال
              if (notification.sentCount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.send,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'تم الإرسال ${notification.sentCount} ${notification.sentCount == 1 ? "مرة" : "مرات"}',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                    if (notification.lastSent != null) ...[
                      Text(
                        ' • آخر إرسال ${_formatLastSent(notification.lastSent!)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.habit:
        return Colors.green;
      case NotificationType.task:
        return Colors.blue;
      case NotificationType.workout:
      case NotificationType.morningExercise:
        return Colors.orange;
      case NotificationType.motivational:
        return Colors.purple;
      case NotificationType.achievement:
      case NotificationType.streak:
        return Colors.amber;
      case NotificationType.reminder:
      case NotificationType.weeklyReport:
        return Colors.grey;
    }
  }

  String _formatScheduleTime(SmartNotification notification) {
    final time = notification.scheduledTime;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    if (notification.repeatDays.isNotEmpty) {
      return '$hour:$minute يومياً';
    } else {
      final day = time.day.toString().padLeft(2, '0');
      final month = time.month.toString().padLeft(2, '0');
      return '$hour:$minute - $day/$month';
    }
  }

  String _formatLastSent(DateTime lastSent) {
    final now = DateTime.now();
    final difference = now.difference(lastSent);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? "يوم" : "أيام"}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? "ساعة" : "ساعات"}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? "دقيقة" : "دقائق"}';
    } else {
      return 'الآن';
    }
  }

  void _showNotificationDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationDetailsSheet(
        notification: notification,
        onEdit: () => _editNotification(context, ref),
        onDelete: () => _deleteNotification(context, ref),
      ),
    );
  }

  void _editNotification(BuildContext context, WidgetRef ref) {
    // TODO: فتح شاشة تعديل الإشعار
    Navigator.pop(context);
  }

  void _deleteNotification(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإشعار'),
        content: const Text('هل أنت متأكد من حذف هذا الإشعار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(smartNotificationsProvider.notifier)
                  .deleteNotification(notification.id);
              Navigator.pop(context); // إغلاق الحوار
              Navigator.pop(context); // إغلاق الورقة السفلية
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class NotificationDetailsSheet extends StatelessWidget {

  const NotificationDetailsSheet({
    super.key,
    required this.notification,
    required this.onEdit,
    required this.onDelete,
  });
  final SmartNotification notification;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مقبض الورقة
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // العنوان والأيقونة
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      notification.type.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.type.displayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _getTypeColor(notification.type),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // المحتوى
              Text(
                'المحتوى:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(notification.body, style: theme.textTheme.bodyMedium),

              const SizedBox(height: 24),

              // تفاصيل التوقيت
              _buildDetailRow(
                context,
                'الوقت المجدول:',
                _formatFullSchedule(notification),
                Icons.access_time,
              ),

              if (notification.repeatDays.isNotEmpty)
                _buildDetailRow(context, 'التكرار:', 'يومياً', Icons.repeat),

              _buildDetailRow(
                context,
                'الأولوية:',
                _getPriorityText(notification.priority),
                Icons.priority_high,
              ),

              if (notification.sentCount > 0)
                _buildDetailRow(
                  context,
                  'عدد مرات الإرسال:',
                  '${notification.sentCount} مرة',
                  Icons.send,
                ),

              const SizedBox(height: 24),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('تعديل'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      label: const Text('حذف'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.habit:
        return Colors.green;
      case NotificationType.task:
        return Colors.blue;
      case NotificationType.workout:
      case NotificationType.morningExercise:
        return Colors.orange;
      case NotificationType.motivational:
        return Colors.purple;
      case NotificationType.achievement:
      case NotificationType.streak:
        return Colors.amber;
      case NotificationType.reminder:
      case NotificationType.weeklyReport:
        return Colors.grey;
    }
  }

  String _formatFullSchedule(SmartNotification notification) {
    final time = notification.scheduledTime;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    final year = time.year;

    return '$hour:$minute - $day/$month/$year';
  }

  String _getPriorityText(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return 'منخفضة';
      case NotificationPriority.normal:
        return 'عادية';
      case NotificationPriority.high:
        return 'عالية';
      case NotificationPriority.critical:
        return 'عاجلة';
    }
  }
}
