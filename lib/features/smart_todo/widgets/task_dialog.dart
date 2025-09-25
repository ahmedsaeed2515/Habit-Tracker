import 'package:flutter/material.dart';
import '../../../core/models/task.dart';

/// حوار إدارة المهام - إضافة أو تحرير
class TaskDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskDialog({super.key, this.task, required this.onSave});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  final List<SubTask> _subTasks = [];
  final _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _initializeWithTask(widget.task!);
    }
  }

  /// تهيئة النموذج بالمهمة الموجودة
  void _initializeWithTask(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _notesController.text = task.notes ?? '';
    _priority = task.priority;
    _dueDate = task.dueDate;
    _subTasks.addAll(task.subTasks);
    _tagsController.text = task.tags.join(', ');
  }

  /// حفظ المهمة
  void _saveTask() {
    if (_titleController.text.trim().isEmpty) return;

    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      sheetId: widget.task?.sheetId ?? 'default_sheet',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      priority: _priority,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      lastModified: DateTime.now(),
      dueDate: _dueDate,
      subTasks: List.from(_subTasks),
      tags: _parseTagsFromString(_tagsController.text),
      completedAt: widget.task?.completedAt,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      status: widget.task?.status ?? TaskStatus.pending,
      sortOrder: widget.task?.sortOrder ?? 0,
    );

    widget.onSave(task);
    Navigator.pop(context);
  }

  /// تحليل العلامات من النص
  List<String> _parseTagsFromString(String tagsText) {
    return tagsText
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  /// إضافة مهمة فرعية
  void _addSubtask() {
    final subtaskTitle = _subtaskController.text.trim();
    if (subtaskTitle.isNotEmpty &&
        !_subTasks.any((st) => st.title == subtaskTitle)) {
      setState(() {
        final subtask = SubTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          taskId: widget.task?.id ?? '',
          title: subtaskTitle,
          createdAt: DateTime.now(),
        );
        _subTasks.add(subtask);
        _subtaskController.clear();
      });
    }
  }

  /// حذف مهمة فرعية
  void _removeSubtask(SubTask subtask) {
    setState(() {
      _subTasks.remove(subtask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleField(),
                    const SizedBox(height: 12),
                    _buildDescriptionField(),
                    const SizedBox(height: 12),
                    _buildPrioritySection(),
                    const SizedBox(height: 12),
                    _buildDueDateSection(),
                    const SizedBox(height: 12),
                    _buildSubtasksSection(),
                    const SizedBox(height: 12),
                    _buildTagsField(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// بناء رأس الحوار
  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          widget.task == null ? Icons.add_task : Icons.edit,
          color: Colors.blue,
          size: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.task == null ? 'إضافة مهمة جديدة' : 'تحرير المهمة',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.grey),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  /// بناء حقل العنوان
  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'عنوان المهمة *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'أدخل عنوان المهمة...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  /// بناء حقل الوصف
  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوصف',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'أدخل وصف المهمة...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  /// بناء قسم الأولوية
  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأولوية',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = _priority == priority;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _priority = priority),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getPriorityColor(priority).withOpacity(0.2)
                        : Colors.grey.shade100,
                    border: Border.all(
                      color: isSelected
                          ? _getPriorityColor(priority)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getPriorityIcon(priority),
                        color: isSelected
                            ? _getPriorityColor(priority)
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPriorityText(priority),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? _getPriorityColor(priority)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// بناء قسم تاريخ الاستحقاق
  Widget _buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تاريخ الاستحقاق',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _selectDueDate,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'اختر تاريخ الاستحقاق'
                        : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                    style: TextStyle(
                      color: _dueDate == null
                          ? Colors.grey.shade600
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (_dueDate != null)
                  GestureDetector(
                    onTap: () => setState(() => _dueDate = null),
                    child: Icon(
                      Icons.clear,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// بناء قسم المهام الفرعية
  Widget _buildSubtasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المهام الفرعية',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _subtaskController,
                decoration: InputDecoration(
                  hintText: 'أضف مهمة فرعية...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _addSubtask(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addSubtask,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        if (_subTasks.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...(_subTasks.map(
            (subtask) => Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subtask.title,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _removeSubtask(subtask),
                    child: const Icon(Icons.close, size: 16, color: Colors.red),
                  ),
                ],
              ),
            ),
          )),
        ],
      ],
    );
  }

  /// بناء حقل العلامات
  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'العلامات',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _tagsController,
          decoration: InputDecoration(
            hintText: 'أدخل العلامات مفصولة بفاصلة...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  /// بناء أزرار الإجراءات
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _titleController.text.trim().isEmpty ? null : _saveTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              widget.task == null ? 'إضافة' : 'حفظ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  /// اختيار تاريخ الاستحقاق
  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  /// الحصول على لون الأولوية
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  /// الحصول على أيقونة الأولوية
  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
      case TaskPriority.urgent:
        return Icons.priority_high;
    }
  }

  /// الحصول على نص الأولوية
  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'منخفضة';
      case TaskPriority.medium:
        return 'متوسطة';
      case TaskPriority.high:
        return 'عالية';
      case TaskPriority.urgent:
        return 'عاجل';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }
}
