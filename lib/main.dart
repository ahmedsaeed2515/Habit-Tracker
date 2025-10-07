// lib/main.dart
// نقطة الدخول الرئيسية للتطبيق

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/database_manager.dart';
import 'core/providers/settings_provider.dart';
import 'features/accessibility/services/accessibility_service.dart';
import 'features/analytics/services/analytics_service.dart';
import 'features/gamification_system/services/gamification_service.dart';
import 'features/health_integration/services/health_integration_service.dart';
import 'features/intelligent_workout_planner/services/ai_workout_planner_service.dart';
import 'features/offline_mode/services/offline_mode_service.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/smart_calendar/services/smart_calendar_service.dart';
import 'features/smart_notifications/services/notification_database_service.dart';
import 'features/smart_notifications/services/notification_service.dart';
import 'features/widgets_system/services/widgets_system_service.dart';
import 'shared/localization/app_localizations.dart';
import 'shared/themes/app_theme.dart';

Future<void> main() async {
  // التأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // تهيئة قاعدة البيانات المحلية
    await DatabaseManager.initialize();

    // تهيئة نظام الإشعارات الذكية
    await NotificationDatabaseService.initialize();
    final notificationService = NotificationService();
    await notificationService.initialize();

    // تهيئة خدمة التحليلات
    final analyticsService = AnalyticsService();
    await analyticsService.init();

    // تهيئة خدمة الألعاب والتحفيز
    await _initializeGamificationService();

    // تهيئة خدمة التقويم الذكي
    await _initializeSmartCalendar();

    // تهيئة خدمة التخطيط الرياضي الذكي
    await _initializeAIWorkoutPlanner();

    // تهيئة نظام الودجت
    await _initializeWidgetsSystem();

    // تهيئة خدمة التكامل الصحي
    await _initializeHealthIntegration();

    // تهيئة خدمة إمكانية الوصول (Accessiblity)
    try {
      final accessibilityService = AccessibilityService();
      await accessibilityService.initialize();
      debugPrint('✅ Accessibility service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Accessibility service: $e');
    }

    // تهيئة وضع العمل بدون اتصال (Offline Mode)
    try {
      final offlineService = OfflineModeService();
      await offlineService.initialize();
      debugPrint('✅ OfflineMode service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing OfflineMode service: $e');
    }

    // نظام Pomodoro Task Management تم تهيئته مع DatabaseManager

    // تشغيل التطبيق
    runApp(const ProviderScope(child: UltimateHabitTrackerApp()));
  } catch (e) {
    debugPrint('خطأ في تهيئة التطبيق: $e');

    // تشغيل التطبيق مع واجهة خطأ بسيطة
    runApp(
      MaterialApp(
        title: 'Habit Tracker - Error',
        theme: AppTheme.lightTheme,
        home: ErrorScreen(error: e.toString()),
      ),
    );
  }
}

class UltimateHabitTrackerApp extends ConsumerWidget {
  const UltimateHabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة الإعدادات
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Task Meta',

      // تهيئة النظام
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // تهيئة اللغة والترجمة
      locale: Locale(settings.language),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // إعداد اتجاه النص حسب اللغة
      builder: (context, child) {
        final locale = Localizations.localeOf(context);
        final isRTL = locale.languageCode == 'ar';

        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },

      // إزالة بانر التطوير
      debugShowCheckedModeBanner: false,

      // الصفحة الرئيسية - عرض onboarding للمستخدمين الجدد
      home: settings.isFirstTime
          ? const OnboardingScreen()
          : const MainAppScreen(),
    );
  }
}

/// شاشة الخطأ البسيطة
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade600),
              const SizedBox(height: 16),
              Text(
                'تعذر تشغيل التطبيق',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  error,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red.shade800),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: main,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// تهيئة خدمة الألعاب والتحفيز
Future<void> _initializeGamificationService() async {
  try {
    final gamificationService = GamificationService();
    await gamificationService.init();
    debugPrint('✅ Gamification service initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing gamification service: $e');
  }
}

// تهيئة خدمة التقويم الذكي
Future<void> _initializeSmartCalendar() async {
  try {
    final calendarService = SmartCalendarService();
    await calendarService.initialize();
    debugPrint('✅ Smart Calendar service initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing Smart Calendar service: $e');
  }
}

// تهيئة خدمة التخطيط الرياضي الذكي
Future<void> _initializeAIWorkoutPlanner() async {
  try {
    await AIWorkoutPlannerService.initialize();
    debugPrint('✅ AI Workout Planner service initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing AI Workout Planner service: $e');
  }
}

// تهيئة نظام الودجت
Future<void> _initializeWidgetsSystem() async {
  try {
    final widgetsService = WidgetsSystemService();
    // إنشاء ودجت افتراضية إذا لم تكن موجودة
    final existingWidgets = await widgetsService.getAllWidgets();
    if (existingWidgets.isEmpty) {
      await widgetsService.createDefaultWidgets();
    }
    debugPrint('✅ Widgets System service initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing Widgets System service: $e');
  }
}

// تهيئة خدمة التكامل الصحي
Future<void> _initializeHealthIntegration() async {
  try {
    final healthService = HealthIntegrationService();
    await healthService.initialize();
    debugPrint('✅ Health Integration service initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing Health Integration service: $e');
  }
}
