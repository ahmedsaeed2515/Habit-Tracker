import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/localization/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/models/settings.dart';
import '../../smart_notifications/screens/notifications_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../voice_commands/screens/voice_commands_screen.dart';
import '../../habit_builder/screens/habit_builder_screen.dart';
import '../../ai_assistant/screens/ai_personal_assistant_screen.dart';
import '../../smart_recommendations/screens/smart_recommendations_screen.dart';
import '../widgets/widgets.dart';

/// شاشة الإعدادات الرئيسية
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // الإعدادات العامة
          SectionHeader(title: localizations.generalSettings),
          SettingsTile(
            title: localizations.language,
            subtitle: settings.language == 'ar' ? 'العربية' : 'English',
            leading: const Icon(Icons.language),
            onTap: () => _showLanguageDialog(context),
          ),
          SettingsTile(
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

          const SizedBox(height: 24),

          // الإشعارات الذكية
          SectionHeader(title: 'الإشعارات الذكية'),
          SettingsTile(
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

          const SizedBox(height: 24),

          // التحليلات المتقدمة
          SectionHeader(title: 'التحليلات والإحصائيات'),
          SettingsTile(
            title: 'التحليلات المتقدمة',
            subtitle: 'رسوم بيانية ورؤى ذكية لأدائك',
            leading: const Icon(Icons.analytics),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            ),
          ),

          const SizedBox(height: 8),

          // الأوامر الصوتية
          SettingsTile(
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

          const SizedBox(height: 8),

          // بناء العادات الذكي
          SettingsTile(
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

          // المساعد الذكي
          SettingsTile(
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

          // التوصيات الذكية
          SettingsTile(
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

          const SizedBox(height: 24),

          // الإشعارات العامة
          SectionHeader(title: localizations.notifications),
          SettingsTile(
            title: localizations.notifications,
            subtitle: settings.notificationsEnabled ? 'مفعل' : 'معطل',
            leading: const Icon(Icons.notifications),
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: (value) => settingsNotifier.toggleNotifications(),
            ),
          ),
          SettingsTile(
            title: localizations.dailyReminder,
            subtitle: settings.dailyReminderTime.displayTime,
            leading: const Icon(Icons.access_time),
            onTap: () => _showTimePickerDialog(context, ref, isAlarm: false),
          ),

          const SizedBox(height: 24),

          // المنبه
          SectionHeader(title: localizations.alarmSettings),
          SettingsTile(
            title: localizations.enableAlarm,
            subtitle: settings.alarmEnabled ? 'مفعل' : 'معطل',
            leading: const Icon(Icons.alarm),
            trailing: Switch(
              value: settings.alarmEnabled,
              onChanged: (value) => settingsNotifier.toggleAlarm(),
            ),
          ),
          if (settings.alarmEnabled) ...[
            SettingsTile(
              title: localizations.alarmTime,
              subtitle: settings.alarmTime.displayTime,
              leading: const Icon(Icons.schedule),
              onTap: () => _showTimePickerDialog(context, ref, isAlarm: true),
            ),
            SettingsTile(
              title: localizations.vibration,
              subtitle: settings.vibrationEnabled ? 'مفعل' : 'معطل',
              leading: const Icon(Icons.vibration),
              trailing: Switch(
                value: settings.vibrationEnabled,
                onChanged: (value) => settingsNotifier.toggleVibration(),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // حول التطبيق
          SectionHeader(title: localizations.about),
          SettingsTile(
            title: localizations.version,
            subtitle: '1.0.0',
            leading: const Icon(Icons.info),
          ),
        ],
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
