import 'package:flutter/material.dart';
import 'screens/pomodoro_todo_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/achievements_screen.dart';

/// فئة التوجيه لنظام إدارة مهام البومودورو
class PomodoroRoutes {
  static const String todoScreen = '/pomodoro/todo';
  static const String analyticsScreen = '/pomodoro/analytics';
  static const String achievementsScreen = '/pomodoro/achievements';
  static const String settingsScreen = '/pomodoro/settings';
  static const String timerScreen = '/pomodoro/timer';

  /// خريطة المسارات للنظام
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      todoScreen: (context) => const PomodoroTodoScreen(),
      analyticsScreen: (context) => const AnalyticsScreen(),
      achievementsScreen: (context) => const AchievementsScreen(),
    };
  }

  /// توليد مسار بناءً على الاسم والمعاملات
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case todoScreen:
        return MaterialPageRoute(
          builder: (context) => const PomodoroTodoScreen(),
          settings: settings,
        );
        
      case analyticsScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              const AnalyticsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          settings: settings,
        );
        
      case achievementsScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              const AchievementsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              )),
              child: child,
            );
          },
          settings: settings,
        );

      default:
        return null;
    }
  }

  /// التنقل إلى شاشة المهام الرئيسية
  static Future<void> navigateToTodoScreen(BuildContext context) {
    return Navigator.pushNamed(context, todoScreen);
  }

  /// التنقل إلى شاشة الإحصائيات
  static Future<void> navigateToAnalytics(BuildContext context) {
    return Navigator.pushNamed(context, analyticsScreen);
  }

  /// التنقل إلى شاشة الإنجازات
  static Future<void> navigateToAchievements(BuildContext context) {
    return Navigator.pushNamed(context, achievementsScreen);
  }

  /// التنقل إلى شاشة الإعدادات
  static Future<void> navigateToSettings(BuildContext context) {
    return Navigator.pushNamed(context, settingsScreen);
  }

  /// التنقل مع استبدال الشاشة الحالية
  static Future<void> navigateAndReplace(
    BuildContext context, 
    String routeName,
  ) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  /// التنقل مع محو جميع الشاشات السابقة
  static Future<void> navigateAndClearStack(
    BuildContext context, 
    String routeName,
  ) {
    return Navigator.pushNamedAndRemoveUntil(
      context, 
      routeName, 
      (route) => false,
    );
  }

  /// العودة للشاشة السابقة مع نتيجة
  static void popWithResult<T>(BuildContext context, T result) {
    Navigator.pop(context, result);
  }

  /// التحقق من إمكانية العودة
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}

/// ويدجت مخصص للتنقل السلس بين الشاشات
class PomodoroPageTransition extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  final PomodoroTransitionType transitionType;

  PomodoroPageTransition({
    required this.child,
    required this.routeName,
    this.transitionType = PomodoroTransitionType.slide,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          settings: RouteSettings(name: routeName),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              animation,
              secondaryAnimation,
              child,
              transitionType,
            );
          },
        );

  static Widget _buildTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    PomodoroTransitionType type,
  ) {
    switch (type) {
      case PomodoroTransitionType.slide:
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );

      case PomodoroTransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case PomodoroTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: child,
        );

      case PomodoroTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
    }
  }
}

/// أنواع الانتقال المتاحة
enum PomodoroTransitionType {
  slide,
  fade,
  scale,
  rotation,
}

/// مساعد للتنقل العام في التطبيق
class PomodoroNavigationHelper {
  static final GlobalKey<NavigatorState> navigatorKey = 
      GlobalKey<NavigatorState>();

  /// الحصول على السياق الحالي
  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// التنقل إلى شاشة جديدة دون سياق
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    final context = currentContext;
    if (context == null) return Future.value(null);
    
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// استبدال الشاشة الحالية دون سياق
  static Future<T?> pushReplacementNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    T? result,
  }) {
    final context = currentContext;
    if (context == null) return Future.value(null);
    
    return Navigator.pushReplacementNamed<T, T>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// العودة للشاشة السابقة دون سياق
  static void pop<T>([T? result]) {
    final context = currentContext;
    if (context == null) return;
    
    Navigator.pop<T>(context, result);
  }

  /// محو جميع الشاشات والانتقال لشاشة جديدة
  static Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    final context = currentContext;
    if (context == null) return Future.value(null);
    
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// عرض حوار تأكيد الخروج من التطبيق
  static Future<bool> showExitConfirmation() async {
    final context = currentContext;
    if (context == null) return false;

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text(
          'تأكيد الخروج',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هل تريد الخروج من التطبيق؟',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'خروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false;
  }
}

/// ويدجت مخصص لإدارة التنقل في النظام
class PomodoroNavigationWrapper extends StatefulWidget {
  final Widget child;

  const PomodoroNavigationWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<PomodoroNavigationWrapper> createState() => 
      _PomodoroNavigationWrapperState();
}

class _PomodoroNavigationWrapperState 
    extends State<PomodoroNavigationWrapper> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        
        // التعامل مع زر العودة في Android
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          // عرض حوار تأكيد الخروج
          final shouldExit = await PomodoroNavigationHelper.showExitConfirmation();
          if (shouldExit) {
            Navigator.pop(context);
          }
        }
      },
      child: widget.child,
    );
  }
}