import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tasks_providers.dart';
import '../models/task_models.dart';

class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen> {
  final _titleCtrl = TextEditingController();
  final _filterCtrl = TextEditingController();
  bool _selectionMode = false;
  final Set<String> _expanded = {};

  @override
  void dispose() {
    _titleCtrl.dispose();
    _filterCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    await ref.read(tasksListProvider.notifier).add(title);
    _titleCtrl.clear();
  }

  void _toggleSelectionMode() {
    setState(() => _selectionMode = !_selectionMode);
    if (!_selectionMode) ref.read(tasksListProvider.notifier).clearSelection();
  }

  Future<void> _bulkDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Delete selected tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(tasksListProvider.notifier).bulkDeleteSelected();
    }
  }

  Future<void> _bulkComplete() async {
    await ref
        .read(tasksListProvider.notifier)
        .bulkMarkCompleteSelected(complete: true);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksListProvider);
    final selectedCount = ref
        .read(tasksListProvider.notifier)
        .selectedIds
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(_selectionMode ? Icons.close : Icons.select_all),
            onPressed: _toggleSelectionMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(hintText: 'New task'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _filterCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Filter tasks...',
                    ),
                    onChanged: (v) =>
                        ref.read(tasksListProvider.notifier).applyFilter(v),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _bulkComplete,
                  child: const Text('Complete'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _bulkDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks yet'))
                  : ListView.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final t = tasks[i];
                        final isSelected = ref
                            .read(tasksListProvider.notifier)
                            .selectedIds
                            .contains(t.id);
                        final expanded = _expanded.contains(t.id);
                        return Column(
                          children: [
                            ListTile(
                              onLongPress: () {
                                if (!_selectionMode) _toggleSelectionMode();
                                ref
                                    .read(tasksListProvider.notifier)
                                    .toggleSelect(t.id);
                              },
                              selected: isSelected,
                              tileColor: isSelected
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.12)
                                  : null,
                              title: Text(
                                t.title,
                                style: t.completed
                                    ? const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                      )
                                    : null,
                              ),
                              leading: _selectionMode
                                  ? Checkbox(
                                      value: isSelected,
                                      onChanged: (_) => ref
                                          .read(tasksListProvider.notifier)
                                          .toggleSelect(t.id),
                                    )
                                  : Checkbox(
                                      value: t.completed,
                                      onChanged: (_) => ref
                                          .read(tasksListProvider.notifier)
                                          .toggleComplete(t.id),
                                    ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (t.subtasks.isNotEmpty)
                                    IconButton(
                                      icon: Icon(
                                        expanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                      ),
                                      onPressed: () => setState(
                                        () => expanded
                                            ? _expanded.remove(t.id)
                                            : _expanded.add(t.id),
                                      ),
                                    ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.subdirectory_arrow_right,
                                    ),
                                    onPressed: () async {
                                      // quick add subtask
                                      final subTitle = await showDialog<String>(
                                        context: context,
                                        builder: (ctx) {
                                          final ctrl = TextEditingController();
                                          return AlertDialog(
                                            title: const Text('Add subtask'),
                                            content: TextField(
                                              controller: ctrl,
                                              decoration: const InputDecoration(
                                                hintText: 'Subtask title',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  ctx,
                                                ).pop(ctrl.text.trim()),
                                                child: const Text('Add'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (subTitle != null &&
                                          subTitle.isNotEmpty) {
                                        final id = DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString();
                                        ref
                                            .read(tasksListProvider.notifier)
                                            .addSubtask(
                                              t.id,
                                              Subtask(id: id, title: subTitle),
                                            );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Confirm'),
                                          content: const Text(
                                            'Delete this task?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(true),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirmed == true)
                                        await ref
                                            .read(tasksListProvider.notifier)
                                            .remove(t.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (expanded && t.subtasks.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 64.0,
                                  right: 12.0,
                                  bottom: 8.0,
                                ),
                                child: Column(
                                  children: t.subtasks
                                      .map(
                                        (s) => CheckboxListTile(
                                          value: s.completed,
                                          title: Text(
                                            s.title,
                                            style: s.completed
                                                ? const TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  )
                                                : null,
                                          ),
                                          onChanged: (_) => ref
                                              .read(tasksListProvider.notifier)
                                              .toggleSubtaskComplete(
                                                t.id,
                                                s.id,
                                              ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _selectionMode
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Text('$selectedCount selected'),
                    const Spacer(),
                    TextButton(
                      onPressed: () async => await _bulkComplete(),
                      child: const Text('Complete'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () async => await _bulkDelete(),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _toggleSelectionMode,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
