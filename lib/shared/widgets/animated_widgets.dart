// lib/shared/widgets/animated_widgets.dart
// ويدجتات متحركة - Animated Widgets

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design_system/app_design_system.dart';

/// ويدجت بتأثير ظهور تدريجي
class FadeInWidget extends StatefulWidget {
  const FadeInWidget({
    super.key,
    required this.child,
    this.duration,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration? duration;
  final Duration delay;

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppDesignSystem.animationCurve,
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

/// ويدجت بتأثير انزلاق
class SlideInWidget extends StatefulWidget {
  const SlideInWidget({
    super.key,
    required this.child,
    this.direction = AxisDirection.up,
    this.duration,
    this.delay = Duration.zero,
    this.offset = 0.5,
  });

  final Widget child;
  final AxisDirection direction;
  final Duration? duration;
  final Duration delay;
  final double offset;

  @override
  State<SlideInWidget> createState() => _SlideInWidgetState();
}

class _SlideInWidgetState extends State<SlideInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    Offset begin;
    switch (widget.direction) {
      case AxisDirection.up:
        begin = Offset(0, widget.offset);
      case AxisDirection.down:
        begin = Offset(0, -widget.offset);
      case AxisDirection.left:
        begin = Offset(widget.offset, 0);
      case AxisDirection.right:
        begin = Offset(-widget.offset, 0);
    }

    _animation = Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppDesignSystem.animationCurve,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}

/// ويدجت بتأثير تكبير
class ScaleInWidget extends StatefulWidget {
  const ScaleInWidget({
    super.key,
    required this.child,
    this.duration,
    this.delay = Duration.zero,
    this.initialScale = 0.8,
  });

  final Widget child;
  final Duration? duration;
  final Duration delay;
  final double initialScale;

  @override
  State<ScaleInWidget> createState() => _ScaleInWidgetState();
}

class _ScaleInWidgetState extends State<ScaleInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: widget.initialScale, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppDesignSystem.animationCurveSpring,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}

/// ويدجت بتأثير اهتزاز
class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.child,
    this.shake = false,
    this.duration,
  });

  final Widget child;
  final bool shake;
  final Duration? duration;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateOffset(double value) {
    const shakeCount = 3;
    return math.sin(value * shakeCount * 2 * math.pi) * 10;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_calculateOffset(_animation.value), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// قائمة متحركة بتأثيرات تدريجية
class AnimatedListView extends StatelessWidget {
  const AnimatedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.animationType = AnimationType.fadeIn,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.scrollController,
    this.padding,
    this.physics,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final AnimationType animationType;
  final Duration staggerDelay;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: padding,
      physics: physics,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final child = itemBuilder(context, index);
        final delay = staggerDelay * index;

        switch (animationType) {
          case AnimationType.fadeIn:
            return FadeInWidget(delay: delay, child: child);
          case AnimationType.slideUp:
            return SlideInWidget(
              delay: delay,
              child: child,
            );
          case AnimationType.slideLeft:
            return SlideInWidget(
              delay: delay,
              direction: AxisDirection.left,
              child: child,
            );
          case AnimationType.scaleIn:
            return ScaleInWidget(delay: delay, child: child);
        }
      },
    );
  }
}

enum AnimationType { fadeIn, slideUp, slideLeft, scaleIn }
