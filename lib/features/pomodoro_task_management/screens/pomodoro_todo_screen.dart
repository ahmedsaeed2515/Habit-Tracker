import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';
import '../widgets/pomodoro_timer_widget.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/quick_stats_widget.dart';
import '../widgets/pomodoro_fab.dart';
import 'task_details_screen.dart';
import 'pomodoro_settings_screen.dart';
import 'analytics_screen.dart';

/// شاشة To-Do List الرئيسية مع نظام Pomodoro متكامل
class PomodoroTodoScreen extends ConsumerStatefulWidget {
  const PomodoroTodoScreen({super.key});

  @override
  ConsumerState<PomodoroTodoScreen> createState() => _PomodoroTodoScreenState();
}

class _PomodoroTodoScreenState extends ConsumerState<PomodoroTodoScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isCompactView = false;
  bool _showCompleted = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimationController.forward();
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Timer and Quick Stats (Fixed Height)
            _buildHeader(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search and Filter Bar
                    _buildSearchAndFilterBar(),

                    // Task List (with minimum height)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: _buildTaskList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const PomodoroFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildHeader() {
    final activeSession = ref.watch(activeSessionProvider);
    final stats = ref.watch(pomodoroStatsProvider);
    final analysis = ref.watch(productivityAnalysisProvider);

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _headerAnimationController,
              curve: Curves.easeOutBack,
            ),
          ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.6),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Greeting and Settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'لنبدأ يوماً منتجاً! 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnalyticsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.analytics, color: Colors.white),
                      tooltip: 'الإحصائيات',
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PomodoroSettingsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.settings, color: Colors.white),
                      tooltip: 'الإعدادات',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Active Timer or Quick Stats
            if (activeSession != null)
              PomodoroTimerWidget(session: activeSession)
            else
              QuickStatsWidget(stats: stats, analysis: analysis),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return FadeTransition(
      opacity: _headerAnimationController,
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
              },
              suffixIcon: _searchQuery.isNotEmpty ? Icons.clear : null,
              onSuffixIconPressed: _searchQuery.isNotEmpty
                  ? () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    }
                  : null,
            ),

            const SizedBox(height: 12),

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
                          // تصفية المهام المستحقة اليوم
                          ref.read(dueTodayTasksProvider);
                          // يمكن تطبيق منطق أكثر تعقيداً هنا
                        }),
                        _buildFilterChip('متأخرة', false, () {
                          // تصفية المهام المتأخرة
                          ref.read(overdueTasksProvider);
                        }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // View Toggle
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isCompactView = !_isCompactView;
                    });
                  },
                  icon: Icon(
                    _isCompactView ? Icons.view_agenda : Icons.view_compact,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: _isCompactView ? 'عرض مفصل' : 'عرض مضغوط',
                ),

                // Show Completed Toggle
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showCompleted = !_showCompleted;
                    });
                  },
                  icon: Icon(
                    _showCompleted ? Icons.visibility : Icons.visibility_off,
                    color: _showCompleted
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  tooltip: _showCompleted ? 'إخفاء المكتملة' : 'عرض المكتملة',
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
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.transparent,
        selectedColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer(
      builder: (context, ref, child) {
        final filteredTasks = ref.watch(filteredTasksProvider);
        final overdueCount = ref.watch(overdueTasksProvider).length;

        // تصفية بناء على البحث
        final searchFilteredTasks = _searchQuery.isEmpty
            ? filteredTasks
            : filteredTasks
                  .where(
                    (task) =>
                        task.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        (task.description?.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ??
                            false),
                  )
                  .toList();

        // تصفية المهام المكتملة
        final displayTasks = _showCompleted
            ? searchFilteredTasks
            : searchFilteredTasks
                  .where((task) => task.status != TaskStatus.completed)
                  .toList();

        if (displayTasks.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // Overdue Tasks Alert
            if (overdueCount > 0) _buildOverdueAlert(overdueCount),

            // Tasks List
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: displayTasks.length,
                  itemBuilder: (context, index) {
                    final task = displayTasks[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TaskItemWidget(
                              task: task,
                              isCompact: _isCompactView,
                              onTap: () => _navigateToTaskDetails(task),
                              onComplete: () => _completeTask(task.id),
                              onStartPomodoro: () =>
                                  _startPomodoroForTask(task),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverdueAlert(int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'لديك $count مهام متأخرة تحتاج اهتمام!',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // تصفية المهام المتأخرة
              setState(() {
                _searchQuery = '';
              });
              ref.read(taskFilterProvider.notifier).resetFilter();
              // يمكن إضافة فلتر خاص للمهام المتأخرة
            },
            child: Text('عرض', style: TextStyle(color: Colors.red.shade600)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'لا توجد مهام تطابق البحث'
                : 'لا توجد مهام حتى الآن',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'جرب مصطلح بحث مختلف'
                : 'اضغط على + لإضافة مهمة جديدة',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            CustomButton(
              text: 'إضافة مهمة جديدة',
              onPressed: _showAddTaskDialog,
              icon: Icons.add,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      elevation: 8,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side - Quick Actions
            Row(
              children: [
                IconButton(
                  onPressed: _showAddTaskDialog,
                  icon: const Icon(Icons.add_task),
                  tooltip: 'إضافة مهمة',
                ),
                IconButton(
                  onPressed: _showQuickActionsMenu,
                  icon: const Icon(Icons.bolt),
                  tooltip: 'إجراءات سريعة',
                ),
              ],
            ),

            // Right Side - Views
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // عرض التقويم
                  },
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'التقويم',
                ),
                IconButton(
                  onPressed: () {
                    // عرض الإنجازات
                  },
                  icon: const Icon(Icons.emoji_events),
                  tooltip: 'الإنجازات',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير! ☀️';
    } else if (hour < 17) {
      return 'مساء الخير! 🌤️';
    } else {
      return 'مساء الخير! 🌙';
    }
  }

  void _navigateToTaskDetails(AdvancedTask task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(taskId: task.id),
      ),
    );
  }

  void _completeTask(String taskId) {
    ref.read(advancedTasksProvider.notifier).completeTask(taskId);

    // إظهار رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم إكمال المهمة! 🎉'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            // تراجع عن الإكمال
          },
        ),
      ),
    );
  }

  void _startPomodoroForTask(AdvancedTask task) {
    ref
        .read(activeSessionProvider.notifier)
        .startSession(type: SessionType.focus, taskId: task.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم بدء جلسة Pomodoro! 🍅'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTaskBottomSheet(),
      ),
    );
  }

  void _showQuickActionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const QuickActionsBottomSheet(),
    );
  }
}

/// شاشة إضافة مهمة سريعة
class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  ConsumerState<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  Duration? _estimatedDuration;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إضافة مهمة جديدة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Title Field
          CustomTextField(
            controller: _titleController,
            hintText: 'عنوان المهمة *',
            prefixIcon: Icons.task,
          ),

          const SizedBox(height: 16),

          // Description Field
          CustomTextField(
            controller: _descriptionController,
            hintText: 'وصف المهمة (اختياري)',
            prefixIcon: Icons.description,
            maxLines: 3,
          ),

          const SizedBox(height: 16),

          // Priority Selector
          Text('الأولوية', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: TaskPriority.values.map((priority) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_getPriorityText(priority)),
                    selected: _priority == priority,
                    onSelected: (_) => setState(() => _priority = priority),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Due Date and Duration
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_dueDate == null ? 'تحديد موعد' : 'موعد الإنجاز'),
                  subtitle: _dueDate == null
                      ? null
                      : Text(
                          '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                        ),
                  onTap: _selectDueDate,
                  dense: true,
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.timer),
                  title: Text(
                    _estimatedDuration == null ? 'تقدير الوقت' : 'الوقت المقدر',
                  ),
                  subtitle: _estimatedDuration == null
                      ? null
                      : Text('${_estimatedDuration!.inMinutes} دقيقة'),
                  onTap: _selectDuration,
                  dense: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _titleController.text.isEmpty ? null : _addTask,
                  child: const Text('إضافة المهمة'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return 'عاجل';
      case TaskPriority.high:
        return 'عالي';
      case TaskPriority.medium:
        return 'متوسط';
      case TaskPriority.low:
        return 'منخفض';
    }
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  Future<void> _selectDuration() async {
    final duration = await showDialog<Duration>(
      context: context,
      builder: (context) => const DurationPickerDialog(),
    );
    if (duration != null) {
      setState(() => _estimatedDuration = duration);
    }
  }

  Future<void> _addTask() async {
    if (_titleController.text.isEmpty) return;

    await ref
        .read(advancedTasksProvider.notifier)
        .createTask(
          title: _titleController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          priority: _priority,
          dueDate: _dueDate,
          estimatedDuration: _estimatedDuration,
        );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إضافة المهمة بنجاح! ✅')));
    }
  }
}

/// حوار اختيار المدة
class DurationPickerDialog extends StatefulWidget {
  const DurationPickerDialog({super.key});

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  int _hours = 0;
  int _minutes = 25;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تقدير الوقت المطلوب'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Hours
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('ساعات'),
              SizedBox(
                width: 60,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _hours = int.tryParse(value) ?? 0;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                ),
              ),
            ],
          ),

          // Minutes
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('دقائق'),
              SizedBox(
                width: 60,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: '25'),
                  onChanged: (value) {
                    _minutes = int.tryParse(value) ?? 25;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '25',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final duration = Duration(hours: _hours, minutes: _minutes);
            Navigator.pop(context, duration);
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

/// شاشة الإجراءات السريعة
class QuickActionsBottomSheet extends ConsumerWidget {
  const QuickActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'إجراءات سريعة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.flash_on, color: Colors.orange),
            title: const Text('جلسة تركيز سريعة'),
            subtitle: const Text('بدء جلسة 25 دقيقة'),
            onTap: () {
              Navigator.pop(context);
              ref
                  .read(activeSessionProvider.notifier)
                  .startSession(type: SessionType.focus);
            },
          ),

          ListTile(
            leading: const Icon(Icons.coffee, color: Colors.brown),
            title: const Text('استراحة قصيرة'),
            subtitle: const Text('بدء استراحة 5 دقائق'),
            onTap: () {
              Navigator.pop(context);
              ref
                  .read(activeSessionProvider.notifier)
                  .startSession(type: SessionType.shortBreak);
            },
          ),

          ListTile(
            leading: const Icon(Icons.checklist, color: Colors.green),
            title: const Text('إكمال جميع المهام السهلة'),
            subtitle: const Text('إكمال المهام ذات الأولوية المنخفضة'),
            onTap: () {
              Navigator.pop(context);
              _completeEasyTasks(ref);
            },
          ),

          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.blue),
            title: const Text('جدولة المهام تلقائياً'),
            subtitle: const Text('ترتيب المهام بناء على AI'),
            onTap: () {
              Navigator.pop(context);
              _scheduleTasksWithAI(ref);
            },
          ),
        ],
      ),
    );
  }

  void _completeEasyTasks(WidgetRef ref) {
    // منطق إكمال المهام السهلة
    final tasks = ref.read(advancedTasksProvider);
    final easyTasks = tasks
        .where(
          (t) =>
              t.priority == TaskPriority.low &&
              t.estimatedDuration != null &&
              t.estimatedDuration!.inMinutes <= 10,
        )
        .toList();

    for (final task in easyTasks) {
      ref.read(advancedTasksProvider.notifier).completeTask(task.id);
    }
  }

  void _scheduleTasksWithAI(WidgetRef ref) {
    // منطق جدولة المهام باستخدام AI
    // هذا مكان لتطبيق خوارزمية ذكية لترتيب المهام
  }
}
