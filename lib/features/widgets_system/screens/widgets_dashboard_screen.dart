// lib/features/widgets_system/screens/widgets_dashboard_screen.dart
// شاشة نظام الودجت

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/widgets_providers.dart';
import '../models/widget_config.dart';

/// شاشة لوحة تحكم الودجت
class WidgetsDashboardScreen extends ConsumerWidget {
  const WidgetsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgetsAsync = ref.watch(activeWidgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام الودجت'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddWidgetDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showWidgetSettings(context, ref),
          ),
        ],
      ),
      body: widgetsAsync.when(
        data: (widgets) => _buildWidgetGrid(context, ref, widgets),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('خطأ في تحميل الودجت: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(activeWidgetsProvider),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetGrid(
    BuildContext context,
    WidgetRef ref,
    List<WidgetConfig> widgets,
  ) {
    if (widgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.widgets, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'لا توجد ودجت مفعلة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('اضغط على زر الإضافة لإنشاء ودجت جديدة'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showAddWidgetDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('إضافة ودجت'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(activeWidgetsProvider);
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          final widget = widgets[index];
          return _buildWidgetCard(context, ref, widget);
        },
      ),
    );
  }

  Widget _buildWidgetCard(
    BuildContext context,
    WidgetRef ref,
    WidgetConfig widget,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showWidgetDetails(context, ref, widget),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _getWidgetTypeIcon(widget.type),
                    size: 32,
                    color: _getWidgetTypeColor(widget.type),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleWidgetAction(context, ref, widget, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('تعديل'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'refresh',
                        child: ListTile(
                          leading: Icon(Icons.refresh),
                          title: Text('تحديث'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: widget.isEnabled ? 'disable' : 'enable',
                        child: ListTile(
                          leading: Icon(
                            widget.isEnabled
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          title: Text(
                            widget.isEnabled ? 'إلغاء التفعيل' : 'تفعيل',
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            'حذف',
                            style: TextStyle(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getWidgetSizeColor(widget.size).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getWidgetSizeName(widget.size),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getWidgetSizeColor(widget.size),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    widget.isEnabled
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: widget.isEnabled ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddWidgetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة ودجت جديدة'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: WidgetType.values.map((type) {
              return ListTile(
                leading: Icon(_getWidgetTypeIcon(type)),
                title: Text(_getWidgetTypeName(type)),
                subtitle: Text(_getWidgetTypeDescription(type)),
                onTap: () {
                  Navigator.of(context).pop();
                  _createWidget(context, ref, type);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _createWidget(
    BuildContext context,
    WidgetRef ref,
    WidgetType type,
  ) async {
    try {
      final now = DateTime.now();
      final widget = WidgetConfig(
        id: 'widget_${now.millisecondsSinceEpoch}',
        type: type,
        title: _getWidgetTypeName(type),
        size: WidgetSize.medium,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(widgetsServiceProvider).createWidget(widget);
      ref.refresh(activeWidgetsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إنشاء الودجت بنجاح')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في إنشاء الودجت: $e')));
      }
    }
  }

  void _handleWidgetAction(
    BuildContext context,
    WidgetRef ref,
    WidgetConfig widget,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _showWidgetDetails(context, ref, widget);
        break;
      case 'refresh':
        await ref.read(widgetsServiceProvider).refreshWidgetData(widget.id);
        ref.refresh(activeWidgetsProvider);
        break;
      case 'enable':
      case 'disable':
        widget.toggleEnabled();
        await ref.read(widgetsServiceProvider).updateWidget(widget);
        ref.refresh(activeWidgetsProvider);
        break;
      case 'delete':
        _confirmDeleteWidget(context, ref, widget);
        break;
    }
  }

  void _confirmDeleteWidget(
    BuildContext context,
    WidgetRef ref,
    WidgetConfig widget,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الودجت'),
        content: Text('هل أنت متأكد من حذف ودجت "${widget.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(widgetsServiceProvider).deleteWidget(widget.id);
              ref.refresh(activeWidgetsProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('تم حذف الودجت')));
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showWidgetDetails(
    BuildContext context,
    WidgetRef ref,
    WidgetConfig widget,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('النوع: ${_getWidgetTypeName(widget.type)}'),
            Text('الحجم: ${_getWidgetSizeName(widget.size)}'),
            Text('الحالة: ${widget.isEnabled ? "مفعل" : "غير مفعل"}'),
            Text('تاريخ الإنشاء: ${_formatDate(widget.createdAt)}'),
            Text('آخر تحديث: ${_formatDate(widget.updatedAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showWidgetSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعدادات الودجت'),
        content: const Text('ستتم إضافة إعدادات النظام قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  IconData _getWidgetTypeIcon(WidgetType type) {
    switch (type) {
      case WidgetType.habitProgress:
        return Icons.track_changes;
      case WidgetType.todayTasks:
        return Icons.today;
      case WidgetType.weeklyProgress:
        return Icons.bar_chart;
      case WidgetType.motivationalQuote:
        return Icons.format_quote;
      case WidgetType.streakCounter:
        return Icons.local_fire_department;
      case WidgetType.statisticsOverview:
        return Icons.analytics;
      case WidgetType.upcomingReminders:
        return Icons.notifications_active;
      case WidgetType.achievementsBadges:
        return Icons.emoji_events;
    }
  }

  Color _getWidgetTypeColor(WidgetType type) {
    switch (type) {
      case WidgetType.habitProgress:
        return Colors.green;
      case WidgetType.todayTasks:
        return Colors.blue;
      case WidgetType.weeklyProgress:
        return Colors.purple;
      case WidgetType.motivationalQuote:
        return Colors.orange;
      case WidgetType.streakCounter:
        return Colors.red;
      case WidgetType.statisticsOverview:
        return Colors.teal;
      case WidgetType.upcomingReminders:
        return Colors.amber;
      case WidgetType.achievementsBadges:
        return Colors.indigo;
    }
  }

  String _getWidgetTypeName(WidgetType type) {
    switch (type) {
      case WidgetType.habitProgress:
        return 'تقدم العادات';
      case WidgetType.todayTasks:
        return 'مهام اليوم';
      case WidgetType.weeklyProgress:
        return 'التقدم الأسبوعي';
      case WidgetType.motivationalQuote:
        return 'اقتباس تحفيزي';
      case WidgetType.streakCounter:
        return 'عداد السلاسل';
      case WidgetType.statisticsOverview:
        return 'نظرة عامة على الإحصائيات';
      case WidgetType.upcomingReminders:
        return 'التذكيرات القادمة';
      case WidgetType.achievementsBadges:
        return 'شارات الإنجازات';
    }
  }

  String _getWidgetTypeDescription(WidgetType type) {
    switch (type) {
      case WidgetType.habitProgress:
        return 'عرض تقدم العادات اليومية';
      case WidgetType.todayTasks:
        return 'قائمة مهام اليوم';
      case WidgetType.weeklyProgress:
        return 'إحصائيات الأسبوع الحالي';
      case WidgetType.motivationalQuote:
        return 'اقتباسات تحفيزية يومية';
      case WidgetType.streakCounter:
        return 'عداد السلاسل المتتالية';
      case WidgetType.statisticsOverview:
        return 'ملخص الإحصائيات العامة';
      case WidgetType.upcomingReminders:
        return 'التذكيرات والمواعيد القادمة';
      case WidgetType.achievementsBadges:
        return 'الإنجازات والشارات المحققة';
    }
  }

  Color _getWidgetSizeColor(WidgetSize size) {
    switch (size) {
      case WidgetSize.small:
        return Colors.green;
      case WidgetSize.medium:
        return Colors.orange;
      case WidgetSize.large:
        return Colors.red;
    }
  }

  String _getWidgetSizeName(WidgetSize size) {
    switch (size) {
      case WidgetSize.small:
        return 'صغير';
      case WidgetSize.medium:
        return 'متوسط';
      case WidgetSize.large:
        return 'كبير';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
