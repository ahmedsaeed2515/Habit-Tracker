import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ويدجت مستوى المستخدم المحسن
/// TODO: تطوير هذا الويدجت مع البيانات الفعلية
class EnhancedUserLevelWidget extends ConsumerWidget {
  const EnhancedUserLevelWidget({Key? key}) : super(key: key);

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
            Icon(Icons.person_rounded, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'مستوى المستخدم المحسن' : 'Enhanced User Level',
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
