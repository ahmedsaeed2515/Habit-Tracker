import 'package:flutter/material.dart';
import '../models/workout_plan.dart';

/// ويدجت بطاقة يوم التمرين
class WorkoutDayCard extends StatelessWidget {

  const WorkoutDayCard({
    super.key,
    required this.day,
    required this.dayNumber,
    this.isCompleted = false,
    this.onTap,
  });
  final WorkoutDay day;
  final int dayNumber;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // رقم اليوم
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const const SizedBox(width: 16),

              // معلومات اليوم
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اليوم $dayNumber',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const const SizedBox(height: 4),
                    Text(
                      '${day.exercises.length} تمرين',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // أيقونة الحالة
              Icon(
                isCompleted ? Icons.check_circle : Icons.play_circle_fill,
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
