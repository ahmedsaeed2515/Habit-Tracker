// lib/features/notes/providers/notes_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notes_repository.dart';
import '../models/note_models.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final repo = NotesRepository();
  return repo;
});

final notesInitProvider = FutureProvider<void>((ref) async {
  await ref.read(notesRepositoryProvider).init();
});

class NotesListNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  NotesListNotifier(this._repo) : super(const AsyncValue.loading()) {
    refresh();
  }
  final NotesRepository _repo;
  String _query = '';
  List<String> _tags = [];

  Future<void> refresh() async {
    try {
      state = const AsyncValue.loading();
      final notes = await _repo.getAll(query: _query, tags: _tags);
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setQuery(String q) {
    _query = q;
    refresh();
  }

  void setTags(List<String> tags) {
    _tags = tags;
    refresh();
  }
}

final notesListProvider =
    StateNotifierProvider<NotesListNotifier, AsyncValue<List<Note>>>((ref) {
      final repo = ref.watch(notesRepositoryProvider);
      return NotesListNotifier(repo);
    });

final noteByIdProvider = FutureProvider.family<Note?, String>((ref, id) async {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.getById(id);
});
