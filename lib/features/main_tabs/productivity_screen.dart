import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/gamification/screens/enhanced_gamification_screen.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // قائمة العناصر القابلة للبحث
  static const List<Map<String, dynamic>> _searchableItems = [
    {'title': 'Gamification', 'titleAr': 'التحفيز', 'route': 'gamification'},
    {'title': 'Pomodoro', 'titleAr': 'بومودورو', 'route': 'pomodoro'},
    {'title': 'Notes', 'titleAr': 'الملاحظات', 'route': 'notes'},
    {
      'title': 'Mood & Journal',
      'titleAr': 'المزاج واليومية',
      'route': 'mood_journal',
    },
    {'title': 'Budget', 'titleAr': 'الميزانية', 'route': 'budget'},
    {'title': 'Projects', 'titleAr': 'المشاريع', 'route': 'projects'},
    {'title': 'Tasks', 'titleAr': 'المهام', 'route': 'tasks'},
    {'title': 'Inbox', 'titleAr': 'صندوق الأفكار', 'route': 'inbox'},
    {'title': 'Library', 'titleAr': 'المكتبة', 'route': 'library'},
  ];

  // العناصر المفلترة
  List<Map<String, dynamic>> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return _searchableItems;
    }

    final query = _searchQuery.toLowerCase();
    return _searchableItems.where((item) {
      final title = (item['title'] as String).toLowerCase();
      final titleAr = (item['titleAr'] as String).toLowerCase();
      return title.contains(query) || titleAr.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'التحفيز والإنتاجية' : 'Productivity'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.primary),
            onPressed: _clearSearch,
            tooltip: isArabic ? 'مسح البحث' : 'Clear search',
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.surface, colorScheme.surfaceContainerLowest],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // شريط البحث محسن
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: isArabic
                        ? 'البحث في المميزات...'
                        : 'Search features...',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              // عنوان القسم
              if (_searchQuery.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.grid_view_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'المميزات المتاحة' : 'Available Features',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // رسالة عدم وجود نتائج
              if (_filteredItems.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isArabic ? 'لا توجد نتائج للبحث' : 'No results found',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic
                              ? 'جرب كلمات مختلفة'
                              : 'Try different keywords',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final crossAxisCount = width > 900
                          ? 4
                          : width > 600
                          ? 3
                          : 2;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.15,
                        ),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];

                          // pick an icon per route for better UX
                          IconData leadingIcon;
                          Color iconColor;
                          switch (item['route'] as String) {
                            case 'gamification':
                              leadingIcon = Icons.emoji_events_rounded;
                              iconColor = const Color(0xFFFFD700); // Gold
                              break;
                            case 'pomodoro':
                              leadingIcon = Icons.timer_rounded;
                              iconColor = const Color(0xFF2196F3); // Blue
                              break;
                            case 'notes':
                              leadingIcon = Icons.note_rounded;
                              iconColor = const Color(0xFF4CAF50); // Green
                              break;
                            case 'mood_journal':
                              leadingIcon = Icons.mood_rounded;
                              iconColor = const Color(0xFFFF9800); // Orange
                              break;
                            case 'budget':
                              leadingIcon =
                                  Icons.account_balance_wallet_rounded;
                              iconColor = const Color(0xFF9C27B0); // Purple
                              break;
                            case 'projects':
                              leadingIcon = Icons.folder_rounded;
                              iconColor = const Color(0xFF795548); // Brown
                              break;
                            case 'tasks':
                              leadingIcon = Icons.checklist_rounded;
                              iconColor = const Color(0xFF607D8B); // Blue Grey
                              break;
                            case 'inbox':
                              leadingIcon = Icons.inbox_rounded;
                              iconColor = const Color(0xFF00BCD4); // Cyan
                              break;
                            case 'library':
                              leadingIcon = Icons.menu_book_rounded;
                              iconColor = const Color(
                                0xFF8BC34A,
                              ); // Light Green
                              break;
                            default:
                              leadingIcon = Icons.extension_rounded;
                              iconColor = colorScheme.primary;
                          }

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: Card(
                              elevation: 6,
                              shadowColor: colorScheme.shadow.withValues(
                                alpha: 0.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  // Add haptic feedback
                                  Feedback.forTap(context);

                                  switch (item['route'] as String) {
                                    case 'gamification':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const EnhancedGamificationScreen(),
                                        ),
                                      );
                                      break;
                                    case 'pomodoro':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const PomodoroTodoScreen(),
                                        ),
                                      );
                                      break;
                                    case 'notes':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const NotesListScreen(),
                                        ),
                                      );
                                      break;
                                    case 'mood_journal':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const MoodJournalScreen(),
                                        ),
                                      );
                                      break;
                                    case 'budget':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const BudgetScreen(),
                                        ),
                                      );
                                      break;
                                    case 'projects':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ProjectsListScreen(),
                                        ),
                                      );
                                      break;
                                    case 'tasks':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const TasksListScreen(),
                                        ),
                                      );
                                      break;
                                    case 'inbox':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const InboxQuickCaptureScreen(),
                                        ),
                                      );
                                      break;
                                    case 'library':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LibraryScreen(),
                                        ),
                                      );
                                      break;
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        colorScheme.surface,
                                        colorScheme.surfaceContainerHighest
                                            .withValues(alpha: 0.3),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: iconColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Icon(
                                          leadingIcon,
                                          size: 32,
                                          color: iconColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        isArabic
                                            ? item['titleAr'] as String
                                            : item['title'] as String,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface,
                                              height: 1.2,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
