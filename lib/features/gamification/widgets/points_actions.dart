import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ويدجت عمليات النقاط - أزرار وإجراءات متعلقة بالنقاط
class PointsActions extends ConsumerWidget {
  const PointsActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'إجراءات سريعة' : 'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    isArabic ? 'عرض التاريخ' : 'View History',
                    Icons.history,
                    Colors.blue,
                    () => _showPointsHistory(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    isArabic ? 'إعادة تعيين' : 'Reset',
                    Icons.refresh,
                    Colors.orange,
                    () => _showResetDialog(context, ref),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  void _showPointsHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تاريخ النقاط'),
        content: const Text('سيتم إضافة تاريخ النقاط لاحقاً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين النقاط'),
        content: const Text('هل أنت متأكد من إعادة تعيين جميع النقاط؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // TODO: تنفيذ إعادة تعيين النقاط
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة هذه الميزة لاحقاً')),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
