// lib/features/voice_commands/services/command_processor.dart
import 'package:flutter/material.dart';
import '../models/voice_command.dart';
import '../../../core/models/habit.dart';
import '../../../core/models/task.dart';

/// معالج الأوامر الصوتية
class CommandProcessor {
  static final CommandProcessor _instance = CommandProcessor._internal();
  factory CommandProcessor() => _instance;
  CommandProcessor._internal();

  /// معالجة الأمر الصوتي وتنفيذه
  Future<VoiceCommand> processCommand(VoiceCommand command) async {
    try {
      command = command.copyWith(
        status: CommandStatus.processing,
        executedAt: DateTime.now(),
      );

      String response = '';
      bool success = false;

      switch (command.type) {
        case VoiceCommandType.habit:
          response = await _processHabitCommand(command);
          success = true;
          break;
        case VoiceCommandType.task:
          response = await _processTaskCommand(command);
          success = true;
          break;
        case VoiceCommandType.exercise:
          response = await _processExerciseCommand(command);
          success = true;
          break;
        case VoiceCommandType.navigation:
          response = await _processNavigationCommand(command);
          success = true;
          break;
        case VoiceCommandType.settings:
          response = await _processSettingsCommand(command);
          success = true;
          break;
        case VoiceCommandType.analytics:
          response = await _processAnalyticsCommand(command);
          success = true;
          break;
        case VoiceCommandType.general:
          response = await _processGeneralCommand(command);
          success = true;
          break;
      }

      return command.copyWith(
        status: success ? CommandStatus.completed : CommandStatus.failed,
        response: response,
        executedAt: DateTime.now(),
      );
    } catch (e) {
      return command.copyWith(
        status: CommandStatus.failed,
        response: 'فشل في تنفيذ الأمر',
        errorMessage: e.toString(),
        executedAt: DateTime.now(),
      );
    }
  }

  /// معالجة أوامر العادات
  Future<String> _processHabitCommand(VoiceCommand command) async {
    final action = command.parameters['action'] as String?;
    final habitName = command.parameters['habitName'] as String?;

    switch (action) {
      case 'complete':
        if (habitName != null) {
          // البحث عن العادة وتعيينها كمكتملة
          return 'تم تعيين عادة "$habitName" كمكتملة';
        }
        return 'تم تعيين العادة كمكتملة';

      case 'add':
        return 'تم إضافة عادة جديدة';

      default:
        return 'تم تنفيذ أمر العادة';
    }
  }

  /// معالجة أوامر المهام
  Future<String> _processTaskCommand(VoiceCommand command) async {
    final action = command.parameters['action'] as String?;

    switch (action) {
      case 'add':
        return 'تم إضافة مهمة جديدة';

      case 'complete':
        return 'تم تعيين المهمة كمكتملة';

      default:
        return 'تم تنفيذ أمر المهمة';
    }
  }

  /// معالجة أوامر التمارين
  Future<String> _processExerciseCommand(VoiceCommand command) async {
    final exerciseType = command.parameters['exerciseType'] as String?;

    if (exerciseType != null) {
      switch (exerciseType) {
        case 'running':
          return 'تم تسجيل تمرين الجري';
        case 'walking':
          return 'تم تسجيل تمرين المشي';
        case 'weightlifting':
          return 'تم تسجيل تمرين رفع الأثقال';
        default:
          return 'تم تسجيل التمرين';
      }
    }

    return 'تم تسجيل نشاط رياضي';
  }

  /// معالجة أوامر التنقل
  Future<String> _processNavigationCommand(VoiceCommand command) async {
    final destination = command.parameters['destination'] as String?;

    if (destination != null) {
      // هنا يمكن إضافة منطق التنقل الفعلي
      switch (destination) {
        case 'habits':
          return 'انتقال إلى شاشة العادات';
        case 'tasks':
          return 'انتقال إلى شاشة المهام';
        case 'exercises':
          return 'انتقال إلى شاشة التمارين';
        case 'settings':
          return 'انتقال إلى شاشة الإعدادات';
        case 'analytics':
          return 'انتقال إلى شاشة التحليلات';
        default:
          return 'انتقال إلى الشاشة المطلوبة';
      }
    }

    return 'تم تنفيذ أمر التنقل';
  }

  /// معالجة أوامر الإعدادات
  Future<String> _processSettingsCommand(VoiceCommand command) async {
    return 'تم الانتقال إلى الإعدادات';
  }

  /// معالجة أوامر التحليلات
  Future<String> _processAnalyticsCommand(VoiceCommand command) async {
    return 'تم عرض التحليلات والإحصائيات';
  }

  /// معالجة الأوامر العامة
  Future<String> _processGeneralCommand(VoiceCommand command) async {
    final text = command.processedText.toLowerCase();

    // أوامر المساعدة
    if (_containsAny(text, ['مساعدة', 'ساعدني', 'كيف'])) {
      return _getHelpResponse();
    }

    // أوامر التحية
    if (_containsAny(text, ['مرحبا', 'السلام عليكم', 'أهلا'])) {
      return 'مرحباً بك! كيف يمكنني مساعدتك اليوم؟';
    }

    // أوامر الوقت
    if (_containsAny(text, ['الوقت', 'الساعة'])) {
      final now = DateTime.now();
      return 'الوقت الحالي هو ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    }

    // الرد الافتراضي
    return 'عذراً، لم أفهم طلبك. يمكنك قول "مساعدة" لمعرفة الأوامر المتاحة';
  }

  /// الحصول على رد المساعدة
  String _getHelpResponse() {
    return '''
الأوامر المتاحة:

📋 العادات:
• "أكمل عادة القراءة"
• "أضف عادة جديدة"

✅ المهام:
• "أضف مهمة"
• "أكمل المهمة"

🏃‍♂️ التمارين:
• "سجل تمرين جري"
• "أضف تمرين يوجا"

🧭 التنقل:
• "اذهب إلى العادات"
• "افتح شاشة المهام"

قل "مرحبا" للترحيب أو "الوقت" لمعرفة الوقت الحالي.
    ''';
  }

  /// تحقق من وجود كلمة واحدة على الأقل من قائمة
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  /// تسجيل الأمر في السجل
  void logCommand(VoiceCommand command) {
    debugPrint(
      'تم تنفيذ الأمر: ${command.originalText} -> ${command.response}',
    );
  }

  /// إنتاج أوامر مقترحة بناءً على السياق
  List<String> getSuggestedCommands(BuildContext context) {
    return [
      'أكمل عادة القراءة',
      'أضف مهمة جديدة',
      'سجل تمرين جري',
      'اذهب إلى التحليلات',
      'أعرض الإعدادات',
      'ما الوقت الحالي؟',
    ];
  }

  /// تحليل نمط استخدام الأوامر
  Map<VoiceCommandType, int> analyzeUsagePattern(List<VoiceCommand> commands) {
    final usage = <VoiceCommandType, int>{};

    for (final command in commands) {
      usage[command.type] = (usage[command.type] ?? 0) + 1;
    }

    return usage;
  }

  /// الحصول على الأوامر الأكثر استخداماً
  List<VoiceCommand> getMostUsedCommands(
    List<VoiceCommand> commands, {
    int limit = 5,
  }) {
    final successfulCommands = commands
        .where((cmd) => cmd.status == CommandStatus.completed)
        .toList();

    // ترتيب حسب التكرار
    final commandCounts = <String, int>{};
    for (final command in successfulCommands) {
      commandCounts[command.processedText] =
          (commandCounts[command.processedText] ?? 0) + 1;
    }

    final sortedCommands = successfulCommands.toSet().toList()
      ..sort(
        (a, b) => (commandCounts[b.processedText] ?? 0).compareTo(
          commandCounts[a.processedText] ?? 0,
        ),
      );

    return sortedCommands.take(limit).toList();
  }
}
