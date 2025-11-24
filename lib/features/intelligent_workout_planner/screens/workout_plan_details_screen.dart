import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/themes/app_theme.dart';
import '../models/workout_plan.dart';
import '../providers/workout_planner_providers.dart';
import '../widgets/plan_stats_widget.dart';
import '../widgets/workout_day_card.dart';
import '../widgets/workout_day_details_sheet.dart';

/// شاشة تفاصيل خطة التمرين
class WorkoutPlanDetailsScreen extends ConsumerWidget {
  const WorkoutPlanDetailsScreen({super.key, required this.plan});
  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(workoutProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
        actions: [
          IconButton(
            icon: Icon(plan.isActive ? Icons.pause : Icons.play_arrow),
            onPressed: () => _togglePlanActivation(context, ref),
            tooltip: plan.isActive ? 'إيقاف الخطة' : 'تفعيل الخطة',
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('تعديل الخطة')),
              const PopupMenuItem(value: 'duplicate', child: Text('نسخ الخطة')),
              const PopupMenuItem(value: 'delete', child: Text('حذف الخطة')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // إحصائيات الخطة
            PlanStatsWidget(plan: plan),

            // التقدم في الخطة
            _buildProgressSection(context, progress),

            // قائمة أيام التمرين
            Expanded(child: _buildWorkoutDaysList(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startWorkout(context, ref),
        icon: const Icon(Icons.play_arrow),
        label: const Text('ابدأ التمرين'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    Map<String, dynamic> progress,
  ) {
    final currentDay = progress['currentDay'] as int;
    final totalDays = plan.days.length;
    final progressPercent = (currentDay / totalDays).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'تقدم الخطة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progressPercent,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اليوم $currentDay من $totalDays',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutDaysList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plan.days.length,
      itemBuilder: (context, index) {
        final day = plan.days[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: WorkoutDayCard(
            day: day,
            dayNumber: index + 1,
            onTap: () => _showDayDetails(context, day),
          ),
        );
      },
    );
  }

  Future<void> _togglePlanActivation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final workoutPlansNotifier = ref.read(workoutPlansProvider.notifier);
      await workoutPlansNotifier.activatePlan(plan.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(plan.isActive ? 'تم إيقاف الخطة' : 'تم تفعيل الخطة'),
          backgroundColor: plan.isActive ? Colors.orange : Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث حالة الخطة: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        // Navigate to edit screen (using the same form screen in edit mode)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'وضع التعديل قريباً - يمكن إنشاء نسخة جديدة بدلاً من ذلك',
            ),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'duplicate':
        _duplicatePlan(context, ref);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  Future<void> _duplicatePlan(BuildContext context, WidgetRef ref) async {
    // Show a snackbar to inform user about duplicate functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إنشاء نسخة من الخطة: ${plan.name}'),
        action: SnackBarAction(
          label: 'عرض',
          onPressed: () {
            // Navigate back to plans list
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الخطة'),
        content: const Text(
          'هل أنت متأكد من حذف هذه الخطة؟ هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePlan(context, ref);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePlan(BuildContext context, WidgetRef ref) async {
    try {
      final workoutPlansNotifier = ref.read(workoutPlansProvider.notifier);
      await workoutPlansNotifier.deletePlan(plan.id);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف الخطة بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف الخطة: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDayDetails(BuildContext context, WorkoutDay day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => WorkoutDayDetailsSheet(
          day: day,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context, WidgetRef ref) {
    final progress = ref.read(workoutProgressProvider);
    final currentDayIndex = (progress['currentDay'] as int) - 1;

    // Show workout execution dialog/screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('بدء التمرين - يوم ${currentDayIndex + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أنت على وشك البدء في تمرين اليوم ${currentDayIndex + 1}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'الميزات:\n• مؤقت تلقائي\n• تتبع المجموعات والتكرارات\n• راحة بين التمارين',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('شاشة تنفيذ التمرين قيد التطوير'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('ابدأ الآن'),
          ),
        ],
      ),
    );
  }
}
