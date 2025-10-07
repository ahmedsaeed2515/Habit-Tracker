// lib/features/mood_journal/data/mood_repository.dart
import 'package:hive/hive.dart';
import '../models/mood_models.dart';

class MoodRepository {
  static const String moodBoxName = 'mood_entries_box';
  static const String journalBoxName = 'journal_entries_box';
  static const String analyticsBoxName = 'mood_analytics_box';

  Box<MoodEntry>? _moodBox;
  Box<JournalEntry>? _journalBox;
  Box<MoodAnalytics>? _analyticsBox;

  Future<void> init() async {
    _moodBox ??= await Hive.openBox<MoodEntry>(moodBoxName);
    _journalBox ??= await Hive.openBox<JournalEntry>(journalBoxName);
    _analyticsBox ??= await Hive.openBox<MoodAnalytics>(analyticsBoxName);
  }

  Future<List<MoodEntry>> getMoodRange(DateTime start, DateTime end) async {
    return _moodBox!.values
        .where((m) => !m.date.isBefore(start) && !m.date.isAfter(end))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> addMood(MoodEntry entry) async => _moodBox!.put(entry.id, entry);
  Future<void> addJournal(JournalEntry entry) async =>
      _journalBox!.put(entry.id, entry);
  Future<void> updateJournal(JournalEntry entry) async => entry.save();

  Future<JournalEntry?> getJournalByDate(DateTime date) async {
    final sameDay = _journalBox!.values.where(
      (j) =>
          j.date.year == date.year &&
          j.date.month == date.month &&
          j.date.day == date.day,
    );
    return sameDay.isEmpty ? null : sameDay.first;
  }

  Future<MoodEntry?> getMoodByDate(DateTime date) async {
    final sameDay = _moodBox!.values.where(
      (m) =>
          m.date.year == date.year &&
          m.date.month == date.month &&
          m.date.day == date.day,
    );
    return sameDay.isEmpty ? null : sameDay.first;
  }

  Future<void> generateAnalytics() async {
    final moods = _moodBox!.values.toList();
    if (moods.isEmpty) return;
    final tagFreq = <String, int>{};
    final distribution = <int, int>{};
    for (final m in moods) {
      distribution[m.moodLevel] = (distribution[m.moodLevel] ?? 0) + 1;
      for (final t in m.tags) {
        tagFreq[t] = (tagFreq[t] ?? 0) + 1;
      }
    }
    final totalTags = tagFreq.values.fold<int>(0, (p, c) => p + c);
    final tagPercent = <String, double>{
      for (final e in tagFreq.entries) e.key: (e.value / totalTags) * 100,
    };
    final analytics = MoodAnalytics(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      generatedAt: DateTime.now(),
      tagFrequency: tagPercent,
      moodDistribution: distribution,
      improvementSuggestions: _basicSuggestions(distribution),
    );
    await _analyticsBox!.put(analytics.id, analytics);
  }

  List<String> _basicSuggestions(Map<int, int> distribution) {
    final avgMood =
        distribution.entries.fold<double>(0, (p, e) => p + (e.key * e.value)) /
        (distribution.values.fold<int>(0, (p, c) => p + c));
    final suggestions = <String>[];
    if (avgMood < 5) {
      suggestions.add('حاول ممارسة التأمل أو المشي الخفيف لتحسين المزاج.');
    } else if (avgMood < 7) {
      suggestions.add('حافظ على عاداتك الجيدة ودوّن ما يرفع مزاجك.');
    } else {
      suggestions.add('مزاج ممتاز! استمر وشارك نجاحاتك في اليوميات.');
    }
    return suggestions;
  }
}
