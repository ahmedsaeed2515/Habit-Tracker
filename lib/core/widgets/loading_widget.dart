import 'package:flutter/material.dart';

/// A reusable loading widget that can be used throughout the application
/// Provides consistent loading UI with customizable options
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;
  final EdgeInsets? padding;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 50.0,
    this.color,
    this.showMessage = true,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
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
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const FullScreenLoadingWidget({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      color: backgroundColor ?? theme.scaffoldBackgroundColor.withOpacity(0.8),
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
  final bool isLoading;
  final Widget child;
  final String? loadingMessage;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingMessage,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: overlayColor ?? Colors.black.withOpacity(0.3),
              child: LoadingWidget(
                message: loadingMessage ?? 'Loading...',
                showMessage: true,
              ),
            ),
          ),
      ],
    );
  }
}

/// A shimmer loading effect widget for skeleton screens
class ShimmerLoadingWidget extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  const ShimmerLoadingWidget({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

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
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonLoadingWidget({
    super.key,
    this.width,
    this.height = 20.0,
    this.borderRadius = 4.0,
  });

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