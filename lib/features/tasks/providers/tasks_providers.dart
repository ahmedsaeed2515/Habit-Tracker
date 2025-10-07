import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tasks_repository.dart';
import '../models/task_models.dart';

final tasksRepoProvider = Provider<TasksRepository>((ref) => TasksRepository());

final tasksListProvider =
    StateNotifierProvider<TasksListNotifier, List<SimpleTask>>(
      (ref) => TasksListNotifier(ref.read(tasksRepoProvider)),
    );

class TasksListNotifier extends StateNotifier<List<SimpleTask>> {
  TasksListNotifier(this._repo) : super([]) {
    _load();
  }

  final TasksRepository _repo;
  // selection state for bulk actions
  final Set<String> _selected = {};
  String _filterQuery = '';

  Future<void> _load() async {
    final items = await _repo.getAll();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  // Filters
  void applyFilter(String query) {
    _filterQuery = query.trim().toLowerCase();
    _refreshView();
  }

  void _refreshView() {
    if (_filterQuery.isEmpty) {
      _load();
      return;
    }
    final filtered = state.where((t) {
      return t.title.toLowerCase().contains(_filterQuery) ||
          (t.notes ?? '').toLowerCase().contains(_filterQuery) ||
          t.tags.any((tag) => tag.toLowerCase().contains(_filterQuery));
    }).toList();
    state = filtered;
  }

  // Selection for bulk
  void toggleSelect(String id) {
    if (_selected.contains(id)) {
      _selected.remove(id);
    } else {
      _selected.add(id);
    }
    // notify UI (we keep state list unchanged but users will query selection set via getter)
    state = List.from(state);
  }

  String get filterQuery => _filterQuery;

  void clearSelection() {
    _selected.clear();
    state = List.from(state);
  }

  Set<String> get selectedIds => Set.unmodifiable(_selected);

  // CRUD
  Future<void> add(
    String title, {
    String? notes,
    List<String> tags = const [],
    DateTime? dueDate,
  }) async {
    final newT = await _repo.create(title, notes: notes);
    // attach tags/dueDate via update for now
    final updated = SimpleTask(
      id: newT.id,
      title: newT.title,
      notes: newT.notes,
      completed: newT.completed,
      subtasks: newT.subtasks,
      tags: tags,
      dueDate: dueDate,
      createdAt: newT.createdAt,
    );
    await _repo.update(updated);
    state = [updated, ...state];
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    _selected.remove(id);
    state = state.where((e) => e.id != id).toList();
  }

  Future<void> toggleComplete(String id) async {
    final t = state.firstWhere((e) => e.id == id);
    final updated = SimpleTask(
      id: t.id,
      title: t.title,
      notes: t.notes,
      completed: !t.completed,
      subtasks: t.subtasks,
      tags: t.tags,
      dueDate: t.dueDate,
      createdAt: t.createdAt,
    );
    await _repo.update(updated);
    state = state.map((e) => e.id == id ? updated : e).toList();
  }

  // Subtasks
  Future<void> addSubtask(String taskId, Subtask subtask) async {
    final t = state.firstWhere((e) => e.id == taskId);
    final updated = SimpleTask(
      id: t.id,
      title: t.title,
      notes: t.notes,
      completed: t.completed,
      subtasks: [...t.subtasks, subtask],
      tags: t.tags,
      dueDate: t.dueDate,
      createdAt: t.createdAt,
    );
    await _repo.update(updated);
    state = state.map((e) => e.id == taskId ? updated : e).toList();
  }

  Future<void> toggleSubtaskComplete(String taskId, String subtaskId) async {
    final t = state.firstWhere((e) => e.id == taskId);
    final newSubtasks = t.subtasks
        .map(
          (s) => s.id == subtaskId
              ? Subtask(id: s.id, title: s.title, completed: !s.completed)
              : s,
        )
        .toList();
    final updated = SimpleTask(
      id: t.id,
      title: t.title,
      notes: t.notes,
      completed: t.completed,
      subtasks: newSubtasks,
      tags: t.tags,
      dueDate: t.dueDate,
      createdAt: t.createdAt,
    );
    await _repo.update(updated);
    state = state.map((e) => e.id == taskId ? updated : e).toList();
  }

  // Bulk actions
  Future<void> bulkDeleteSelected() async {
    final ids = selectedIds.toList();
    if (ids.isEmpty) return;
    await _repo.deleteMany(ids);
    _selected.clear();
    state = state.where((e) => !ids.contains(e.id)).toList();
  }

  Future<void> bulkMarkCompleteSelected({bool complete = true}) async {
    final ids = selectedIds.toList();
    if (ids.isEmpty) return;
    await _repo.markManyComplete(ids, complete: complete);
    _selected.clear();
    // update local state
    state = state
        .map(
          (e) => ids.contains(e.id)
              ? SimpleTask(
                  id: e.id,
                  title: e.title,
                  notes: e.notes,
                  completed: complete,
                  subtasks: e.subtasks,
                  tags: e.tags,
                  dueDate: e.dueDate,
                  createdAt: e.createdAt,
                )
              : e,
        )
        .toList();
  }
}
