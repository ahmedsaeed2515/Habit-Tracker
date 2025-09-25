// lib/features/gym_tracker/widgets/workout_card.dart
// Widget لعرض بطاقة تمرين واحد في قائمة التمارين

import 'package:flutter/material.dart';

import '../../../core/models/workout.dart';

/// Widget لعرض تمرين واحد في شكل بطاقة
class WorkoutCard extends StatelessWidget {
  /// بيانات التمرين المراد عرضه
  final Workout workout;

  /// دالة للتعديل على التمرين
  final VoidCallback onEdit;

  /// دالة لحذف التمرين
  final VoidCallback onDelete;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onEdit,
    required this.onDelete,
  });

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
            const SizedBox(height: 8),
            _buildTypeInfo(),
            if (workout.notes.isNotEmpty) _buildNotes(),
            const SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// بناء رأس البطاقة (الاسم والمدة)
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getWorkoutIcon(workout.type),
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            workout.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          '${workout.duration} دقيقة',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// عرض نوع التمرين
  Widget _buildTypeInfo() {
    return Text(
      workout.type,
      style: TextStyle(color: Colors.grey[600], fontSize: 14),
    );
  }

  /// عرض الملاحظات إذا كانت موجودة
  Widget _buildNotes() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          workout.notes,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
      ],
    );
  }

  /// بناء تذييل البطاقة (التاريخ والأزرار)
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${workout.date.day}/${workout.date.month}/${workout.date.year}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Row(
          children: [
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
  IconData _getWorkoutIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cardio':
      case 'كارديو':
        return Icons.directions_run;
      case 'strength':
      case 'قوة':
        return Icons.fitness_center;
      case 'flexibility':
      case 'مرونة':
        return Icons.self_improvement;
      case 'sports':
      case 'رياضة':
        return Icons.sports;
      default:
        return Icons.fitness_center;
    }
  }
}
