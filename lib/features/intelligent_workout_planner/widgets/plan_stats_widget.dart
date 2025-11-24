import 'package:flutter/material.dart';
import '../models/workout_plan.dart';

/// ويدجت إحصائيات خطة التمرين
class PlanStatsWidget extends StatelessWidget {

  const PlanStatsWidget({super.key, required this.plan});
  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: '${plan.durationWeeks}',
            label: 'أسابيع',
            icon: Icons.calendar_today,
          ),
          _StatItem(
            value: '${plan.days.length}',
            label: 'أيام',
            icon: Icons.today,
          ),
          _StatItem(
            value: plan.difficulty,
            label: 'المستوى',
            icon: Icons.fitness_center,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
