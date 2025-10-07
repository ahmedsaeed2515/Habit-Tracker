import 'package:flutter/foundation.dart';

@immutable
class Subtask {
  final String id;
  final String title;
  final bool completed;

  const Subtask({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'completed': completed,
  };
  factory Subtask.fromMap(Map<dynamic, dynamic> m) => Subtask(
    id: m['id'] as String,
    title: m['title'] as String,
    completed: m['completed'] as bool? ?? false,
  );
}

@immutable
class SimpleTask {
  final String id;
  final String title;
  final String? notes;
  final bool completed;
  final List<Subtask> subtasks;
  final List<String> tags;
  final DateTime? dueDate;
  final DateTime createdAt;

  const SimpleTask({
    required this.id,
    required this.title,
    this.notes,
    this.completed = false,
    this.subtasks = const [],
    this.tags = const [],
    this.dueDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'notes': notes,
    'completed': completed,
    'subtasks': subtasks.map((s) => s.toMap()).toList(),
    'tags': tags,
    'dueDate': dueDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory SimpleTask.fromMap(Map<dynamic, dynamic> m) => SimpleTask(
    id: m['id'] as String,
    title: m['title'] as String,
    notes: m['notes'] as String?,
    completed: m['completed'] as bool? ?? false,
    subtasks:
        (m['subtasks'] as List<dynamic>?)
            ?.map((e) => Subtask.fromMap(Map<dynamic, dynamic>.from(e as Map)))
            .toList() ??
        [],
    tags: List<String>.from(m['tags'] ?? <String>[]),
    dueDate: m['dueDate'] != null
        ? DateTime.parse(m['dueDate'] as String)
        : null,
    createdAt: DateTime.parse(m['createdAt'] as String),
  );
}
