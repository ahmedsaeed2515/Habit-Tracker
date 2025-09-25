// lib/core/models/task.dart
// نموذج المهام الذكية مع الألواح والأوراق

import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 8)
class TaskSheet extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String color;

  @HiveField(4)
  List<Task> tasks;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime lastModified;

  @HiveField(7)
  bool isActive;

  TaskSheet({
    required this.id,
    required this.name,
    this.description = '',
    this.color = '#2196F3',
    required this.tasks,
    required this.createdAt,
    required this.lastModified,
    this.isActive = true,
  });

  // حساب إحصائيات الورقة
  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((task) => task.isCompleted).length;
  int get pendingTasks =>
      tasks.where((task) => !task.isCompleted && !task.isOverdue).length;
  int get overdueTasks => tasks.where((task) => task.isOverdue).length;

  double get completionPercentage {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks * 100);
  }

  TaskSheet copyWith({
    String? name,
    String? description,
    String? color,
    List<Task>? tasks,
    DateTime? lastModified,
    bool? isActive,
  }) {
    return TaskSheet(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt,
      lastModified: lastModified ?? DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }
}

@HiveType(typeId: 9)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String sheetId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  TaskPriority priority;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  TaskStatus status;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime lastModified;

  @HiveField(10)
  bool isCompleted;

  @HiveField(11)
  DateTime? completedAt;

  @HiveField(12)
  String? notes;

  @HiveField(13)
  List<SubTask> subTasks;

  @HiveField(14)
  int sortOrder;

  Task({
    required this.id,
    required this.sheetId,
    required this.title,
    this.description = '',
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.tags = const [],
    this.status = TaskStatus.pending,
    required this.createdAt,
    required this.lastModified,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
    this.subTasks = const [],
    this.sortOrder = 0,
  });

  // التحقق من انتهاء الموعد النهائي
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  // حساب نسبة إنجاز المهام الفرعية
  double get subTaskProgress {
    if (subTasks.isEmpty) return 0.0;
    final completed = subTasks.where((sub) => sub.isCompleted).length;
    return (completed / subTasks.length * 100);
  }

  // حساب أيام متبقية للموعد النهائي
  int get daysUntilDue {
    if (dueDate == null) return 0;
    final difference = dueDate!.difference(DateTime.now()).inDays;
    return difference;
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    List<String>? tags,
    TaskStatus? status,
    DateTime? lastModified,
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
    List<SubTask>? subTasks,
    int? sortOrder,
  }) {
    return Task(
      id: id,
      sheetId: sheetId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      createdAt: createdAt,
      lastModified: lastModified ?? DateTime.now(),
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      subTasks: subTasks ?? this.subTasks,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

@HiveType(typeId: 10)
class SubTask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String title;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  int sortOrder;

  SubTask({
    required this.id,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.sortOrder = 0,
  });

  SubTask copyWith({String? title, bool? isCompleted, int? sortOrder}) {
    return SubTask(
      id: id,
      taskId: taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

@HiveType(typeId: 11)
enum TaskPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,

  @HiveField(3)
  urgent,
}

@HiveType(typeId: 12)
enum TaskStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,

  @HiveField(3)
  cancelled,

  @HiveField(4)
  onHold,
}
