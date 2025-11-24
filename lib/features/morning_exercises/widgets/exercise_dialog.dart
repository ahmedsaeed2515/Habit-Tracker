// lib/features/morning_exercises/widgets/exercise_dialog.dart
// Dialog لإضافة أو تعديل التمارين الصباحية

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/morning_exercise.dart';
import '../../../core/providers/morning_exercises_provider.dart';

/// Dialog لإضافة تمرين صباحي جديد أو تعديل تمرين موجود
class ExerciseDialog extends ConsumerStatefulWidget {

  const ExerciseDialog({super.key, this.exercise});
  /// التمرين المراد تعديله (null للإضافة الجديدة)
  final MorningExercise? exercise;

  @override
  ConsumerState<ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends ConsumerState<ExerciseDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _repsController;
  late final TextEditingController _setsController;

  /// قائمة التمارين الافتراضية
  final List<String> _defaultExercises = [
    'القرفصاء (Squats)',
    'الضغط (Push-ups)',
    'العقلة (Pull-ups)',
    'البلانك (Plank)',
    'البوربي (Burpees)',
    'الرفعة الميتة (Deadlift)',
    'تمارين البطن (Crunches)',
    'الجري في المكان (Running in Place)',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    super.dispose();
  }

  /// تهيئة المتحكمات بالبيانات الموجودة أو القيم الافتراضية
  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.exercise?.name ?? '');
    _repsController = TextEditingController(
      text: widget.exercise?.targetReps.toString() ?? '10',
    );
    _setsController = TextEditingController(
      text: widget.exercise?.targetSets.toString() ?? '3',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exercise != null;

    return AlertDialog(
      title: Text(isEditing ? 'تعديل التمرين' : 'إضافة تمرين جديد'),
      content: _buildDialogContent(isEditing),
      actions: _buildDialogActions(isEditing),
    );
  }

  /// بناء محتوى الـ Dialog
  Widget _buildDialogContent(bool isEditing) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isEditing) _buildQuickExerciseSelector(),
          _buildNameField(),
          const const SizedBox(height: 16),
          _buildRepsAndSetsRow(),
        ],
      ),
    );
  }

  /// بناء محدد التمارين السريعة
  Widget _buildQuickExerciseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر تمرين سريع:'),
        const const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _defaultExercises.map((exerciseName) {
            return ActionChip(
              label: Text(exerciseName),
              onPressed: () {
                _nameController.text = exerciseName;
              },
            );
          }).toList(),
        ),
        const const SizedBox(height: 16),
        const Text('أو اكتب تمرين مخصص:'),
        const const SizedBox(height: 8),
      ],
    );
  }

  /// حقل اسم التمرين
  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'اسم التمرين',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.sports_gymnastics),
      ),
    );
  }

  /// صف التكرارات والمجموعات
  Widget _buildRepsAndSetsRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _repsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'التكرارات',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.repeat),
            ),
          ),
        ),
        const const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _setsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'المجموعات',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.timer),
            ),
          ),
        ),
      ],
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
        onPressed: _canSave() ? _saveExercise : null,
        child: Text(isEditing ? 'حفظ' : 'إضافة'),
      ),
    ];
  }

  /// التحقق من إمكانية الحفظ
  bool _canSave() {
    return _nameController.text.isNotEmpty;
  }

  /// حفظ التمرين
  void _saveExercise() {
    final exercise = MorningExercise(
      id:
          widget.exercise?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      type: _determineExerciseType(_nameController.text),
      targetReps: int.tryParse(_repsController.text) ?? 10,
      targetSets: int.tryParse(_setsController.text) ?? 3,
      reps: int.tryParse(_repsController.text) ?? 10,
      date: widget.exercise?.date ?? DateTime.now(),
      isCompleted: widget.exercise?.isCompleted ?? false,
      caloriesBurned: _calculateCalories(
        _nameController.text,
        int.tryParse(_repsController.text) ?? 10,
        int.tryParse(_setsController.text) ?? 3,
      ),
      actualReps: widget.exercise?.actualReps,
      actualSets: widget.exercise?.actualSets,
      completedAt: widget.exercise?.completedAt,
    );

    if (widget.exercise == null) {
      // إضافة تمرين جديد
      ref.read(morningExercisesProvider.notifier).addExercise(exercise);
    } else {
      // تحديث تمرين موجود
      ref.read(morningExercisesProvider.notifier).updateExercise(exercise);
    }

    Navigator.of(context).pop();
  }

  /// تحديد نوع التمرين حسب الاسم
  ExerciseType _determineExerciseType(String exerciseName) {
    final name = exerciseName.toLowerCase();
    if (name.contains('قرفصاء') || name.contains('squat')) {
      return ExerciseType.squat;
    } else if (name.contains('ضغط') || name.contains('push')) {
      return ExerciseType.pushUp;
    } else if (name.contains('عقلة') || name.contains('pull')) {
      return ExerciseType.pullUp;
    } else {
      return ExerciseType.custom;
    }
  }

  /// حساب السعرات الحرارية المقدرة
  int _calculateCalories(String exerciseName, int reps, int sets) {
    int baseCaloriesPerRep = 1;

    final name = exerciseName.toLowerCase();
    if (name.contains('قرفصاء') || name.contains('squat')) {
      baseCaloriesPerRep = 1;
    } else if (name.contains('ضغط') || name.contains('push')) {
      baseCaloriesPerRep = 1;
    } else if (name.contains('عقلة') || name.contains('pull')) {
      baseCaloriesPerRep = 2;
    } else if (name.contains('بوربي') || name.contains('burpee')) {
      baseCaloriesPerRep = 3;
    } else if (name.contains('جري') || name.contains('run')) {
      baseCaloriesPerRep = 2;
    }

    return reps * sets * baseCaloriesPerRep;
  }
}
