import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شبكة الإنجازات المحسنة
/// TODO: تطوير هذا الويدجت مع البيانات الفعلية
class EnhancedAchievementsGrid extends ConsumerWidget {
  const EnhancedAchievementsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'شبكة الإنجازات المحسنة' : 'Enhanced Achievements Grid',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'قريباً - يتطلب تطوير'
                : 'Coming Soon - Needs Development',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
