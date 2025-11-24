import 'package:flutter/material.dart';
import '../../../shared/themes/app_theme.dart';
import '../models/workout_plan.dart';
import '../screens/workout_plan_details_screen.dart';

/// بطاقة عرض خطة التمرين
class WorkoutPlanCard extends StatelessWidget {
  const WorkoutPlanCard({super.key, required this.plan});
  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _showPlanDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان الخطة وحالة التفعيل
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (plan.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primaryColor),
                      ),
                      child: const Text(
                        'نشط',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // وصف الخطة
              Text(
                plan.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // إحصائيات الخطة
              Row(
                children: [
                  _buildStatChip(
                    context,
                    Icons.calendar_today,
                    '${plan.durationWeeks} أسابيع',
                  ),
                  const SizedBox(width: 12),
                  _buildStatChip(
                    context,
                    Icons.fitness_center,
                    _getDifficultyText(plan.difficulty),
                  ),
                  const SizedBox(width: 12),
                  _buildStatChip(
                    context,
                    Icons.sports_gymnastics,
                    '${_getTotalExercises()} تمرين',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // أهداف العضلات
              if (plan.targetMuscles.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: plan.targetMuscles.map((muscle) {
                    return Chip(
                      label: Text(
                        _getMuscleName(muscle),
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                      side: BorderSide(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 12),

              // تاريخ الإنشاء
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'تم الإنشاء ${_formatDate(plan.createdAt)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'متقدم';
      default:
        return difficulty;
    }
  }

  int _getTotalExercises() {
    return plan.days
        .where((day) => !day.isRestDay)
        .fold(0, (sum, day) => sum + day.exercises.length);
  }

  String _getMuscleName(String muscle) {
    final muscleNames = {
      'chest': 'صدر',
      'back': 'ظهر',
      'shoulders': 'كتفين',
      'arms': 'ذراعين',
      'legs': 'ساقين',
      'core': 'وسط',
      'cardio': 'قلب',
      'full_body': 'جسم كامل',
    };

    return muscleNames[muscle] ?? muscle;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسبوع${weeks > 1 ? '' : ''}';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months شهر${months > 1 ? '' : ''}';
    }
  }

  void _showPlanDetails(BuildContext context) {
    // Navigate to workout plan details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPlanDetailsScreen(plan: plan),
      ),
    );
  }
}
