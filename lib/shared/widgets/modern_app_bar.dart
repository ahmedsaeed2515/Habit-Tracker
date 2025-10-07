// lib/shared/widgets/modern_app_bar.dart
// شريط تطبيق حديث بتأثير glassmorphism - Modern App Bar

import 'dart:ui';
import 'package:flutter/material.dart';
import '../design_system/app_design_system.dart';

/// شريط تطبيق حديث بتأثير glassmorphism
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ModernAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.useGlassmorphism = true,
    this.height = kToolbarHeight,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final bool useGlassmorphism;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (useGlassmorphism) {
      return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: height + MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface.withValues(alpha: 0.7),
                  theme.colorScheme.surface.withValues(alpha: 0.5),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spacingSmall,
                ),
                child: Row(
                  children: [
                    if (leading != null) leading!,
                    if (leading == null && Navigator.canPop(context))
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    if (centerTitle) const Spacer(),
                    if (title != null)
                      DefaultTextStyle(
                        style: AppDesignSystem.titleLarge(context),
                        child: title!,
                      ),
                    const Spacer(),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
    );
  }
}

/// شريط تطبيق بتدرج لوني
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.gradient,
    this.height = kToolbarHeight,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Gradient? gradient;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveGradient =
        gradient ??
        LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        );

    return Container(
      height: height + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(gradient: effectiveGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spacingSmall,
          ),
          child: Row(
            children: [
              if (leading != null) leading!,
              if (leading == null && Navigator.canPop(context))
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              if (centerTitle) const Spacer(),
              if (title != null)
                DefaultTextStyle(
                  style: AppDesignSystem.titleLarge(
                    context,
                  ).copyWith(color: Colors.white),
                  child: title!,
                ),
              const Spacer(),
              if (actions != null)
                ...actions!.map((action) {
                  return IconTheme(
                    data: const IconThemeData(color: Colors.white),
                    child: action,
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
