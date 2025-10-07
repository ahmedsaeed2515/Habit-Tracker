import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // قائمة العناصر القابلة للبحث
  static const List<Map<String, dynamic>> _searchableItems = [
    {
      'title': 'Habits',
      'titleAr': 'العادات',
      'icon': Icons.track_changes,
      'route': 'habits',
    },
    {
      'title': 'Tasks',
      'titleAr': 'المهام',
      'icon': Icons.checklist,
      'route': 'tasks',
    },
    {
      'title': 'Morning Exercises',
      'titleAr': 'تمارين صباحية',
      'icon': Icons.wb_sunny,
      'route': 'morning_exercises',
    },
    {
      'title': 'Gym',
      'titleAr': 'الجيم',
      'icon': Icons.fitness_center,
      'route': 'gym',
    },
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
        title: Text(isArabic ? 'النشاط اليومي' : 'Daily'),
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
                        ? 'البحث في الأنشطة...'
                        : 'Search activities...',
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

              // بطاقة استكشاف الميزات
              Card(
                elevation: 4,
                shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    // انتقل إلى لوحة التحكم (tab 0)
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.explore_rounded,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? 'استكشف كل الميزات'
                                    : 'Explore all features',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic
                                    ? 'انتقل إلى لوحة التحكم للوصول السريع لكل الميزات'
                                    : 'Go to Dashboard for quick access to all features',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // عنوان القسم
              if (_searchQuery.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.today_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'الأنشطة اليومية' : 'Daily Activities',
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
                            case 'habits':
                              leadingIcon = Icons.track_changes_rounded;
                              iconColor = const Color(0xFF4CAF50); // Green
                              break;
                            case 'tasks':
                              leadingIcon = Icons.checklist_rounded;
                              iconColor = const Color(0xFF2196F3); // Blue
                              break;
                            case 'morning_exercises':
                              leadingIcon = Icons.wb_sunny_rounded;
                              iconColor = const Color(0xFFFF9800); // Orange
                              break;
                            case 'gym':
                              leadingIcon = Icons.fitness_center_rounded;
                              iconColor = const Color(0xFF9C27B0); // Purple
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
                                    case 'habits':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const DailyHabitsScreen(),
                                        ),
                                      );
                                      break;
                                    case 'tasks':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SmartTodoScreen(),
                                        ),
                                      );
                                      break;
                                    case 'morning_exercises':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const MorningExercisesScreen(),
                                        ),
                                      );
                                      break;
                                    case 'gym':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const GymTrackerScreen(),
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
