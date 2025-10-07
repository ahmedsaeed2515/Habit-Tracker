import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_providers.dart';
import '../models/mood_models.dart';

class MoodJournalScreen extends ConsumerStatefulWidget {
  const MoodJournalScreen({super.key});

  @override
  ConsumerState<MoodJournalScreen> createState() => _MoodJournalScreenState();
}

class _MoodJournalScreenState extends ConsumerState<MoodJournalScreen> {
  final _journalController = TextEditingController();
  int _moodLevel = 5;
  bool _loading = true;
  JournalEntry? _journal;
  MoodEntry? _mood;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await ref.read(moodRepositoryProvider).init();
    final repo = ref.read(moodRepositoryProvider);
    final today = DateTime.now();
    final mood = await repo.getMoodByDate(today);
    final journal = await repo.getJournalByDate(today);
    setState(() {
      _mood = mood;
      _journal = journal;
      if (mood != null) _moodLevel = mood.moodLevel;
      if (journal != null) _journalController.text = journal.content;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final repo = ref.read(moodRepositoryProvider);
    final now = DateTime.now();
    if (_mood == null) {
      _mood = MoodEntry(
        id: now.millisecondsSinceEpoch.toString(),
        date: DateTime(now.year, now.month, now.day),
        moodLevel: _moodLevel,
      );
      await repo.addMood(_mood!);
    } else {
      _mood!.moodLevel = _moodLevel; // تعديل بسيط
      await _mood!.save();
    }
    if (_journal == null) {
      _journal = JournalEntry(
        id: (now.millisecondsSinceEpoch + 1).toString(),
        date: DateTime(now.year, now.month, now.day),
        content: _journalController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await repo.addJournal(_journal!);
    } else {
      _journal!.content = _journalController.text.trim();
      _journal!.updatedAt = DateTime.now();
      await repo.updateJournal(_journal!);
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم الحفظ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المزاج واليومية'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('مستوى المزاج (1-10):'),
                  Slider(
                    value: _moodLevel.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _moodLevel.toString(),
                    onChanged: (v) => setState(() => _moodLevel = v.toInt()),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: _journalController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelText: 'اليومية',
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
