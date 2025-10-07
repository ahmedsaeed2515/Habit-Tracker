import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/library_repository.dart';
import '../models/library_models.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(),
);

final libraryListProvider =
    StateNotifierProvider<LibraryListNotifier, List<LinkItem>>(
      (ref) => LibraryListNotifier(ref.read(libraryRepositoryProvider)),
    );

class LibraryListNotifier extends StateNotifier<List<LinkItem>> {

  LibraryListNotifier(this._repo) : super([]) {
    _load();
  }
  final LibraryRepository _repo;

  Future<void> _load() async {
    final items = await _repo.getAllLinks();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  Future<void> add(
    String title,
    String url, {
    List<String> tags = const [],
  }) async {
    final item = await _repo.addLink(title: title, url: url, tags: tags);
    state = [item, ...state];
  }

  Future<void> remove(String id) async {
    await _repo.deleteLink(id);
    state = state.where((e) => e.id != id).toList();
  }
}
