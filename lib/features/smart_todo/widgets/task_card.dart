// lib/features/smart_todo/widgets/task_card.dart
// بطاقة عرض المهمة الذكية

import 'package:flutter/material.dart';
import '../../../core/models/task.dart';

/// بطاقة لعرض المهمة مع جميع المعلومات والخيارات
class TaskCard extends StatelessWidget {

  const TaskCard({
    super.key,
    required this.task,
    this.onCompleted,
    this.onEdit,
    this.onDelete,
    this.onPriorityChanged,
  });
  /// المهمة المراد عرضها
  final Task task;

  /// دالة استدعاء عند إكمال المهمة
  final VoidCallback? onCompleted;

  /// دالة استدعاء عند تعديل المهمة
  final VoidCallback? onEdit;

  /// دالة استدعاء عند حذف المهمة
  final VoidCallback? onDelete;

  /// دالة استدعاء عند تغيير الأولوية
  final Function(TaskPriority)? onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: _getCardElevation(),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildPriorityStripe(),
            Expanded(
              child: Column(
                children: [
                  _buildTaskHeader(),
                  _buildTaskContent(),
                  _buildTaskFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء شريط الأولوية الجانبي
  Widget _buildPriorityStripe() {
    return Container(width: 4, color: _getPriorityColor());
  }

  /// بناء رأس المهمة
  Widget _buildTaskHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: task.isCompleted ? Colors.green.shade50 : null,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
      ),
      child: Row(
        children: [
          _buildCompletionCheckbox(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted ? Colors.grey : null,
                  ),
                ),
                if (task.tags.isNotEmpty) _buildTagsRow(),
              ],
            ),
          ),
          _buildPriorityBadge(),
        ],
      ),
    );
  }

  /// بناء صندوق الإكمال
  Widget _buildCompletionCheckbox() {
    return GestureDetector(
      onTap: onCompleted,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: task.isCompleted ? Colors.green : Colors.grey,
            width: 2,
          ),
          color: task.isCompleted ? Colors.green : Colors.transparent,
        ),
        child: task.isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  /// بناء صف العلامات
  Widget _buildTagsRow() {
    if (task.tags.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        children: [
          ...task.tags.take(3).map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '#$tag',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
          if (task.tags.length > 3)
            Text(
              '+${task.tags.length - 3}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  /// بناء شارة الأولوية
  Widget _buildPriorityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getPriorityColor().withValues(alpha: 0.5)),
      ),
      child: Text(
        _getPriorityText(),
        style: TextStyle(
          fontSize: 10,
          color: _getPriorityColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// بناء محتوى المهمة
  Widget _buildTaskContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description.isNotEmpty) ...[
            Text(
              task.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 8),
          ],
          _buildTaskMetadata(),
        ],
      ),
    );
  }

  /// بناء بيانات المهمة الوصفية
  Widget _buildTaskMetadata() {
    return Row(
      children: [
        if (task.dueDate != null) ...[
          _buildMetadataChip(
            Icons.calendar_today,
            _formatDate(task.dueDate!),
            _isOverdue() ? Colors.red : Colors.orange,
          ),
          const SizedBox(width: 8),
        ],
        if (task.subTasks.isNotEmpty) ...[
          _buildMetadataChip(
            Icons.checklist,
            '${task.subTasks.where((s) => s.isCompleted).length}/${task.subTasks.length}',
            Colors.blue,
          ),
          const SizedBox(width: 8),
        ],
        if (task.tags.isNotEmpty) ...[
          _buildMetadataChip(
            Icons.tag,
            '${task.tags.length} علامات',
            Colors.purple,
          ),
        ],
      ],
    );
  }

  /// بناء رقاقة البيانات الوصفية
  Widget _buildMetadataChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء ذيل المهمة
  Widget _buildTaskFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildActionButtons(), _buildTaskTimestamp()],
      ),
    );
  }

  /// بناء أزرار الإجراءات
  Widget _buildActionButtons() {
    return Row(
      children: [
        if (onEdit != null)
          _buildActionButton(
            Icons.edit_outlined,
            'تعديل',
            Colors.blue,
            onEdit!,
          ),
        if (onEdit != null && onDelete != null) const SizedBox(width: 8),
        if (onDelete != null)
          _buildActionButton(
            Icons.delete_outline,
            'حذف',
            Colors.red,
            onDelete!,
          ),
      ],
    );
  }

  /// بناء زر إجراء
  Widget _buildActionButton(
    IconData icon,
    String tooltip,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  /// بناء الطابع الزمني للمهمة
  Widget _buildTaskTimestamp() {
    return Text(
      task.isCompleted && task.completedAt != null
          ? 'اكتملت ${_formatDateTime(task.completedAt!)}'
          : 'أُنشئت ${_formatDateTime(task.createdAt)}',
      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
    );
  }

  /// الحصول على ارتفاع البطاقة حسب الأولوية
  double _getCardElevation() {
    switch (task.priority) {
      case TaskPriority.urgent:
        return 6;
      case TaskPriority.high:
        return 4;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 1;
    }
  }

  /// الحصول على لون الأولوية
  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.urgent:
        return Colors.red.shade700;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  /// الحصول على نص الأولوية
  String _getPriorityText() {
    switch (task.priority) {
      case TaskPriority.urgent:
        return 'عاجلة';
      case TaskPriority.high:
        return 'عالية';
      case TaskPriority.medium:
        return 'متوسطة';
      case TaskPriority.low:
        return 'منخفضة';
    }
  }

  /// التحقق من تأخر المهمة
  bool _isOverdue() {
    if (task.dueDate == null || task.isCompleted) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }

  /// تنسيق التاريخ
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;

    if (diff == 0) return 'اليوم';
    if (diff == 1) return 'غداً';
    if (diff == -1) return 'أمس';
    if (diff > 1) return 'خلال $diff أيام';
    if (diff < -1) return 'متأخر ${-diff} أيام';

    return '${date.day}/${date.month}';
  }

  /// تنسيق التاريخ والوقت
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
