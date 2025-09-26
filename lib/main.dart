// lib/main.dart
// نقطة الدخول الرئيسية للتطبيق

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/database/database_manager.dart';
import 'core/providers/settings_provider.dart';
import 'shared/themes/app_theme.dart';
import 'shared/localization/app_localizations.dart';
import 'features/smart_notifications/services/notification_service.dart';
import 'features/smart_notifications/services/notification_database_service.dart';
import 'features/analytics/services/analytics_service.dart';
import 'features/gamification/services/unified_gamification_service.dart';
import 'app.dart';

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
      title: 'Ultimate Habit & Fitness Tracker',

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

      // الصفحة الرئيسية
      home: const MainAppScreen(),
    );
  }
}

/// شاشة الخطأ البسيطة
class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

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
                onPressed: () {
                  // إعادة تشغيل التطبيق
                  main();
                },
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
    final gamificationService = UnifiedGamificationService();
    await gamificationService.initialize();
    debugPrint('✅ Gamification service initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing gamification service: $e');
  }
}
