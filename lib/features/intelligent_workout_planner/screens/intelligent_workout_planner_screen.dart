import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/themes/app_theme.dart';
import '../models/workout_plan.dart';
import '../providers/workout_planner_providers.dart';
import '../widgets/workout_plan_card.dart';
import '../widgets/create_plan_dialog.dart';
import '../widgets/ai_recommendations_widget.dart';

/// الشاشة الرئيسية للتخطيط الرياضي الذكي
class IntelligentWorkoutPlannerScreen extends ConsumerWidget {
  const IntelligentWorkoutPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutPlansAsync = ref.watch(workoutPlansProvider);
    final activePlanAsync = ref.watch(activeWorkoutPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التخطيط الرياضي الذكي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePlanDialog(context, ref),
            tooltip: 'إنشاء خطة جديدة',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان الشاشة
              Text(
                'خطط التمرين الذكية',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'خطط تمرين مخصصة مدعومة بالذكاء الاصطناعي',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // التوصيات الذكية
              const AIRecommendationsWidget(),
              const SizedBox(height: 24),

              // الخطة النشطة
              _buildActivePlanSection(context, activePlanAsync),
              const SizedBox(height: 24),

              // قائمة الخطط
              Expanded(
                child: _buildWorkoutPlansList(context, workoutPlansAsync),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePlanDialog(context, ref),
        icon: const Icon(Icons.auto_fix_high),
        label: const Text('إنشاء خطة ذكية'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildActivePlanSection(
    BuildContext context,
    AsyncValue<WorkoutPlan?> activePlanAsync,
  ) {
    return activePlanAsync.when(
      data: (activePlan) {
        if (activePlan == null) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.fitness_center, color: Colors.grey[400], size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'لا توجد خطة نشطة',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'أنشئ خطة تمرين مخصصة لبدء رحلتك الرياضية',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          elevation: 4,
          color: AppTheme.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_filled,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'الخطة النشطة',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  activePlan.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  activePlan.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildPlanStat(
                      context,
                      '${activePlan.durationWeeks}',
                      'أسابيع',
                      Icons.calendar_today,
                    ),
                    const SizedBox(width: 24),
                    _buildPlanStat(
                      context,
                      activePlan.difficulty,
                      'المستوى',
                      Icons.trending_up,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'خطأ في تحميل الخطة النشطة: ${error.toString()}',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkoutPlansList(
    BuildContext context,
    AsyncValue<List<WorkoutPlan>> plansAsync,
  ) {
    return plansAsync.when(
      data: (plans) {
        if (plans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'لا توجد خطط تمرين',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'ابدأ بإنشاء خطة تمرين مخصصة',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: WorkoutPlanCard(plan: plan),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل خطط التمرين',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.red.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.red.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlanDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const CreatePlanDialog(),
    );
  }
}
