import 'package:flutter/material.dart';

/// A custom error widget that provides consistent error UI throughout the application
/// This file is named with a 'custom_' prefix to avoid conflicts with Flutter's built-in ErrorWidget
class CustomErrorWidget extends StatelessWidget {

  const CustomErrorWidget({
    super.key,
    this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.iconColor,
    this.messageStyle,
    this.padding = const EdgeInsets.all(16.0),
    this.showIcon = true,
  });
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final Color? iconColor;
  final TextStyle? messageStyle;
  final EdgeInsets? padding;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultMessage = message ?? 'An error occurred. Please try again.';

    return Padding(
      padding: padding!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && icon != null) ...[
            Icon(
              icon,
              size: 64.0,
              color: iconColor ?? theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            defaultMessage,
            style: messageStyle ?? theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryButtonText!),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A minimal error widget for inline error display
class InlineErrorWidget extends StatelessWidget {

  const InlineErrorWidget({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
    this.color,
    this.textStyle,
  });
  final String message;
  final IconData? icon;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = color ?? theme.colorScheme.error;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16.0,
            color: errorColor,
          ),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            message,
            style: textStyle ?? theme.textTheme.bodySmall?.copyWith(
              color: errorColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// A full-screen error widget for major application errors
class FullScreenErrorWidget extends StatelessWidget {

  const FullScreenErrorWidget({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.onRetry,
    this.onGoHome,
    this.retryButtonText = 'Try Again',
    this.homeButtonText = 'Go Home',
  });
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final String? retryButtonText;
  final String? homeButtonText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80.0,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              Column(
                children: [
                  if (onRetry != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: Text(retryButtonText!),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                    ),
                  if (onRetry != null && onGoHome != null)
                    const SizedBox(height: 16),
                  if (onGoHome != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onGoHome,
                        icon: const Icon(Icons.home),
                        label: Text(homeButtonText!),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An error boundary widget that catches and displays errors
class ErrorBoundary extends StatefulWidget {

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });
  final Widget child;
  final Widget Function(BuildContext context, FlutterErrorDetails error)? errorBuilder;
  final void Function(FlutterErrorDetails error)? onError;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  void initState() {
    super.initState();
    
    // Set up error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      if (widget.onError != null) {
        widget.onError!(details);
      }
      
      setState(() {
        _error = details;
      });
    };
  }

  void _retry() {
    setState(() {
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _error!);
      }
      
      return CustomErrorWidget(
        message: 'An unexpected error occurred',
        onRetry: _retry,
        retryButtonText: 'Try Again',
      );
    }
    
    return widget.child;
  }
}

/// A network error widget specifically for network-related errors
class NetworkErrorWidget extends StatelessWidget {

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });
  final VoidCallback? onRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      icon: Icons.wifi_off,
      message: customMessage ?? 'No internet connection. Please check your network and try again.',
      onRetry: onRetry,
    );
  }
}

/// A not found error widget for 404-style errors
class NotFoundErrorWidget extends StatelessWidget {

  const NotFoundErrorWidget({
    super.key,
    this.message,
    this.onGoBack,
    this.goBackButtonText = 'Go Back',
  });
  final String? message;
  final VoidCallback? onGoBack;
  final String? goBackButtonText;

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      icon: Icons.search_off,
      message: message ?? 'The requested content could not be found.',
      onRetry: onGoBack,
      retryButtonText: goBackButtonText,
    );
  }
}