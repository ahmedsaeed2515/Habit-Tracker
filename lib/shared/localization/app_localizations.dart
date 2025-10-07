// lib/shared/localization/app_localizations.dart
// نظام الترجمة للتطبيق (عربي/إنجليزي)

import 'package:flutter/material.dart';

class AppLocalizations {

  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  // النصوص مباشرة في الكود
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Ultimate Habit & Fitness Tracker',
      'gymTracker': 'Gym Tracker',
      'morningExercises': 'Morning Exercises',
      'dailyHabits': 'Daily Habits',
      'smartTodo': 'Smart To-Do',
      'dashboard': 'Dashboard',
      'settings': 'Settings',
      'workouts': 'Workouts',
      'exercises': 'Exercises',
      'habits': 'Habits',
      'tasks': 'Tasks',
      'statistics': 'Statistics',
      'progress': 'Progress',
      'generalSettings': 'General Settings',
      'language': 'Language',
      'theme': 'Theme',
      'darkTheme': 'Dark Theme',
      'lightTheme': 'Light Theme',
      'notifications': 'Notifications',
      'enableNotifications': 'Enable Notifications',
      'dailyReminder': 'Daily Reminder',
      'alarmSettings': 'Alarm Settings',
      'enableAlarm': 'Enable Alarm',
      'alarmTime': 'Alarm Time',
      'vibration': 'Vibration',
      'volume': 'Volume',
      'backupSettings': 'Backup Settings',
      'autoBackup': 'Auto Backup',
      'manualBackup': 'Manual Backup',
      'resetData': 'Reset Data',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'thisWeek': 'This Week',
      'thisMonth': 'This Month',
      'allTime': 'All Time',
      'noDataAvailable': 'No data available',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'overview': 'Overview',
      'quickActions': 'Quick Actions',
      'recentActivity': 'Recent Activity',
      'thisWeekSummary': 'This Week Summary',
      'about': 'About',
      'version': 'Version',
    },
    'ar': {
      'appTitle': 'متتبع العادات واللياقة البدنية الشامل',
      'gymTracker': 'متتبع الجيم',
      'morningExercises': 'تمارين الصباح',
      'dailyHabits': 'العادات اليومية',
      'smartTodo': 'قائمة المهام الذكية',
      'dashboard': 'لوحة المعلومات',
      'settings': 'الإعدادات',
      'workouts': 'التمارين',
      'exercises': 'التدريبات',
      'habits': 'العادات',
      'tasks': 'المهام',
      'statistics': 'الإحصائيات',
      'progress': 'التقدم',
      'generalSettings': 'الإعدادات العامة',
      'language': 'اللغة',
      'theme': 'المظهر',
      'darkTheme': 'المظهر الداكن',
      'lightTheme': 'المظهر الفاتح',
      'notifications': 'الإشعارات',
      'enableNotifications': 'تفعيل الإشعارات',
      'dailyReminder': 'التذكير اليومي',
      'alarmSettings': 'إعدادات المنبه',
      'enableAlarm': 'تفعيل المنبه',
      'alarmTime': 'وقت المنبه',
      'vibration': 'الاهتزاز',
      'volume': 'مستوى الصوت',
      'backupSettings': 'إعدادات النسخ الاحتياطي',
      'autoBackup': 'النسخ الاحتياطي التلقائي',
      'manualBackup': 'النسخ الاحتياطي اليدوي',
      'resetData': 'إعادة تعيين البيانات',
      'confirm': 'تأكيد',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'today': 'اليوم',
      'yesterday': 'أمس',
      'thisWeek': 'هذا الأسبوع',
      'thisMonth': 'هذا الشهر',
      'allTime': 'جميع الأوقات',
      'noDataAvailable': 'لا توجد بيانات متاحة',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'overview': 'نظرة عامة',
      'quickActions': 'إجراءات سريعة',
      'recentActivity': 'النشاط الأخير',
      'thisWeekSummary': 'ملخص هذا الأسبوع',
      'about': 'حول',
      'version': 'الإصدار',
    },
  };

  Future<bool> load() async {
    return true;
  }

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // التحقق من كون اللغة من اليمين للشمال
  bool get isRTL => locale.languageCode == 'ar';

  // النصوص العامة
  String get appTitle => translate('appTitle');
  String get gymTracker => translate('gymTracker');
  String get morningExercises => translate('morningExercises');
  String get dailyHabits => translate('dailyHabits');
  String get smartTodo => translate('smartTodo');
  String get dashboard => translate('dashboard');
  String get settings => translate('settings');
  String get workouts => translate('workouts');
  String get exercises => translate('exercises');
  String get habits => translate('habits');
  String get tasks => translate('tasks');
  String get statistics => translate('statistics');
  String get progress => translate('progress');
  String get generalSettings => translate('generalSettings');
  String get language => translate('language');
  String get theme => translate('theme');
  String get darkTheme => translate('darkTheme');
  String get lightTheme => translate('lightTheme');
  String get notifications => translate('notifications');
  String get enableNotifications => translate('enableNotifications');
  String get dailyReminder => translate('dailyReminder');
  String get alarmSettings => translate('alarmSettings');
  String get enableAlarm => translate('enableAlarm');
  String get alarmTime => translate('alarmTime');
  String get vibration => translate('vibration');
  String get volume => translate('volume');
  String get backupSettings => translate('backupSettings');
  String get autoBackup => translate('autoBackup');
  String get manualBackup => translate('manualBackup');
  String get resetData => translate('resetData');
  String get confirm => translate('confirm');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get add => translate('add');
  String get today => translate('today');
  String get yesterday => translate('yesterday');
  String get thisWeek => translate('thisWeek');
  String get thisMonth => translate('thisMonth');
  String get allTime => translate('allTime');
  String get noDataAvailable => translate('noDataAvailable');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get overview => translate('overview');
  String get quickActions => translate('quickActions');
  String get recentActivity => translate('recentActivity');
  String get thisWeekSummary => translate('thisWeekSummary');
  String get about => translate('about');
  String get version => translate('version');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
