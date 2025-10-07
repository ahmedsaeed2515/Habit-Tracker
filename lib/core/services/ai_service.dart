import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// خدمة الذكاء الاصطناعي للتطبيق
class AIService {
  factory AIService() => _instance;
  AIService._internal();
  static final AIService _instance = AIService._internal();

  bool _initialized = false;
  final math.Random _random = math.Random();

  /// تهيئة خدمة الذكاء الاصطناعي
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // هنا يمكن إضافة تهيئة نماذج الذكاء الاصطناعي
      await Future.delayed(const Duration(milliseconds: 100));
      
      _initialized = true;
      debugPrint('✅ تم تهيئة خدمة الذكاء الاصطناعي بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الذكاء الاصطناعي: $e');
    }
  }

  /// تحليل إنتاجية المستخدم
  Future<ProductivityInsights> analyzeProductivity({
    required int completedSessions,
    required int totalSessions,
    required Duration focusTime,
    required int completedTasks,
    required List<String> tags,
  }) async {
    if (!_initialized) await initialize();

    // محاكاة تحليل الذكاء الاصطناعي
    await Future.delayed(const Duration(milliseconds: 500));

    final completionRate = totalSessions > 0 ? completedSessions / totalSessions : 0.0;
    final focusMinutes = focusTime.inMinutes;

    // حساب نقاط الإنتاجية
    double productivityScore = 0.0;
    productivityScore += completionRate * 40; // معدل الإنجاز (40%)
    productivityScore += (focusMinutes / 120).clamp(0.0, 1.0) * 30; // وقت التركيز (30%)
    productivityScore += (completedTasks * 5).clamp(0.0, 30.0); // المهام المكتملة (30%)

    // توليد اقتراحات
    final suggestions = _generateSuggestions(
      completionRate,
      focusMinutes,
      completedTasks,
      tags,
    );

    return ProductivityInsights(
      productivityScore: productivityScore.clamp(0.0, 100.0),
      completionRate: completionRate * 100,
      focusEfficiency: _calculateFocusEfficiency(focusMinutes, completedSessions),
      suggestions: suggestions,
      strengths: _identifyStrengths(completionRate, focusMinutes, completedTasks),
      improvements: _identifyImprovements(completionRate, focusMinutes, completedTasks),
    );
  }

  /// تقدير الوقت اللازم للمهام
  Future<Duration> estimateTaskDuration({
    required String title,
    required String? description,
    required List<String> tags,
    List<TaskData> historicalTasks = const [],
  }) async {
    if (!_initialized) await initialize();

    await Future.delayed(const Duration(milliseconds: 200));

    // تحليل المهام المماثلة
    final similarTasks = _findSimilarTasks(title, description, tags, historicalTasks);
    
    if (similarTasks.isNotEmpty) {
      final avgDuration = _calculateAverageDuration(similarTasks);
      return Duration(minutes: (avgDuration.inMinutes * (0.8 + _random.nextDouble() * 0.4)).round());
    }

    // تقدير افتراضي بناء على طول العنوان والوصف
    final baseMinutes = _estimateFromText(title, description);
    
    // تعديل بناء على التاقات
    final tagMultiplier = _getTagMultiplier(tags);
    
    final estimatedMinutes = (baseMinutes * tagMultiplier).round();
    return Duration(minutes: estimatedMinutes.clamp(15, 240)); // بين 15 دقيقة و4 ساعات
  }

  /// تحليل أنماط الإنتاجية
  Future<ProductivityPatterns> analyzePatterns({
    required List<SessionData> sessions,
    required List<TaskData> tasks,
  }) async {
    if (!_initialized) await initialize();

    await Future.delayed(const Duration(milliseconds: 300));

    final bestTimeOfDay = _findBestTimeOfDay(sessions);
    final mostProductiveDays = _findMostProductiveDays(sessions);
    final optimalSessionLength = _findOptimalSessionLength(sessions);
    final productiveTags = _findMostProductiveTags(tasks);

    return ProductivityPatterns(
      bestTimeOfDay: bestTimeOfDay,
      mostProductiveDays: mostProductiveDays,
      optimalSessionLength: optimalSessionLength,
      productiveTags: productiveTags,
      focusStreaks: _analyzeFocusStreaks(sessions),
      breakPatterns: _analyzeBreakPatterns(sessions),
    );
  }

  /// توليد اقتراحات ذكية للمهام
  List<String> _generateSuggestions(
    double completionRate,
    int focusMinutes,
    int completedTasks,
    List<String> tags,
  ) {
    final suggestions = <String>[];

    if (completionRate < 0.7) {
      suggestions.add('جرب تقصير مدة الجلسات إلى 20 دقيقة لزيادة معدل الإنجاز');
    }

    if (focusMinutes < 60) {
      suggestions.add('حاول زيادة وقت التركيز اليومي إلى ساعة على الأقل');
    }

    if (completedTasks < 3) {
      suggestions.add('قسم المهام الكبيرة إلى مهام أصغر لزيادة الشعور بالإنجاز');
    }

    if (tags.contains('صعب')) {
      suggestions.add('ابدأ بالمهام الصعبة في بداية اليوم عندما تكون طاقتك في أعلى مستوياتها');
    }

    // إضافة اقتراحات عشوائية مفيدة
    final randomSuggestions = [
      'خذ استراحة قصيرة كل 25 دقيقة للحفاظ على التركيز',
      'تأكد من شرب كمية كافية من الماء أثناء العمل',
      'استخدم موسيقى التركيز أو الضوضاء البيضاء',
      'تجنب استخدام الهاتف أثناء جلسات التركيز',
      'حضر قائمة مهامك في الليلة السابقة',
    ];
    
    suggestions.add(randomSuggestions[_random.nextInt(randomSuggestions.length)]);

    return suggestions;
  }

  double _calculateFocusEfficiency(int focusMinutes, int completedSessions) {
    if (completedSessions == 0) return 0.0;
    final avgFocusPerSession = focusMinutes / completedSessions;
    return (avgFocusPerSession / 25).clamp(0.0, 2.0) * 50; // نورماليز لنسبة مئوية
  }

  List<String> _identifyStrengths(double completionRate, int focusMinutes, int completedTasks) {
    final strengths = <String>[];

    if (completionRate >= 0.8) {
      strengths.add('معدل إنجاز عالي للجلسات');
    }

    if (focusMinutes >= 120) {
      strengths.add('وقت تركيز يومي ممتاز');
    }

    if (completedTasks >= 5) {
      strengths.add('إنجاز عدد جيد من المهام');
    }

    if (strengths.isEmpty) {
      strengths.add('مواظبة على استخدام النظام');
    }

    return strengths;
  }

  List<String> _identifyImprovements(double completionRate, int focusMinutes, int completedTasks) {
    final improvements = <String>[];

    if (completionRate < 0.6) {
      improvements.add('تحسين معدل إكمال الجلسات');
    }

    if (focusMinutes < 60) {
      improvements.add('زيادة الوقت اليومي للتركيز');
    }

    if (completedTasks < 3) {
      improvements.add('زيادة عدد المهام المكتملة يومياً');
    }

    return improvements;
  }

  List<TaskData> _findSimilarTasks(
    String title,
    String? description,
    List<String> tags,
    List<TaskData> historicalTasks,
  ) {
    return historicalTasks.where((task) {
      // تشابه في التاقات
      final commonTags = task.tags.where((tag) => tags.contains(tag)).length;
      if (commonTags > 0) return true;

      // تشابه في الكلمات المفتاحية
      final titleWords = title.toLowerCase().split(' ');
      final taskTitleWords = task.title.toLowerCase().split(' ');
      final commonWords = titleWords.where(taskTitleWords.contains).length;
      
      return commonWords >= 2;
    }).toList();
  }

  Duration _calculateAverageDuration(List<TaskData> tasks) {
    if (tasks.isEmpty) return const Duration(minutes: 25);
    
    final totalMinutes = tasks.fold<int>(0, (sum, task) => sum + task.actualDuration.inMinutes);
    return Duration(minutes: totalMinutes ~/ tasks.length);
  }

  int _estimateFromText(String title, String? description) {
    final titleLength = title.length;
    final descLength = description?.length ?? 0;
    
    // تقدير أساسي: كلمة واحدة = دقيقة واحدة تقريباً
    final baseMinutes = (titleLength / 6).round() + (descLength / 50).round();
    
    return (baseMinutes + 20).clamp(25, 60); // إضافة 20 دقيقة أساسية
  }

  double _getTagMultiplier(List<String> tags) {
    double multiplier = 1.0;
    
    if (tags.contains('سهل')) multiplier *= 0.8;
    if (tags.contains('صعب')) multiplier *= 1.5;
    if (tags.contains('عاجل')) multiplier *= 0.9; // المهام العاجلة عادة أسرع
    if (tags.contains('بحث')) multiplier *= 1.8;
    if (tags.contains('كتابة')) multiplier *= 1.4;
    
    return multiplier;
  }

  TimeOfDay _findBestTimeOfDay(List<SessionData> sessions) {
    // تحليل الجلسات لإيجاد أفضل وقت في اليوم
    final hourlyScores = <int, double>{};
    
    for (final session in sessions) {
      final hour = session.startTime.hour;
      final score = session.isCompleted ? 1.0 : 0.5;
      hourlyScores[hour] = (hourlyScores[hour] ?? 0.0) + score;
    }
    
    if (hourlyScores.isEmpty) return const TimeOfDay(hour: 9, minute: 0);
    
    final bestHour = hourlyScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return TimeOfDay(hour: bestHour, minute: 0);
  }

  List<String> _findMostProductiveDays(List<SessionData> sessions) {
    final dayNames = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    final dayScores = <int, double>{};
    
    for (final session in sessions) {
      final dayOfWeek = session.startTime.weekday;
      final score = session.isCompleted ? 1.0 : 0.5;
      dayScores[dayOfWeek] = (dayScores[dayOfWeek] ?? 0.0) + score;
    }
    
    final sortedDays = dayScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedDays.take(3).map((e) => dayNames[e.key - 1]).toList();
  }

  Duration _findOptimalSessionLength(List<SessionData> sessions) {
    // تحليل طول الجلسات الأكثر نجاحاً
    final completedSessions = sessions.where((s) => s.isCompleted).toList();
    
    if (completedSessions.isEmpty) return const Duration(minutes: 25);
    
    final totalMinutes = completedSessions.fold<int>(
      0, 
      (sum, session) => sum + session.duration.inMinutes,
    );
    
    final avgMinutes = totalMinutes ~/ completedSessions.length;
    return Duration(minutes: avgMinutes);
  }

  List<String> _findMostProductiveTags(List<TaskData> tasks) {
    final tagScores = <String, double>{};
    
    for (final task in tasks) {
      final score = task.isCompleted ? 1.0 : 0.0;
      for (final tag in task.tags) {
        tagScores[tag] = (tagScores[tag] ?? 0.0) + score;
      }
    }
    
    final sortedTags = tagScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedTags.take(5).map((e) => e.key).toList();
  }

  List<int> _analyzeFocusStreaks(List<SessionData> sessions) {
    // تحليل سلاسل التركيز
    final streaks = <int>[];
    int currentStreak = 0;
    
    for (final session in sessions) {
      if (session.isCompleted) {
        currentStreak++;
      } else {
        if (currentStreak > 0) {
          streaks.add(currentStreak);
          currentStreak = 0;
        }
      }
    }
    
    if (currentStreak > 0) streaks.add(currentStreak);
    
    return streaks;
  }

  Map<String, int> _analyzeBreakPatterns(List<SessionData> sessions) {
    // تحليل أنماط الاستراحة
    final breakTypes = <String, int>{};
    
    for (final session in sessions) {
      if (session.type == 'break') {
        final duration = session.duration.inMinutes;
        String breakType;
        
        if (duration <= 5) {
          breakType = 'استراحة قصيرة';
        } else if (duration <= 15) {
          breakType = 'استراحة متوسطة';
        } else {
          breakType = 'استراحة طويلة';
        }
        
        breakTypes[breakType] = (breakTypes[breakType] ?? 0) + 1;
      }
    }
    
    return breakTypes;
  }
}

/// بيانات جلسة العمل
class SessionData {

  const SessionData({
    required this.startTime,
    required this.duration,
    required this.isCompleted,
    required this.type,
  });
  final DateTime startTime;
  final Duration duration;
  final bool isCompleted;
  final String type;
}

/// بيانات المهمة
class TaskData {

  const TaskData({
    required this.title,
    this.description,
    required this.tags,
    required this.actualDuration,
    required this.isCompleted,
  });
  final String title;
  final String? description;
  final List<String> tags;
  final Duration actualDuration;
  final bool isCompleted;
}

/// رؤى الإنتاجية
class ProductivityInsights {

  const ProductivityInsights({
    required this.productivityScore,
    required this.completionRate,
    required this.focusEfficiency,
    required this.suggestions,
    required this.strengths,
    required this.improvements,
  });
  final double productivityScore;
  final double completionRate;
  final double focusEfficiency;
  final List<String> suggestions;
  final List<String> strengths;
  final List<String> improvements;
}

/// أنماط الإنتاجية
class ProductivityPatterns {

  const ProductivityPatterns({
    required this.bestTimeOfDay,
    required this.mostProductiveDays,
    required this.optimalSessionLength,
    required this.productiveTags,
    required this.focusStreaks,
    required this.breakPatterns,
  });
  final TimeOfDay bestTimeOfDay;
  final List<String> mostProductiveDays;
  final Duration optimalSessionLength;
  final List<String> productiveTags;
  final List<int> focusStreaks;
  final Map<String, int> breakPatterns;
}