// lib/shared/widgets/modern_card.dart
// بطاقة حديثة قابلة لإعادة الاستخدام - Modern Card

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design_system/app_design_system.dart';

/// بطاقة حديثة مع ظلال وتأثيرات حركة
class ModernCard extends StatefulWidget {
  const ModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.enableHoverEffect = true,
    this.enableHapticFeedback = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? elevation;
  final bool enableHoverEffect;
  final bool enableHapticFeedback;

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDesignSystem.animationDurationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppDesignSystem.animationCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      scale: _scaleAnimation.value,
      duration: AppDesignSystem.animationDurationFast,
      child: MouseRegion(
        onEnter: widget.enableHoverEffect
            ? (_) => setState(() => _isHovered = true)
            : null,
        onExit: widget.enableHoverEffect
            ? (_) => setState(() => _isHovered = false)
            : null,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: AppDesignSystem.animationDurationNormal,
            curve: AppDesignSystem.animationCurve,
            margin: widget.margin ?? AppDesignSystem.paddingSmall,
            decoration: BoxDecoration(
              color:
                  widget.backgroundColor ??
                  (theme.brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.9)),
              borderRadius:
                  widget.borderRadius ?? AppDesignSystem.borderRadiusXLarge,
              boxShadow: _isHovered
                  ? AppDesignSystem.mediumShadow(context)
                  : AppDesignSystem.lightShadow(context),
            ),
            child: ClipRRect(
              borderRadius:
                  widget.borderRadius ?? AppDesignSystem.borderRadiusXLarge,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius:
                      widget.borderRadius ?? AppDesignSystem.borderRadiusXLarge,
                  child: Padding(
                    padding: widget.padding ?? AppDesignSystem.paddingMedium,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
