import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inbox_providers.dart';
import '../../library/screens/library_screen.dart';

class InboxQuickCaptureScreen extends ConsumerStatefulWidget {
  const InboxQuickCaptureScreen({super.key});

  @override
  ConsumerState<InboxQuickCaptureScreen> createState() =>
      _InboxQuickCaptureScreenState();
}

class _InboxQuickCaptureScreenState
    extends ConsumerState<InboxQuickCaptureScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    await ref
        .read(inboxListProvider.notifier)
        .add(title, content: _descController.text.trim());
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _titleController.clear();
      _descController.clear();
    });
    messenger.showSnackBar(const SnackBar(content: Text('Idea saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Capture')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Idea'),
            ),
            const SizedBox(height: 24),
            const Text('Your recent ideas:'),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final list = ref.watch(inboxListProvider);
                  if (list.isEmpty) {
                    return const Center(child: Text('No ideas yet'));
                  }
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final idea = list[i];
                      return ListTile(
                        title: Text(idea.title),
                        subtitle: idea.content.isNotEmpty
                            ? Text(idea.content)
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await ref
                                .read(inboxListProvider.notifier)
                                .remove(idea.id);
                            if (!mounted) return;
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Deleted')),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.library_books_outlined),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LibraryScreen()));
        },
      ),
    );
  }
}
