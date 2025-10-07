import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../gamification/screens/enhanced_gamification_screen.dart';
import '../../intelligent_workout_planner/screens/intelligent_workout_planner_screen.dart';
// import '../../gym_tracker/screens/gym_tracker_screen.dart';
// import '../../daily_habits/screens/daily_habits_screen.dart';
// import '../../smart_todo/screens/smart_todo_screen.dart';
import '../../pomodoro_task_management/screens/pomodoro_todo_screen.dart';
import '../../smart_calendar/screens/smart_calendar_screen.dart';
import '../../widgets_system/screens/widgets_dashboard_screen.dart';

/// ويدجت روابط سريعة للوصول إلى الميزات الأساسية
class QuickShortcuts extends ConsumerWidget {
  const QuickShortcuts({super.key});

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: label,
                  child: Icon(
                    icon,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الوصول السريع' : 'Quick Shortcuts',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _tile(context, Icons.widgets, isArabic ? 'الودجت' : 'Widgets', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WidgetsDashboardScreen(),
                ),
              );
            }),
            const SizedBox(width: 12),
            _tile(
              context,
              Icons.videogame_asset,
              isArabic ? 'التحفيز' : 'Gamification',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EnhancedGamificationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _tile(context, Icons.timer, isArabic ? 'بومودورو' : 'Pomodoro', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PomodoroTodoScreen()),
              );
            }),
            const SizedBox(width: 12),
            _tile(
              context,
              Icons.calendar_month,
              isArabic ? 'التقويم' : 'Calendar',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SmartCalendarScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _tile(
              context,
              Icons.fitness_center,
              isArabic ? 'التخطيط الرياضي' : 'Workout Planner',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const IntelligentWorkoutPlannerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            // يمكن إضافة رابط آخر هنا في المستقبل
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }
}
