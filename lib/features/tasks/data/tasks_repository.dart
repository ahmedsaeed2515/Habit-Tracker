import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/task_models.dart';

class TasksRepository {
  static const String boxName = 'tasks_v1';
  final Uuid _uuid = const Uuid();

  Future<Box> _openBox() => Hive.openBox(boxName);

  Future<SimpleTask> create(String title, {String? notes}) async {
    final box = await _openBox();
    final id = _uuid.v4();
    final t = SimpleTask(
      id: id,
      title: title,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await box.put(id, t.toMap());
    return t;
  }

  Future<Subtask> addSubtask(String taskId, String title) async {
    final box = await _openBox();
    final data = box.get(taskId);
    if (data == null) throw Exception('Task not found');
    final task = SimpleTask.fromMap(Map<dynamic, dynamic>.from(data as Map));
    final subId = _uuid.v4();
    final sub = Subtask(id: subId, title: title);
    final updated = SimpleTask(
      id: task.id,
      title: task.title,
      notes: task.notes,
      completed: task.completed,
      subtasks: [...task.subtasks, sub],
      tags: task.tags,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
    );
    await box.put(taskId, updated.toMap());
    return sub;
  }

  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    final box = await _openBox();
    final data = box.get(taskId);
    if (data == null) return;
    final task = SimpleTask.fromMap(Map<dynamic, dynamic>.from(data as Map));
    final updatedSubs = task.subtasks
        .map(
          (s) => s.id == subtaskId
              ? Subtask(id: s.id, title: s.title, completed: !s.completed)
              : s,
        )
        .toList();
    final updated = SimpleTask(
      id: task.id,
      title: task.title,
      notes: task.notes,
      completed: task.completed,
      subtasks: updatedSubs,
      tags: task.tags,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
    );
    await box.put(taskId, updated.toMap());
  }

  Future<void> deleteMany(List<String> ids) async {
    final box = await _openBox();
    await box.deleteAll(ids);
  }

  Future<void> markManyComplete(
    List<String> ids, {
    bool complete = true,
  }) async {
    final box = await _openBox();
    for (final id in ids) {
      final data = box.get(id);
      if (data == null) continue;
      final item = SimpleTask.fromMap(Map<dynamic, dynamic>.from(data as Map));
      final updated = SimpleTask(
        id: item.id,
        title: item.title,
        notes: item.notes,
        completed: complete,
        subtasks: item.subtasks,
        tags: item.tags,
        dueDate: item.dueDate,
        createdAt: item.createdAt,
      );
      await box.put(id, updated.toMap());
    }
  }

  Future<List<SimpleTask>> getAll() async {
    final box = await _openBox();
    final list = box.values
        .map((e) => SimpleTask.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
    return list;
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<SimpleTask> update(SimpleTask task) async {
    final box = await _openBox();
    await box.put(task.id, task.toMap());
    return task;
  }
}
