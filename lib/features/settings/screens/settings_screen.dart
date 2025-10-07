import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/settings.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/localization/app_localizations.dart';
import '../../ai_assistant/screens/ai_personal_assistant_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../habit_builder/screens/habit_builder_screen.dart';
import '../../smart_notifications/screens/notifications_screen.dart';
import '../../smart_recommendations/screens/smart_recommendations_screen.dart';
import '../../voice_commands/screens/voice_commands_screen.dart';
import '../widgets/widgets.dart';

/// شاشة الإعدادات الرئيسية
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          localizations.settings,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.8),
              theme.colorScheme.secondary.withValues(alpha: 0.6),
              theme.colorScheme.tertiary.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          children: [
            // الإعدادات العامة
            SectionHeader(title: localizations.generalSettings),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SettingsTile(
                title: localizations.language,
                subtitle: settings.language == 'ar' ? 'العربية' : 'English',
                leading: const Icon(Icons.language),
                onTap: () => _showLanguageDialog(context),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: SettingsTile(
                title: localizations.theme,
                subtitle: settings.isDarkMode
                    ? localizations.darkTheme
                    : localizations.lightTheme,
                leading: Icon(
                  settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                trailing: Switch(
                  value: settings.isDarkMode,
                  onChanged: (value) => settingsNotifier.toggleDarkMode(),
                ),
              ),
            ),

            // الإشعارات الذكية
            const SectionHeader(title: 'الإشعارات الذكية'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: SettingsTile(
                title: 'إدارة الإشعارات',
                subtitle: 'إعدادات الإشعارات الذكية والتذكيرات',
                leading: const Icon(Icons.smart_toy),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                ),
              ),
            ),

            // التحليلات المتقدمة
            const SectionHeader(title: 'التحليلات والإحصائيات'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SettingsTile(
                title: 'التحليلات المتقدمة',
                subtitle: 'رسوم بيانية ورؤى ذكية لأدائك',
                leading: const Icon(Icons.analytics),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsScreen(),
                  ),
                ),
              ),
            ),

            // الأوامر الصوتية
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SettingsTile(
                title: 'الأوامر الصوتية',
                subtitle: 'التحكم بالتطبيق باستخدام الصوت',
                leading: const Icon(Icons.mic),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VoiceCommandsScreen(),
                  ),
                ),
              ),
            ),

            // بناء العادات الذكي
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SettingsTile(
                title: 'بناء العادات الذكي',
                subtitle: 'إنشاء عادات مخصصة بناءً على اهتماماتك',
                leading: const Icon(Icons.auto_awesome),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HabitBuilderScreen(),
                  ),
                ),
              ),
            ),

            // المساعد الذكي
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SettingsTile(
                title: 'المساعد الذكي',
                subtitle: 'تحدث مع مساعدك الشخصي للعادات',
                leading: const Icon(Icons.smart_toy),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AIPersonalAssistantScreen(),
                  ),
                ),
              ),
            ),

            // التوصيات الذكية
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: SettingsTile(
                title: 'التوصيات الذكية',
                subtitle: 'اقتراحات مخصصة لتحسين عاداتك',
                leading: const Icon(Icons.lightbulb),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SmartRecommendationsScreen(),
                  ),
                ),
              ),
            ),

            // الإشعارات العامة
            SectionHeader(title: localizations.notifications),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SettingsTile(
                title: localizations.notifications,
                subtitle: settings.notificationsEnabled ? 'مفعل' : 'معطل',
                leading: const Icon(Icons.notifications),
                trailing: Switch(
                  value: settings.notificationsEnabled,
                  onChanged: (value) => settingsNotifier.toggleNotifications(),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: SettingsTile(
                title: localizations.dailyReminder,
                subtitle: settings.dailyReminderTime.displayTime,
                leading: const Icon(Icons.access_time),
                onTap: () =>
                    _showTimePickerDialog(context, ref, isAlarm: false),
              ),
            ),

            // المنبه
            SectionHeader(title: localizations.alarmSettings),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SettingsTile(
                title: localizations.enableAlarm,
                subtitle: settings.alarmEnabled ? 'مفعل' : 'معطل',
                leading: const Icon(Icons.alarm),
                trailing: Switch(
                  value: settings.alarmEnabled,
                  onChanged: (value) => settingsNotifier.toggleAlarm(),
                ),
              ),
            ),
            if (settings.alarmEnabled) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: SettingsTile(
                  title: localizations.alarmTime,
                  subtitle: settings.alarmTime.displayTime,
                  leading: const Icon(Icons.schedule),
                  onTap: () =>
                      _showTimePickerDialog(context, ref, isAlarm: true),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 24),
                child: SettingsTile(
                  title: localizations.vibration,
                  subtitle: settings.vibrationEnabled ? 'مفعل' : 'معطل',
                  leading: const Icon(Icons.vibration),
                  trailing: Switch(
                    value: settings.vibrationEnabled,
                    onChanged: (value) => settingsNotifier.toggleVibration(),
                  ),
                ),
              ),
            ],

            // حول التطبيق
            SectionHeader(title: localizations.about),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SettingsTile(
                title: localizations.version,
                subtitle: '1.0.0',
                leading: const Icon(Icons.info),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// عرض حوار اختيار اللغة
  void _showLanguageDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const LanguageDialog());
  }

  /// عرض حوار اختيار الوقت
  void _showTimePickerDialog(
    BuildContext context,
    WidgetRef ref, {
    required bool isAlarm,
  }) {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final currentSettings = ref.read(settingsProvider);
    final currentTime = isAlarm
        ? currentSettings.alarmTime
        : currentSettings.dailyReminderTime;

    showTimePicker(
      context: context,
      initialTime: material.TimeOfDay(
        hour: currentTime.hour,
        minute: currentTime.minute,
      ),
    ).then((time) {
      if (time != null) {
        final newTime = AppTimeOfDay.fromTimeOfDay(time);
        if (isAlarm) {
          settingsNotifier.updateAlarmTime(newTime);
        } else {
          settingsNotifier.updateDailyReminderTime(newTime);
        }
      }
    });
  }
}
