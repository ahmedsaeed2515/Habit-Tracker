import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/library_models.dart';

class LibraryRepository {
  static const String boxName = 'library_links_v1';
  final Uuid _uuid = const Uuid();

  Future<Box> _openBox() async {
    return await Hive.openBox(boxName);
  }

  Future<LinkItem> addLink({
    required String title,
    required String url,
    List<String> tags = const [],
  }) async {
    final box = await _openBox();
    final id = _uuid.v4();
    final item = LinkItem(
      id: id,
      title: title,
      url: url,
      tags: tags,
      createdAt: DateTime.now(),
    );
    await box.put(id, item.toMap());
    return item;
  }

  Future<List<LinkItem>> getAllLinks() async {
    final box = await _openBox();
    return box.values
        .map((e) => LinkItem.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> deleteLink(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
