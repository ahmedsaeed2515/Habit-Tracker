import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/task.dart';

/// Provider لإدارة المهام
class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([]) {
    _loadTasks();
  }

  Box<Task>? _taskBox;

  /// تحميل المهام من Hive
  Future<void> _loadTasks() async {
    try {
      _taskBox = await Hive.openBox<Task>('tasks');
      state = _taskBox!.values.toList();
    } catch (e) {
      debugPrint('خطأ في تحميل المهام: $e');
    }
  }

  /// إضافة مهمة جديدة
  Future<void> addTask(Task task) async {
    try {
      await _taskBox?.put(task.id, task);
      state = [...state, task];
    } catch (e) {
      debugPrint('خطأ في إضافة المهمة: $e');
    }
  }

  /// تحديث مهمة موجودة
  Future<void> updateTask(Task updatedTask) async {
    try {
      await _taskBox?.put(updatedTask.id, updatedTask);
      state = state.map((task) {
        return task.id == updatedTask.id ? updatedTask : task;
      }).toList();
    } catch (e) {
      debugPrint('خطأ في تحديث المهمة: $e');
    }
  }

  /// حذف مهمة
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskBox?.delete(taskId);
      state = state.where((task) => task.id != taskId).toList();
    } catch (e) {
      debugPrint('خطأ في حذف المهمة: $e');
    }
  }

  /// تبديل حالة إكمال المهمة
  Future<void> toggleTaskCompletion(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    await updateTask(updatedTask);
  }

  /// الحصول على المهام حسب الحالة
  List<Task> getTasksByStatus(TaskStatus status) {
    return state.where((task) => task.status == status).toList();
  }

  /// الحصول على المهام المكتملة
  List<Task> getCompletedTasks() {
    return state.where((task) => task.isCompleted).toList();
  }

  /// الحصول على المهام المعلقة
  List<Task> getPendingTasks() {
    return state.where((task) => !task.isCompleted).toList();
  }

  /// الحصول على المهام المتأخرة
  List<Task> getOverdueTasks() {
    return state.where((task) => task.isOverdue).toList();
  }

  /// البحث في المهام
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return state;

    final lowercaseQuery = query.toLowerCase();
    return state.where((task) {
      return task.title.toLowerCase().contains(lowercaseQuery) ||
          task.description.toLowerCase().contains(lowercaseQuery) ||
          task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  /// فلترة المهام حسب الأولوية
  List<Task> filterByPriority(TaskPriority priority) {
    return state.where((task) => task.priority == priority).toList();
  }

  /// فلترة المهام حسب العلامات
  List<Task> filterByTag(String tag) {
    return state.where((task) => task.tags.contains(tag)).toList();
  }

  /// ترتيب المهام حسب الأولوية
  List<Task> sortByPriority(List<Task> tasks) {
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) {
      final priorityOrder = {
        TaskPriority.urgent: 4,
        TaskPriority.high: 3,
        TaskPriority.medium: 2,
        TaskPriority.low: 1,
      };
      return priorityOrder[b.priority]!.compareTo(priorityOrder[a.priority]!);
    });
    return sortedTasks;
  }

  /// ترتيب المهام حسب تاريخ الاستحقاق
  List<Task> sortByDueDate(List<Task> tasks) {
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sortedTasks;
  }

  /// ترتيب المهام حسب تاريخ الإنشاء
  List<Task> sortByCreatedDate(List<Task> tasks) {
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedTasks;
  }

  /// الحصول على إحصائيات المهام
  Map<String, int> getTaskStatistics() {
    return {
      'total': state.length,
      'completed': getCompletedTasks().length,
      'pending': getPendingTasks().length,
      'overdue': getOverdueTasks().length,
      'urgent': filterByPriority(TaskPriority.urgent).length,
      'high': filterByPriority(TaskPriority.high).length,
      'medium': filterByPriority(TaskPriority.medium).length,
      'low': filterByPriority(TaskPriority.low).length,
    };
  }

  /// الحصول على جميع العلامات المستخدمة
  List<String> getAllTags() {
    final allTags = <String>{};
    for (final task in state) {
      allTags.addAll(task.tags);
    }
    return allTags.toList()..sort();
  }
}

/// مزود المهام
final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});

/// مزود إحصائيات المهام
final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasksNotifier = ref.watch(tasksProvider.notifier);
  return tasksNotifier.getTaskStatistics();
});

/// مزود المهام المكتملة
final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isCompleted).toList();
});

/// مزود المهام المعلقة
final pendingTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => !task.isCompleted).toList();
});

/// مزود المهام المتأخرة
final overdueTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isOverdue).toList();
});

/// مزود جميع العلامات
final allTagsProvider = Provider<List<String>>((ref) {
  final tasksNotifier = ref.watch(tasksProvider.notifier);
  return tasksNotifier.getAllTags();
});
