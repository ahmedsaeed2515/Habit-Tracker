// lib/shared/widgets/gradient_button.dart
// زر بتدرج لوني مع تأثيرات حركة - Gradient Button

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design_system/app_design_system.dart';

/// زر بتدرج لوني حديث
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.enableHapticFeedback = true,
    this.isLoading = false,
    this.disabled = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? elevation;
  final bool enableHapticFeedback;
  final bool isLoading;
  final bool disabled;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDesignSystem.animationDurationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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

  void _handleTap() {
    if (widget.disabled || widget.isLoading || widget.onPressed == null) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    _controller.forward().then((_) {
      _controller.reverse();
    });

    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = widget.gradient ?? AppDesignSystem.buttonGradient(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: widget.disabled ? null : gradient,
          color: widget.disabled ? Colors.grey : null,
          borderRadius:
              widget.borderRadius ?? AppDesignSystem.borderRadiusLarge,
          boxShadow: widget.disabled
              ? []
              : [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            borderRadius:
                widget.borderRadius ?? AppDesignSystem.borderRadiusLarge,
            child: Container(
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spacingLarge,
                    vertical: AppDesignSystem.spacingMedium,
                  ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      child: widget.child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
