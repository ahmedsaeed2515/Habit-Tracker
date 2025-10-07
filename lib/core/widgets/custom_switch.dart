import 'package:flutter/material.dart';

/// A customizable switch widget that provides consistent styling
/// throughout the application with additional features
class CustomSwitch extends StatefulWidget {

  const CustomSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.padding,
    this.enabled = true,
    this.leading,
    this.trailing,
  });
  final bool value;
  final void Function(bool)? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final EdgeInsets? padding;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.title != null || widget.subtitle != null) {
      return Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: widget.enabled 
                            ? theme.colorScheme.onSurface
                            : theme.disabledColor,
                      ),
                    ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: widget.enabled 
                            ? theme.colorScheme.onSurface.withOpacity(0.7)
                            : theme.disabledColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildSwitch(theme),
            if (widget.trailing != null) ...[
              const SizedBox(width: 12),
              widget.trailing!,
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: _buildSwitch(theme),
    );
  }

  Widget _buildSwitch(ThemeData theme) {
    return Switch(
      value: widget.value,
      onChanged: widget.enabled ? widget.onChanged : null,
      activeThumbColor: widget.thumbColor ?? theme.colorScheme.onPrimary,
      activeTrackColor: widget.activeColor ?? theme.colorScheme.primary,
      inactiveThumbColor: widget.thumbColor ?? theme.colorScheme.onSurface,
      inactiveTrackColor: widget.inactiveColor ?? theme.colorScheme.outline.withOpacity(0.3),
    );
  }
}

/// A switch list tile with enhanced customization options
class CustomSwitchListTile extends StatelessWidget {

  const CustomSwitchListTile({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.leading,
    this.secondary,
    this.padding,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
  });
  final bool value;
  final void Function(bool)? onChanged;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? secondary;
  final EdgeInsets? padding;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: padding,
      child: SwitchListTile(
        value: value,
        onChanged: enabled ? onChanged : null,
        title: title != null ? Text(title!) : null,
        subtitle: subtitle != null ? Text(subtitle!) : null,
        secondary: leading,
        activeThumbColor: activeColor ?? theme.colorScheme.primary,
        inactiveTrackColor: inactiveColor ?? theme.colorScheme.outline.withOpacity(0.3),
        contentPadding: EdgeInsets.zero,
        dense: false,
      ),
    );
  }
}

/// A toggle switch widget with custom styling
class CustomToggleSwitch extends StatelessWidget {

  const CustomToggleSwitch({
    super.key,
    required this.labels,
    required this.selectedIndex,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeForegroundColor,
    this.inactiveForegroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(4.0),
    this.enabled = true,
  });
  final List<String> labels;
  final int selectedIndex;
  final void Function(int)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeForegroundColor;
  final Color? inactiveForegroundColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: inactiveColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius!),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = index == selectedIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: enabled ? () => onChanged?.call(index) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: isSelected
                    ? BoxDecoration(
                        color: activeColor ?? theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(borderRadius! - 4),
                      )
                    : null,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? activeForegroundColor ?? theme.colorScheme.onPrimary
                        : inactiveForegroundColor ?? theme.colorScheme.onSurface.withOpacity(
                            enabled ? 1.0 : 0.5,
                          ),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A switch with icon indicators
class CustomIconSwitch extends StatelessWidget {

  const CustomIconSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeIcon,
    this.inactiveIcon,
    this.activeLabel,
    this.inactiveLabel,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
    this.padding,
  });
  final bool value;
  final void Function(bool)? onChanged;
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final String? activeLabel;
  final String? inactiveLabel;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (inactiveIcon != null || inactiveLabel != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (inactiveIcon != null)
                  Icon(
                    inactiveIcon,
                    size: 20,
                    color: !value && enabled 
                        ? (inactiveColor ?? theme.colorScheme.onSurface)
                        : theme.disabledColor,
                  ),
                if (inactiveLabel != null) ...[
                  if (inactiveIcon != null) const SizedBox(width: 4),
                  Text(
                    inactiveLabel!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: !value && enabled 
                          ? (inactiveColor ?? theme.colorScheme.onSurface)
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ],
            ),
          const SizedBox(width: 8),
          CustomSwitch(
            value: value,
            onChanged: onChanged,
            enabled: enabled,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          const SizedBox(width: 8),
          if (activeIcon != null || activeLabel != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activeIcon != null)
                  Icon(
                    activeIcon,
                    size: 20,
                    color: value && enabled 
                        ? (activeColor ?? theme.colorScheme.primary)
                        : theme.disabledColor,
                  ),
                if (activeLabel != null) ...[
                  if (activeIcon != null) const SizedBox(width: 4),
                  Text(
                    activeLabel!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: value && enabled 
                          ? (activeColor ?? theme.colorScheme.primary)
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}