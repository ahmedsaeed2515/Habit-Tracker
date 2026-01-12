// lib/features/dashboard/screens/dashboard_screen.dart
// شاشة لوحة التحكم الرئيسية - محسنة لتجربة مستخدم أفضل وإمكانية وصول أعلى

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../shared/localization/app_localizations.dart';
import '../../daily_habits/screens/daily_habits_screen.dart';
import '../../smart_notifications/screens/notifications_screen.dart';
import '../../smart_todo/screens/smart_todo_screen.dart';
import '../widgets/widgets.dart';

/// شاشة لوحة التحكم الرئيسية
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          localizations.dashboard,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          // زر الملف الشخصي
          Semantics(
            label: isArabic ? 'الملف الشخصي' : 'Profile',
            hint: isArabic
                ? 'اضغط لعرض الملف الشخصي'
                : 'Tap to view profile',
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                tooltip: isArabic ? 'الملف الشخصي' : 'Profile',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ),
          Semantics(
            label: isArabic ? 'الإشعارات' : 'Notifications',
            hint: isArabic
                ? 'اضغط لعرض الإشعارات'
                : 'Tap to view notifications',
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                tooltip: isArabic ? 'الإشعارات' : 'Notifications',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.8),
              theme.colorScheme.secondary.withValues(alpha: 0.6),
              theme.colorScheme.tertiary.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: AnimationLimiter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: isArabic ? 50.0 : -50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: const [
                  // قسم الترحيب
                  WelcomeSection(),
                  const SizedBox(height: 24),

                  // الملخص السريع
                  QuickSummary(),
                  const SizedBox(height: 24),

                  // روابط الوصول السريع
                  QuickShortcuts(),
                  const SizedBox(height: 24),

                  // الإجراءات السريعة
                  QuickActions(),
                  const SizedBox(height: 24),

                  // النشاط الأخير
                  RecentActivity(),
                  const SizedBox(height: 24),

                  // الإحصائيات الأسبوعية
                  WeeklyStats(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            // إظهار قائمة لإضافة عناصر جديدة
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const const SizedBox(height: 16),
                      Text(
                        isArabic ? 'إضافة عنصر جديد' : 'Add New Item',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const const SizedBox(height: 16),
                      _buildAddItemTile(
                        context,
                        icon: Icons.task_alt,
                        title: isArabic ? 'مهمة جديدة' : 'New Task',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to Smart Todo screen to add a new task
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SmartTodoScreen(),
                            ),
                          );
                        },
                      ),
                      _buildAddItemTile(
                        context,
                        icon: Icons.repeat,
                        title: isArabic ? 'عادة جديدة' : 'New Habit',
                        color: Colors.green,
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to Daily Habits screen to add a new habit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DailyHabitsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          tooltip: isArabic ? 'إضافة عنصر جديد' : 'Add New Item',
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAddItemTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
