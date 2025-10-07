// lib/common/mixins/search_mixin.dart
// Mixin لإضافة وظائف البحث لأي شاشة

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin SearchMixin<T extends StatefulWidget> on State<T> {
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  bool get hasSearchQuery => _searchQuery.isNotEmpty;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final newQuery = searchController.text.trim();
    if (newQuery != _searchQuery) {
      setState(() {
        _searchQuery = newQuery;
      });
      onSearchQueryChanged(_searchQuery);
    }
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    onSearchQueryChanged('');
  }

  // يجب تنفيذ هذه الطريقة في الـ widget المستخدم
  void onSearchQueryChanged(String query);

  // طريقة مساعدة لفلترة القوائم
  List<E> filterList<E>(
    List<E> items,
    String Function(E item) getSearchableText,
  ) {
    if (_searchQuery.isEmpty) {
      return items;
    }

    final query = _searchQuery.toLowerCase();
    return items.where((item) {
      final text = getSearchableText(item).toLowerCase();
      return text.contains(query);
    }).toList();
  }

  // طريقة مساعدة للبحث المتقدم (دعم البحث في حقول متعددة)
  List<E> advancedFilter<E>(
    List<E> items,
    List<String Function(E item)> getSearchableFields,
  ) {
    if (_searchQuery.isEmpty) {
      return items;
    }

    final query = _searchQuery.toLowerCase();
    return items.where((item) {
      return getSearchableFields.any((getField) {
        final fieldText = getField(item).toLowerCase();
        return fieldText.contains(query);
      });
    }).toList();
  }

  // بناء شريط البحث
  Widget buildSearchBar({
    required String hintText,
    Color? backgroundColor,
    Color? textColor,
    double? height,
    bool showClearButton = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: showClearButton && hasSearchQuery
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// Mixin للـ ConsumerStatefulWidget
mixin ConsumerSearchMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  bool get hasSearchQuery => _searchQuery.isNotEmpty;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final newQuery = searchController.text.trim();
    if (newQuery != _searchQuery) {
      setState(() {
        _searchQuery = newQuery;
      });
      onSearchQueryChanged(_searchQuery);
    }
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    onSearchQueryChanged('');
  }

  // يجب تنفيذ هذه الطريقة في الـ widget المستخدم
  void onSearchQueryChanged(String query);

  // طريقة مساعدة لفلترة القوائم
  List<E> filterList<E>(
    List<E> items,
    String Function(E item) getSearchableText,
  ) {
    if (_searchQuery.isEmpty) {
      return items;
    }

    final query = _searchQuery.toLowerCase();
    return items.where((item) {
      final searchableText = getSearchableText(item).toLowerCase();
      return searchableText.contains(query);
    }).toList();
  }

  // فلترة متقدمة للبحث في عدة حقول
  List<E> advancedFilter<E>(
    List<E> items,
    List<String Function(E item)> getSearchableFields,
  ) {
    if (_searchQuery.isEmpty) {
      return items;
    }

    final query = _searchQuery.toLowerCase();
    return items.where((item) {
      return getSearchableFields.any((getField) {
        final fieldValue = getField(item).toLowerCase();
        return fieldValue.contains(query);
      });
    }).toList();
  }

  // بناء شريط البحث
  Widget buildSearchBar({
    String? hintText,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: hintText ?? 'البحث...',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          suffixIcon: hasSearchQuery
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}