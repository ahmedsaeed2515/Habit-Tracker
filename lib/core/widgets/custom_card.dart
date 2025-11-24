import 'package:flutter/material.dart';

/// كارت مخصص قابل لإعادة الاستخدام
class CustomCard extends StatelessWidget {

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.color,
    this.shadowColor,
    this.border,
    this.gradient,
    this.onTap,
    this.isClickable = false,
  });
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final Color? color;
  final Color? shadowColor;
  final Border? border;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool isClickable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget cardContent = Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? theme.cardColor) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
        border: border,
        boxShadow: elevation != null ? [
          BoxShadow(
            color: shadowColor ?? theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: elevation! * 2,
            offset: Offset(0, elevation! / 2),
          ),
        ] : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );

    if (isClickable || onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// كارت مخصص مع header وbody
class CustomCardWithHeader extends StatelessWidget {

  const CustomCardWithHeader({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.trailing,
    this.leadingIcon,
    this.headerColor,
    this.margin,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.onTap,
  });
  final String title;
  final Widget? subtitle;
  final Widget body;
  final Widget? trailing;
  final IconData? leadingIcon;
  final Color? headerColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      margin: margin,
      padding: EdgeInsets.zero,
      borderRadius: borderRadius,
      elevation: elevation,
      onTap: onTap,
      isClickable: onTap != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: padding ?? const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: headerColor ?? theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius ?? 12.0),
                topRight: Radius.circular(borderRadius ?? 12.0),
              ),
            ),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        DefaultTextStyle(
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                          ) ?? const TextStyle(),
                          child: subtitle!,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          
          // Body
          Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: body,
          ),
        ],
      ),
    );
  }
}

/// كارت احصائيات بسيط
class StatCard extends StatelessWidget {

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
    this.onTap,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.primaryColor;

    return CustomCard(
      onTap: onTap,
      isClickable: onTap != null,
      gradient: LinearGradient(
        colors: [
          cardColor.withValues(alpha: 0.1),
          cardColor.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: cardColor,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// كارت بقائمة عناصر
class ListCard extends StatelessWidget {

  const ListCard({
    super.key,
    required this.title,
    required this.items,
    this.maxItems,
    this.trailing,
    this.onSeeMore,
    this.margin,
  });
  final String title;
  final List<Widget> items;
  final int? maxItems;
  final Widget? trailing;
  final VoidCallback? onSeeMore;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayItems = maxItems != null && items.length > maxItems! 
        ? items.take(maxItems!).toList() 
        : items;
    final hasMore = maxItems != null && items.length > maxItems!;

    return CustomCard(
      margin: margin,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          
          // Items
          if (displayItems.isNotEmpty) ...[
            ...displayItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: item,
            )),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'لا توجد عناصر للعرض',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
          
          // See More Button
          if (hasMore) ...[
            const Divider(height: 1),
            InkWell(
              onTap: onSeeMore,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'عرض المزيد (${items.length - maxItems!})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.primaryColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// كارت تحميل
class LoadingCard extends StatelessWidget {

  const LoadingCard({
    super.key,
    this.message,
    this.height,
  });
  final String? message;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      child: SizedBox(
        height: height ?? 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: theme.primaryColor,
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// كارت فارغ (عدم وجود بيانات)
class EmptyCard extends StatelessWidget {

  const EmptyCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: theme.disabledColor,
              ),
              const SizedBox(height: 16),
            ],
            
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.disabledColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}