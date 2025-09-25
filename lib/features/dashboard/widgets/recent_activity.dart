import 'package:flutter/material.dart';
import '../../../shared/themes/app_theme.dart';
import '../../../shared/localization/app_localizations.dart';

/// ويدجت عرض النشاط الأخير
class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.recentActivity,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: عرض جميع النشاطات
              },
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.lightShadow,
          ),
          child: Column(
            children: [
              ActivityItem(
                title: 'تم إكمال تمرين الصدر',
                subtitle: 'منذ ساعتين',
                icon: Icons.fitness_center,
                color: AppTheme.featureColors['gym']!,
              ),
              const Divider(height: 1),
              ActivityItem(
                title: 'تم تسجيل 50 عقلة',
                subtitle: 'منذ 4 ساعات',
                icon: Icons.wb_sunny,
                color: AppTheme.featureColors['morning']!,
              ),
              const Divider(height: 1),
              ActivityItem(
                title: 'إكمال عادة شرب الماء',
                subtitle: 'منذ 6 ساعات',
                icon: Icons.water_drop,
                color: AppTheme.featureColors['habits']!,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// عنصر نشاط واحد
class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
