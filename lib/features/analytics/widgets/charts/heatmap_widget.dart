// lib/features/analytics/widgets/charts/heatmap_widget.dart
import 'package:flutter/material.dart';

/// ويدجت الخريطة الحرارية لعرض نشاط المستخدم عبر الأيام
class HeatMapWidget extends StatelessWidget {
  final Map<DateTime, double> data;
  final String title;
  final double cellSize;
  final int weeksToShow;

  const HeatMapWidget({
    super.key,
    required this.data,
    required this.title,
    this.cellSize = 12.0,
    this.weeksToShow = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHeatMap(context),
            const SizedBox(height: 12),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatMap(BuildContext context) {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: weeksToShow * 7));

    // بناء قائمة الأيام للعرض
    final days = <DateTime>[];
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    // تجميع الأيام في أسابيع
    final weeks = <List<DateTime>>[];
    for (int i = 0; i < days.length; i += 7) {
      final weekEnd = (i + 7 < days.length) ? i + 7 : days.length;
      weeks.add(days.sublist(i, weekEnd));
    }

    return SizedBox(
      height: 8 * (cellSize + 2), // 7 أيام + header
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أيام الأسبوع (header)
            Row(
              children: [
                SizedBox(width: cellSize + 2), // مساحة فارغة للمحاذاة
                ..._buildDayLabels(),
              ],
            ),
            // الخريطة الحرارية
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أرقام الأشهر
                _buildMonthLabels(weeks.first.first, weeks.last.last),
                // الأسابيع
                ...weeks.map((week) => _buildWeekColumn(week)).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDayLabels() {
    const dayNames = ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'];
    return dayNames
        .map(
          (day) => Container(
            width: cellSize,
            height: cellSize,
            margin: const EdgeInsets.all(1),
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildMonthLabels(DateTime start, DateTime end) {
    return SizedBox(
      width: cellSize + 2,
      child: Column(
        children: List.generate(7, (index) {
          if (index == 0) {
            return Container(
              height: cellSize,
              margin: const EdgeInsets.all(1),
              child: Center(
                child: Text(
                  _getMonthName(start.month),
                  style: const TextStyle(fontSize: 9),
                ),
              ),
            );
          }
          return Container(
            width: cellSize,
            height: cellSize,
            margin: const EdgeInsets.all(1),
          );
        }),
      ),
    );
  }

  Widget _buildWeekColumn(List<DateTime> week) {
    return Column(
      children: [
        // مساحة فارغة لمحاذاة الشهور
        Container(
          width: cellSize,
          height: cellSize,
          margin: const EdgeInsets.all(1),
        ),
        // خلايا الأسبوع
        ...week.map((day) => _buildDayCell(day)).toList(),
        // إضافة خلايا فارغة إذا لم يكن الأسبوع مكتمل
        ...List.generate(
          7 - week.length,
          (index) => Container(
            width: cellSize,
            height: cellSize,
            margin: const EdgeInsets.all(1),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime day) {
    final score = data[DateTime(day.year, day.month, day.day)] ?? 0.0;
    final intensity = (score / 100.0).clamp(0.0, 1.0);

    return Container(
      width: cellSize,
      height: cellSize,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: _getColorForIntensity(intensity),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          // يمكن إضافة وظيفة عرض تفاصيل اليوم
        },
        child: Container(),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('أقل', style: TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          final intensity = index / 4.0;
          return Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: _getColorForIntensity(intensity),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        const Text('أكثر', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getColorForIntensity(double intensity) {
    if (intensity == 0.0) {
      return Colors.grey.shade100;
    }

    const baseColor = Colors.green;
    return Color.lerp(
      baseColor.withOpacity(0.1),
      baseColor.withOpacity(0.9),
      intensity,
    )!;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return monthNames[month - 1].substring(0, 3);
  }
}
