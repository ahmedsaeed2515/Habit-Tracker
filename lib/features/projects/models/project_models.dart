// lib/features/projects/models/project_models.dart

import 'package:hive/hive.dart';

part 'project_models.g.dart';

/// Project model - typeId 263
@HiveType(typeId: 263)
class Project extends HiveObject {

  Project({
    required this.id,
    required this.name,
    this.description = '',
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.status = ProjectStatus.planning,
    this.progress = 0,
    this.tags = const [],
    this.colorHex,
    this.isArchived = false,
    this.phaseIds = const [],
    this.milestones = const [],
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime? endDate;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  ProjectStatus status;

  @HiveField(8)
  int progress; // 0-100

  @HiveField(9)
  List<String> tags;

  @HiveField(10)
  String? colorHex;

  @HiveField(11)
  bool isArchived;

  @HiveField(12)
  List<String> phaseIds; // References to ProjectPhase

  @HiveField(13)
  List<String> milestones;

  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProjectStatus? status,
    int? progress,
    List<String>? tags,
    String? colorHex,
    bool? isArchived,
    List<String>? phaseIds,
    List<String>? milestones,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      colorHex: colorHex ?? this.colorHex,
      isArchived: isArchived ?? this.isArchived,
      phaseIds: phaseIds ?? this.phaseIds,
      milestones: milestones ?? this.milestones,
    );
  }
}

/// Project status enum - typeId 264
@HiveType(typeId: 264)
enum ProjectStatus {
  @HiveField(0)
  planning,
  @HiveField(1)
  active,
  @HiveField(2)
  onHold,
  @HiveField(3)
  completed,
  @HiveField(4)
  cancelled,
}

/// ProjectPhase model - typeId 265
@HiveType(typeId: 265)
class ProjectPhase extends HiveObject { // References to ProjectTask

  ProjectPhase({
    required this.id,
    required this.projectId,
    required this.name,
    this.description = '',
    required this.startDate,
    this.endDate,
    required this.orderIndex,
    this.status = PhaseStatus.pending,
    this.taskIds = const [],
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String projectId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  int orderIndex;

  @HiveField(7)
  PhaseStatus status;

  @HiveField(8)
  List<String> taskIds;

  ProjectPhase copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? orderIndex,
    PhaseStatus? status,
    List<String>? taskIds,
  }) {
    return ProjectPhase(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      orderIndex: orderIndex ?? this.orderIndex,
      status: status ?? this.status,
      taskIds: taskIds ?? this.taskIds,
    );
  }
}

/// Phase status enum - typeId 266
@HiveType(typeId: 266)
enum PhaseStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
  @HiveField(3)
  blocked,
}

/// ProjectTask model - typeId 267
@HiveType(typeId: 267)
class ProjectTask extends HiveObject {

  ProjectTask({
    required this.id,
    required this.phaseId,
    required this.title,
    this.description = '',
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.assignedTo,
    this.dependencies = const [],
    this.estimatedHours = 0,
    this.actualHours = 0,
    this.tags = const [],
    this.attachments = const [],
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String phaseId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  DateTime? completedAt;

  @HiveField(7)
  TaskPriority priority;

  @HiveField(8)
  TaskStatus status;

  @HiveField(9)
  String? assignedTo;

  @HiveField(10)
  List<String> dependencies; // Task IDs that must be completed first

  @HiveField(11)
  int estimatedHours;

  @HiveField(12)
  int actualHours;

  @HiveField(13)
  List<String> tags;

  @HiveField(14)
  List<String> attachments;

  ProjectTask copyWith({
    String? id,
    String? phaseId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    TaskPriority? priority,
    TaskStatus? status,
    String? assignedTo,
    List<String>? dependencies,
    int? estimatedHours,
    int? actualHours,
    List<String>? tags,
    List<String>? attachments,
  }) {
    return ProjectTask(
      id: id ?? this.id,
      phaseId: phaseId ?? this.phaseId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      dependencies: dependencies ?? this.dependencies,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
    );
  }

  bool get isBlocked =>
      dependencies.isNotEmpty && status != TaskStatus.completed;
}

/// Task priority enum - typeId 268
@HiveType(typeId: 268)
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

/// Task status enum - typeId 269
@HiveType(typeId: 269)
enum TaskStatus {
  @HiveField(0)
  todo,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  review,
  @HiveField(3)
  completed,
  @HiveField(4)
  blocked,
}

/// Project view mode enum - typeId 270
@HiveType(typeId: 270)
enum ProjectViewMode {
  @HiveField(0)
  list,
  @HiveField(1)
  kanban,
  @HiveField(2)
  gantt,
  @HiveField(3)
  timeline,
}
