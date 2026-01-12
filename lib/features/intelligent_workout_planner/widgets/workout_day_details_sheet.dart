import 'package:flutter/material.dart';
import '../models/workout_plan.dart';

/// شيت تفاصيل يوم التمرين
class WorkoutDayDetailsSheet extends StatelessWidget {

  const WorkoutDayDetailsSheet({
    super.key,
    required this.day,
    required this.scrollController,
  });
  final WorkoutDay day;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'تمارين اليوم',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // Exercises List
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: day.exercises.length,
              itemBuilder: (context, index) {
                final exercise = day.exercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Exercise info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const const SizedBox(height: 4),
                              Text(
                                '${exercise.sets} مجموعات × ${exercise.reps} تكرار',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              if (exercise.restSeconds > 0) ...[
                                const const SizedBox(height: 4),
                                Text(
                                  'وقت الراحة: ${exercise.restSeconds} ثانية',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Exercise icon
                        Icon(
                          Icons.fitness_center,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
