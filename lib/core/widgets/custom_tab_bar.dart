import 'package:flutter/material.dart';

/// A custom tab bar widget that provides consistent styling and behavior
/// throughout the application with additional customization options
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.indicatorPadding,
    this.indicatorWeight = 2.0,
    this.indicatorSize,
    this.indicator,
    this.isScrollable = false,
    this.tabAlignment,
    this.backgroundColor,
    this.height = 48.0,
  });
  final List<Tab> tabs;
  final TabController? controller;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsets? labelPadding;
  final EdgeInsets? indicatorPadding;
  final double? indicatorWeight;
  final TabBarIndicatorSize? indicatorSize;
  final Decoration? indicator;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final Color? backgroundColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      color: backgroundColor ?? theme.appBarTheme.backgroundColor,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        indicatorColor: indicatorColor ?? theme.primaryColor,
        labelColor: labelColor ?? theme.primaryColor,
        unselectedLabelColor: unselectedLabelColor ?? 
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle: labelStyle ?? theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: unselectedLabelStyle ?? theme.textTheme.bodyMedium,
        labelPadding: labelPadding,
        indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
        indicatorWeight: indicatorWeight!,
        indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
        indicator: indicator,
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height!);
}

/// A vertical tab bar for side navigation
class VerticalTabBar extends StatelessWidget {

  const VerticalTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.width = 120.0,
    this.padding,
    this.borderRadius,
  });
  final List<Tab> tabs;
  final int selectedIndex;
  final void Function(int)? onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final double? width;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: borderRadius,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;
          
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 2.0),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedColor ?? theme.colorScheme.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  if (tab.icon != null) ...[
                    Icon(
                      (tab.icon! as Icon).icon,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : unselectedColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20.0,
                    ),
                    const const SizedBox(width: 8.0),
                  ],
                  Expanded(
                    child: Text(
                      tab.text!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : unselectedColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A custom tab bar with badges
class BadgeTabBar extends StatelessWidget implements PreferredSizeWidget {

  const BadgeTabBar({
    super.key,
    required this.tabs,
    required this.badges,
    this.controller,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.badgeColor,
    this.badgeTextColor,
    this.isScrollable = false,
    this.height = 48.0,
  });
  final List<Tab> tabs;
  final List<int?> badges;
  final TabController? controller;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final bool isScrollable;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TabBar(
      controller: controller,
      isScrollable: isScrollable,
      indicatorColor: indicatorColor ?? theme.primaryColor,
      labelColor: labelColor ?? theme.primaryColor,
      unselectedLabelColor: unselectedLabelColor ?? 
          theme.colorScheme.onSurface.withValues(alpha: 0.6),
      tabs: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final badgeCount = badges.length > index ? badges[index] : null;
        
        return Tab(
          child: Stack(
            children: [
              tab.child ?? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.icon != null) tab.icon!,
                  if (tab.icon != null && tab.text != null)
                    const const SizedBox(width: 8.0),
                  if (tab.text != null) Text(tab.text!),
                ],
              ),
              if (badgeCount != null && badgeCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: badgeColor ?? theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20.0,
                      minHeight: 20.0,
                    ),
                    child: Text(
                      badgeCount > 99 ? '99+' : badgeCount.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: badgeTextColor ?? theme.colorScheme.onError,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

/// A sliding tab bar with smooth animations
class SlidingTabBar extends StatefulWidget {

  const SlidingTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.indicatorColor,
    this.height = 40.0,
    this.padding,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 200),
  });
  final List<String> tabs;
  final int selectedIndex;
  final void Function(int)? onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Duration animationDuration;

  @override
  State<SlidingTabBar> createState() => _SlidingTabBarState();
}

class _SlidingTabBarState extends State<SlidingTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SlidingTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(25.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - 8.0) / widget.tabs.length;
          
          return Stack(
            children: [
              AnimatedPositioned(
                duration: widget.animationDuration,
                left: widget.selectedIndex * tabWidth + 4.0,
                child: Container(
                  width: tabWidth - 4.0,
                  height: widget.height! - 8.0,
                  decoration: BoxDecoration(
                    color: widget.indicatorColor ?? theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(21.0),
                  ),
                ),
              ),
              Row(
                children: widget.tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  final isSelected = index == widget.selectedIndex;
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onTap?.call(index),
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          tab,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? widget.selectedColor ?? theme.colorScheme.onPrimary
                                : widget.unselectedColor ?? theme.colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}