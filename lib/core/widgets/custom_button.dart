import 'package:flutter/material.dart';

/// زر مخصص قابل لإعادة الاستخدام
class CustomButton extends StatelessWidget {

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.minimumSize,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconOnRight = false,
    this.elevation,
  }) : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool iconOnRight;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isEnabled = !isDisabled && !isLoading && onPressed != null;

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation ?? 2,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: minimumSize ?? const Size(120, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
    ).merge(style);

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        icon: _buildIcon(),
        label: _buildLabel(),
      );
    }

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: buttonStyle,
      child: _buildContent(),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Icon(icon, size: 18);
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: iconOnRight ? [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, size: 18),
        ] : [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// زر مخطط (Outlined)
class CustomOutlinedButton extends StatelessWidget {

  const CustomOutlinedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.minimumSize,
    this.isLoading = false,
    this.icon,
    this.iconOnRight = false,
  }) : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final bool isLoading;
  final IconData? icon;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isEnabled = !isLoading && onPressed != null;

    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: textColor ?? theme.primaryColor,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: minimumSize ?? const Size(120, 44),
      side: BorderSide(
        color: borderColor ?? theme.primaryColor,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
    );

    Widget content;
    if (isLoading) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(text),
        ],
      );
    } else if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: iconOnRight ? [
          Text(text),
          const SizedBox(width: 8),
          Icon(icon, size: 18),
        ] : [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else {
      content = Text(text);
    }

    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: buttonStyle,
      child: content,
    );
  }
}

/// زر نص بسيط
class CustomTextButton extends StatelessWidget {

  const CustomTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.padding,
    this.minimumSize,
    this.isLoading = false,
    this.icon,
    this.iconOnRight = false,
  }) : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final bool isLoading;
  final IconData? icon;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isEnabled = !isLoading && onPressed != null;

    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: textColor ?? theme.primaryColor,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minimumSize: minimumSize ?? const Size(0, 36),
    );

    Widget content;
    if (isLoading) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: iconOnRight ? [
          Text(text),
          const SizedBox(width: 4),
          Icon(icon, size: 16),
        ] : [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(text),
        ],
      );
    } else {
      content = Text(text);
    }

    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: buttonStyle,
      child: content,
    );
  }
}

/// زر عائم مخصص
class CustomFloatingActionButton extends StatelessWidget {

  const CustomFloatingActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.mini = false,
    this.heroTag,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final bool mini;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? theme.primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      tooltip: tooltip,
      mini: mini,
      heroTag: heroTag,
      child: Icon(icon),
    );
  }
}

/// مجموعة أزرار (Button Group)
class CustomButtonGroup extends StatelessWidget {

  const CustomButtonGroup({
    Key? key,
    required this.buttons,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.spacing,
  }) : super(key: key);
  final List<CustomButtonGroupItem> buttons;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttonWidgets = buttons.map((item) {
      switch (item.type) {
        case ButtonType.elevated:
          return Expanded(
            child: CustomButton(
              text: item.text,
              onPressed: item.onPressed,
              backgroundColor: item.color,
              isLoading: item.isLoading,
              icon: item.icon,
            ),
          );
        case ButtonType.outlined:
          return Expanded(
            child: CustomOutlinedButton(
              text: item.text,
              onPressed: item.onPressed,
              borderColor: item.color,
              textColor: item.color,
              isLoading: item.isLoading,
              icon: item.icon,
            ),
          );
        case ButtonType.text:
          return Expanded(
            child: CustomTextButton(
              text: item.text,
              onPressed: item.onPressed,
              textColor: item.color,
              isLoading: item.isLoading,
              icon: item.icon,
            ),
          );
      }
    }).toList();

    // إضافة spacing بين الأزرار
    if (spacing != null && buttonWidgets.length > 1) {
      final List<Widget> spacedWidgets = [];
      for (int i = 0; i < buttonWidgets.length; i++) {
        spacedWidgets.add(buttonWidgets[i]);
        if (i < buttonWidgets.length - 1) {
          spacedWidgets.add(SizedBox(
            width: direction == Axis.horizontal ? spacing : 0,
            height: direction == Axis.vertical ? spacing : 0,
          ));
        }
      }
      buttonWidgets.clear();
      buttonWidgets.addAll(spacedWidgets);
    }

    Widget content;
    if (direction == Axis.horizontal) {
      content = Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: buttonWidgets,
      );
    } else {
      content = Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: buttonWidgets,
      );
    }

    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    return content;
  }
}

/// عنصر في مجموعة الأزرار
class CustomButtonGroupItem {

  const CustomButtonGroupItem({
    required this.text,
    this.onPressed,
    this.type = ButtonType.elevated,
    this.color,
    this.icon,
    this.isLoading = false,
  });
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final Color? color;
  final IconData? icon;
  final bool isLoading;
}

/// نوع الزر
enum ButtonType {
  elevated,
  outlined,
  text,
}

/// زر مع أيقونة كبيرة (Action Button)
class CustomActionButton extends StatelessWidget {

  const CustomActionButton({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onPressed,
    this.color,
    this.isLoading = false,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: !isLoading ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                CircularProgressIndicator(
                  color: buttonColor,
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: buttonColor,
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}