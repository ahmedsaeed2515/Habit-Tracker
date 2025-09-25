import 'package:flutter/material.dart';
import '../../../shared/themes/app_theme.dart';
import '../../../shared/localization/app_localizations.dart';

/// ويدجت الملخص السريع للأنشطة اليومية
class QuickSummary extends StatelessWidget {
  const QuickSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.overview,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'التمارين',
                value: '2/3',
                subtitle: 'مكتملة',
                icon: Icons.fitness_center,
                color: AppTheme.featureColors['gym']!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'العادات',
                value: '4/6',
                subtitle: 'مكتملة',
                icon: Icons.track_changes,
                color: AppTheme.featureColors['habits']!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'المهام',
                value: '7/12',
                subtitle: 'مكتملة',
                icon: Icons.checklist,
                color: AppTheme.featureColors['todo']!,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// بطاقة ملخص للإحصائيات
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(subtitle, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
