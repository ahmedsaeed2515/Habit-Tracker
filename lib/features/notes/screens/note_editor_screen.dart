import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../notes/providers/notes_providers.dart';
import '../models/note_models.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, this.noteId});
  final String? noteId;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;
  Note? _loaded;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.noteId == null) return;
    setState(() => _isLoading = true);
    final note = await ref
        .read(notesRepositoryProvider)
        .getById(widget.noteId!);
    if (mounted) {
      setState(() {
        _loaded = note;
        if (note != null) {
          _titleController.text = note.title;
          _contentController.text = note.content;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    final repo = ref.read(notesRepositoryProvider);
    final now = DateTime.now();
    if (_loaded == null) {
      final note = Note(
        id: now.millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim().isEmpty
            ? 'بدون عنوان'
            : _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await repo.add(note);
    } else {
      final updated = _loaded!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        updatedAt: DateTime.now(),
      );
      await repo.update(updated);
    }
    if (mounted) {
      ref.read(notesListProvider.notifier).refresh();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'ملاحظة جديدة' : 'تعديل ملاحظة'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'العنوان',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelText: 'المحتوى',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
