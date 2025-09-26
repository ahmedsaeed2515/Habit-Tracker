import 'dart:async';
import 'package:flutter/foundation.dart';

/// خدمة تتبع الصحة والراحة أثناء العمل
class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  bool _initialized = false;
  Timer? _reminderTimer;
  DateTime? _lastBreakTime;
  int _eyeRestCount = 0;
  int _hydrationReminderCount = 0;
  int _stretchingReminderCount = 0;

  /// تهيئة خدمة الصحة
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _lastBreakTime = DateTime.now();
      _startHealthReminders();
      
      _initialized = true;
      debugPrint('✅ تم تهيئة خدمة الصحة بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الصحة: $e');
    }
  }

  /// بدء تذكيرات الصحة
  void _startHealthReminders() {
    _reminderTimer = Timer.periodic(const Duration(minutes: 20), (timer) {
      _checkHealthReminders();
    });
  }

  /// فحص وإرسال تذكيرات الصحة
  void _checkHealthReminders() {
    final now = DateTime.now();
    final timeSinceLastBreak = now.difference(_lastBreakTime ?? now);

    // تذكير راحة العين كل 20 دقيقة
    if (timeSinceLastBreak.inMinutes >= 20) {
      _sendEyeRestReminder();
    }

    // تذكير شرب الماء كل 30 دقيقة
    if (timeSinceLastBreak.inMinutes >= 30) {
      _sendHydrationReminder();
    }

    // تذكير التمدد كل 45 دقيقة
    if (timeSinceLastBreak.inMinutes >= 45) {
      _sendStretchingReminder();
    }
  }

  /// تذكير راحة العين
  void _sendEyeRestReminder() {
    _eyeRestCount++;
    debugPrint('👀 تذكير راحة العين: قم بقاعدة 20-20-20');
    
    // يمكن هنا إرسال إشعار فعلي
    _onHealthReminderTriggered(HealthReminderType.eyeRest);
  }

  /// تذكير شرب الماء
  void _sendHydrationReminder() {
    _hydrationReminderCount++;
    debugPrint('💧 تذكير شرب الماء: اشرب كوب ماء');
    
    _onHealthReminderTriggered(HealthReminderType.hydration);
  }

  /// تذكير التمدد
  void _sendStretchingReminder() {
    _stretchingReminderCount++;
    debugPrint('🧘 تذكير التمدد: قم ببعض تمارين التمدد');
    
    _onHealthReminderTriggered(HealthReminderType.stretching);
  }

  /// عند إثارة تذكير صحي
  void _onHealthReminderTriggered(HealthReminderType type) {
    // يمكن هنا إضافة منطق إرسال الإشعارات أو تحديث الواجهة
  }

  /// تسجيل أخذ استراحة
  void recordBreakTaken() {
    _lastBreakTime = DateTime.now();
    debugPrint('✅ تم تسجيل أخذ استراحة');
  }

  /// الحصول على إحصائيات الصحة اليومية
  HealthStats getDailyHealthStats() {
    return HealthStats(
      eyeRestReminders: _eyeRestCount,
      hydrationReminders: _hydrationReminderCount,
      stretchingReminders: _stretchingReminderCount,
      lastBreakTime: _lastBreakTime,
      totalWorkTime: _calculateTotalWorkTime(),
      recommendedBreaks: _calculateRecommendedBreaks(),
    );
  }

  /// حساب إجمالي وقت العمل
  Duration _calculateTotalWorkTime() {
    // هذا placeholder - يجب ربطه بخدمة البومودورو
    return const Duration(hours: 2);
  }

  /// حساب عدد الاستراحات الموصى بها
  int _calculateRecommendedBreaks() {
    final totalWorkTime = _calculateTotalWorkTime();
    return (totalWorkTime.inMinutes / 25).ceil(); // استراحة كل 25 دقيقة
  }

  /// الحصول على اقتراحات صحية
  List<HealthSuggestion> getHealthSuggestions() {
    final suggestions = <HealthSuggestion>[];
    final stats = getDailyHealthStats();
    final now = DateTime.now();

    // اقتراح راحة العين
    if (_lastBreakTime != null) {
      final timeSinceBreak = now.difference(_lastBreakTime!);
      if (timeSinceBreak.inMinutes >= 20) {
        suggestions.add(const HealthSuggestion(
          type: HealthReminderType.eyeRest,
          title: 'راحة العين',
          description: 'حان وقت راحة العين! طبق قاعدة 20-20-20',
          instructions: [
            'انظر بعيداً عن الشاشة',
            'ركز على شيء يبعد 20 قدم (6 أمتار)',
            'استمر لمدة 20 ثانية على الأقل',
            'أرمش عدة مرات لترطيب العين',
          ],
          priority: HealthPriority.high,
        ));
      }
    }

    // اقتراح شرب الماء
    if (stats.hydrationReminders < 3) {
      suggestions.add(const HealthSuggestion(
        type: HealthReminderType.hydration,
        title: 'اشرب الماء',
        description: 'حافظ على ترطيب جسمك أثناء العمل',
        instructions: [
          'اشرب كوب ماء (250 مل)',
          'اشرب ببطء وليس دفعة واحدة',
          'تأكد من أن الماء في درجة حرارة الغرفة',
        ],
        priority: HealthPriority.medium,
      ));
    }

    // اقتراح التمدد
    if (stats.stretchingReminders == 0) {
      suggestions.add(const HealthSuggestion(
        type: HealthReminderType.stretching,
        title: 'تمارين التمدد',
        description: 'قم ببعض التمارين لتحريك جسمك',
        instructions: [
          'قف من مقعدك',
          'مد ذراعيك فوق رأسك',
          'لف كتفيك للخلف والأمام',
          'اثن رقبتك يميناً ويساراً بلطف',
          'قم بتمرين القرفصاء البسيط',
        ],
        priority: HealthPriority.medium,
      ));
    }

    // اقتراح المشي
    if (stats.totalWorkTime.inHours >= 1) {
      suggestions.add(const HealthSuggestion(
        type: HealthReminderType.walking,
        title: 'المشي',
        description: 'امشي قليلاً لتحريك الدورة الدموية',
        instructions: [
          'قف من مقعدك',
          'امشي داخل الغرفة لمدة 2-3 دقائق',
          'أو اخرج للهواء الطلق إذا أمكن',
          'تنفس بعمق أثناء المشي',
        ],
        priority: HealthPriority.low,
      ));
    }

    return suggestions;
  }

  /// تقييم الوضعية أثناء العمل
  PostureAssessment assessPosture() {
    return const PostureAssessment(
      overallScore: 75,
      neckPosition: PostureQuality.good,
      shoulderAlignment: PostureQuality.fair,
      backSupport: PostureQuality.good,
      screenDistance: PostureQuality.excellent,
      suggestions: [
        'تأكد من أن الشاشة على مستوى العين',
        'اجعل قدميك مسطحتين على الأرض',
        'استخدم وسادة دعم أسفل الظهر إذا لزم الأمر',
      ],
    );
  }

  /// حساب مؤشر التعب
  double calculateFatigueIndex() {
    final stats = getDailyHealthStats();
    double fatigueScore = 0.0;

    // العمل لفترات طويلة بدون راحة يزيد التعب
    final workTime = stats.totalWorkTime.inMinutes;
    fatigueScore += (workTime / 60) * 15; // 15 نقطة لكل ساعة

    // قلة الاستراحات تزيد التعب
    final missedBreaks = stats.recommendedBreaks - (stats.eyeRestReminders + stats.stretchingReminders);
    fatigueScore += missedBreaks * 10;

    // العمل المتواصل بدون حركة
    if (_lastBreakTime != null) {
      final timeSinceBreak = DateTime.now().difference(_lastBreakTime!).inMinutes;
      if (timeSinceBreak > 60) {
        fatigueScore += 25; // زيادة كبيرة للعمل أكثر من ساعة متواصلة
      }
    }

    return (fatigueScore / 100).clamp(0.0, 1.0); // تحويل لنسبة من 0-1
  }

  /// إعطاء توصيات مخصصة بناء على حالة المستخدم
  List<String> getPersonalizedRecommendations() {
    final fatigueIndex = calculateFatigueIndex();
    final recommendations = <String>[];

    if (fatigueIndex > 0.7) {
      recommendations.add('مستوى التعب مرتفع - خذ استراحة طويلة (15-30 دقيقة)');
      recommendations.add('تجنب المهام المعقدة في الوقت الحالي');
      recommendations.add('فكر في إنهاء العمل مبكراً اليوم');
    } else if (fatigueIndex > 0.4) {
      recommendations.add('مستوى التعب متوسط - خذ استراحة قصيرة (5-10 دقائق)');
      recommendations.add('اشرب كوب ماء أو مشروب منعش');
      recommendations.add('قم ببعض التمارين البسيطة');
    } else {
      recommendations.add('مستوى الطاقة جيد - استمر في العمل مع استراحات منتظمة');
      recommendations.add('حافظ على هذا الإيقاع الجيد');
    }

    return recommendations;
  }

  /// إيقاف خدمة الصحة
  void dispose() {
    _reminderTimer?.cancel();
    debugPrint('🛑 تم إيقاف خدمة الصحة');
  }
}

/// أنواع التذكيرات الصحية
enum HealthReminderType {
  eyeRest,      // راحة العين
  hydration,    // شرب الماء  
  stretching,   // التمدد
  walking,      // المشي
  posture,      // الوضعية
}

/// أولوية التذكير الصحي
enum HealthPriority {
  low,
  medium,
  high,
  critical,
}

/// جودة الوضعية
enum PostureQuality {
  poor,
  fair,
  good,
  excellent,
}

/// إحصائيات الصحة اليومية
class HealthStats {
  final int eyeRestReminders;
  final int hydrationReminders;
  final int stretchingReminders;
  final DateTime? lastBreakTime;
  final Duration totalWorkTime;
  final int recommendedBreaks;

  const HealthStats({
    required this.eyeRestReminders,
    required this.hydrationReminders,
    required this.stretchingReminders,
    required this.lastBreakTime,
    required this.totalWorkTime,
    required this.recommendedBreaks,
  });

  int get totalReminders => eyeRestReminders + hydrationReminders + stretchingReminders;
  
  double get healthComplianceRate {
    if (recommendedBreaks == 0) return 1.0;
    return (totalReminders / recommendedBreaks).clamp(0.0, 1.0);
  }
}

/// اقتراح صحي
class HealthSuggestion {
  final HealthReminderType type;
  final String title;
  final String description;
  final List<String> instructions;
  final HealthPriority priority;

  const HealthSuggestion({
    required this.type,
    required this.title,
    required this.description,
    required this.instructions,
    required this.priority,
  });
}

/// تقييم الوضعية
class PostureAssessment {
  final double overallScore; // من 0-100
  final PostureQuality neckPosition;
  final PostureQuality shoulderAlignment;
  final PostureQuality backSupport;
  final PostureQuality screenDistance;
  final List<String> suggestions;

  const PostureAssessment({
    required this.overallScore,
    required this.neckPosition,
    required this.shoulderAlignment,
    required this.backSupport,
    required this.screenDistance,
    required this.suggestions,
  });

  String get overallGrade {
    if (overallScore >= 90) return 'ممتاز';
    if (overallScore >= 80) return 'جيد جداً';
    if (overallScore >= 70) return 'جيد';
    if (overallScore >= 60) return 'مقبول';
    return 'يحتاج تحسين';
  }
}