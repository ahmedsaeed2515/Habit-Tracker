// lib/features/voice_commands/services/voice_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/voice_command.dart';

/// خدمة الأوامر الصوتية المتقدمة
class VoiceService {
  factory VoiceService() => _instance;
  VoiceService._internal();
  static final VoiceService _instance = VoiceService._internal();

  late SpeechToText _speechToText;
  late FlutterTts _flutterTts;

  bool _isInitialized = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  // callbacks
  Function(String)? onRecognitionResult;
  Function(String)? onRecognitionError;
  Function()? onListeningStart;
  Function()? onListeningStop;
  Function()? onSpeakingStart;
  Function()? onSpeakingComplete;

  /// تهيئة الخدمة
  Future<bool> initialize() async {
    try {
      if (_isInitialized) return true;

      _speechToText = SpeechToText();
      _flutterTts = FlutterTts();

      // طلب إذن الميكروفون
      final microphonePermission = await Permission.microphone.request();
      if (microphonePermission != PermissionStatus.granted) {
        debugPrint('إذن الميكروفون مرفوض');
        return false;
      }

      // تهيئة التعرف على الكلام
      final speechInitialized = await _speechToText.initialize(
        onError: (error) {
          debugPrint('خطأ في التعرف على الكلام: ${error.errorMsg}');
          onRecognitionError?.call(error.errorMsg);
        },
        onStatus: (status) {
          debugPrint('حالة التعرف على الكلام: $status');
        },
      );

      if (!speechInitialized) {
        debugPrint('فشل في تهيئة التعرف على الكلام');
        return false;
      }

      // تهيئة تحويل النص إلى صوت
      await _setupTts();

      _isInitialized = true;
      debugPrint('✅ تم تهيئة خدمة الأوامر الصوتية بنجاح');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الأوامر الصوتية: $e');
      return false;
    }
  }

  /// إعداد تحويل النص إلى صوت
  Future<void> _setupTts() async {
    try {
      await _flutterTts.setLanguage('ar');
      await _flutterTts.setSpeechRate(0.7);
      await _flutterTts.setVolume(0.8);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        onSpeakingStart?.call();
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        onSpeakingComplete?.call();
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('خطأ TTS: $msg');
      });
    } catch (e) {
      debugPrint('خطأ في إعداد TTS: $e');
    }
  }

  /// بدء الاستماع للأوامر الصوتية
  Future<bool> startListening() async {
    if (!_isInitialized || _isListening) return false;

    try {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onRecognitionResult?.call(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'ar_SA', // العربية السعودية
      );

      _isListening = true;
      onListeningStart?.call();
      return true;
    } catch (e) {
      debugPrint('خطأ في بدء الاستماع: $e');
      return false;
    }
  }

  /// إيقاف الاستماع
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speechToText.stop();
      _isListening = false;
      onListeningStop?.call();
    } catch (e) {
      debugPrint('خطأ في إيقاف الاستماع: $e');
    }
  }

  /// نطق نص
  Future<bool> speak(String text) async {
    if (!_isInitialized || _isSpeaking) return false;

    try {
      await _flutterTts.speak(text);
      return true;
    } catch (e) {
      debugPrint('خطأ في النطق: $e');
      return false;
    }
  }

  /// إيقاف النطق
  Future<void> stopSpeaking() async {
    if (!_isSpeaking) return;

    try {
      await _flutterTts.stop();
      _isSpeaking = false;
    } catch (e) {
      debugPrint('خطأ في إيقاف النطق: $e');
    }
  }

  /// معالجة الأمر الصوتي
  VoiceCommand processVoiceCommand(String recognizedText) {
    final command = VoiceCommand(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalText: recognizedText,
      processedText: _cleanText(recognizedText),
      type: _determineCommandType(recognizedText),
      createdAt: DateTime.now(),
    );

    return _enrichCommand(command);
  }

  /// تنظيف النص المُعرَّف عليه
  String _cleanText(String text) {
    return text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// تحديد نوع الأمر
  VoiceCommandType _determineCommandType(String text) {
    final cleanText = text.toLowerCase();

    // كلمات مفتاحية للعادات
    if (_containsAny(cleanText, ['عادة', 'عادتي', 'أكمل', 'أنهي', 'عمل'])) {
      return VoiceCommandType.habit;
    }

    // كلمات مفتاحية للمهام
    if (_containsAny(cleanText, [
      'مهمة',
      'مهام',
      'واجب',
      'مشروع',
      'أضف مهمة',
    ])) {
      return VoiceCommandType.task;
    }

    // كلمات مفتاحية للتمارين
    if (_containsAny(cleanText, [
      'تمرين',
      'رياضة',
      'جري',
      'مشي',
      'رفع أثقال',
      'يوجا',
    ])) {
      return VoiceCommandType.exercise;
    }

    // كلمات مفتاحية للتنقل
    if (_containsAny(cleanText, [
      'اذهب إلى',
      'انتقل',
      'افتح',
      'أعرض',
      'شاشة',
    ])) {
      return VoiceCommandType.navigation;
    }

    // كلمات مفتاحية للإعدادات
    if (_containsAny(cleanText, ['إعدادات', 'ضبط', 'تغيير', 'خيارات'])) {
      return VoiceCommandType.settings;
    }

    // كلمات مفتاحية للتحليلات
    if (_containsAny(cleanText, [
      'تحليلات',
      'إحصائيات',
      'تقرير',
      'أداء',
      'نتائج',
    ])) {
      return VoiceCommandType.analytics;
    }

    return VoiceCommandType.general;
  }

  /// تحسين معلومات الأمر
  VoiceCommand _enrichCommand(VoiceCommand command) {
    final parameters = <String, dynamic>{};
    var confidence = 0.5;

    switch (command.type) {
      case VoiceCommandType.habit:
        parameters.addAll(_extractHabitParameters(command.processedText));
        confidence = _calculateHabitConfidence(command.processedText);
        break;
      case VoiceCommandType.task:
        parameters.addAll(_extractTaskParameters(command.processedText));
        confidence = _calculateTaskConfidence(command.processedText);
        break;
      case VoiceCommandType.exercise:
        parameters.addAll(_extractExerciseParameters(command.processedText));
        confidence = _calculateExerciseConfidence(command.processedText);
        break;
      case VoiceCommandType.navigation:
        parameters.addAll(_extractNavigationParameters(command.processedText));
        confidence = _calculateNavigationConfidence(command.processedText);
        break;
      default:
        confidence = 0.3;
    }

    return command.copyWith(parameters: parameters, confidence: confidence);
  }

  /// استخراج معاملات العادات
  Map<String, dynamic> _extractHabitParameters(String text) {
    final parameters = <String, dynamic>{};

    // استخراج اسم العادة
    final habitName = _extractHabitName(text);
    if (habitName != null) {
      parameters['habitName'] = habitName;
    }

    // استخراج الإجراء
    if (text.contains('أكمل') || text.contains('أنهي')) {
      parameters['action'] = 'complete';
    } else if (text.contains('أضف')) {
      parameters['action'] = 'add';
    }

    return parameters;
  }

  /// استخراج معاملات المهام
  Map<String, dynamic> _extractTaskParameters(String text) {
    final parameters = <String, dynamic>{};

    if (text.contains('أضف مهمة')) {
      parameters['action'] = 'add';
    } else if (text.contains('أكمل مهمة')) {
      parameters['action'] = 'complete';
    }

    return parameters;
  }

  /// استخراج معاملات التمارين
  Map<String, dynamic> _extractExerciseParameters(String text) {
    final parameters = <String, dynamic>{};

    // استخراج نوع التمرين
    if (text.contains('جري')) parameters['exerciseType'] = 'running';
    if (text.contains('مشي')) parameters['exerciseType'] = 'walking';
    if (text.contains('رفع أثقال')) {
      parameters['exerciseType'] = 'weightlifting';
    }

    return parameters;
  }

  /// استخراج معاملات التنقل
  Map<String, dynamic> _extractNavigationParameters(String text) {
    final parameters = <String, dynamic>{};

    if (text.contains('العادات')) parameters['destination'] = 'habits';
    if (text.contains('المهام')) parameters['destination'] = 'tasks';
    if (text.contains('التمارين')) parameters['destination'] = 'exercises';
    if (text.contains('الإعدادات')) parameters['destination'] = 'settings';
    if (text.contains('التحليلات')) parameters['destination'] = 'analytics';

    return parameters;
  }

  /// استخراج اسم العادة من النص
  String? _extractHabitName(String text) {
    // يمكن تحسينها بنظام NLP أكثر تقدماً
    if (text.contains('عادة ')) {
      final parts = text.split('عادة ');
      if (parts.length > 1) {
        return parts[1].split(' ').first;
      }
    }
    return null;
  }

  /// حساب مستوى الثقة للعادات
  double _calculateHabitConfidence(String text) {
    double confidence = 0.3;

    if (_containsAny(text, ['أكمل', 'أنهي'])) confidence += 0.3;
    if (_containsAny(text, ['عادة', 'عادتي'])) confidence += 0.2;
    if (text.length > 5) confidence += 0.1;

    return confidence.clamp(0.0, 1.0);
  }

  /// حساب مستوى الثقة للمهام
  double _calculateTaskConfidence(String text) {
    double confidence = 0.3;

    if (_containsAny(text, ['مهمة', 'واجب'])) confidence += 0.3;
    if (_containsAny(text, ['أضف', 'أكمل'])) confidence += 0.2;

    return confidence.clamp(0.0, 1.0);
  }

  /// حساب مستوى الثقة للتمارين
  double _calculateExerciseConfidence(String text) {
    double confidence = 0.3;

    if (_containsAny(text, ['تمرين', 'رياضة', 'جري'])) confidence += 0.4;

    return confidence.clamp(0.0, 1.0);
  }

  /// حساب مستوى الثقة للتنقل
  double _calculateNavigationConfidence(String text) {
    double confidence = 0.3;

    if (_containsAny(text, ['اذهب', 'افتح', 'أعرض'])) confidence += 0.3;
    if (_containsAny(text, ['شاشة', 'صفحة'])) confidence += 0.2;

    return confidence.clamp(0.0, 1.0);
  }

  /// تحقق من وجود كلمة واحدة على الأقل من قائمة
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  /// الحصول على قائمة اللغات المدعومة
  Future<List<LocaleName>> getSupportedLocales() async {
    if (!_isInitialized) return [];
    return _speechToText.locales();
  }

  /// الحصول على قائمة أصوات TTS المدعومة
  Future<List<dynamic>> getTtsVoices() async {
    return await _flutterTts.getVoices;
  }

  /// تحديد إعدادات TTS
  Future<void> configureTts({
    double? speechRate,
    double? volume,
    double? pitch,
    String? language,
  }) async {
    if (speechRate != null) await _flutterTts.setSpeechRate(speechRate);
    if (volume != null) await _flutterTts.setVolume(volume);
    if (pitch != null) await _flutterTts.setPitch(pitch);
    if (language != null) await _flutterTts.setLanguage(language);
  }

  /// التحقق من حالة الخدمة
  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isAvailable => _speechToText.isAvailable;

  /// تنظيف الموارد
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    _isInitialized = false;
    _isListening = false;
    _isSpeaking = false;
  }
}
