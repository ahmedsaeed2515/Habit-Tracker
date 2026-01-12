// lib/app.dart
// الشاشة الرئيسية للتطبيق مع شريط التنقل السفلي

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/gamification_system/screens/gamification_screen.dart';
import 'features/main_tabs/daily_screen.dart';
import 'features/main_tabs/productivity_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/smart_calendar/screens/smart_calendar_screen.dart';
import 'features/social/screens/social_screen.dart';
import 'shared/localization/app_localizations.dart';

/// مقدم حالة مؤشر التبويب المحدد
final selectedTabIndexProvider = StateProvider<int>(
  (ref) => 0,
); // البداية من لوحة التحكم

class MainAppScreen extends ConsumerWidget {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // ست تبويبات رئيسية: لوحة التحكم، اليومي، التقويم، الإنتاجية، الألعاب، التواصل الاجتماعي، الإعدادات
    final screens = [
      const DashboardScreen(),
      const DailyScreen(),
      const SmartCalendarScreen(),
      const ProductivityScreen(),
      const GamificationScreen(),
      const SocialScreen(),
      const SettingsScreen(),
    ];

    // قائمة عناصر شريط التنقل (5 عناصر)
    final navItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.dashboard),
        activeIcon: const Icon(Icons.dashboard),
        label: localizations.dashboard,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.today),
        activeIcon: const Icon(Icons.today),
        label: isArabic ? 'اليومي' : 'Daily',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.calendar_month),
        activeIcon: const Icon(Icons.calendar_month),
        label: isArabic ? 'التقويم' : 'Calendar',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.work_outline),
        activeIcon: const Icon(Icons.work_outline),
        label: isArabic ? 'الإنتاجية' : 'Productivity',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.emoji_events),
        activeIcon: const Icon(Icons.emoji_events),
        label: isArabic ? 'الألعاب' : 'Gamification',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.people),
        activeIcon: const Icon(Icons.people),
        label: isArabic ? 'التواصل' : 'Social',
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

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
      height: MediaQuery.of(context).size.height * 0.08, // مرن بدلاً من ثابت 65
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              width:
                  MediaQuery.of(context).size.width *
                  0.2, // مرن بدلاً من ثابت 80
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.bottomNavigationBarTheme.selectedItemColor
                                ?.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Semantics(
                      label: item.label ?? 'Navigation item',
                      child: item.icon,
                    ),
                  ),
                  const const SizedBox(height: 4),
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
