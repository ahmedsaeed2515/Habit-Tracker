// lib/shared/widgets/glass_container.dart
// حاوية زجاجية قابلة لإعادة الاستخدام - Glassmorphism Container

import 'package:flutter/material.dart';
import '../design_system/app_design_system.dart';

/// حاوية زجاجية مع تأثير Glassmorphism
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.opacity = 0.2,
    this.blur = 10.0,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.showBorder = true,
  });

  final Widget child;
  final double opacity;
  final double blur;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: borderRadius ?? AppDesignSystem.borderRadiusLarge,
        border: showBorder
            ? Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5)
            : null,
        boxShadow: AppDesignSystem.lightShadow(context),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? AppDesignSystem.borderRadiusLarge,
        child: container,
      );
    }

    return container;
  }
}
