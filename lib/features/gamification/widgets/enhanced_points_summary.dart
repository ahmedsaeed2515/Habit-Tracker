import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ملخص النقاط المحسن
/// TODO: تطوير هذا الويدجت مع البيانات الفعلية
class EnhancedPointsSummary extends ConsumerWidget {
  const EnhancedPointsSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.star_rounded, size: 48, color: Colors.amber),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'ملخص النقاط المحسن' : 'Enhanced Points Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'قريباً - يتطلب تطوير'
                  : 'Coming Soon - Needs Development',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
