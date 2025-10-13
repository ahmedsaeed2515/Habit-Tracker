import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/feature_grid_widget.dart';
import '../../common/widgets/search_bar_widget.dart';
import '../../features/daily_habits/screens/daily_habits_screen.dart';
import '../../features/gym_tracker/screens/gym_tracker_screen.dart';
import '../../features/morning_exercises/screens/morning_exercises_screen.dart';
import '../../features/smart_todo/screens/smart_todo_screen.dart';

class DailyScreen extends ConsumerStatefulWidget {
  const DailyScreen({super.key});

  @override
  ConsumerState<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends ConsumerState<DailyScreen> {
  String _searchQuery = '';

  // قائمة الميزات اليومية
  static final List<FeatureItem> _dailyFeatures = [
    const FeatureItem(
      title: 'Habits',
      titleAr: 'العادات',
      icon: Icons.track_changes_rounded,
      route: 'habits',
      iconColor: Color(0xFF4CAF50),
      gradientColors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
    ),
    const FeatureItem(
      title: 'Tasks',
      titleAr: 'المهام',
      icon: Icons.checklist_rounded,
      route: 'tasks',
      iconColor: Color(0xFF2196F3),
      gradientColors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
    ),
    const FeatureItem(
      title: 'Morning Exercises',
      titleAr: 'تمارين صباحية',
      icon: Icons.wb_sunny_rounded,
      route: 'morning_exercises',
      iconColor: Color(0xFFFF9800),
      gradientColors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
    ),
    const FeatureItem(
      title: 'Gym',
      titleAr: 'الجيم',
      icon: Icons.fitness_center_rounded,
      route: 'gym',
      iconColor: Color(0xFF9C27B0),
      gradientColors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
    ),
  ];

  // العناصر المفلترة
  List<FeatureItem> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return _dailyFeatures;
    }

    final query = _searchQuery.toLowerCase();
    return _dailyFeatures.where((item) {
      final title = item.title.toLowerCase();
      final titleAr = item.titleAr.toLowerCase();
      return title.contains(query) || titleAr.contains(query);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }

  void _navigateToFeature(BuildContext context, String route) {
    Feedback.forTap(context);

    Widget? screen;
    switch (route) {
      case 'habits':
        screen = const DailyHabitsScreen();
        break;
      case 'tasks':
        screen = const SmartTodoScreen();
        break;
      case 'morning_exercises':
        screen = const MorningExercisesScreen();
        break;
      case 'gym':
        screen = const GymTrackerScreen();
        break;
    }

    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'النشاط اليومي' : 'Daily'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              hintText: isArabic ? 'البحث في الأنشطة...' : 'Search activities...',
              onChanged: _onSearchChanged,
              onClear: () => _onSearchChanged(''),
            ),
          ),

          // شبكة الميزات
          Expanded(
            child: FeatureGridWidget(
              items: _filteredItems,
              onItemTap: (route) => _navigateToFeature(context, route),
            ),
          ),
        ],
      ),
    );
  }
}
