// lib/features/analytics/widgets/kpi_cards.dart
import 'package:flutter/material.dart';

/// ويدجت بطاقة مؤشر أداء رئيسي
class KpiCard extends StatelessWidget {

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
    this.showTrend = false,
  });
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool showTrend;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              const const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (showTrend && trend != null) ...[
              const const SizedBox(height: 8),
              _buildTrendIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator() {
    if (trend == null) return const SizedBox.shrink();

    final isPositive = trend!.startsWith('+');
    final isNegative = trend!.startsWith('-');

    Color trendColor = Colors.grey;
    IconData trendIcon = Icons.trending_flat;

    if (isPositive) {
      trendColor = Colors.green;
      trendIcon = Icons.trending_up;
    } else if (isNegative) {
      trendColor = Colors.red;
      trendIcon = Icons.trending_down;
    }

    return Row(
      children: [
        Icon(trendIcon, size: 16, color: trendColor),
        const const SizedBox(width: 4),
        Text(
          trend!,
          style: TextStyle(
            fontSize: 12,
            color: trendColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// ويدجت مجموعة مؤشرات الأداء
class KpiCardsGrid extends StatelessWidget {

  const KpiCardsGrid({
    super.key,
    required this.summaryStats,
    this.crossAxisCount = 2,
  });
  final Map<String, dynamic> summaryStats;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final kpis = _buildKpiList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) => kpis[index],
    );
  }

  List<KpiCard> _buildKpiList() {
    return [
      KpiCard(
        title: 'النقاط الإجمالية',
        value: '${(summaryStats['averageScore'] ?? 0.0).toStringAsFixed(1)}%',
        subtitle: 'متوسط الأداء',
        icon: Icons.star,
        color: Colors.amber,
        trend: _calculateTrend(summaryStats['averageScore']),
        showTrend: true,
      ),
      KpiCard(
        title: 'العادات المكتملة',
        value: '${summaryStats['totalHabits'] ?? 0}',
        subtitle: 'إجمالي العادات',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      KpiCard(
        title: 'المهام المنجزة',
        value: '${summaryStats['totalTasks'] ?? 0}',
        subtitle: 'إجمالي المهام',
        icon: Icons.task_alt,
        color: Colors.blue,
      ),
      KpiCard(
        title: 'السلسلة الحالية',
        value: '${summaryStats['currentStreak'] ?? 0}',
        subtitle: 'أيام متتالية',
        icon: Icons.local_fire_department,
        color: Colors.orange,
      ),
      KpiCard(
        title: 'أطول سلسلة',
        value: '${summaryStats['longestStreak'] ?? 0}',
        subtitle: 'أفضل إنجاز',
        icon: Icons.emoji_events,
        color: Colors.purple,
      ),
      KpiCard(
        title: 'أيام النشاط',
        value: '${summaryStats['totalDays'] ?? 0}',
        subtitle: 'أيام مسجلة',
        icon: Icons.calendar_today,
        color: Colors.teal,
      ),
    ];
  }

  String? _calculateTrend(averageScore) {
    if (averageScore == null) return null;

    final score = averageScore as double;

    if (score >= 80) {
      return '+ممتاز';
    } else if (score >= 60) {
      return '+جيد';
    } else if (score >= 40) {
      return '~متوسط';
    } else {
      return '-يحتاج تحسين';
    }
  }
}

/// ويدجت مؤشر دائري للتقدم
class CircularProgressKpi extends StatelessWidget {

  const CircularProgressKpi({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.color,
    this.unit = '%',
  });
  final String title;
  final double value;
  final double maxValue;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final progress = (value / maxValue).clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const const SizedBox(height: 16),
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    strokeWidth: 8,
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).toInt()}$unit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(1)} / ${maxValue.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
