import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// ويدجت عرض الإحصائيات السريعة
class QuickStatsWidget extends ConsumerWidget {

  const QuickStatsWidget({
    super.key,
    required this.stats,
    required this.analysis,
  });
  final PomodoroStats stats;
  final ProductivityAnalysis analysis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إحصائيات اليوم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStreakBadge(),
            ],
          ),
          
          const const SizedBox(height: 16),
          
          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.local_fire_department,
                  value: '${stats.completedSessions}',
                  label: 'جلسات مكتملة',
                  color: Colors.orange,
                ),
              ),
              const const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.timer,
                  value: '${stats.totalFocusTime.inMinutes}',
                  label: 'دقائق تركيز',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          
          const const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.task_alt,
                  value: '${stats.completedTasks}',
                  label: 'مهام مكتملة',
                  color: Colors.green,
                ),
              ),
              const const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.trending_up,
                  value: '${analysis.todayScore.toInt()}%',
                  label: 'نقاط الإنتاجية',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          
          const const SizedBox(height: 16),
          
          // Progress Indicator
          _buildProgressIndicator(),
          
          const const SizedBox(height: 12),
          
          // Quick Actions
          _buildQuickActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildStreakBadge() {
    if (analysis.streak == 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: 16,
          ),
          const const SizedBox(width: 4),
          Text(
            '${analysis.streak} أيام',
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    const targetSessions = 8; // هدف يومي
    final progress = (stats.completedSessions / targetSessions).clamp(0.0, 1.0);
    final remaining = math.max(0, targetSessions - stats.completedSessions);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'التقدم نحو الهدف اليومي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              remaining > 0 ? 'باقي $remaining جلسات' : 'تم تحقيق الهدف! 🎉',
              style: TextStyle(
                color: remaining > 0 ? Colors.white70 : Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              remaining > 0 ? Colors.blue : Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.play_circle_fill,
            label: 'بدء جلسة',
            color: Colors.green,
            onTap: () => _startQuickSession(ref, SessionType.focus),
          ),
        ),
        const const SizedBox(width: 8),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.coffee,
            label: 'استراحة',
            color: Colors.brown,
            onTap: () => _startQuickSession(ref, SessionType.shortBreak),
          ),
        ),
        const const SizedBox(width: 8),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.analytics,
            label: 'التفاصيل',
            color: Colors.blue,
            onTap: () => _navigateToAnalytics(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startQuickSession(WidgetRef ref, SessionType type) {
    ref.read(activeSessionProvider.notifier).startSession(type: type);
  }

  void _navigateToAnalytics(BuildContext context) {
    Navigator.pushNamed(context, '/analytics');
  }
}

/// ويدجت عرض الإحصائيات الأسبوعية المضغوطة
class WeeklyStatsPreview extends ConsumerWidget {
  const WeeklyStatsPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsNotifier = ref.watch(pomodoroStatsProvider.notifier);
    final weeklyStats = statsNotifier.getWeeklyStats();
    
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الأسبوع الحالي',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 20,
              ),
            ],
          ),
          
          const const SizedBox(height: 12),
          
          // Weekly Chart
          SizedBox(
            height: 40,
            child: Row(
              children: weeklyStats.asMap().entries.map((entry) {
                final index = entry.key;
                final stat = entry.value;
                final maxSessions = weeklyStats
                    .map((s) => s.completedSessions)
                    .reduce((a, b) => a > b ? a : b);
                final height = maxSessions > 0 
                    ? (stat.completedSessions / maxSessions) * 30
                    : 0.0;
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: height + 4, // minimum height
                          decoration: BoxDecoration(
                            color: _getDayColor(index, stat.completedSessions > 0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const const SizedBox(height: 4),
                        Text(
                          _getDayName(index),
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const const SizedBox(height: 8),
          
          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeeklySummaryItem(
                'المجموع',
                '${weeklyStats.fold<int>(0, (sum, stat) => sum + stat.completedSessions)}',
                Icons.local_fire_department,
                Colors.orange,
              ),
              _buildWeeklySummaryItem(
                'المتوسط',
                '${(weeklyStats.fold<int>(0, (sum, stat) => sum + stat.completedSessions) / 7).toInt()}',
                Icons.trending_up,
                Colors.blue,
              ),
              _buildWeeklySummaryItem(
                'أفضل يوم',
                '${weeklyStats.map((s) => s.completedSessions).reduce((a, b) => a > b ? a : b)}',
                Icons.star,
                Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getDayColor(int dayIndex, bool hasData) {
    final today = DateTime.now().weekday - 1; // Convert to 0-6
    
    if (dayIndex == today) {
      return hasData ? Colors.blue : Colors.blue.withValues(alpha: 0.3);
    } else if (dayIndex < today) {
      return hasData ? Colors.green : Colors.grey.withValues(alpha: 0.3);
    } else {
      return Colors.grey.withValues(alpha: 0.2);
    }
  }

  String _getDayName(int dayIndex) {
    const days = ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'];
    return days[dayIndex];
  }
}

/// ويدجت عرض نصائح الإنتاجية
class ProductivityTipsWidget extends ConsumerWidget {
  const ProductivityTipsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(smartRecommendationsProvider);
    
    if (recommendations.isEmpty) return const SizedBox.shrink();
    
    final topRecommendation = recommendations.first;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Colors.amber[600],
                size: 20,
              ),
              const const SizedBox(width: 8),
              const Text(
                'نصيحة ذكية',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              _getPriorityBadge(topRecommendation.priority),
            ],
          ),
          
          const const SizedBox(height: 8),
          
          // Title
          Text(
            topRecommendation.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          
          const const SizedBox(height: 4),
          
          // Description
          Text(
            topRecommendation.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          
          const const SizedBox(height: 12),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _applyRecommendation(ref, topRecommendation),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('تطبيق', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const const SizedBox(width: 8),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _dismissRecommendation(ref, topRecommendation),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('إخفاء', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getPriorityBadge(int priority) {
    Color color;
    String text;
    
    if (priority >= 4) {
      color = Colors.red;
      text = 'عالي';
    } else if (priority >= 3) {
      color = Colors.orange;
      text = 'متوسط';
    } else {
      color = Colors.blue;
      text = 'منخفض';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _applyRecommendation(WidgetRef ref, SmartRecommendation recommendation) {
    // تطبيق التوصية حسب النوع
    switch (recommendation.type) {
      case RecommendationType.focusImprovement:
        // تقليل مدة الجلسات
        ref.read(pomodoroSettingsProvider.notifier)
            .updateFocusSession(const Duration(minutes: 20));
        break;
      case RecommendationType.settings:
        // فتح شاشة الإعدادات
        break;
      default:
        break;
    }
  }

  void _dismissRecommendation(WidgetRef ref, SmartRecommendation recommendation) {
    // إخفاء التوصية
    // يمكن حفظ التوصيات المخفية في التخزين المحلي
  }
}