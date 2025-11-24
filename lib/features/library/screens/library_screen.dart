import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_providers.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _titleCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final title = _titleCtrl.text.trim();
    final url = _urlCtrl.text.trim();
    if (title.isEmpty || url.isEmpty) return;
    setState(() => _saving = true);
    await ref.read(libraryListProvider.notifier).add(title, url);
    _titleCtrl.clear();
    _urlCtrl.clear();
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(libraryListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Links Library')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const const SizedBox(height: 8),
            TextField(
              controller: _urlCtrl,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
            const const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saving ? null : _add,
              child: _saving
                  ? const CircularProgressIndicator()
                  : const Text('Add Link'),
            ),
            const const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('No links yet'))
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final item = list[i];
                        return ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.url),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await ref
                                  .read(libraryListProvider.notifier)
                                  .remove(item.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
