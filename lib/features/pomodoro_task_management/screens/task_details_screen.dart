import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// شاشة تفاصيل المهمة مع إمكانية التعديل
class TaskDetailsScreen extends ConsumerStatefulWidget {

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });
  final String taskId;

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(taskDetailsProvider(widget.taskId));
    final pomodoroCount = ref.watch(taskPomodoroCountProvider(widget.taskId));
    final progress = ref.watch(taskProgressProvider(widget.taskId));

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('المهمة غير موجودة')),
        body: const Center(
          child: Text('لم يتم العثور على المهمة المطلوبة'),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, task),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(context, task, pomodoroCount, progress),
            
            const SizedBox(height: 16),
            
            // Description Section
            if (task.description != null && task.description!.isNotEmpty)
              _buildDescriptionSection(context, task),
            
            const SizedBox(height: 16),
            
            // Subtasks Section
            if (task.subtasks.isNotEmpty)
              _buildSubtasksSection(context, task),
            
            const SizedBox(height: 16),
            
            // Progress Section
            _buildProgressSection(context, task, progress),
            
            const SizedBox(height: 16),
            
            // Time Tracking Section
            _buildTimeTrackingSection(context, task, pomodoroCount),
            
            const SizedBox(height: 16),
            
            // Actions Section
            _buildActionsSection(context, task),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AdvancedTask task) {
    return AppBar(
      title: const Text('تفاصيل المهمة'),
      backgroundColor: task.priorityColor.withOpacity(0.8),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(_isEditing ? Icons.save : Icons.edit),
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing;
            });
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, value, task),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                leading: Icon(Icons.copy),
                title: Text('نسخ المهمة'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('حذف المهمة', style: TextStyle(color: Colors.red)),
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    AdvancedTask task,
    int pomodoroCount,
    double progress,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              task.priorityColor.withOpacity(0.1),
              task.priorityColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Priority
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: task.priorityColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: task.priorityColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getPriorityText(task.priority),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Info Row
            Row(
              children: [
                // Due Date
                if (task.dueDate != null) ...[
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: task.isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task.dueDate!),
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: task.isOverdue ? FontWeight.bold : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                
                // Pomodoro Count
                const Icon(
                  Icons.local_fire_department,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  '$pomodoroCount 🍅',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const Spacer(),
                
                // Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(task.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusText(task.status),
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(task.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            // Tags
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: task.tags.map((tag) => Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: task.priorityColor.withOpacity(0.1),
                  side: BorderSide(
                    color: task.priorityColor.withOpacity(0.3),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, AdvancedTask task) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'الوصف',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtasksSection(BuildContext context, AdvancedTask task) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'المهام الفرعية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${task.subtasks.where((s) => s.isCompleted).length}/${task.subtasks.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...task.subtasks.map((subtask) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleSubtask(subtask.id),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: subtask.isCompleted ? Colors.green : Colors.transparent,
                        border: Border.all(
                          color: subtask.isCompleted ? Colors.green : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: subtask.isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      subtask.title,
                      style: TextStyle(
                        decoration: subtask.isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                        color: subtask.isCompleted 
                            ? Colors.grey 
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, AdvancedTask task, double progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'التقدم',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${progress.toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: task.priorityColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(task.priorityColor),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTrackingSection(
    BuildContext context,
    AdvancedTask task,
    int pomodoroCount,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'تتبع الوقت',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    'الوقت المقدر',
                    task.estimatedDuration?.inMinutes.toString() ?? 'غير محدد',
                    Icons.schedule,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeInfo(
                    'الوقت الفعلي',
                    '${task.actualDuration.inMinutes} دقيقة',
                    Icons.timer_outlined,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTimeInfo(
              'جلسات Pomodoro',
              '$pomodoroCount جلسة',
              Icons.local_fire_department,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, AdvancedTask task) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإجراءات',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: task.status != TaskStatus.completed
                        ? () => _startPomodoroForTask(task)
                        : null,
                    icon: const Icon(Icons.play_circle),
                    label: const Text('بدء Pomodoro'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: task.status != TaskStatus.completed
                        ? () => _completeTask(task)
                        : null,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('إكمال'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSubtask(String subtaskId) {
    ref.read(advancedTasksProvider.notifier).toggleSubtask(widget.taskId, subtaskId);
  }

  void _startPomodoroForTask(AdvancedTask task) {
    ref.read(activeSessionProvider.notifier).startSession(
      type: SessionType.focus,
      taskId: task.id,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم بدء جلسة Pomodoro! 🍅'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _completeTask(AdvancedTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إكمال المهمة'),
        content: const Text('هل أنت متأكد من إكمال هذه المهمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(advancedTasksProvider.notifier).completeTask(widget.taskId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إكمال المهمة! 🎉'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('إكمال'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action, AdvancedTask task) {
    switch (action) {
      case 'duplicate':
        // إضافة منطق نسخ المهمة
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سيتم تنفيذ نسخ المهمة قريباً')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, task);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, AdvancedTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المهمة'),
        content: const Text('هل أنت متأكد من حذف هذه المهمة؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الحوار
              Navigator.pop(context); // العودة للشاشة السابقة
              ref.read(advancedTasksProvider.notifier).deleteTask(widget.taskId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المهمة'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return 'عاجل';
      case TaskPriority.high:
        return 'عالي';
      case TaskPriority.medium:
        return 'متوسط';
      case TaskPriority.low:
        return 'منخفض';
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'في الانتظار';
      case TaskStatus.inProgress:
        return 'قيد التنفيذ';
      case TaskStatus.completed:
        return 'مكتمل';
      case TaskStatus.cancelled:
        return 'ملغي';
      case TaskStatus.onHold:
        return 'معلق';
      case TaskStatus.archived:
        return 'مؤرشف';
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
      case TaskStatus.onHold:
        return Colors.grey;
      case TaskStatus.archived:
        return Colors.brown;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final targetDay = DateTime(date.year, date.month, date.day);

    if (targetDay == today) {
      return 'اليوم';
    } else if (targetDay == tomorrow) {
      return 'غداً';
    } else if (targetDay.isBefore(today)) {
      final daysDiff = today.difference(targetDay).inDays;
      return 'متأخر $daysDiff يوم';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}