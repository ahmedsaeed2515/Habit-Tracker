// lib/shared/design_system/app_design_system.dart
// نظام التصميم الموحد للتطبيق - Design System

import 'package:flutter/material.dart';

/// نظام التصميم الموحد
class AppDesignSystem {
  // === الألوان ===

  /// ألوان التدرج للخلفيات
  static List<Color> getGradientColors(
    BuildContext context, {
    double alpha = 0.8,
  }) {
    final theme = Theme.of(context);
    return [
      theme.colorScheme.primary.withValues(alpha: alpha),
      theme.colorScheme.secondary.withValues(alpha: alpha * 0.75),
      theme.colorScheme.tertiary.withValues(alpha: alpha * 0.5),
    ];
  }

  /// تدرج الخلفية الرئيسي
  static LinearGradient primaryGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: getGradientColors(context),
    );
  }

  /// تدرج للأزرار
  static LinearGradient buttonGradient(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
    );
  }

  // === الظلال ===

  /// ظل خفيف
  static List<BoxShadow> lightShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// ظل متوسط
  static List<BoxShadow> mediumShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// ظل قوي
  static List<BoxShadow> strongShadow(BuildContext context) {
    final theme = Theme.of(context);
    return [
      BoxShadow(
        color: theme.colorScheme.primary.withValues(alpha: 0.3),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ];
  }

  // === الحدود المستديرة ===

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusCircular = 100.0;

  static BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static BorderRadius borderRadiusXLarge = BorderRadius.circular(radiusXLarge);
  static BorderRadius borderRadiusCircular = BorderRadius.circular(
    radiusCircular,
  );

  // === المسافات ===

  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  static const EdgeInsets paddingXSmall = EdgeInsets.all(spacingXSmall);
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacingSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacingLarge);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(spacingXLarge);

  // === Glassmorphism ===

  /// خلفية زجاجية للأزرار والبطاقات
  static BoxDecoration glassDecoration(
    BuildContext context, {
    double opacity = 0.2,
    double blur = 10.0,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: borderRadius ?? borderRadiusLarge,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.3),
        width: 1.5,
      ),
      boxShadow: lightShadow(context),
    );
  }

  /// بطاقة زجاجية
  static BoxDecoration glassCardDecoration(
    BuildContext context, {
    Color? color,
    double opacity = 0.9,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withValues(alpha: opacity),
      borderRadius: borderRadiusXLarge,
      boxShadow: mediumShadow(context),
    );
  }

  // === الحركات والانتقالات ===

  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  static const Curve animationCurve = Curves.easeInOut;
  static const Curve animationCurveSpring = Curves.easeOutBack;

  // === أنماط النصوص ===

  /// عنوان كبير مع وزن قوي
  static TextStyle headlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    );
  }

  /// عنوان متوسط
  static TextStyle headlineMedium(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600);
  }

  /// عنوان صغير
  static TextStyle titleLarge(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600);
  }

  /// نص الجسم مع وزن متوسط
  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.5);
  }

  /// نص صغير مع شفافية
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: (color ?? Theme.of(context).colorScheme.onSurface).withValues(
        alpha: 0.7,
      ),
    );
  }

  // === أيقونات ملونة ===

  static const Map<String, IconData> categoryIcons = {
    'habits': Icons.repeat,
    'tasks': Icons.task_alt,
    'exercises': Icons.fitness_center,
    'gym': Icons.sports_gymnastics,
    'gamification': Icons.emoji_events,
    'pomodoro': Icons.timer,
    'notes': Icons.note_alt,
    'mood': Icons.mood,
    'budget': Icons.account_balance_wallet,
    'projects': Icons.folder_open,
    'inbox': Icons.inbox,
    'library': Icons.library_books,
    'analytics': Icons.analytics,
    'voice': Icons.mic,
    'ai': Icons.smart_toy,
    'social': Icons.people,
    'calendar': Icons.calendar_month,
    'settings': Icons.settings,
  };

  static const Map<String, Color> categoryColors = {
    'habits': Colors.green,
    'tasks': Colors.blue,
    'exercises': Colors.orange,
    'gym': Colors.purple,
    'gamification': Colors.amber,
    'pomodoro': Colors.red,
    'notes': Colors.teal,
    'mood': Colors.pink,
    'budget': Colors.indigo,
    'projects': Colors.brown,
    'inbox': Colors.cyan,
    'library': Colors.deepOrange,
    'analytics': Colors.deepPurple,
    'voice': Colors.lightBlue,
    'ai': Colors.lightGreen,
    'social': Colors.blueGrey,
    'calendar': Colors.lime,
    'settings': Colors.grey,
  };
}
