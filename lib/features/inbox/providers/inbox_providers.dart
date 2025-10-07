import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/inbox_repository.dart';
import '../models/inbox_models.dart';

final inboxRepositoryProvider = Provider<InboxRepository>(
  (ref) => InboxRepository(),
);

final inboxListProvider = StateNotifierProvider<InboxListNotifier, List<Idea>>(
  (ref) => InboxListNotifier(ref.read(inboxRepositoryProvider)),
);

class InboxListNotifier extends StateNotifier<List<Idea>> {

  InboxListNotifier(this._repo) : super([]) {
    _load();
  }
  final InboxRepository _repo;

  Future<void> _load() async {
    final items = await _repo.getAllIdeas();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  Future<void> add(
    String title, {
    String content = '',
    List<String> tags = const [],
  }) async {
    final newIdea = await _repo.createIdea(
      title: title,
      content: content,
      tags: tags,
    );
    state = [newIdea, ...state];
  }

  Future<void> remove(String id) async {
    await _repo.deleteIdea(id);
    state = state.where((e) => e.id != id).toList();
  }

  Future<void> update(Idea idea) async {
    final updated = await _repo.updateIdea(idea);
    state = state.map((e) => e.id == idea.id ? updated : e).toList();
  }
}
