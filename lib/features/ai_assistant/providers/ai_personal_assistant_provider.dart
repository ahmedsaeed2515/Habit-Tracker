import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_message.dart';
import '../services/ai_personal_assistant_service.dart';
import '../../../core/providers/habits_provider.dart';

final aiPersonalAssistantProvider =
    StateNotifierProvider<
      AIPersonalAssistantNotifier,
      AIPersonalAssistantState
    >((ref) {
      return AIPersonalAssistantNotifier(ref);
    });

class AIPersonalAssistantState {
  final List<AIMessage> messages;
  final AIPersonalityProfile? userProfile;
  final bool isTyping;
  final bool isLoading;
  final String? error;

  const AIPersonalAssistantState({
    this.messages = const [],
    this.userProfile,
    this.isTyping = false,
    this.isLoading = false,
    this.error,
  });

  AIPersonalAssistantState copyWith({
    List<AIMessage>? messages,
    AIPersonalityProfile? userProfile,
    bool? isTyping,
    bool? isLoading,
    String? error,
  }) {
    return AIPersonalAssistantState(
      messages: messages ?? this.messages,
      userProfile: userProfile ?? this.userProfile,
      isTyping: isTyping ?? this.isTyping,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AIPersonalAssistantNotifier
    extends StateNotifier<AIPersonalAssistantState> {
  AIPersonalAssistantNotifier(this._ref)
    : super(const AIPersonalAssistantState()) {
    _init();
  }

  final Ref _ref;
  final AIPersonalAssistantService _service = AIPersonalAssistantService();

  void _init() {
    // تحميل الرسائل والملف الشخصي المحفوظ
    _loadMessages();
    _loadUserProfile();

    // إرسال رسالة ترحيب
    _sendWelcomeMessage();
  }

  void _loadMessages() {
    // TODO: تحميل الرسائل من Hive
    state = state.copyWith(isLoading: false);
  }

  void _loadUserProfile() {
    // TODO: تحميل الملف الشخصي من Hive
    // إذا لم يوجد ملف، إنشاء ملف افتراضي
    if (state.userProfile == null) {
      final defaultProfile = _createDefaultProfile();
      state = state.copyWith(userProfile: defaultProfile);
    }
  }

  AIPersonalityProfile _createDefaultProfile() {
    return AIPersonalityProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'المستخدم',
      personalityType: PersonalityType.balanced,
      traits: {
        'organized': 0.5,
        'social': 0.5,
        'ambitious': 0.5,
        'flexible': 0.5,
        'detail_oriented': 0.5,
      },
      preferredMotivationMethods: ['تشجيع', 'تحدي', 'مكافآت'],
      interests: ['صحة', 'تعلم', 'عمل'],
      communicationStyle: 'ودود ومحفز',
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  void _sendWelcomeMessage() {
    final welcomeMessage = AIMessage(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      content:
          '👋 مرحباً! أنا مساعدك الذكي لتتبع العادات. أنا هنا لمساعدتك في تحقيق أهدافك وتقديم النصائح المخصصة لك. كيف يمكنني مساعدتك اليوم؟',
      isFromUser: false,
      timestamp: DateTime.now(),
      type: AIMessageType.text,
      confidence: 1.0,
    );

    state = state.copyWith(messages: [welcomeMessage, ...state.messages]);
  }

  // إرسال رسالة من المستخدم
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // إضافة رسالة المستخدم
    final userMessage = AIMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      isFromUser: true,
      timestamp: DateTime.now(),
      type: AIMessageType.text,
    );

    state = state.copyWith(
      messages: [userMessage, ...state.messages],
      isTyping: true,
    );

    // معالجة الرسالة وإنشاء رد
    await _processUserMessage(content);
  }

  Future<void> _processUserMessage(String content) async {
    try {
      // تأخير صغير لمحاكاة الكتابة
      await Future.delayed(const Duration(seconds: 2));

      final habits = _ref.read(habitsProvider);
      final response = _service.processUserQuery(
        content,
        habits,
        state.userProfile!,
      );

      state = state.copyWith(
        messages: [response, ...state.messages],
        isTyping: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'حدث خطأ في معالجة الرسالة',
        isTyping: false,
      );
    }
  }

  // تحليل سلوك المستخدم وإرسال رؤى
  void analyzeUserBehavior() {
    final habits = _ref.read(habitsProvider);
    final insight = _service.analyzeUserBehavior(habits, state.userProfile!);

    state = state.copyWith(messages: [insight, ...state.messages]);
  }

  // إرسال اقتراحات ذكية
  void generateSmartSuggestions() {
    final habits = _ref.read(habitsProvider);
    final suggestions = _service.generateSmartHabitSuggestions(
      habits,
      state.userProfile!,
    );

    // إضافة الاقتراحات بتأخير صغير بينها
    for (int i = 0; i < suggestions.length; i++) {
      Future.delayed(Duration(milliseconds: 500 * i), () {
        if (mounted) {
          state = state.copyWith(messages: [suggestions[i], ...state.messages]);
        }
      });
    }
  }

  // إرسال رسالة مبنية على الوقت
  void sendTimeBasedMessage() {
    final message = _service.generateTimeBasedMessage(state.userProfile!);
    state = state.copyWith(messages: [message, ...state.messages]);
  }

  // تحديث الملف الشخصي
  void updateUserProfile(AIPersonalityProfile newProfile) {
    state = state.copyWith(userProfile: newProfile);
    // TODO: حفظ في Hive
  }

  // حذف رسالة
  void deleteMessage(String messageId) {
    final updatedMessages = state.messages
        .where((m) => m.id != messageId)
        .toList();
    state = state.copyWith(messages: updatedMessages);
  }

  // مسح جميع الرسائل
  void clearMessages() {
    state = state.copyWith(messages: []);
    _sendWelcomeMessage();
  }

  // إرسال نصيحة عشوائية
  void sendRandomTip() {
    final habits = _ref.read(habitsProvider);
    final tipMessage = _service.processUserQuery(
      'نصيحة',
      habits,
      state.userProfile!,
    );

    state = state.copyWith(messages: [tipMessage, ...state.messages]);
  }

  // إرسال اقتباس تحفيزي
  void sendMotivationalQuote() {
    final habits = _ref.read(habitsProvider);
    final quoteMessage = _service.processUserQuery(
      'تحفيز',
      habits,
      state.userProfile!,
    );

    state = state.copyWith(messages: [quoteMessage, ...state.messages]);
  }

  // إرسال إحصائيات
  void sendStats() {
    final habits = _ref.read(habitsProvider);
    final statsMessage = _service.processUserQuery(
      'إحصائيات',
      habits,
      state.userProfile!,
    );

    state = state.copyWith(messages: [statsMessage, ...state.messages]);
  }

  // إزالة رسائل الخطأ
  void clearError() {
    state = state.copyWith(error: null);
  }
}
