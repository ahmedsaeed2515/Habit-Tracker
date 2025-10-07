// lib/features/notes/data/notes_repository.dart
// Repository لإدارة CRUD للملاحظات

import 'package:hive/hive.dart';
import '../models/note_models.dart';

class NotesRepository {
  NotesRepository._();
  factory NotesRepository() => _instance ??= NotesRepository._();
  static const String notesBoxName = 'notes_box';
  static NotesRepository? _instance;

  Box<Note>? _notesBox;

  Future<void> init() async {
    _notesBox ??= await Hive.openBox<Note>(notesBoxName);
  }

  Box<Note> get _box {
    if (_notesBox == null) {
      throw StateError('Notes box not initialized');
    }
    return _notesBox!;
  }

  Future<List<Note>> getAll({String? query, List<String>? tags}) async {
    final values = _box.values.toList();
    Iterable<Note> filtered = values;
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered.where(
        (n) =>
            n.title.toLowerCase().contains(q) ||
            n.content.toLowerCase().contains(q),
      );
    }
    if (tags != null && tags.isNotEmpty) {
      filtered = filtered.where((n) => tags.every((t) => n.tags.contains(t)));
    }
    return filtered.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<Note?> getById(String id) async => _box.get(id);

  Future<void> add(Note note) async {
    await _box.put(note.id, note);
  }

  Future<void> update(Note note) async {
    await note.save();
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> togglePin(Note note) async {
    final updated = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await _box.put(updated.id, updated);
  }

  Future<void> archive(Note note, {required bool archive}) async {
    final updated = note.copyWith(
      isArchived: archive,
      updatedAt: DateTime.now(),
    );
    await _box.put(updated.id, updated);
  }

  Future<List<String>> getAllTags() async {
    final tags = <String>{};
    for (final n in _box.values) {
      tags.addAll(n.tags);
    }
    return tags.toList()..sort();
  }
}
