// lib/features/morning_exercises/widgets/exercise_card.dart
// Widget لعرض بطاقة تمرين صباحي واحد

import 'package:flutter/material.dart';

import '../../../core/models/morning_exercise.dart';

/// Widget لعرض تمرين صباحي واحد في شكل بطاقة
class ExerciseCard extends StatelessWidget {

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });
  /// بيانات التمرين المراد عرضه
  final MorningExercise exercise;

  /// دالة لإكمال التمرين
  final VoidCallback onComplete;

  /// دالة للتعديل على التمرين
  final VoidCallback onEdit;

  /// دالة لحذف التمرين
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildExerciseInfo(),
            const SizedBox(height: 16),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// بناء رأس البطاقة (الاسم والحالة)
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getExerciseIcon(exercise.name),
          color: exercise.isCompleted
              ? Colors.green
              : Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            exercise.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: exercise.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
              color: exercise.isCompleted ? Colors.grey : null,
            ),
          ),
        ),
        if (exercise.isCompleted)
          const Icon(Icons.check_circle, color: Colors.green),
      ],
    );
  }

  /// بناء معلومات التمرين (التكرارات والمجموعات والسعرات)
  Widget _buildExerciseInfo() {
    return Row(
      children: [
        _buildInfoChip(Icons.repeat, '${exercise.targetReps} تكرار'),
        const SizedBox(width: 16),
        _buildInfoChip(Icons.timer, '${exercise.targetSets} مجموعة'),
        const SizedBox(width: 16),
        _buildInfoChip(
          Icons.local_fire_department,
          '${exercise.caloriesBurned} سعرة',
        ),
      ],
    );
  }

  /// بناء معلومة واحدة مع أيقونة
  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  /// بناء تذييل البطاقة (الوقت والأزرار)
  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${exercise.date.hour.toString().padLeft(2, '0')}:${exercise.date.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Row(
          children: [
            if (!exercise.isCompleted) ...[
              ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check, size: 18),
                label: const Text('إكمال'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 32),
                ),
              ),
              const SizedBox(width: 8),
            ],
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }

  /// تحديد أيقونة التمرين حسب النوع
  IconData _getExerciseIcon(String exerciseName) {
    if (exerciseName.contains('قرفصاء') || exerciseName.contains('Squat')) {
      return Icons.airline_seat_recline_extra;
    } else if (exerciseName.contains('ضغط') || exerciseName.contains('Push')) {
      return Icons.fitness_center;
    } else if (exerciseName.contains('عقلة') || exerciseName.contains('Pull')) {
      return Icons.accessibility_new;
    } else if (exerciseName.contains('بلانك') ||
        exerciseName.contains('Plank')) {
      return Icons.straighten;
    } else if (exerciseName.contains('جري') || exerciseName.contains('Run')) {
      return Icons.directions_run;
    } else if (exerciseName.contains('بطن') ||
        exerciseName.contains('Crunch')) {
      return Icons.self_improvement;
    } else {
      return Icons.sports_gymnastics;
    }
  }
}
