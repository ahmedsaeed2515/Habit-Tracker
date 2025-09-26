import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unified_gamification_provider.dart';

/// الملف الأساسي لملخص النقاط - مقسم إلى مكونات صغيرة
class PointsSummary extends ConsumerWidget {
  const PointsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final userDataState = ref.watch(userGameDataProvider);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Text(
              isArabic ? 'ملخص النقاط' : 'Points Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // النقاط الإجمالية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars, color: Colors.amber, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    isArabic ? 'إجمالي النقاط: ' : 'Total Points: ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '${userDataState.totalPoints}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // شبكة النقاط
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                _buildPointCard(
                  context,
                  isArabic ? 'أسبوعي' : 'Weekly',
                  '${userDataState.weeklyPoints}',
                  Icons.calendar_view_week,
                  Colors.blue,
                ),
                _buildPointCard(
                  context,
                  isArabic ? 'شهري' : 'Monthly',
                  '${userDataState.monthlyPoints}',
                  Icons.calendar_view_month,
                  Colors.green,
                ),
                _buildPointCard(
                  context,
                  isArabic ? 'المستوى' : 'Level',
                  '${userDataState.currentLevel}',
                  Icons.trending_up,
                  Colors.purple,
                ),
                _buildPointCard(
                  context,
                  isArabic ? 'الخط' : 'Streak',
                  '${userDataState.currentStreak}',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
