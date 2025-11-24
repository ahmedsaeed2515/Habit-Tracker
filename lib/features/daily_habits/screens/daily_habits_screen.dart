// lib/features/daily_habits/screens/daily_habits_screen.dart
// الشاشة الرئيسية للعادات اليومية

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/empty_state_widget.dart';
import '../../../core/models/habit.dart';
import '../../../core/providers/habits_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_dialog.dart';

/// الشاشة الرئيسية للعادات اليومية
class DailyHabitsScreen extends ConsumerWidget {
  const DailyHabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);

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
                  _buildActiveHabitsTab(context, ref, habits),
                  _buildStatsTab(context, ref, habits),
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
      title: const Text('العادات اليومية'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddHabitDialog(context, ref),
        ),
      ],
    );
  }

  /// بناء شريط التبويبات
  Widget _buildTabBar() {
    return const TabBar(
      tabs: [
        Tab(text: 'العادات النشطة', icon: Icon(Icons.track_changes)),
        Tab(text: 'الإحصائيات', icon: Icon(Icons.analytics)),
      ],
    );
  }

  /// بناء تبويب العادات النشطة
  Widget _buildActiveHabitsTab(
    BuildContext context,
    WidgetRef ref,
    List<Habit> habits,
  ) {
    final activeHabits = habits.where((h) => h.isActive).toList();

    if (activeHabits.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.track_changes,
        title: 'لا توجد عادات نشطة',
        description: 'أضف عادتك الأولى لبدء التتبع',
        buttonText: 'إضافة عادة',
        onPressed: () => _showAddHabitDialog(context, ref),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeHabits.length,
      itemBuilder: (context, index) {
        final habit = activeHabits[index];
        return HabitCard(
          habit: habit,
          onCompleted: () => _markHabitCompleted(ref, habit),
          onEdit: () => _showEditHabitDialog(context, ref, habit),
          onDelete: () => _showDeleteConfirmation(context, ref, habit),
        );
      },
    );
  }

  /// بناء تبويب الإحصائيات
  Widget _buildStatsTab(
    BuildContext context,
    WidgetRef ref,
    List<Habit> habits,
  ) {
    if (habits.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.analytics,
        title: 'لا توجد إحصائيات',
        description: 'أضف عادات لعرض الإحصائيات',
      );
    }

    return _buildStatsContent(habits);
  }

  /// بناء محتوى الإحصائيات
  Widget _buildStatsContent(List<Habit> habits) {
    final totalHabits = habits.length;
    final activeHabits = habits.where((h) => h.isActive).length;
    final completedToday = habits
        .where((h) => h.getTodayProgress() >= 100)
        .length;
    final totalStreak = habits.fold<int>(0, (sum, h) => sum + h.currentStreak);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatsCard('إجمالي العادات', totalHabits.toString(), Icons.list),
        _buildStatsCard(
          'العادات النشطة',
          activeHabits.toString(),
          Icons.track_changes,
        ),
        _buildStatsCard(
          'مكتملة اليوم',
          completedToday.toString(),
          Icons.check_circle,
        ),
        _buildStatsCard(
          'مجموع السلاسل',
          totalStreak.toString(),
          Icons.trending_up,
        ),
        const const SizedBox(height: 16),
        _buildHabitsBreakdown(habits),
      ],
    );
  }

  /// بناء بطاقة إحصائية
  Widget _buildStatsCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// بناء تفصيل العادات
  Widget _buildHabitsBreakdown(List<Habit> habits) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفصيل العادات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const const SizedBox(height: 12),
            ...habits.map(
              (habit) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(habit.icon),
                    const const SizedBox(width: 8),
                    Expanded(child: Text(habit.name)),
                    Text('${habit.getTodayProgress().toInt()}%'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// إظهار dialog إضافة عادة
  void _showAddHabitDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => const HabitDialog());
  }

  /// إظهار dialog تعديل العادة
  void _showEditHabitDialog(BuildContext context, WidgetRef ref, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => HabitDialog(habit: habit),
    );
  }

  /// تأكيد حذف العادة
  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العادة'),
        content: Text('هل أنت متأكد من حذف "${habit.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(habitsProvider.notifier).deleteHabit(habit.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  /// تعيين العادة كمكتملة
  void _markHabitCompleted(WidgetRef ref, Habit habit) {
    ref.read(habitsProvider.notifier).markHabitCompleted(habit.id);
  }
}
