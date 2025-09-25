// lib/core/models/habit_extensions.dart
// Extensions للنموذج Habit لإضافة الخصائص المطلوبة للـ AI features

import 'habit.dart';

extension HabitExtensions on Habit {
  // التحقق من إنجاز العادة اليوم
  bool get isCompletedToday {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    return entries.any(
      (entry) =>
          entry.date.isAfter(todayStart.subtract(const Duration(days: 1))) &&
          entry.date.isBefore(todayStart.add(const Duration(days: 1))) &&
          entry.isCompleted,
    );
  }

  // فئة العادة (مشتقة من النوع والاسم)
  String get category {
    // تصنيف بناءً على الاسم أو يمكن إضافة حقل منفصل
    final lowerName = name.toLowerCase();

    if (lowerName.contains('رياضة') ||
        lowerName.contains('تمرين') ||
        lowerName.contains('جري') ||
        lowerName.contains('مشي')) {
      return 'رياضة';
    } else if (lowerName.contains('قراءة') ||
        lowerName.contains('كتاب') ||
        lowerName.contains('دراسة')) {
      return 'تعليم';
    } else if (lowerName.contains('ماء') ||
        lowerName.contains('شرب') ||
        lowerName.contains('صحة')) {
      return 'صحة';
    } else if (lowerName.contains('نوم') || lowerName.contains('استيقاظ')) {
      return 'نوم';
    } else if (lowerName.contains('عمل') || lowerName.contains('مهمة')) {
      return 'عمل';
    } else {
      return 'أخرى';
    }
  }

  // وقت التذكير (افتراضي - يمكن إضافة حقل منفصل لاحقاً)
  DateTime get reminderTime {
    // وقت افتراضي: 9:00 صباحاً
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 9, 0);
  }

  // تكرار العادة (يومي افتراضياً)
  String get frequency {
    return 'يومي';
  }

  // حساب معدل النجاح
  double get successRate {
    if (entries.isEmpty) return 0.0;
    final completedCount = entries.where((entry) => entry.isCompleted).length;
    return (completedCount / entries.length) * 100;
  }

  // الحصول على آخر نشاط
  DateTime? get lastActivity {
    if (entries.isEmpty) return null;
    return entries
        .where((entry) => entry.isCompleted)
        .map((entry) => entry.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  // عدد الأيام منذ آخر نشاط
  int get daysSinceLastActivity {
    final last = lastActivity;
    if (last == null) return -1;
    return DateTime.now().difference(last).inDays;
  }
}
