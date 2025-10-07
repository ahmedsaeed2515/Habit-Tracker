import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unified_gamification_provider.dart';

/// ويدجت الإحصائيات المتقدمة للنقاط - ملف منفصل للصيانة
class PointsStatistics extends ConsumerWidget {
  const PointsStatistics({super.key});

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
              isArabic ? 'إحصائيات متقدمة' : 'Advanced Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // تقدم المستوى
            _buildProgressSection(context, userDataState, isArabic),

            const SizedBox(height: 16),

            // إحصائيات إضافية
            _buildAdditionalStats(context, userDataState, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    userDataState,
    bool isArabic,
  ) {
    final progress = userDataState.levelProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'تقدم المستوى الحالي' : 'Current Level Progress',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}% مكتمل',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAdditionalStats(
    BuildContext context,
    userDataState,
    bool isArabic,
  ) {
    return Column(
      children: [
        _buildStatRow(
          context,
          isArabic ? 'أطول خط' : 'Longest Streak',
          '${userDataState.longestStreak}',
          Icons.whatshot,
          Colors.red,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          context,
          isArabic ? 'للمستوى التالي' : 'To Next Level',
          '${userDataState.pointsNeededForNextLevel}',
          Icons.flag,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
