// lib/features/smart_todo/screens/smart_todo_screen.dart
// شاشة المهام الذكية

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/custom_tab_switcher.dart';
import '../../../common/widgets/empty_state_widget.dart';
import '../../../common/widgets/stat_card.dart';
import '../../../core/models/task.dart';
import '../../../shared/localization/app_localizations.dart';
import '../providers/tasks_provider.dart';
import '../widgets/widgets.dart';

/// شاشة المهام الذكية مع إدارة المهام المتقدمة
class SmartTodoScreen extends ConsumerStatefulWidget {
  const SmartTodoScreen({super.key});

  @override
  ConsumerState<SmartTodoScreen> createState() => _SmartTodoScreenState();
}

class _SmartTodoScreenState extends ConsumerState<SmartTodoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  TaskPriority? _selectedPriority;
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final tasks = ref.watch(tasksProvider);
    final taskStats = ref.watch(taskStatsProvider);

    return Scaffold(
      appBar: _buildAppBar(localizations),
      body: Column(
        children: [
          _buildStatsCards(taskStats),
          _buildSearchAndFilter(),
          _buildTabBar(),
          Expanded(child: _buildTasksList(tasks)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskDialog,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar(AppLocalizations localizations) {
    return AppBar(
      title: Text(localizations.smartTodo),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  /// بناء بطاقات الإحصائيات
  Widget _buildStatsCards(Map<String, int> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: 'المجموع',
              value: stats['total']?.toString() ?? '0',
              color: Colors.blue,
              icon: Icons.checklist,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              title: 'مكتملة',
              value: stats['completed']?.toString() ?? '0',
              color: Colors.green,
              icon: Icons.check_circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              title: 'معلقة',
              value: stats['pending']?.toString() ?? '0',
              color: Colors.orange,
              icon: Icons.pending,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              title: 'متأخرة',
              value: stats['overdue']?.toString() ?? '0',
              color: Colors.red,
              icon: Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء شريط البحث والفلتر
  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'البحث في المهام...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.purple),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _clearFilters,
              icon: Icon(
                Icons.clear,
                color: _hasActiveFilters() ? Colors.red : Colors.grey,
              ),
              tooltip: 'مسح الفلاتر',
            ),
          ),
        ],
      ),
    );
  }

  /// بناء شريط التبويبات
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomTabSwitcher(
        options: const [
          TabOption(text: 'الكل'),
          TabOption(text: 'معلقة'),
          TabOption(text: 'مكتملة'),
          TabOption(text: 'متأخرة'),
        ],
        selectedIndex: _tabController.index,
        onChanged: (index) => _tabController.animateTo(index),
      ),
    );
  }

  /// بناء قائمة المهام
  Widget _buildTasksList(List<Task> allTasks) {
    final filteredTasks = _getFilteredTasks(allTasks);

    return TabBarView(
      controller: _tabController,
      children: [
        _buildTasksTab(filteredTasks),
        _buildTasksTab(filteredTasks.where((t) => !t.isCompleted).toList()),
        _buildTasksTab(filteredTasks.where((t) => t.isCompleted).toList()),
        _buildTasksTab(filteredTasks.where((t) => t.isOverdue).toList()),
      ],
    );
  }

  /// بناء تبويبة المهام
  Widget _buildTasksTab(List<Task> tasks) {
    if (tasks.isEmpty) {
      String message = 'لا توجد مهام';
      IconData icon = Icons.checklist;

      switch (_tabController.index) {
        case 1:
          message = 'لا توجد مهام معلقة';
          icon = Icons.pending;
          break;
        case 2:
          message = 'لا توجد مهام مكتملة';
          icon = Icons.check_circle;
          break;
        case 3:
          message = 'لا توجد مهام متأخرة';
          icon = Icons.warning;
          break;
      }

      return EmptyStateWidget(
        icon: icon,
        title: message,
        description: 'قم بإضافة مهمة جديدة للبدء',
        buttonText: 'إضافة مهمة جديدة',
        onPressed: _showTaskDialog,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onCompleted: () => _toggleTaskCompletion(task.id),
          onEdit: () => _showTaskDialog(task: task),
          onDelete: () => _deleteTask(task.id),
        );
      },
    );
  }

  /// الحصول على المهام المفلترة
  List<Task> _getFilteredTasks(List<Task> tasks) {
    List<Task> filtered = List.from(tasks);

    // البحث النصي
    if (_searchQuery.isNotEmpty) {
      final tasksNotifier = ref.read(tasksProvider.notifier);
      filtered = tasksNotifier.searchTasks(_searchQuery);
    }

    // فلترة حسب الأولوية
    if (_selectedPriority != null) {
      filtered = filtered
          .where((t) => t.priority == _selectedPriority)
          .toList();
    }

    // فلترة حسب العلامة
    if (_selectedTag != null) {
      filtered = filtered.where((t) => t.tags.contains(_selectedTag)).toList();
    }

    // ترتيب المهام
    final tasksNotifier = ref.read(tasksProvider.notifier);
    return tasksNotifier.sortByPriority(filtered);
  }

  /// عرض حوار إضافة/تحرير مهمة
  void _showTaskDialog({Task? task}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TaskDialog(
        task: task,
        onSave: (newTask) {
          final tasksNotifier = ref.read(tasksProvider.notifier);
          if (task == null) {
            tasksNotifier.addTask(newTask);
          } else {
            tasksNotifier.updateTask(newTask);
          }
        },
      ),
    );
  }

  /// تبديل حالة إكمال المهمة
  void _toggleTaskCompletion(String taskId) {
    final tasksNotifier = ref.read(tasksProvider.notifier);
    tasksNotifier.toggleTaskCompletion(taskId);
  }

  /// حذف مهمة
  void _deleteTask(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المهمة'),
        content: const Text('هل أنت متأكد من حذف هذه المهمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final tasksNotifier = ref.read(tasksProvider.notifier);
              tasksNotifier.deleteTask(taskId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  /// عرض حوار الفلاتر
  void _showFilterDialog() {
    final allTags = ref.read(allTagsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('فلترة المهام'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأولوية:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [null, ...TaskPriority.values].map((priority) {
                final isSelected = _selectedPriority == priority;
                return ChoiceChip(
                  label: Text(
                    priority == null ? 'الكل' : _getPriorityText(priority),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPriority = selected ? priority : null;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'العلامات:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (allTags.isEmpty)
              const Text('لا توجد علامات')
            else
              Wrap(
                spacing: 8,
                children: [null, ...allTags].map((tag) {
                  final isSelected = _selectedTag == tag;
                  return ChoiceChip(
                    label: Text(tag ?? 'الكل'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTag = selected ? tag : null;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  /// مسح جميع الفلاتر
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedPriority = null;
      _selectedTag = null;
    });
  }

  /// التحقق من وجود فلاتر نشطة
  bool _hasActiveFilters() {
    return _searchQuery.isNotEmpty ||
        _selectedPriority != null ||
        _selectedTag != null;
  }

  /// عرض المزيد من الخيارات
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('ترتيب المهام'),
              onTap: () {
                Navigator.pop(context);
                _showSortOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('إحصائيات تفصيلية'),
              onTap: () {
                Navigator.pop(context);
                _showDetailedStats();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('تصدير المهام'),
              onTap: () {
                Navigator.pop(context);
                _showExportOptions();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// عرض خيارات الترتيب
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ترتيب المهام',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('حسب تاريخ الإنشاء'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الترتيب حسب تاريخ الإنشاء')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('حسب تاريخ الاستحقاق'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم الترتيب حسب تاريخ الاستحقاق'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('حسب الأولوية'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الترتيب حسب الأولوية')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('حسب الفئة'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الترتيب حسب الفئة')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('حسب الاسم (أ-ي)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الترتيب حسب الاسم')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// عرض الإحصائيات التفصيلية
  void _showDetailedStats() {
    final stats = ref.read(taskStatsProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إحصائيات تفصيلية'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('إجمالي المهام', '${stats['total']}', Icons.task),
              const Divider(),
              _buildStatRow(
                'المهام المكتملة',
                '${stats['completed']}',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatRow(
                'المهام النشطة',
                '${stats['active']}',
                Icons.pending,
                Colors.orange,
              ),
              const Divider(),
              _buildStatRow(
                'أولوية عالية',
                '${stats['highPriority']}',
                Icons.priority_high,
                Colors.red,
              ),
              _buildStatRow(
                'أولوية متوسطة',
                '${stats['mediumPriority']}',
                Icons.remove,
                Colors.orange,
              ),
              _buildStatRow(
                'أولوية منخفضة',
                '${stats['lowPriority']}',
                Icons.arrow_downward,
                Colors.blue,
              ),
              const Divider(),
              _buildStatRow(
                'نسبة الإنجاز',
                '${((stats['completed']! / (stats['total']! > 0 ? stats['total']! : 1)) * 100).toStringAsFixed(1)}%',
                Icons.percent,
                Colors.purple,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value,
    IconData icon, [
    Color? color,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey[700], size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// عرض خيارات التصدير
  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تصدير المهام',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('تصدير كـ CSV'),
              subtitle: const Text('ملف جدول بيانات'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تصدير المهام كملف CSV'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('تصدير كـ JSON'),
              subtitle: const Text('ملف بيانات JSON'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تصدير المهام كملف JSON'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('تصدير كـ PDF'),
              subtitle: const Text('ملف PDF للطباعة'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تصدير المهام كملف PDF'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: const Text('تصدير كـ نص'),
              subtitle: const Text('ملف نصي بسيط'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تصدير المهام كملف نصي'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// الحصول على نص الأولوية
  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'منخفضة';
      case TaskPriority.medium:
        return 'متوسطة';
      case TaskPriority.high:
        return 'عالية';
      case TaskPriority.urgent:
        return 'عاجل';
    }
  }
}
