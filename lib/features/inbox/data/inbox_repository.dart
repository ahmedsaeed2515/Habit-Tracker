import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/inbox_models.dart';

class InboxRepository {
  static const String boxName = 'inbox_box_v1';

  final Uuid _uuid = const Uuid();
  Future<Box> _openBox() => Hive.openBox(boxName);

  Future<Idea> createIdea({
    required String title,
    String content = '',
    List<String> tags = const [],
  }) async {
    final box = await _openBox();
    final id = _uuid.v4();
    final now = DateTime.now();
    final idea = Idea(
      id: id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
      tags: tags,
    );
    await box.put(id, idea.toMap());
    return idea;
  }

  Future<List<Idea>> getAllIdeas() async {
    final box = await _openBox();
    final list = box.values
        .map((e) => Idea.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
    return list;
  }

  Future<void> deleteIdea(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<Idea?> getIdea(String id) async {
    final box = await _openBox();
    final data = box.get(id);
    if (data == null) return null;
    return Idea.fromMap(Map<dynamic, dynamic>.from(data as Map));
  }

  Future<Idea> updateIdea(Idea idea) async {
    final box = await _openBox();
    final updated = idea.copyWith(updatedAt: DateTime.now());
    await box.put(updated.id, updated.toMap());
    return updated;
  }
}
