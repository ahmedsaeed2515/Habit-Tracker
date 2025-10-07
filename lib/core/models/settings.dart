import 'package:flutter/material.dart' as material;
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 13)
class AppSettings extends HiveObject {

  AppSettings({
    this.language = 'en',
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    AppTimeOfDay? dailyReminderTime,
    this.alarmEnabled = false,
    AppTimeOfDay? alarmTime,
    this.customAlarmSoundPath,
    this.alarmVolume = 0.8,
    this.vibrationEnabled = true,
    this.defaultAlarmSound = 'default_alarm',
    this.weekendAlarmsEnabled = true,
    this.alarmDays = const [0, 1, 2, 3, 4, 5, 6], // جميع أيام الأسبوع
    this.autoBackupEnabled = false,
    this.lastBackupDate,
    this.isFirstTime = true,
  }) : dailyReminderTime =
           dailyReminderTime ?? AppTimeOfDay(hour: 9, minute: 0),
       alarmTime = alarmTime ?? AppTimeOfDay(hour: 5, minute: 30);
  @HiveField(0)
  String language;

  @HiveField(1)
  bool isDarkMode;

  @HiveField(2)
  bool notificationsEnabled;

  @HiveField(3)
  AppTimeOfDay dailyReminderTime;

  @HiveField(4)
  bool alarmEnabled;

  @HiveField(5)
  AppTimeOfDay alarmTime;

  @HiveField(6)
  String? customAlarmSoundPath;

  @HiveField(7)
  double alarmVolume;

  @HiveField(8)
  bool vibrationEnabled;

  @HiveField(9)
  String defaultAlarmSound;

  @HiveField(10)
  bool weekendAlarmsEnabled;

  @HiveField(11)
  List<int> alarmDays; // 0 = الأحد، 1 = الاثنين، إلخ

  @HiveField(12)
  bool autoBackupEnabled;

  @HiveField(13)
  DateTime? lastBackupDate;

  @HiveField(14)
  bool isFirstTime;

  // التحقق من تفعيل المنبه لليوم المحدد
  bool isAlarmEnabledForDay(int dayOfWeek) {
    return alarmDays.contains(dayOfWeek);
  }

  // التحقق من تفعيل المنبه لاليوم
  bool get isAlarmEnabledToday {
    final today = DateTime.now().weekday % 7; // تحويل لنظام 0-6
    return isAlarmEnabledForDay(today);
  }

  AppSettings copyWith({
    String? language,
    bool? isDarkMode,
    bool? notificationsEnabled,
    AppTimeOfDay? dailyReminderTime,
    bool? alarmEnabled,
    AppTimeOfDay? alarmTime,
    String? customAlarmSoundPath,
    double? alarmVolume,
    bool? vibrationEnabled,
    String? defaultAlarmSound,
    bool? weekendAlarmsEnabled,
    List<int>? alarmDays,
    bool? autoBackupEnabled,
    DateTime? lastBackupDate,
    bool? isFirstTime,
  }) {
    return AppSettings(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
      alarmTime: alarmTime ?? this.alarmTime,
      customAlarmSoundPath: customAlarmSoundPath ?? this.customAlarmSoundPath,
      alarmVolume: alarmVolume ?? this.alarmVolume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      defaultAlarmSound: defaultAlarmSound ?? this.defaultAlarmSound,
      weekendAlarmsEnabled: weekendAlarmsEnabled ?? this.weekendAlarmsEnabled,
      alarmDays: alarmDays ?? this.alarmDays,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}

@HiveType(typeId: 14)
class AppTimeOfDay extends HiveObject {

  AppTimeOfDay({required this.hour, required this.minute});

  // تحويل من TimeOfDay إلى AppTimeOfDay
  factory AppTimeOfDay.fromTimeOfDay(material.TimeOfDay timeOfDay) {
    return AppTimeOfDay(hour: timeOfDay.hour, minute: timeOfDay.minute);
  }
  @HiveField(0)
  int hour;

  @HiveField(1)
  int minute;

  // تحويل إلى TimeOfDay
  material.TimeOfDay toTimeOfDay() {
    return material.TimeOfDay(hour: hour, minute: minute);
  }

  // تحويل لنص للعرض
  String get displayTime {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // تحويل لنص مع AM/PM
  String get displayTime12Hour {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  // مقارنة الأوقات
  bool isBefore(AppTimeOfDay other) {
    if (hour < other.hour) return true;
    if (hour == other.hour && minute < other.minute) return true;
    return false;
  }

  bool isAfter(AppTimeOfDay other) {
    return !isBefore(other) && !isEqual(other);
  }

  bool isEqual(AppTimeOfDay other) {
    return hour == other.hour && minute == other.minute;
  }

  AppTimeOfDay copyWith({int? hour, int? minute}) {
    return AppTimeOfDay(hour: hour ?? this.hour, minute: minute ?? this.minute);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppTimeOfDay &&
        other.hour == hour &&
        other.minute == minute;
  }

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;

  @override
  String toString() => 'AppTimeOfDay($hour:$minute)';
}
