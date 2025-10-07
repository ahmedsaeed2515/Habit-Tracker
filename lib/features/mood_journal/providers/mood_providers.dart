// lib/features/mood_journal/providers/mood_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../data/mood_repository.dart';
import '../models/mood_models.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  final repo = MoodRepository();
  return repo;
});

final moodInitProvider = FutureProvider<void>((ref) async {
  await ref.read(moodRepositoryProvider).init();
});

final todayMoodProvider = FutureProvider<MoodEntry?>((ref) async {
  await ref.watch(moodInitProvider.future);
  return ref.read(moodRepositoryProvider).getMoodByDate(DateTime.now());
});

final todayJournalProvider = FutureProvider<JournalEntry?>((ref) async {
  await ref.watch(moodInitProvider.future);
  return ref.read(moodRepositoryProvider).getJournalByDate(DateTime.now());
});

final moodRangeProvider = FutureProvider.family<List<MoodEntry>, DateTimeRange?>(
  (ref, range) async {
    await ref.watch(moodInitProvider.future);
    if (range == null) {
      return [];
    }
    return ref
        .read(moodRepositoryProvider)
        .getMoodRange(range.start, range.end);
  },
);

final latestAnalyticsProvider = FutureProvider<MoodAnalytics?>((ref) async {
  await ref.watch(moodInitProvider.future);
  // لا نحتفظ بكل الأناليتكس الآن، نأخذ آخر واحد فقط
  // الوصول المباشر للصندوق غير مكشوف هنا، يمكن تحسينه لاحقاً
  return null;
});
