// lib/features/gym_tracker/screens/gym_tracker_screen.dart
// الشاشة الرئيسية لمتتبع الجيم - مبسطة ومنظمة

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/empty_state_widget.dart';
import '../../../core/models/workout.dart';
import '../../../core/providers/gym_provider.dart';
import '../../../shared/localization/app_localizations.dart';
import '../widgets/workout_card.dart';
import '../widgets/workout_dialog.dart';

/// الشاشة الرئيسية لمتتبع الجيم مع تبويبات للفترات الزمنية المختلفة
class GymTrackerScreen extends ConsumerStatefulWidget {
  const GymTrackerScreen({super.key});

  @override
  ConsumerState<GymTrackerScreen> createState() => _GymTrackerScreenState();
}

class _GymTrackerScreenState extends ConsumerState<GymTrackerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _buildAppBar(localizations),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar(AppLocalizations localizations) {
    return AppBar(
      title: Text(localizations.gymTracker),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _showAddWorkoutDialog,
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: _showStatsDialog,
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(icon: const Icon(Icons.today), text: localizations.today),
          Tab(icon: const Icon(Icons.view_week), text: localizations.thisWeek),
          Tab(icon: const Icon(Icons.history), text: localizations.allTime),
        ],
      ),
    );
  }

  /// بناء المحتوى الرئيسي
  Widget _buildBody() {
    final workouts = ref.watch(workoutsProvider);

    return TabBarView(
      controller: _tabController,
      children: [
        _WorkoutListView(
          workouts: _filterTodayWorkouts(workouts),
          emptyStateConfig: _EmptyStateConfig.today(),
          onEdit: _showEditWorkoutDialog,
          onDelete: _confirmDeleteWorkout,
        ),
        _WorkoutListView(
          workouts: _filterWeekWorkouts(workouts),
          emptyStateConfig: _EmptyStateConfig.week(),
          onEdit: _showEditWorkoutDialog,
          onDelete: _confirmDeleteWorkout,
        ),
        _WorkoutListView(
          workouts: workouts,
          emptyStateConfig: _EmptyStateConfig.allTime(),
          onEdit: _showEditWorkoutDialog,
          onDelete: _confirmDeleteWorkout,
        ),
      ],
    );
  }

  /// بناء الزر العائم
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showAddWorkoutDialog,
      child: const Icon(Icons.add),
    );
  }

  /// تصفية تمارين اليوم
  List<Workout> _filterTodayWorkouts(List<Workout> workouts) {
    final today = DateTime.now();
    return workouts.where((workout) {
      return workout.date.year == today.year &&
          workout.date.month == today.month &&
          workout.date.day == today.day;
    }).toList();
  }

  /// تصفية تمارين الأسبوع
  List<Workout> _filterWeekWorkouts(List<Workout> workouts) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return workouts.where((workout) {
      return workout.date.isAfter(
            startOfWeek.subtract(const Duration(days: 1)),
          ) &&
          workout.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }

  /// إظهار حوار إضافة تمرين جديد
  void _showAddWorkoutDialog() {
    showDialog(context: context, builder: (context) => const WorkoutDialog());
  }

  /// إظهار حوار تعديل تمرين
  void _showEditWorkoutDialog(Workout workout) {
    showDialog(
      context: context,
      builder: (context) => WorkoutDialog(workout: workout),
    );
  }

  /// تأكيد حذف تمرين
  void _confirmDeleteWorkout(Workout workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التمرين'),
        content: Text('هل أنت متأكد من حذف تمرين "${workout.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(workoutsProvider.notifier).deleteWorkout(workout.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  /// إظهار حوار الإحصائيات
  void _showStatsDialog() {
    // TODO: تطوير حوار الإحصائيات منفصل
  }
}

/// Widget لعرض قائمة التمارين أو الحالة الفارغة
class _WorkoutListView extends StatelessWidget {

  const _WorkoutListView({
    required this.workouts,
    required this.emptyStateConfig,
    required this.onEdit,
    required this.onDelete,
  });
  final List<Workout> workouts;
  final _EmptyStateConfig emptyStateConfig;
  final Function(Workout) onEdit;
  final Function(Workout) onDelete;

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return EmptyStateWidget(
        icon: emptyStateConfig.icon,
        title: emptyStateConfig.title,
        description: emptyStateConfig.description,
        buttonText: emptyStateConfig.buttonText,
        onPressed: emptyStateConfig.onPressed,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return WorkoutCard(
          workout: workout,
          onEdit: () => onEdit(workout),
          onDelete: () => onDelete(workout),
        );
      },
    );
  }
}

/// إعدادات الحالة الفارغة لكل تبويبة
class _EmptyStateConfig {

  const _EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onPressed,
  });

  factory _EmptyStateConfig.today() {
    return const _EmptyStateConfig(
      icon: Icons.fitness_center,
      title: 'لا توجد تمارين اليوم',
      description: 'ابدأ تمرينك الأول!',
    );
  }

  factory _EmptyStateConfig.week() {
    return const _EmptyStateConfig(
      icon: Icons.calendar_view_week,
      title: 'لا توجد تمارين هذا الأسبوع',
      description: 'ابدأ روتينك الأسبوعي!',
    );
  }

  factory _EmptyStateConfig.allTime() {
    return const _EmptyStateConfig(
      icon: Icons.history,
      title: 'لا توجد تمارين مسجلة',
      description: 'سجل تمرينك الأول!',
    );
  }
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onPressed;
}
