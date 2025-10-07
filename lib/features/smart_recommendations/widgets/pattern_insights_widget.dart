import 'package:flutter/material.dart';
import '../models/habit_recommendation.dart';

class PatternInsightsWidget extends StatelessWidget {

  const PatternInsightsWidget({super.key, required this.patterns});
  final List<UserBehaviorPattern> patterns;

  @override
  Widget build(BuildContext context) {
    if (patterns.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأنماط المكتشفة',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...patterns.map((pattern) => _buildPatternCard(theme, pattern)),
      ],
    );
  }

  Widget _buildPatternCard(ThemeData theme, UserBehaviorPattern pattern) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getPatternIcon(pattern.patternType),
                  color: _getPatternColor(pattern.patternType),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPatternTitle(pattern.patternType),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pattern.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStrengthIndicator(theme, pattern.strength),
              ],
            ),
            const SizedBox(height: 12),
            _buildPatternDetails(theme, pattern),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthIndicator(ThemeData theme, double strength) {
    final percentage = (strength * 100).round();
    final color = _getStrengthColor(strength);

    return Column(
      children: [
        Text(
          '$percentage%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: strength,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatternDetails(ThemeData theme, UserBehaviorPattern pattern) {
    final details = <Widget>[];

    // تفاصيل محددة حسب نوع النمط
    switch (pattern.patternType) {
      case PatternType.consistentTiming:
        final optimalTime = pattern.data['optimalTime'] as String?;
        if (optimalTime != null) {
          details.add(
            _buildDetailItem(
              theme,
              Icons.access_time,
              'الوقت الأمثل',
              optimalTime,
            ),
          );
        }
        break;

      case PatternType.categoryPreference:
        final category = pattern.data['category'] as String?;
        final habitCount = pattern.data['habitCount'] as int?;
        if (category != null && habitCount != null) {
          details.add(
            _buildDetailItem(
              theme,
              Icons.category,
              'فئة مفضلة',
              '$category ($habitCount عادات)',
            ),
          );
        }
        break;

      case PatternType.consecutiveSuccess:
        final streakLength = pattern.data['streakLength'] as int?;
        if (streakLength != null) {
          details.add(
            _buildDetailItem(
              theme,
              Icons.local_fire_department,
              'أطول سلسلة',
              '$streakLength يوم',
            ),
          );
        }
        break;

      case PatternType.dropoffPattern:
        final completionRate = pattern.data['completionRate'] as double?;
        if (completionRate != null) {
          details.add(
            _buildDetailItem(
              theme,
              Icons.trending_down,
              'معدل الإنجاز',
              '${(completionRate * 100).round()}%',
            ),
          );
        }
        break;

      case PatternType.weekdayPreference:
        final preferredDays = pattern.data['preferredDays'] as List<String>?;
        if (preferredDays != null && preferredDays.isNotEmpty) {
          details.add(
            _buildDetailItem(
              theme,
              Icons.calendar_today,
              'الأيام المفضلة',
              preferredDays.join(', '),
            ),
          );
        }
        break;

      case PatternType.recoveryPattern:
        final recoveryTime = pattern.data['recoveryTime'] as int?;
        if (recoveryTime != null) {
          details.add(
            _buildDetailItem(
              theme,
              Icons.refresh,
              'وقت التعافي',
              '$recoveryTime يوم',
            ),
          );
        }
        break;

      case PatternType.seasonalVariation:
        final season = pattern.data['season'] as String?;
        if (season != null) {
          details.add(
            _buildDetailItem(theme, Icons.wb_sunny, 'الموسم المؤثر', season),
          );
        }
        break;
    }

    // إضافة تفاصيل عامة
    details.add(
      _buildDetailItem(
        theme,
        Icons.repeat,
        'التكرار',
        '${pattern.frequency} مرة',
      ),
    );

    if (details.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const Divider(height: 1),
        const SizedBox(height: 8),
        Wrap(spacing: 16, runSpacing: 8, children: details),
      ],
    );
  }

  Widget _buildDetailItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  IconData _getPatternIcon(PatternType type) {
    switch (type) {
      case PatternType.consistentTiming:
        return Icons.schedule;
      case PatternType.weekdayPreference:
        return Icons.calendar_view_week;
      case PatternType.consecutiveSuccess:
        return Icons.local_fire_department;
      case PatternType.dropoffPattern:
        return Icons.trending_down;
      case PatternType.recoveryPattern:
        return Icons.refresh;
      case PatternType.seasonalVariation:
        return Icons.wb_sunny;
      case PatternType.categoryPreference:
        return Icons.category;
    }
  }

  Color _getPatternColor(PatternType type) {
    switch (type) {
      case PatternType.consistentTiming:
        return Colors.blue.shade600;
      case PatternType.weekdayPreference:
        return Colors.green.shade600;
      case PatternType.consecutiveSuccess:
        return Colors.orange.shade600;
      case PatternType.dropoffPattern:
        return Colors.red.shade600;
      case PatternType.recoveryPattern:
        return Colors.teal.shade600;
      case PatternType.seasonalVariation:
        return Colors.yellow.shade700;
      case PatternType.categoryPreference:
        return Colors.purple.shade600;
    }
  }

  String _getPatternTitle(PatternType type) {
    switch (type) {
      case PatternType.consistentTiming:
        return 'نمط وقت ثابت';
      case PatternType.weekdayPreference:
        return 'تفضيل أيام معينة';
      case PatternType.consecutiveSuccess:
        return 'نجاح متتالي';
      case PatternType.dropoffPattern:
        return 'نمط انخفاض الأداء';
      case PatternType.recoveryPattern:
        return 'نمط التعافي';
      case PatternType.seasonalVariation:
        return 'تغيير موسمي';
      case PatternType.categoryPreference:
        return 'تفضيل فئة معينة';
    }
  }

  Color _getStrengthColor(double strength) {
    if (strength >= 0.8) {
      return Colors.green.shade600;
    } else if (strength >= 0.6) {
      return Colors.orange.shade600;
    } else if (strength >= 0.4) {
      return Colors.red.shade600;
    } else {
      return Colors.grey.shade600;
    }
  }
}
