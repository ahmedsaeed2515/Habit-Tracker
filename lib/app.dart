// lib/app.dart
// الشاشة الرئيسية للتطبيق مع شريط التنقل السفلي

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/localization/app_localizations.dart';
import 'features/gym_tracker/screens/gym_tracker_screen.dart';
import 'features/morning_exercises/screens/morning_exercises_screen.dart';
import 'features/daily_habits/screens/daily_habits_screen.dart';
import 'features/smart_todo/screens/smart_todo_screen.dart';
import 'features/gamification/screens/enhanced_gamification_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/settings/screens/settings_screen.dart';
// الميزات الجديدة
import 'features/smart_calendar/screens/smart_calendar_screen.dart';
import 'features/widgets_system/screens/widgets_dashboard_screen.dart';
import 'features/pomodoro_task_management/screens/pomodoro_todo_screen.dart';

/// مقدم حالة مؤشر التبويب المحدد
final selectedTabIndexProvider = StateProvider<int>(
  (ref) => 5,
); // البداية من لوحة التحكم

class MainAppScreen extends ConsumerWidget {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // قائمة الشاشات
    final screens = [
      const GymTrackerScreen(),
      const MorningExercisesScreen(),
      const DailyHabitsScreen(),
      const SmartTodoScreen(),
      const EnhancedGamificationScreen(),
      const DashboardScreen(),
      const SmartCalendarScreen(), // التقويم الذكي
      const WidgetsDashboardScreen(), // نظام الودجت
      const PomodoroTodoScreen(), // إدارة المهام مع تقنية Pomodoro
      const SettingsScreen(),
    ];

    // قائمة عناصر شريط التنقل
    final navItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.fitness_center),
        activeIcon: const Icon(Icons.fitness_center),
        label: localizations.gymTracker,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.wb_sunny),
        activeIcon: const Icon(Icons.wb_sunny),
        label: localizations.morningExercises,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.track_changes),
        activeIcon: const Icon(Icons.track_changes),
        label: localizations.dailyHabits,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.checklist),
        activeIcon: const Icon(Icons.checklist),
        label: localizations.smartTodo,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.videogame_asset),
        activeIcon: const Icon(Icons.videogame_asset),
        label: isArabic ? 'الألعاب' : 'Gamification',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.dashboard),
        activeIcon: const Icon(Icons.dashboard),
        label: localizations.dashboard,
      ),
      // الميزات الجديدة
      BottomNavigationBarItem(
        icon: const Icon(Icons.calendar_month),
        activeIcon: const Icon(Icons.calendar_month),
        label: isArabic ? 'التقويم' : 'Calendar',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.widgets),
        activeIcon: const Icon(Icons.widgets),
        label: isArabic ? 'الودجت' : 'Widgets',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.timer),
        activeIcon: const Icon(Icons.timer),
        label: isArabic ? 'بومودورو' : 'Pomodoro',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        activeIcon: const Icon(Icons.settings),
        label: localizations.settings,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: navItems.length > 5
          ? _buildScrollableBottomNavBar(context, ref, selectedIndex, navItems)
          : _buildBottomNavigationBar(context, ref, selectedIndex, navItems),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
    List<BottomNavigationBarItem> items,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedTabIndexProvider.notifier).state = index;
        },
        items: items,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        elevation: 0, // إزالة الظل الافتراضي لاستخدام ظل مخصص
        enableFeedback: true,
      ),
    );
  }

  Widget _buildScrollableBottomNavBar(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
    List<BottomNavigationBarItem> items,
  ) {
    final theme = Theme.of(context);

    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              ref.read(selectedTabIndexProvider.notifier).state = index;
            },
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.bottomNavigationBarTheme.selectedItemColor
                                ?.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: item.icon,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label ?? '',
                    style: TextStyle(
                      color: isSelected
                          ? theme.bottomNavigationBarTheme.selectedItemColor
                          : theme.bottomNavigationBarTheme.unselectedItemColor,
                      fontSize: isSelected ? 11 : 10,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
