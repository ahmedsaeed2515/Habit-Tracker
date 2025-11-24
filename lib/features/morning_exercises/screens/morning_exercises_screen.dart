// lib/features/morning_exercises/screens/morning_exercises_screen.dart
// الشاشة الرئيسية لتطبيق التمارين الصباحية

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/empty_state_widget.dart';
import '../../../core/models/morning_exercise.dart';
import '../../../core/providers/morning_exercises_provider.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_dialog.dart';

/// الشاشة الرئيسية للتمارين الصباحية
class MorningExercisesScreen extends ConsumerWidget {
  const MorningExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(morningExercisesProvider);

    return Scaffold(
      appBar: _buildAppBar(context, ref),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTodayTab(context, ref, exercises),
                  _buildHistoryTab(context, ref, exercises),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('التمارين الصباحية'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddExerciseDialog(context, ref),
        ),
      ],
    );
  }

  /// بناء شريط التبويبات
  Widget _buildTabBar() {
    return const TabBar(
      tabs: [
        Tab(text: 'التمارين اليوم', icon: Icon(Icons.today)),
        Tab(text: 'السجل', icon: Icon(Icons.history)),
      ],
    );
  }

  /// بناء تبويب اليوم
  Widget _buildTodayTab(
    BuildContext context,
    WidgetRef ref,
    List<MorningExercise> exercises,
  ) {
    final todayExercises = exercises
        .where((e) => _isSameDate(e.date, DateTime.now()))
        .toList();

    return Column(
      children: [
        _buildStatsSection(todayExercises),
        Expanded(
          child: todayExercises.isEmpty
              ? _buildEmptyState(context, ref)
              : _buildExercisesList(context, ref, todayExercises),
        ),
      ],
    );
  }

  /// بناء تبويب السجل
  Widget _buildHistoryTab(
    BuildContext context,
    WidgetRef ref,
    List<MorningExercise> exercises,
  ) {
    final historyExercises =
        exercises.where((e) => !_isSameDate(e.date, DateTime.now())).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    if (historyExercises.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history,
        title: 'لا يوجد سجل تمارين',
        description: 'ستظهر هنا التمارين السابقة',
      );
    }

    return _buildExercisesList(context, ref, historyExercises);
  }

  /// بناء قسم الإحصائيات
  Widget _buildStatsSection(List<MorningExercise> exercises) {
    final completedCount = exercises.where((e) => e.isCompleted).length;
    final totalCalories = exercises
        .where((e) => e.isCompleted)
        .fold<int>(0, (sum, e) => sum + e.caloriesBurned);
    final completionRate = exercises.isEmpty
        ? 0
        : ((completedCount / exercises.length) * 100).round();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(
              'مكتمل',
              '$completedCount/${exercises.length}',
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatColumn(
              'السعرات',
              '$totalCalories',
              Icons.local_fire_department,
              Colors.orange,
            ),
            _buildStatColumn(
              'المعدل',
              '$completionRate%',
              Icons.trending_up,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء عمود الإحصائية
  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// بناء الحالة الفارغة
  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return EmptyStateWidget(
      icon: Icons.sports_gymnastics,
      title: 'لا توجد تمارين لليوم',
      description: 'أضف تمرينك الصباحي الأول',
      buttonText: 'إضافة تمرين',
      onPressed: () => _showAddExerciseDialog(context, ref),
    );
  }

  /// بناء قائمة التمارين
  Widget _buildExercisesList(
    BuildContext context,
    WidgetRef ref,
    List<MorningExercise> exercises,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return ExerciseCard(
          exercise: exercise,
          onComplete: () => _markAsCompleted(ref, exercise),
          onEdit: () => _showEditExerciseDialog(context, ref, exercise),
          onDelete: () => _showDeleteConfirmation(context, ref, exercise),
        );
      },
    );
  }

  /// التحقق من تطابق التاريخ
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// إظهار dialog إضافة تمرين
  void _showAddExerciseDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => const ExerciseDialog());
  }

  /// إظهار dialog تعديل التمرين
  void _showEditExerciseDialog(
    BuildContext context,
    WidgetRef ref,
    MorningExercise exercise,
  ) {
    showDialog(
      context: context,
      builder: (context) => ExerciseDialog(exercise: exercise),
    );
  }

  /// تأكيد حذف التمرين
  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    MorningExercise exercise,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التمرين'),
        content: Text('هل أنت متأكد من حذف "${exercise.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(morningExercisesProvider.notifier)
                  .deleteExercise(exercise.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  /// تعيين التمرين كمكتمل
  void _markAsCompleted(WidgetRef ref, MorningExercise exercise) {
    ref.read(morningExercisesProvider.notifier).completeExercise(exercise.id);
  }
}
