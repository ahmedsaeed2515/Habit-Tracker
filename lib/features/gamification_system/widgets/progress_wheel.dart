import 'dart:math';
import 'package:flutter/material.dart';

class ProgressWheel extends StatelessWidget {

  const ProgressWheel({
    super.key,
    required this.progress,
    this.size = 100,
    this.progressColor,
    this.backgroundColor,
    this.strokeWidth = 8,
    this.child,
    this.label,
  });
  final double progress; // 0.0 to 1.0
  final double size;
  final Color? progressColor;
  final Color? backgroundColor;
  final double strokeWidth;
  final Widget? child;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveProgressColor = progressColor ?? theme.colorScheme.primary;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressPainter(
              progress: 1.0,
              color: effectiveBackgroundColor,
              strokeWidth: strokeWidth,
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressPainter(
              progress: progress.clamp(0.0, 1.0),
              color: effectiveProgressColor,
              strokeWidth: strokeWidth,
            ),
          ),
          // Center content
          Center(
            child:
                child ??
                (label != null
                    ? Text(
                        label!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: effectiveProgressColor,
                        ),
                      )
                    : null),
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {

  _ProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * progress, // Sweep angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
