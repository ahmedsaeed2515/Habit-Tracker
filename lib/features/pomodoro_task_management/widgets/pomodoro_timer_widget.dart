import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// ويدجت عرض تايمر Pomodoro مع تأثيرات بصرية متقدمة
class PomodoroTimerWidget extends ConsumerStatefulWidget {

  const PomodoroTimerWidget({
    super.key,
    required this.session,
  });
  final PomodoroSession session;

  @override
  ConsumerState<PomodoroTimerWidget> createState() => _PomodoroTimerWidgetState();
}

class _PomodoroTimerWidgetState extends ConsumerState<PomodoroTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _rotationController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _rotationAnimation;
  
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startUpdateTimer();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationController = AnimationController(
      duration: const Duration(minutes: 1),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _rotationController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final remainingTime = session.remainingTime;
    final progress = session.progress;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Timer Display
          _buildTimerDisplay(context, session, remainingTime, progress),
          
          const SizedBox(height: 20),
          
          // Controls
          _buildTimerControls(context, session),
          
          const SizedBox(height: 16),
          
          // Session Info
          _buildSessionInfo(context, session),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(
    BuildContext context,
    PomodoroSession session,
    Duration remainingTime,
    double progress,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Ripple Effect
        if (session.status == SessionStatus.active)
          AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) {
              return Container(
                width: 180 + (_rippleAnimation.value * 40),
                height: 180 + (_rippleAnimation.value * 40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getSessionColor(session.type)
                        .withValues(alpha: 0.3 * (1 - _rippleAnimation.value)),
                    width: 2,
                  ),
                ),
              );
            },
          ),
        
        // Main Timer Circle
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: session.status == SessionStatus.active 
                  ? _pulseAnimation.value 
                  : 1.0,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _getSessionColor(session.type).withValues(alpha: 0.8),
                      _getSessionColor(session.type).withValues(alpha: 0.4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getSessionColor(session.type).withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: TimerProgressPainter(
                    progress: progress,
                    color: Colors.white,
                    strokeWidth: 6,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Time Display
                        Text(
                          _formatDuration(remainingTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Session Type
                        Text(
                          _getSessionTypeText(session.type),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        // Cycle Number
                        if (session.type == SessionType.focus)
                          Text(
                            'الدورة ${session.cycleNumber}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        
        // Floating Elements (for focus session)
        if (session.type == SessionType.focus && session.status == SessionStatus.active)
          ..._buildFloatingElements(),
      ],
    );
  }

  List<Widget> _buildFloatingElements() {
    return List.generate(6, (index) {
      return AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          final angle = (index * math.pi / 3) + _rotationAnimation.value;
          final radius = 100.0 + (10 * math.sin(angle * 2));
          
          return Positioned(
            left: 90 + radius * math.cos(angle),
            top: 90 + radius * math.sin(angle),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildTimerControls(BuildContext context, PomodoroSession session) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pause/Resume Button
        if (session.status == SessionStatus.active)
          _buildControlButton(
            icon: Icons.pause,
            onPressed: () => ref.read(activeSessionProvider.notifier).pauseSession(),
            color: Colors.orange,
            tooltip: 'إيقاف مؤقت',
          )
        else if (session.status == SessionStatus.paused)
          _buildControlButton(
            icon: Icons.play_arrow,
            onPressed: () => ref.read(activeSessionProvider.notifier).resumeSession(),
            color: Colors.green,
            tooltip: 'استئناف',
          ),
        
        const SizedBox(width: 16),
        
        // Stop Button
        _buildControlButton(
          icon: Icons.stop,
          onPressed: () => _showStopDialog(context),
          color: Colors.red,
          tooltip: 'إيقاف',
        ),
        
        const SizedBox(width: 16),
        
        // Skip Button
        _buildControlButton(
          icon: Icons.skip_next,
          onPressed: () => ref.read(activeSessionProvider.notifier).skipSession(),
          color: Colors.blue,
          tooltip: 'تخطي',
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionInfo(BuildContext context, PomodoroSession session) {
    final taskId = session.taskId;
    final taskName = taskId != null 
        ? ref.watch(taskDetailsProvider(taskId))?.title 
        : null;

    return Column(
      children: [
        // Current Task
        if (taskName != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.task_alt,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  taskName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // Next Session Info
        _buildNextSessionInfo(context, session),
        
        // Motivational Quote
        if (session.type == SessionType.focus && session.status == SessionStatus.active)
          _buildMotivationalQuote(context),
      ],
    );
  }

  Widget _buildNextSessionInfo(BuildContext context, PomodoroSession session) {
    final settings = ref.watch(pomodoroSettingsProvider);
    String nextSessionText = '';
    
    if (session.type == SessionType.focus) {
      if (session.cycleNumber % settings.longBreakInterval == 0) {
        nextSessionText = 'التالي: استراحة طويلة (${settings.longBreak.inMinutes} د)';
      } else {
        nextSessionText = 'التالي: استراحة قصيرة (${settings.shortBreak.inMinutes} د)';
      }
    } else {
      nextSessionText = 'التالي: جلسة تركيز (${settings.focusSession.inMinutes} د)';
    }
    
    return Text(
      nextSessionText,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMotivationalQuote(BuildContext context) {
    final quotes = [
      'التركيز هو سر النجاح 💪',
      'كل دقيقة تحسب! ⏰',
      'أنت أقوى مما تعتقد! 🚀',
      'الثبات يحقق المعجزات ✨',
      'استمر... النتائج قادمة! 🎯',
    ];
    
    final quote = quotes[DateTime.now().second % quotes.length];
    
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        quote,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getSessionColor(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return Colors.red;
      case SessionType.shortBreak:
        return Colors.green;
      case SessionType.longBreak:
        return Colors.blue;
      case SessionType.custom:
        return Colors.purple;
    }
  }

  String _getSessionTypeText(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return 'تركيز';
      case SessionType.shortBreak:
        return 'استراحة قصيرة';
      case SessionType.longBreak:
        return 'استراحة طويلة';
      case SessionType.custom:
        return 'مخصص';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showStopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إيقاف الجلسة'),
        content: const Text('هل تريد إيقاف الجلسة الحالية؟ سيتم حفظ التقدم.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activeSessionProvider.notifier).cancelSession();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إيقاف'),
          ),
        ],
      ),
    );
  }
}

/// رسام التقدم الدائري للتايمر
class TimerProgressPainter extends CustomPainter {

  TimerProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 4.0,
  });
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    // Background Circle
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );

    // Progress Dot
    if (progress > 0) {
      final dotAngle = (-math.pi / 2) + sweepAngle;
      final dotCenter = Offset(
        center.dx + radius * math.cos(dotAngle),
        center.dy + radius * math.sin(dotAngle),
      );

      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dotCenter, strokeWidth / 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(TimerProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}

/// ويدجت مضغوط لعرض التايمر في الشريط العلوي
class CompactTimerWidget extends ConsumerWidget {

  const CompactTimerWidget({
    super.key,
    required this.session,
  });
  final PomodoroSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainingTime = session.remainingTime;
    final progress = session.progress;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getSessionColor(session.type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getSessionColor(session.type).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Indicator
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getSessionColor(session.type),
              ),
              backgroundColor: _getSessionColor(session.type).withValues(alpha: 0.2),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Time and Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDuration(remainingTime),
                style: TextStyle(
                  color: _getSessionColor(session.type),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                _getSessionTypeText(session.type),
                style: TextStyle(
                  color: _getSessionColor(session.type).withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 8),
          
          // Status Icon
          Icon(
            session.status == SessionStatus.active 
                ? Icons.play_arrow 
                : Icons.pause,
            color: _getSessionColor(session.type),
            size: 16,
          ),
        ],
      ),
    );
  }

  Color _getSessionColor(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return Colors.red;
      case SessionType.shortBreak:
        return Colors.green;
      case SessionType.longBreak:
        return Colors.blue;
      case SessionType.custom:
        return Colors.purple;
    }
  }

  String _getSessionTypeText(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return 'تركيز';
      case SessionType.shortBreak:
        return 'استراحة';
      case SessionType.longBreak:
        return 'استراحة طويلة';
      case SessionType.custom:
        return 'مخصص';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}