// lib/features/pomodoro_task_management/widgets/pomodoro_header_widget.dart
// ويدجت رأس شاشة Pomodoro مع المؤقت والإحصائيات

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';
import '../screens/analytics_screen.dart';
import '../screens/pomodoro_settings_screen.dart';
import 'pomodoro_timer_widget.dart';
import 'quick_stats_widget.dart';

/// ويدجت رأس الشاشة الرئيسية لـ Pomodoro
class PomodoroHeaderWidget extends ConsumerWidget {
  const PomodoroHeaderWidget({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider);
    final stats = ref.watch(pomodoroStatsProvider);
    final analysis = ref.watch(productivityAnalysisProvider);

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.easeOutBack,
            ),
          ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.6),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Greeting and Settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'لنبدأ يوماً منتجاً! 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnalyticsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.analytics, color: Colors.white),
                      tooltip: 'الإحصائيات',
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PomodoroSettingsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.settings, color: Colors.white),
                      tooltip: 'الإعدادات',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Active Timer or Quick Stats
            if (activeSession != null)
              PomodoroTimerWidget(session: activeSession)
            else
              QuickStatsWidget(stats: stats, analysis: analysis),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير ☀️';
    } else if (hour < 17) {
      return 'مساء الخير 🌤️';
    } else {
      return 'مساء الخير 🌙';
    }
  }
}
