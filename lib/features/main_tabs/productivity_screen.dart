import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/feature_grid_widget.dart';
import '../../common/widgets/search_bar_widget.dart';
import '../../features/gamification_system/screens/gamification_screen.dart';
import '../../features/pomodoro_task_management/screens/pomodoro_todo_screen.dart';
import '../budget/screens/budget_screen.dart';
import '../inbox/screens/inbox_quick_capture.dart';
import '../library/screens/library_screen.dart';
import '../mood_journal/screens/mood_journal_screen.dart';
import '../notes/screens/notes_list_screen.dart';
import '../projects/screens/projects_list_screen.dart';
import '../tasks/screens/tasks_list_screen.dart';

class ProductivityScreen extends ConsumerStatefulWidget {
  const ProductivityScreen({super.key});

  @override
  ConsumerState<ProductivityScreen> createState() => _ProductivityScreenState();
}

class _ProductivityScreenState extends ConsumerState<ProductivityScreen> {
  String _searchQuery = '';

  // قائمة ميزات الإنتاجية
  static final List<FeatureItem> _productivityFeatures = [
    const FeatureItem(
      title: 'Gamification',
      titleAr: 'التحفيز',
      icon: Icons.emoji_events_rounded,
      route: 'gamification',
      iconColor: Color(0xFFFFD700),
      gradientColors: [Color(0xFFFFF9C4), Color(0xFFFFE082)],
    ),
    const FeatureItem(
      title: 'Pomodoro',
      titleAr: 'بومودورو',
      icon: Icons.timer_rounded,
      route: 'pomodoro',
      iconColor: Color(0xFFE91E63),
      gradientColors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
    ),
    const FeatureItem(
      title: 'Notes',
      titleAr: 'الملاحظات',
      icon: Icons.note_rounded,
      route: 'notes',
      iconColor: Color(0xFF3F51B5),
      gradientColors: [Color(0xFFE8EAF6), Color(0xFFC5CAE9)],
    ),
    const FeatureItem(
      title: 'Mood & Journal',
      titleAr: 'المزاج واليومية',
      route: 'mood_journal',
      icon: Icons.mood_rounded,
      iconColor: Color(0xFF00BCD4),
      gradientColors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
    ),
    const FeatureItem(
      title: 'Budget',
      titleAr: 'الميزانية',
      icon: Icons.account_balance_wallet_rounded,
      route: 'budget',
      iconColor: Color(0xFF4CAF50),
      gradientColors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
    ),
    const FeatureItem(
      title: 'Projects',
      titleAr: 'المشاريع',
      icon: Icons.folder_rounded,
      route: 'projects',
      iconColor: Color(0xFFFF9800),
      gradientColors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
    ),
    const FeatureItem(
      title: 'Tasks',
      titleAr: 'المهام',
      icon: Icons.task_alt_rounded,
      route: 'tasks',
      iconColor: Color(0xFF2196F3),
      gradientColors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
    ),
    const FeatureItem(
      title: 'Inbox',
      titleAr: 'صندوق الأفكار',
      icon: Icons.inbox_rounded,
      route: 'inbox',
      iconColor: Color(0xFF9C27B0),
      gradientColors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
    ),
    const FeatureItem(
      title: 'Library',
      titleAr: 'المكتبة',
      icon: Icons.library_books_rounded,
      route: 'library',
      iconColor: Color(0xFF795548),
      gradientColors: [Color(0xFFEFEBE9), Color(0xFFD7CCC8)],
    ),
  ];

  // العناصر المفلترة
  List<FeatureItem> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return _productivityFeatures;
    }

    final query = _searchQuery.toLowerCase();
    return _productivityFeatures.where((item) {
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
      case 'gamification':
        screen = const GamificationScreen();
        break;
      case 'pomodoro':
        screen = const PomodoroTodoScreen();
        break;
      case 'notes':
        screen = const NotesListScreen();
        break;
      case 'mood_journal':
        screen = const MoodJournalScreen();
        break;
      case 'budget':
        screen = const BudgetScreen();
        break;
      case 'projects':
        screen = const ProjectsListScreen();
        break;
      case 'tasks':
        screen = const TasksListScreen();
        break;
      case 'inbox':
        screen = const InboxQuickCaptureScreen();
        break;
      case 'library':
        screen = const LibraryScreen();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'التحفيز والإنتاجية' : 'Productivity'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              hintText: isArabic ? 'البحث في المميزات...' : 'Search features...',
              onChanged: _onSearchChanged,
              onClear: () => _onSearchChanged(''),
            ),
          ),

          // شبكة الميزات
          Expanded(
            child: FeatureGridWidget(
              items: _filteredItems,
              onItemTap: (route) => _navigateToFeature(context, route),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
