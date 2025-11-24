import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// ويدجت عرض المهمة مع ميزات متقدمة
class TaskItemWidget extends ConsumerWidget {

  const TaskItemWidget({
    super.key,
    required this.task,
    this.isCompact = false,
    required this.onTap,
    required this.onComplete,
    required this.onStartPomodoro,
  });
  final AdvancedTask task;
  final bool isCompact;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onStartPomodoro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: task.status == TaskStatus.completed ? 1 : 3,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _getBorderColor(context),
            width: task.isOverdue ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: task.status == TaskStatus.completed
                  ? LinearGradient(
                      colors: [
                        Colors.green.withValues(alpha: 0.1),
                        Colors.green.withValues(alpha: 0.05),
                      ],
                    )
                  : null,
            ),
            child: isCompact ? _buildCompactView(context, ref) : _buildDetailedView(context, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactView(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Completion Checkbox
        _buildCompletionCheckbox(context),
        
        const SizedBox(width: 12),
        
        // Task Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Priority
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed
                            ? Colors.grey
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildPriorityIndicator(),
                ],
              ),
              
              // Progress and Due Date
              if (task.subtasks.isNotEmpty || task.dueDate != null)
                Row(
                  children: [
                    if (task.subtasks.isNotEmpty) ...[
                      Icon(
                        Icons.checklist,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${task.subtasks.where((s) => s.isCompleted).length}/${task.subtasks.length}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (task.dueDate != null) ...[
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: task.isOverdue ? Colors.red : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(task.dueDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: task.isOverdue ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
        
        // Quick Actions
        _buildQuickActions(context),
      ],
    );
  }

  Widget _buildDetailedView(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            _buildCompletionCheckbox(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Priority
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: task.status == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.status == TaskStatus.completed
                                ? Colors.grey
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildPriorityIndicator(),
                    ],
                  ),
                  
                  // Description
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Progress Bar (if has subtasks)
        if (task.subtasks.isNotEmpty) ...[
          _buildProgressBar(context),
          const SizedBox(height: 8),
        ],
        
        // Tags
        if (task.tags.isNotEmpty) ...[
          _buildTagsRow(context),
          const SizedBox(height: 8),
        ],
        
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
                _formatDueDate(task.dueDate!),
                style: TextStyle(
                  fontSize: 12,
                  color: task.isOverdue ? Colors.red : Colors.grey[600],
                  fontWeight: task.isOverdue ? FontWeight.w600 : null,
                ),
              ),
              const SizedBox(width: 16),
            ],
            
            // Estimated Duration
            if (task.estimatedDuration != null) ...[
              Icon(
                Icons.timer,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${task.estimatedDuration!.inMinutes} دقيقة',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
            ],
            
            // Pomodoro Sessions
            if (task.pomodoroSessions > 0) ...[
              const Icon(
                Icons.local_fire_department,
                size: 16,
                color: Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                '${task.pomodoroSessions} 🍅',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            
            const Spacer(),
            
            // Quick Actions
            _buildQuickActions(context),
          ],
        ),
        
        // Subtasks Preview (show first few)
        if (task.subtasks.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSubtasksPreview(context, ref),
        ],
      ],
    );
  }

  Widget _buildCompletionCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: task.status != TaskStatus.completed ? onComplete : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.status == TaskStatus.completed
              ? Colors.green
              : Colors.transparent,
          border: Border.all(
            color: task.status == TaskStatus.completed
                ? Colors.green
                : task.priorityColor,
            width: 2,
          ),
        ),
        child: task.status == TaskStatus.completed
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    return Container(
      width: 8,
      height: 20,
      decoration: BoxDecoration(
        color: task.priorityColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final progress = task.completionPercentage / 100;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${task.completionPercentage.toInt()}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            task.priorityColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: task.tags.map((tag) => Chip(
        label: Text(
          tag,
          style: const TextStyle(fontSize: 11),
        ),
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      )).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Start Pomodoro Button
        if (task.status != TaskStatus.completed)
          IconButton(
            onPressed: onStartPomodoro,
            icon: const Icon(Icons.play_circle),
            color: Colors.red,
            tooltip: 'بدء Pomodoro',
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        
        // More Options
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, value),
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey[600],
          ),
          iconSize: 20,
          padding: EdgeInsets.zero,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit, size: 20),
                title: Text('تعديل'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                leading: Icon(Icons.copy, size: 20),
                title: Text('نسخ'),
                dense: true,
              ),
            ),
            if (task.status != TaskStatus.completed)
              const PopupMenuItem(
                value: 'complete',
                child: ListTile(
                  leading: Icon(Icons.check_circle, size: 20),
                  title: Text('إكمال'),
                  dense: true,
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, size: 20, color: Colors.red),
                title: Text('حذف', style: TextStyle(color: Colors.red)),
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtasksPreview(BuildContext context, WidgetRef ref) {
    final visibleSubtasks = task.subtasks.take(2).toList();
    final remainingCount = task.subtasks.length - visibleSubtasks.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleSubtasks.map((subtask) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _toggleSubtask(ref, subtask.id),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: subtask.isCompleted
                        ? Colors.green
                        : Colors.transparent,
                    border: Border.all(
                      color: subtask.isCompleted
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  child: subtask.isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtask.title,
                  style: TextStyle(
                    fontSize: 12,
                    decoration: subtask.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: subtask.isCompleted
                        ? Colors.grey
                        : Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )),
        
        if (remainingCount > 0)
          Text(
            'و $remainingCount مهام فرعية أخرى...',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Color _getBorderColor(BuildContext context) {
    if (task.isOverdue) return Colors.red;
    if (task.status == TaskStatus.completed) return Colors.green;
    return task.priorityColor.withValues(alpha: 0.3);
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    if (dueDay == today) {
      return 'اليوم';
    } else if (dueDay == tomorrow) {
      return 'غداً';
    } else if (dueDay.isBefore(today)) {
      final daysDiff = today.difference(dueDay).inDays;
      return 'متأخر $daysDiff يوم';
    } else {
      final daysDiff = dueDay.difference(today).inDays;
      if (daysDiff <= 7) {
        return 'خلال $daysDiff يوم';
      } else {
        return '${dueDate.day}/${dueDate.month}';
      }
    }
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        _editTask(context);
        break;
      case 'duplicate':
        _duplicateTask(context);
        break;
      case 'complete':
        onComplete();
        break;
      case 'delete':
        _deleteTask(context);
        break;
    }
  }

  void _editTask(BuildContext context) {
    // Navigate to edit task screen
    Navigator.pushNamed(
      context,
      '/edit-task',
      arguments: task,
    );
  }

  void _duplicateTask(BuildContext context) {
    // Show duplicate confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نسخ المهمة'),
        content: const Text('هل تريد إنشاء نسخة من هذه المهمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Logic to duplicate task
            },
            child: const Text('نسخ'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المهمة'),
        content: const Text('هل أنت متأكد من حذف هذه المهمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Logic to delete task
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _toggleSubtask(WidgetRef ref, String subtaskId) {
    ref.read(advancedTasksProvider.notifier).toggleSubtask(task.id, subtaskId);
  }
}