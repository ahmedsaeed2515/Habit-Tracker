// lib/features/gym_tracker/widgets/workout_dialog.dart
// Dialog لإضافة أو تعديل التمارين

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/workout.dart';
import '../../../core/providers/gym_provider.dart';

/// Dialog لإضافة تمرين جديد أو تعديل تمرين موجود
class WorkoutDialog extends ConsumerStatefulWidget {
  /// التمرين المراد تعديله (null للإضافة الجديدة)
  final Workout? workout;

  const WorkoutDialog({super.key, this.workout});

  @override
  ConsumerState<WorkoutDialog> createState() => _WorkoutDialogState();
}

class _WorkoutDialogState extends ConsumerState<WorkoutDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _durationController;

  late String _selectedType;
  late DateTime _selectedDate;

  /// أنواع التمارين المتاحة
  final List<String> _workoutTypes = ['قوة', 'كارديو', 'مرونة', 'رياضة'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  /// تهيئة المتحكمات بالبيانات الموجودة أو القيم الافتراضية
  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.workout?.name ?? '');
    _notesController = TextEditingController(text: widget.workout?.notes ?? '');
    _durationController = TextEditingController(
      text: widget.workout?.duration.toString() ?? '',
    );
    _selectedType = widget.workout?.type ?? 'قوة';
    _selectedDate = widget.workout?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.workout != null;

    return AlertDialog(
      title: Text(isEditing ? 'تعديل التمرين' : 'إضافة تمرين جديد'),
      content: _buildDialogContent(),
      actions: _buildDialogActions(isEditing),
    );
  }

  /// بناء محتوى الـ Dialog
  Widget _buildDialogContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNameField(),
          const SizedBox(height: 16),
          _buildTypeDropdown(),
          const SizedBox(height: 16),
          _buildDurationField(),
          const SizedBox(height: 16),
          _buildNotesField(),
        ],
      ),
    );
  }

  /// حقل اسم التمرين
  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'اسم التمرين',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.fitness_center),
      ),
    );
  }

  /// قائمة منسدلة لنوع التمرين
  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: const InputDecoration(
        labelText: 'نوع التمرين',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items: _workoutTypes.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedType = value;
          });
        }
      },
    );
  }

  /// حقل مدة التمرين
  Widget _buildDurationField() {
    return TextField(
      controller: _durationController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'المدة (بالدقائق)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.timer),
      ),
    );
  }

  /// حقل الملاحظات
  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'ملاحظات',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.notes),
        alignLabelWithHint: true,
      ),
    );
  }

  /// بناء أزرار الـ Dialog
  List<Widget> _buildDialogActions(bool isEditing) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('إلغاء'),
      ),
      ElevatedButton(
        onPressed: _canSave() ? _saveWorkout : null,
        child: Text(isEditing ? 'حفظ' : 'إضافة'),
      ),
    ];
  }

  /// التحقق من إمكانية الحفظ
  bool _canSave() {
    return _nameController.text.isNotEmpty &&
        _durationController.text.isNotEmpty;
  }

  /// حفظ التمرين
  void _saveWorkout() {
    final workout = Workout(
      id:
          widget.workout?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _notesController.text,
      date: _selectedDate,
      muscleGroup: _selectedType,
      sets: widget.workout?.sets ?? [], // الحفاظ على المجموعات الموجودة
      duration: int.tryParse(_durationController.text) ?? 0,
      type: _selectedType,
      notes: _notesController.text,
    );

    if (widget.workout == null) {
      // إضافة تمرين جديد
      ref.read(workoutsProvider.notifier).addWorkout(workout);
    } else {
      // تحديث تمرين موجود
      ref.read(workoutsProvider.notifier).updateWorkout(workout);
    }

    Navigator.of(context).pop();
  }
}
