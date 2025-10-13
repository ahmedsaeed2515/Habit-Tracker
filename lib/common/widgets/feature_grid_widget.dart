// lib/common/widgets/feature_grid_widget.dart
// ويدجت شبكة الميزات القابلة لإعادة الاستخدام

import 'package:flutter/material.dart';

/// نموذج عنصر الميزة
class FeatureItem {
  const FeatureItem({
    required this.title,
    required this.titleAr,
    required this.icon,
    required this.route,
    this.iconColor,
    this.gradientColors,
  });

  final String title;
  final String titleAr;
  final IconData icon;
  final String route;
  final Color? iconColor;
  final List<Color>? gradientColors;
}

/// ويدجت شبكة الميزات
class FeatureGridWidget extends StatelessWidget {
  const FeatureGridWidget({
    super.key,
    required this.items,
    required this.onItemTap,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
    this.spacing = 16.0,
  });

  final List<FeatureItem> items;
  final Function(String route) onItemTap;
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _FeatureCard(
          item: items[index],
          onTap: () => onItemTap(items[index].route),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا توجد نتائج' : 'No results found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة الميزة
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.item,
    required this.onTap,
  });

  final FeatureItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // تحديد ألوان التدرج
    final gradientColors = item.gradientColors ??
        [
          colorScheme.primaryContainer,
          colorScheme.primaryContainer.withOpacity(0.7),
        ];

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 32,
                  color: item.iconColor ?? colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  isArabic ? item.titleAr : item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
