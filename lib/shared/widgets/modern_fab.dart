// lib/shared/widgets/modern_fab.dart
// زر عائم حديث - Modern Floating Action Button

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design_system/app_design_system.dart';

/// زر عائم حديث بتدرج لوني
class ModernFloatingActionButton extends StatefulWidget {
  const ModernFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.enableHapticFeedback = true,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool enableHapticFeedback;

  @override
  State<ModernFloatingActionButton> createState() =>
      _ModernFloatingActionButtonState();
}

class _ModernFloatingActionButtonState extends State<ModernFloatingActionButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    _controller.forward().then((_) {
      _controller.reverse();
    });

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient =
        widget.gradient ??
        LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        );

    if (widget.label != null) {
      // Extended FAB with label
      return ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: AppDesignSystem.borderRadiusLarge,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: widget.elevation * 2,
                offset: Offset(0, widget.elevation),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleTap,
              borderRadius: AppDesignSystem.borderRadiusLarge,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spacingLarge,
                  vertical: AppDesignSystem.spacingMedium,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.foregroundColor ?? Colors.white,
                    ),
                    const SizedBox(width: AppDesignSystem.spacingSmall),
                    Text(
                      widget.label!,
                      style: TextStyle(
                        color: widget.foregroundColor ?? Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Regular FAB
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: widget.elevation * 2,
              offset: Offset(0, widget.elevation),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _handleTap,
            customBorder: const CircleBorder(),
            child: Icon(
              widget.icon,
              color: widget.foregroundColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// زر عائم صغير حديث
class ModernSmallFAB extends StatelessWidget {
  const ModernSmallFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          customBorder: const CircleBorder(),
          child: Icon(
            icon,
            size: 20,
            color: foregroundColor ?? theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
