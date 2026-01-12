import 'package:flutter/material.dart';

/// A custom app bar widget that provides consistent styling and behavior
/// throughout the application with additional customization options
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shape,
    this.centerTitle = true,
    this.titleSpacing,
    this.toolbarHeight = kToolbarHeight,
    this.bottom,
    this.showBackButton = false,
    this.onBackPressed,
    this.backButtonIcon = Icons.arrow_back,
  });
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool centerTitle;
  final double? titleSpacing;
  final double toolbarHeight;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final IconData? backButtonIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      shape: shape ?? theme.appBarTheme.shape,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      bottom: bottom,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    
    if (showBackButton) {
      return IconButton(
        icon: Icon(backButtonIcon),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// A sliver app bar with custom styling
class CustomSliverAppBar extends StatelessWidget {

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.flexibleSpace,
    this.bottom,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.expandedHeight,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.showBackButton = false,
    this.onBackPressed,
  });
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? expandedHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SliverAppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: _buildLeading(context),
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      pinned: pinned,
      floating: floating,
      snap: snap,
      expandedHeight: expandedHeight ?? 200.0,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      centerTitle: centerTitle,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    
    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    
    return null;
  }
}

/// An app bar with gradient background
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {

  const GradientAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    required this.gradient,
    this.centerTitle = true,
    this.toolbarHeight = kToolbarHeight,
    this.bottom,
    this.showBackButton = false,
    this.onBackPressed,
    this.foregroundColor,
  });
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Gradient gradient;
  final bool centerTitle;
  final double toolbarHeight;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: AppBar(
        title: titleWidget ?? (title != null ? Text(title!) : null),
        actions: actions,
        leading: _buildLeading(context),
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: centerTitle,
        toolbarHeight: toolbarHeight,
        bottom: bottom,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    
    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// A collapsible app bar with custom animations
class CollapsibleAppBar extends StatefulWidget {

  const CollapsibleAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.backgroundWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight = 200.0,
    this.pinned = true,
    this.floating = false,
    this.scrollController,
  });
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? backgroundWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final ScrollController? scrollController;

  @override
  State<CollapsibleAppBar> createState() => _CollapsibleAppBarState();
}

class _CollapsibleAppBarState extends State<CollapsibleAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    widget.scrollController?.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController != null) {
      final offset = widget.scrollController!.offset;
      final progress = (offset / widget.expandedHeight).clamp(0.0, 1.0);
      _controller.animateTo(progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomSliverAppBar(
      title: widget.title,
      titleWidget: widget.titleWidget,
      actions: widget.actions,
      leading: widget.leading,
      pinned: widget.pinned,
      floating: widget.floating,
      expandedHeight: widget.expandedHeight,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: 1.0 - _animation.value,
              child: widget.backgroundWidget ?? Container(
                color: widget.backgroundColor ?? theme.primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A search app bar with built-in search functionality
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {

  const SearchAppBar({
    super.key,
    this.title,
    this.hintText = 'Search...',
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.toolbarHeight = kToolbarHeight,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchController,
  });
  final String? title;
  final String? hintText;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double toolbarHeight;
  final void Function(String)? onSearchChanged;
  final void Function(String)? onSearchSubmitted;
  final TextEditingController? searchController;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _controller.clear();
    });
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: (widget.foregroundColor ?? theme.appBarTheme.foregroundColor)
                      ?.withValues(alpha: 0.7),
                ),
              ),
              style: TextStyle(
                color: widget.foregroundColor ?? theme.appBarTheme.foregroundColor,
              ),
              onChanged: widget.onSearchChanged,
              onSubmitted: widget.onSearchSubmitted,
            )
          : Text(widget.title ?? ''),
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _stopSearch,
            )
          : widget.leading,
      actions: _isSearching
          ? [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  if (widget.onSearchChanged != null) {
                    widget.onSearchChanged!('');
                  }
                },
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _startSearch,
              ),
              ...?widget.actions,
            ],
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      toolbarHeight: widget.toolbarHeight,
    );
  }
}