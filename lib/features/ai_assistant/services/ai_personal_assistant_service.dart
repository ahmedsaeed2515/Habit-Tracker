import 'dart:math';
import '../models/ai_message.dart';
import '../../../core/models/habit.dart';
import '../../../core/models/habit_extensions.dart';

class AIPersonalAssistantService {
  static final AIPersonalAssistantService _instance =
      AIPersonalAssistantService._internal();
  factory AIPersonalAssistantService() => _instance;
  AIPersonalAssistantService._internal();

  final List<String> _motivationalQuotes = [
    "النجاح هو مجموع الجهود الصغيرة المتكررة يوماً بعد يوم",
    "العادات الجيدة هي مفتاح النجاح في الحياة",
    "كل يوم جديد هو فرصة لتصبح نسخة أفضل من نفسك",
    "الثبات على العادات الإيجابية يبني شخصية قوية",
    "التقدم الصغير المستمر أفضل من الانطلاقة الكبيرة المتقطعة",
  ];

  final List<String> _habitTips = [
    "ابدأ بعادة صغيرة واحدة فقط",
    "اربط العادة الجديدة بعادة موجودة",
    "استخدم تذكيرات بصرية",
    "احتفل بالإنجازات الصغيرة",
    "كن صبوراً - تحتاج العادة 66 يوماً لتصبح تلقائية",
  ];

  // تحليل سلوك المستخدم وتقديم رؤى ذكية
  AIMessage analyzeUserBehavior(
    List<Habit> habits,
    AIPersonalityProfile profile,
  ) {
    final completedHabits = habits.where((h) => h.isCompletedToday).length;
    final totalHabits = habits.length;
    final completionRate = totalHabits > 0
        ? completedHabits / totalHabits
        : 0.0;

    String insight;
    AIMessageType messageType;

    if (completionRate >= 0.8) {
      insight = _generateCelebrationMessage(completionRate, profile);
      messageType = AIMessageType.celebration;
    } else if (completionRate >= 0.5) {
      insight = _generateMotivationalMessage(completionRate, profile);
      messageType = AIMessageType.motivational;
    } else if (completionRate >= 0.2) {
      insight = _generateSuggestionMessage(habits, profile);
      messageType = AIMessageType.suggestion;
    } else {
      insight = _generateWarningMessage(profile);
      messageType = AIMessageType.warning;
    }

    return AIMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: insight,
      isFromUser: false,
      timestamp: DateTime.now(),
      type: messageType,
      confidence: _calculateConfidence(completionRate),
      metadata: {
        'completionRate': completionRate,
        'totalHabits': totalHabits,
        'completedHabits': completedHabits,
      },
    );
  }

  // توليد اقتراحات ذكية للعادات
  List<AIMessage> generateSmartHabitSuggestions(
    List<Habit> currentHabits,
    AIPersonalityProfile profile,
  ) {
    final suggestions = <AIMessage>[];
    final existingCategories = currentHabits.map((h) => h.category).toSet();

    // اقتراحات مبنية على الشخصية
    final personalitySuggestions = _getPersonalityBasedSuggestions(
      profile.personalityType,
      existingCategories,
    );

    for (final suggestion in personalitySuggestions) {
      suggestions.add(
        AIMessage(
          id:
              DateTime.now().millisecondsSinceEpoch.toString() +
              suggestions.length.toString(),
          content: suggestion,
          isFromUser: false,
          timestamp: DateTime.now(),
          type: AIMessageType.suggestion,
          confidence: 0.8,
          metadata: {
            'suggestionType': 'personality_based',
            'personalityType': profile.personalityType.name,
          },
        ),
      );
    }

    // اقتراحات للفجوات في العادات
    final gapSuggestions = _identifyHabitGaps(existingCategories);
    for (final suggestion in gapSuggestions) {
      suggestions.add(
        AIMessage(
          id:
              DateTime.now().millisecondsSinceEpoch.toString() +
              suggestions.length.toString(),
          content: suggestion,
          isFromUser: false,
          timestamp: DateTime.now(),
          type: AIMessageType.suggestion,
          confidence: 0.7,
          metadata: {'suggestionType': 'gap_analysis'},
        ),
      );
    }

    return suggestions.take(3).toList(); // أفضل 3 اقتراحات
  }

  // معالجة استفسارات المستخدم
  AIMessage processUserQuery(
    String query,
    List<Habit> habits,
    AIPersonalityProfile profile,
  ) {
    final lowercaseQuery = query.toLowerCase();

    String response;
    AIMessageType messageType = AIMessageType.text;

    if (lowercaseQuery.contains('نصيحة') || lowercaseQuery.contains('tip')) {
      response = _getRandomTip();
      messageType = AIMessageType.suggestion;
    } else if (lowercaseQuery.contains('تحفيز') ||
        lowercaseQuery.contains('motivation')) {
      response = _getMotivationalQuote();
      messageType = AIMessageType.motivational;
    } else if (lowercaseQuery.contains('إحصائيات') ||
        lowercaseQuery.contains('stats')) {
      response = _generateStatsResponse(habits);
      messageType = AIMessageType.insight;
    } else if (lowercaseQuery.contains('مساعدة') ||
        lowercaseQuery.contains('help')) {
      response = _getHelpResponse();
      messageType = AIMessageType.text;
    } else {
      response = _generateContextualResponse(query, habits, profile);
      messageType = AIMessageType.text;
    }

    return AIMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response,
      isFromUser: false,
      timestamp: DateTime.now(),
      type: messageType,
      confidence: 0.9,
    );
  }

  // رسائل مخصصة حسب الوقت
  AIMessage generateTimeBasedMessage(AIPersonalityProfile profile) {
    final hour = DateTime.now().hour;
    String message;
    AIMessageType messageType = AIMessageType.motivational;

    if (hour >= 5 && hour < 12) {
      message = _getMorningMessage(profile);
    } else if (hour >= 12 && hour < 17) {
      message = _getAfternoonMessage(profile);
    } else if (hour >= 17 && hour < 21) {
      message = _getEveningMessage(profile);
    } else {
      message = _getNightMessage(profile);
    }

    return AIMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isFromUser: false,
      timestamp: DateTime.now(),
      type: messageType,
      confidence: 0.8,
    );
  }

  // Helper Methods
  String _generateCelebrationMessage(
    double rate,
    AIPersonalityProfile profile,
  ) {
    final percentage = (rate * 100).round();
    return "🎉 رائع! لقد أكملت $percentage% من عاداتك اليوم! استمر على هذا الأداء المميز!";
  }

  String _generateMotivationalMessage(
    double rate,
    AIPersonalityProfile profile,
  ) {
    final percentage = (rate * 100).round();
    return "💪 أداء جيد! $percentage% من عاداتك مكتملة. يمكنك تحقيق المزيد!";
  }

  String _generateSuggestionMessage(
    List<Habit> habits,
    AIPersonalityProfile profile,
  ) {
    final incompleteHabits = habits.where((h) => !h.isCompletedToday).toList();
    if (incompleteHabits.isNotEmpty) {
      final habit = incompleteHabits.first;
      return "💡 لديك عادة '${habit.name}' لم تكتمل بعد. ما رأيك في إنجازها الآن؟";
    }
    return "🎯 حاول التركيز على عادة واحدة في كل مرة لتحقيق أفضل النتائج.";
  }

  String _generateWarningMessage(AIPersonalityProfile profile) {
    return "⚠️ يبدو أنك لم تنجز الكثير من عاداتك اليوم. تذكر أن الخطوات الصغيرة تؤدي إلى تغييرات كبيرة!";
  }

  double _calculateConfidence(double completionRate) {
    return (0.5 + (completionRate * 0.5)).clamp(0.0, 1.0);
  }

  List<String> _getPersonalityBasedSuggestions(
    PersonalityType type,
    Set<String> existingCategories,
  ) {
    switch (type) {
      case PersonalityType.achiever:
        return [
          "جرب إضافة عادة تحدي يومي لتحفيز روح الإنجاز لديك",
          "ما رأيك في تتبع هدف أسبوعي جديد؟",
        ];
      case PersonalityType.explorer:
        return [
          "اكتشف عادة جديدة كل أسبوع لإشباع فضولك",
          "جرب تعلم مهارة جديدة لمدة 15 دقيقة يومياً",
        ];
      case PersonalityType.socializer:
        return [
          "فكر في إضافة عادة اجتماعية مثل الاتصال بصديق يومياً",
          "ما رأيك في الانضمام لمجموعة تشارك نفس أهدافك؟",
        ];
      case PersonalityType.competitor:
        return [
          "أنشئ تحدي مع نفسك أو الأصدقاء",
          "حدد هدف يومي قابل للقياس والمنافسة",
        ];
      case PersonalityType.perfectionist:
        return [
          "ركز على إتقان عادة واحدة قبل إضافة أخرى",
          "اعتمد نظام تقييم جودة الأداء وليس فقط الإنجاز",
        ];
      case PersonalityType.balanced:
        return [
          "حافظ على التوازن بين العادات الصحية والمهنية والشخصية",
          "جرب دمج عادات متعددة في روتين واحد",
        ];
    }
  }

  List<String> _identifyHabitGaps(Set<String> existingCategories) {
    final suggestions = <String>[];

    if (!existingCategories.contains('صحة')) {
      suggestions.add(
        "لاحظت أنك لا تتبع عادات صحية. ما رأيك في إضافة عادة رياضية؟",
      );
    }

    if (!existingCategories.contains('تعلم')) {
      suggestions.add("التعلم المستمر مهم! فكر في إضافة عادة تعليمية جديدة.");
    }

    if (!existingCategories.contains('عمل')) {
      suggestions.add("عادات العمل تحسن الإنتاجية. جرب إضافة عادة مهنية.");
    }

    return suggestions;
  }

  String _getRandomTip() {
    final random = Random();
    return "💡 نصيحة: ${_habitTips[random.nextInt(_habitTips.length)]}";
  }

  String _getMotivationalQuote() {
    final random = Random();
    return "✨ ${_motivationalQuotes[random.nextInt(_motivationalQuotes.length)]}";
  }

  String _generateStatsResponse(List<Habit> habits) {
    final total = habits.length;
    final completed = habits.where((h) => h.isCompletedToday).length;
    final rate = total > 0 ? (completed / total * 100).round() : 0;

    return "📊 إحصائياتك اليوم:\n• إجمالي العادات: $total\n• المكتملة: $completed\n• معدل الإنجاز: $rate%";
  }

  String _getHelpResponse() {
    return "🤖 مرحباً! أنا مساعدك الذكي. يمكنني مساعدتك في:\n• تحليل أدائك\n• تقديم نصائح للعادات\n• التحفيز والتشجيع\n• الإجابة على استفساراتك\n\nما الذي تحتاج مساعدة فيه؟";
  }

  String _generateContextualResponse(
    String query,
    List<Habit> habits,
    AIPersonalityProfile profile,
  ) {
    return "أفهم استفسارك. بناءً على عاداتك الحالية وشخصيتك، أنصحك بالتركيز على التقدم التدريجي. هل تريد اقتراحات محددة؟";
  }

  String _getMorningMessage(AIPersonalityProfile profile) {
    return "🌅 صباح الخير! يوم جديد مليء بالفرص. استعد لتحقيق أهدافك!";
  }

  String _getAfternoonMessage(AIPersonalityProfile profile) {
    return "☀️ كيف يسير يومك؟ لا تنس مراجعة تقدمك في العادات!";
  }

  String _getEveningMessage(AIPersonalityProfile profile) {
    return "🌆 وقت المراجعة! كيف كان أداؤك في العادات اليوم؟";
  }

  String _getNightMessage(AIPersonalityProfile profile) {
    return "🌙 وقت الراحة. تذكر أن النوم الجيد عادة مهمة أيضاً!";
  }
}
