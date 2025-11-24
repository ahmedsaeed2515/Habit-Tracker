// lib/features/daily_habits/widgets/habit_card.dart
// بطاقة عرض العادة اليومية

import 'package:flutter/material.dart';

import '../../../core/models/habit.dart';

/// بطاقة لعرض العادة اليومية مع جميع المعلومات والخيارات
class HabitCard extends StatelessWidget {

  const HabitCard({
    super.key,
    required this.habit,
    this.onCompleted,
    this.onEdit,
    this.onDelete,
  });
  /// العادة اليومية المراد عرضها
  final Habit habit;

  /// دالة استدعاء عند إكمال العادة
  final VoidCallback? onCompleted;

  /// دالة استدعاء عند تعديل العادة
  final VoidCallback? onEdit;

  /// دالة استدعاء عند حذف العادة
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: IntrinsicHeight(
        child: Column(
          children: [
            _buildHabitHeader(),
            _buildHabitContent(),
            _buildHabitFooter(),
          ],
        ),
      ),
    );
  }

  /// بناء رأس البطاقة مع حالة العادة
  Widget _buildHabitHeader() {
    final todayProgress = habit.getTodayProgress();
    final isCompleted = todayProgress >= 100.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isCompleted ? Colors.green : Colors.orange,
            child: Text(habit.icon, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (habit.description.isNotEmpty)
                  Text(
                    habit.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          _buildStatusBadge(isCompleted, todayProgress),
        ],
      ),
    );
  }

  /// بناء محتوى البطاقة مع معلومات العادة
  Widget _buildHabitContent() {
    final todayProgress = habit.getTodayProgress();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (habit.description.isNotEmpty) ...[
            Text(
              habit.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
          ],
          _buildProgressBar(todayProgress),
          const SizedBox(height: 12),
          _buildHabitStats(),
        ],
      ),
    );
  }

  /// بناء شريط التقدم
  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم اليومي',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '${progress.toInt()}%',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 100 ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  /// بناء إحصائيات العادة
  Widget _buildHabitStats() {
    return Row(
      children: [
        _buildStatChip(
          Icons.trending_up,
          'السلسلة',
          '${habit.currentStreak} أيام',
          Colors.blue,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          Icons.star,
          'أطول سلسلة',
          '${habit.longestStreak} أيام',
          Colors.purple,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          Icons.timeline,
          'المعدل',
          '${habit.getWeeklyCompletionRate().toInt()}%',
          Colors.green,
        ),
      ],
    );
  }

  /// بناء رقاقة الإحصائية
  Widget _buildStatChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 8),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء ذيل البطاقة مع الأزرار
  Widget _buildHabitFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildActionButtons(), _buildTimeInfo()],
      ),
    );
  }

  /// بناء أزرار الإجراءات
  Widget _buildActionButtons() {
    final todayProgress = habit.getTodayProgress();
    final isCompleted = todayProgress >= 100.0;

    return Row(
      children: [
        if (!isCompleted && onCompleted != null)
          _buildActionButton(
            Icons.check_circle_outline,
            'إكمال',
            Colors.green,
            onCompleted!,
          ),
        if (onEdit != null) ...[
          const SizedBox(width: 8),
          _buildActionButton(
            Icons.edit_outlined,
            'تعديل',
            Colors.blue,
            onEdit!,
          ),
        ],
        if (onDelete != null) ...[
          const SizedBox(width: 8),
          _buildActionButton(
            Icons.delete_outline,
            'حذف',
            Colors.red,
            onDelete!,
          ),
        ],
      ],
    );
  }

  /// بناء زر إجراء صغير
  Widget _buildActionButton(
    IconData icon,
    String tooltip,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  /// بناء معلومات الوقت
  Widget _buildTimeInfo() {
    final now = DateTime.now();
    return Text(
      '${now.day}/${now.month}/${now.year}',
      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
    );
  }

  /// بناء شارة الحالة
  Widget _buildStatusBadge(bool isCompleted, double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isCompleted ? 'مكتمل' : '${progress.toInt()}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
