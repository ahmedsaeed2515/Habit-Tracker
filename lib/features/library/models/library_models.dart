import 'package:flutter/foundation.dart';

@immutable
class LinkItem {
  final String id;
  final String title;
  final String url;
  final List<String> tags;
  final DateTime createdAt;

  const LinkItem({
    required this.id,
    required this.title,
    required this.url,
    this.tags = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'url': url,
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
  };

  static LinkItem fromMap(Map<dynamic, dynamic> m) => LinkItem(
    id: m['id'] as String,
    title: m['title'] as String,
    url: m['url'] as String,
    tags: List<String>.from(m['tags'] ?? <String>[]),
    createdAt: DateTime.parse(m['createdAt'] as String),
  );
}
