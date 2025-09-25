// lib/core/providers/settings_provider.dart
// مقدم حالة الإعدادات

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_manager.dart';
import '../models/settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(DatabaseManager.getAppSettings());

  /// تحديث الإعدادات عمومًا
  Future<void> updateSettings(AppSettings newSettings) async {
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تغيير اللغة
  Future<void> changeLanguage(String language) async {
    final newSettings = state.copyWith(language: language);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تبديل الوضع المظلم/الفاتح
  Future<void> toggleDarkMode() async {
    final newSettings = state.copyWith(isDarkMode: !state.isDarkMode);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تبديل الإشعارات
  Future<void> toggleNotifications() async {
    final newSettings = state.copyWith(
      notificationsEnabled: !state.notificationsEnabled,
    );
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تحديث وقت التذكير اليومي
  Future<void> updateDailyReminderTime(AppTimeOfDay time) async {
    final newSettings = state.copyWith(dailyReminderTime: time);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تبديل المنبه
  Future<void> toggleAlarm() async {
    final newSettings = state.copyWith(alarmEnabled: !state.alarmEnabled);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تحديث وقت المنبه
  Future<void> updateAlarmTime(AppTimeOfDay time) async {
    final newSettings = state.copyWith(alarmTime: time);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تحديث مسار صوت المنبه المخصص
  Future<void> updateCustomAlarmSound(String? path) async {
    final newSettings = state.copyWith(customAlarmSoundPath: path);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تحديث مستوى الصوت
  Future<void> updateAlarmVolume(double volume) async {
    final newSettings = state.copyWith(alarmVolume: volume);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تبديل الاهتزاز
  Future<void> toggleVibration() async {
    final newSettings = state.copyWith(
      vibrationEnabled: !state.vibrationEnabled,
    );
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تحديث أيام المنبه
  Future<void> updateAlarmDays(List<int> days) async {
    final newSettings = state.copyWith(alarmDays: days);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تبديل المنبه في عطلة نهاية الأسبوع
  Future<void> toggleWeekendAlarms() async {
    final newSettings = state.copyWith(
      weekendAlarmsEnabled: !state.weekendAlarmsEnabled,
    );
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تبديل النسخ الاحتياطي التلقائي
  Future<void> toggleAutoBackup() async {
    final newSettings = state.copyWith(
      autoBackupEnabled: !state.autoBackupEnabled,
    );
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }

  /// تحديث تاريخ آخر نسخة احتياطية
  Future<void> updateLastBackupDate(DateTime date) async {
    final newSettings = state.copyWith(lastBackupDate: date);
    state = newSettings;
    await DatabaseManager.updateAppSettings(newSettings);
  }
}

// مقدم حالة الإعدادات
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  return SettingsNotifier();
});

// مقدمات الحالة المشتقة للوصول السريع
final themeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isDarkMode;
});

final languageProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).language;
});

final notificationsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).notificationsEnabled;
});

final alarmEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).alarmEnabled;
});
