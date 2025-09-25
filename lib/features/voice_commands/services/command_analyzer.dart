// lib/features/voice_commands/services/command_analyzer.dart
import '../models/voice_command.dart';

/// محلل الأوامر الصوتية
class CommandAnalyzer {
  static final CommandAnalyzer _instance = CommandAnalyzer._internal();
  factory CommandAnalyzer() => _instance;
  CommandAnalyzer._internal();

  /// كلمات مفتاحية للعادات
  final _habitKeywords = [
    'عادة',
    'عادات',
    'habit',
    'habits',
    'أكمل',
    'انتهيت',
    'تم',
    'مكتمل',
    'بدء',
    'ابدأ',
    'start',
    'begin',
    'تمرين',
    'رياضة',
    'exercise',
    'قراءة',
    'كتاب',
    'reading',
    'book',
    'صلاة',
    'prayer',
    'meditation',
  ];

  /// كلمات مفتاحية للمهام
  final _taskKeywords = [
    'مهمة',
    'مهام',
    'task',
    'tasks',
    'عمل',
    'job',
    'work',
    'اجتماع',
    'meeting',
    'موعد',
    'appointment',
    'مكالمة',
    'call',
    'مراجعة',
    'review',
  ];

  /// كلمات مفتاحية للتمارين
  final _exerciseKeywords = [
    'تمرين',
    'تمارين',
    'exercise',
    'exercises',
    'رياضة',
    'sport',
    'fitness',
    'جري',
    'running',
    'جيم',
    'gym',
    'يوغا',
    'yoga',
    'سباحة',
    'swimming',
    'مشي',
    'walking',
    'دراجة',
    'cycling',
  ];

  /// كلمات مفتاحية للتنقل
  final _navigationKeywords = [
    'اذهب',
    'go',
    'انتقل',
    'navigate',
    'صفحة',
    'page',
    'شاشة',
    'screen',
    'العادات',
    'habits',
    'المهام',
    'tasks',
    'الإعدادات',
    'settings',
    'التحليلات',
    'analytics',
    'الرئيسية',
    'home',
    'main',
  ];

  /// تحليل النص وتحديد نوع الأمر
  CommandAnalysisResult analyzeCommand(String text) {
    final cleanText = text.toLowerCase().trim();

    // تحليل درجة الثقة
    double confidence = _calculateConfidence(cleanText);

    // تحديد نوع الأمر
    VoiceCommandType type = _determineCommandType(cleanText);

    // استخراج المعاملات
    Map<String, dynamic> parameters = _extractParameters(cleanText, type);

    return CommandAnalysisResult(
      type: type,
      confidence: confidence,
      parameters: parameters,
      processedText: _cleanAndProcessText(text),
    );
  }

  /// تحديد نوع الأمر بناءً على الكلمات المفتاحية
  VoiceCommandType _determineCommandType(String text) {
    int habitScore = _calculateKeywordScore(text, _habitKeywords);
    int taskScore = _calculateKeywordScore(text, _taskKeywords);
    int exerciseScore = _calculateKeywordScore(text, _exerciseKeywords);
    int navigationScore = _calculateKeywordScore(text, _navigationKeywords);

    // العثور على أعلى نقاط
    Map<VoiceCommandType, int> scores = {
      VoiceCommandType.habit: habitScore,
      VoiceCommandType.task: taskScore,
      VoiceCommandType.exercise: exerciseScore,
      VoiceCommandType.navigation: navigationScore,
    };

    final maxScore = scores.values.reduce((a, b) => a > b ? a : b);
    if (maxScore > 0) {
      return scores.entries.where((entry) => entry.value == maxScore).first.key;
    }

    return VoiceCommandType.general;
  }

  /// حساب نقاط الكلمات المفتاحية
  int _calculateKeywordScore(String text, List<String> keywords) {
    int score = 0;
    for (String keyword in keywords) {
      if (text.contains(keyword.toLowerCase())) {
        score++;
      }
    }
    return score;
  }

  /// حساب درجة الثقة
  double _calculateConfidence(String text) {
    if (text.isEmpty) return 0.0;

    double baseConfidence = 0.5;

    // زيادة الثقة بناءً على طول النص
    if (text.length > 10) baseConfidence += 0.1;
    if (text.length > 20) baseConfidence += 0.1;

    // زيادة الثقة بناءً على وجود كلمات مفتاحية
    int totalKeywords =
        _calculateKeywordScore(text, _habitKeywords) +
        _calculateKeywordScore(text, _taskKeywords) +
        _calculateKeywordScore(text, _exerciseKeywords) +
        _calculateKeywordScore(text, _navigationKeywords);

    baseConfidence += totalKeywords * 0.1;

    return baseConfidence.clamp(0.0, 1.0);
  }

  /// استخراج المعاملات من النص
  Map<String, dynamic> _extractParameters(String text, VoiceCommandType type) {
    Map<String, dynamic> parameters = {};

    switch (type) {
      case VoiceCommandType.habit:
        parameters['habitName'] = _extractHabitName(text);
        parameters['action'] = _extractHabitAction(text);
        break;
      case VoiceCommandType.task:
        parameters['taskName'] = _extractTaskName(text);
        parameters['action'] = _extractTaskAction(text);
        break;
      case VoiceCommandType.navigation:
        parameters['destination'] = _extractNavigationDestination(text);
        break;
      case VoiceCommandType.exercise:
        parameters['exerciseType'] = _extractExerciseType(text);
        parameters['duration'] = _extractDuration(text);
        break;
      default:
        break;
    }

    return parameters;
  }

  /// استخراج اسم العادة
  String? _extractHabitName(String text) {
    // تنفيذ منطق استخراج اسم العادة
    RegExp habitPattern = RegExp(r'عادة\s+(.+?)(?:\s|$)', caseSensitive: false);
    Match? match = habitPattern.firstMatch(text);
    return match?.group(1)?.trim();
  }

  /// استخراج إجراء العادة
  String? _extractHabitAction(String text) {
    if (text.contains('أكمل') ||
        text.contains('تم') ||
        text.contains('انتهيت')) {
      return 'complete';
    } else if (text.contains('بدء') || text.contains('ابدأ')) {
      return 'start';
    } else if (text.contains('إيقاف') || text.contains('توقف')) {
      return 'pause';
    }
    return 'view';
  }

  /// استخراج اسم المهمة
  String? _extractTaskName(String text) {
    RegExp taskPattern = RegExp(r'مهمة\s+(.+?)(?:\s|$)', caseSensitive: false);
    Match? match = taskPattern.firstMatch(text);
    return match?.group(1)?.trim();
  }

  /// استخراج إجراء المهمة
  String? _extractTaskAction(String text) {
    if (text.contains('أكمل') || text.contains('تم')) {
      return 'complete';
    } else if (text.contains('أضف') || text.contains('أنشئ')) {
      return 'create';
    } else if (text.contains('احذف') || text.contains('امسح')) {
      return 'delete';
    }
    return 'view';
  }

  /// استخراج وجهة التنقل
  String? _extractNavigationDestination(String text) {
    if (text.contains('العادات') || text.contains('habits')) return 'habits';
    if (text.contains('المهام') || text.contains('tasks')) return 'tasks';
    if (text.contains('الإعدادات') || text.contains('settings'))
      return 'settings';
    if (text.contains('التحليلات') || text.contains('analytics'))
      return 'analytics';
    if (text.contains('الرئيسية') || text.contains('home')) return 'home';
    return null;
  }

  /// استخراج نوع التمرين
  String? _extractExerciseType(String text) {
    if (text.contains('جري') || text.contains('running')) return 'running';
    if (text.contains('مشي') || text.contains('walking')) return 'walking';
    if (text.contains('يوغا') || text.contains('yoga')) return 'yoga';
    if (text.contains('سباحة') || text.contains('swimming')) return 'swimming';
    return 'general';
  }

  /// استخراج المدة
  int? _extractDuration(String text) {
    RegExp durationPattern = RegExp(
      r'(\d+)\s*(?:دقيقة|دقائق|minutes?)',
      caseSensitive: false,
    );
    Match? match = durationPattern.firstMatch(text);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  /// تنظيف ومعالجة النص
  String _cleanAndProcessText(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]', unicode: true), '');
  }
}

/// نتيجة تحليل الأمر
class CommandAnalysisResult {
  final VoiceCommandType type;
  final double confidence;
  final Map<String, dynamic> parameters;
  final String processedText;

  CommandAnalysisResult({
    required this.type,
    required this.confidence,
    required this.parameters,
    required this.processedText,
  });
}
