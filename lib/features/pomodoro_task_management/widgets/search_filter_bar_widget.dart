// lib/features/pomodoro_task_management/widgets/search_filter_bar_widget.dart
// ويدجت شريط البحث والتصفية

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/custom_text_field.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// ويدجت شريط البحث والتصفية
class SearchFilterBarWidget extends ConsumerStatefulWidget {
  const SearchFilterBarWidget({
    super.key,
    required this.animationController,
    this.onSearchChanged,
    this.onShowCompletedChanged,
    this.onViewModeChanged,
  });

  final AnimationController animationController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<bool>? onShowCompletedChanged;
  final ValueChanged<bool>? onViewModeChanged;

  @override
  ConsumerState<SearchFilterBarWidget> createState() =>
      _SearchFilterBarWidgetState();
}

class _SearchFilterBarWidgetState extends ConsumerState<SearchFilterBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showCompleted = false;
  bool _isCompactView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animationController,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            CustomTextField(
              controller: _searchController,
              hintText: 'البحث في المهام...',
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                widget.onSearchChanged?.call(value);
              },
              suffixIcon: _searchQuery.isNotEmpty ? Icons.clear : null,
              onSuffixIconPressed: _searchQuery.isNotEmpty
                  ? () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                      widget.onSearchChanged?.call('');
                    }
                  : null,
            ),

            const const SizedBox(height: 12),

            // Filter and View Options
            Row(
              children: [
                // Quick Filters
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'الكل',
                          true,
                          () => ref
                              .read(taskFilterProvider.notifier)
                              .resetFilter(),
                        ),
                        _buildFilterChip(
                          'عالي الأولوية',
                          false,
                          () => ref
                              .read(taskFilterProvider.notifier)
                              .updatePriority(TaskPriority.high),
                        ),
                        _buildFilterChip('مستحقة اليوم', false, () {
                          ref.read(taskFilterProvider.notifier).updateDueDate(
                                DateTime.now(),
                              );
                        }),
                      ],
                    ),
                  ),
                ),

                const const SizedBox(width: 8),

                // View Mode Toggles
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isCompactView ? Icons.view_list : Icons.view_agenda,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _isCompactView = !_isCompactView;
                          });
                          widget.onViewModeChanged?.call(_isCompactView);
                        },
                        tooltip: _isCompactView ? 'العرض العادي' : 'العرض المدمج',
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Theme.of(context).dividerColor,
                      ),
                      IconButton(
                        icon: Icon(
                          _showCompleted
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _showCompleted = !_showCompleted;
                          });
                          widget.onShowCompletedChanged?.call(_showCompleted);
                        },
                        tooltip: _showCompleted
                            ? 'إخفاء المكتملة'
                            : 'إظهار المكتملة',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
