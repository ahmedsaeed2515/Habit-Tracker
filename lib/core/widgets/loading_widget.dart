import 'package:flutter/material.dart';

/// A reusable loading widget that can be used throughout the application
/// Provides consistent loading UI with customizable options
class LoadingWidget extends StatelessWidget {

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 50.0,
    this.color,
    this.showMessage = true,
    this.padding = const EdgeInsets.all(16.0),
  });
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.primaryColor,
              ),
              strokeWidth: 3.0,
            ),
          ),
          if (showMessage && message != null) ...[
            const const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A full-screen loading widget that covers the entire screen
class FullScreenLoadingWidget extends StatelessWidget {

  const FullScreenLoadingWidget({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ColoredBox(
      color: backgroundColor ?? theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
      child: Center(
        child: LoadingWidget(
          message: message ?? 'Loading...',
          color: indicatorColor,
          size: 60.0,
        ),
      ),
    );
  }
}

/// A loading overlay widget that can be placed on top of other widgets
class LoadingOverlay extends StatelessWidget {

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingMessage,
    this.overlayColor,
  });
  final bool isLoading;
  final Widget child;
  final String? loadingMessage;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: overlayColor ?? Colors.black.withValues(alpha: 0.3),
              child: LoadingWidget(
                message: loadingMessage ?? 'Loading...',
              ),
            ),
          ),
      ],
    );
  }
}

/// A shimmer loading effect widget for skeleton screens
class ShimmerLoadingWidget extends StatefulWidget {

  const ShimmerLoadingWidget({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  @override
  State<ShimmerLoadingWidget> createState() => _ShimmerLoadingWidgetState();
}

class _ShimmerLoadingWidgetState extends State<ShimmerLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.period,
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ?? 
        (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ?? 
        (isDark ? Colors.grey[500]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _animation.value, 0.0),
              end: Alignment(1.0 + _animation.value, 0.0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// A simple skeleton loading widget for list items
class SkeletonLoadingWidget extends StatelessWidget {

  const SkeletonLoadingWidget({
    super.key,
    this.width,
    this.height = 20.0,
    this.borderRadius = 4.0,
  });
  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ShimmerLoadingWidget(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}