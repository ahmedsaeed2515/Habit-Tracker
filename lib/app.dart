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
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        activeIcon: const Icon(Icons.settings),
        label: localizations.settings,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: _buildBottomNavigationBar(
        context,
        ref,
        selectedIndex,
        navItems,
      ),
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
}
