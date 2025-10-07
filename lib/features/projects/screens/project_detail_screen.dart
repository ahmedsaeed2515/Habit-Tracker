// lib/features/projects/screens/project_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_providers.dart';
import '../models/project_models.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ProjectViewMode _viewMode = ProjectViewMode.kanban;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(projectDetailProvider(widget.projectId));
    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('المشروع')),
        body: const Center(child: Text('المشروع غير موجود')),
      );
    }

    final phases = ref.watch(projectPhasesProvider(widget.projectId));
    final statistics = ref.watch(projectStatisticsProvider(widget.projectId));

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProjectDialog(context, ref, project);
            },
          ),
          PopupMenuButton<ProjectViewMode>(
            icon: const Icon(Icons.view_module),
            onSelected: (mode) {
              setState(() {
                _viewMode = mode;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ProjectViewMode.kanban,
                child: Text('Kanban'),
              ),
              const PopupMenuItem(
                value: ProjectViewMode.list,
                child: Text('قائمة'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'المهام'),
            Tab(text: 'الإحصائيات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTasksView(project, phases),
          _buildStatisticsView(statistics),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPhaseDialog(context, project),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksView(Project project, List<ProjectPhase> phases) {
    if (phases.isEmpty) {
      return const Center(
        child: Text('لا توجد مراحل بعد\nانقر + لإضافة مرحلة'),
      );
    }

    if (_viewMode == ProjectViewMode.kanban) {
      return _buildKanbanView(phases);
    } else {
      return _buildListView(phases);
    }
  }

  Widget _buildKanbanView(List<ProjectPhase> phases) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: phases.map((phase) => _PhaseColumn(phase: phase)).toList(),
      ),
    );
  }

  Widget _buildListView(List<ProjectPhase> phases) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: phases.length,
      itemBuilder: (context, index) {
        final phase = phases[index];
        final tasks = ref.watch(phaseTasksProvider(phase.id));
        return Card(
          child: ExpansionTile(
            title: Text(phase.name),
            subtitle: Text('${tasks.length} مهام'),
            children: tasks
                .map(
                  (task) => ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: _TaskStatusIcon(status: task.status),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsView(Map<String, dynamic> statistics) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatCard(
            title: 'إجمالي المهام',
            value: '${statistics['totalTasks']}',
            icon: Icons.task,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'المهام المكتملة',
            value: '${statistics['completedTasks']}',
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'التقدم',
            value: '${statistics['progress'].toStringAsFixed(1)}%',
            icon: Icons.trending_up,
            color: Colors.purple,
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'الوقت المقدر',
            value: '${statistics['totalEstimatedHours']} ساعة',
            icon: Icons.access_time,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'الوقت الفعلي',
            value: '${statistics['totalActualHours']} ساعة',
            icon: Icons.timer,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void _showEditProjectDialog(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) {
    final nameCtrl = TextEditingController(text: project.name);
    final descCtrl = TextEditingController(text: project.description);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل المشروع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'اسم المشروع'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'الوصف'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              // In a real app, this would update the project in the repository
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project edit functionality coming soon'),
                ),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showAddPhaseDialog(BuildContext context, Project project) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مرحلة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'اسم المرحلة'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'الوصف'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final phases = ref.read(projectPhasesProvider(project.id));
              final phase = ProjectPhase(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                projectId: project.id,
                name: nameCtrl.text.trim(),
                description: descCtrl.text.trim(),
                startDate: DateTime.now(),
                orderIndex: phases.length,
              );
              await ref.read(projectsRepositoryProvider).addPhase(phase);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                setState(() {});
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

class _PhaseColumn extends ConsumerWidget {
  final ProjectPhase phase;

  const _PhaseColumn({required this.phase});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(phaseTasksProvider(phase.id));

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phase.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tasks.length} مهام',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _TaskCard(task: task);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                onPressed: () {
                  _showAddTaskDialog(context, ref, phase);
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة مهمة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(
    BuildContext context,
    WidgetRef ref,
    ProjectPhase phase,
  ) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مهمة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'عنوان المهمة'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'الوصف'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              final task = ProjectTask(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                phaseId: phase.id,
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                createdAt: DateTime.now(),
              );
              await ref.read(projectsRepositoryProvider).addTask(task);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final ProjectTask task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                _TaskStatusIcon(status: task.status),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TaskStatusIcon extends StatelessWidget {
  final TaskStatus status;

  const _TaskStatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (status) {
      case TaskStatus.todo:
        icon = Icons.circle_outlined;
        color = Colors.grey;
        break;
      case TaskStatus.inProgress:
        icon = Icons.adjust;
        color = Colors.blue;
        break;
      case TaskStatus.review:
        icon = Icons.pending;
        color = Colors.orange;
        break;
      case TaskStatus.completed:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case TaskStatus.blocked:
        icon = Icons.block;
        color = Colors.red;
        break;
    }

    return Icon(icon, color: color, size: 20);
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600])),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
