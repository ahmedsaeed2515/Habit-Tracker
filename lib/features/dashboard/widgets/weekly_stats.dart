import 'package:flutter/material.dart';

import '../../../shared/localization/app_localizations.dart';
import '../../../shared/themes/app_theme.dart';

/// ويدجت الإحصائيات الأسبوعية
class WeeklyStats extends StatelessWidget {
  const WeeklyStats({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.thisWeekSummary,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.lightShadow,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeeklyStatItem(
                    title: 'التمارين',
                    value: '8',
                    color: AppTheme.featureColors['gym']!,
                  ),
                  WeeklyStatItem(
                    title: 'العادات',
                    value: '24',
                    color: AppTheme.featureColors['habits']!,
                  ),
                  WeeklyStatItem(
                    title: 'المهام',
                    value: '45',
                    color: AppTheme.featureColors['todo']!,
                  ),
                ],
              ),
              const const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                    const const SizedBox(width: 8),
                    Text(
                      'أداء ممتاز هذا الأسبوع! 🎉',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// عنصر إحصائية أسبوعية واحد
class WeeklyStatItem extends StatelessWidget {

  const WeeklyStatItem({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const const SizedBox(height: 4),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
