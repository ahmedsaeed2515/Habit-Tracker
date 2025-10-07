// lib/features/projects/data/projects_repository.dart

import 'package:hive/hive.dart';
import '../models/project_models.dart';

class ProjectsRepository {
  static final ProjectsRepository _instance = ProjectsRepository._internal();
  factory ProjectsRepository() => _instance;
  ProjectsRepository._internal();

  Box<Project>? _projectsBox;
  Box<ProjectPhase>? _phasesBox;
  Box<ProjectTask>? _tasksBox;

  Future<void> init() async {
    _projectsBox = await Hive.openBox<Project>('projects');
    _phasesBox = await Hive.openBox<ProjectPhase>('project_phases');
    _tasksBox = await Hive.openBox<ProjectTask>('project_tasks');
  }

  // === Projects ===
  Future<void> addProject(Project project) async {
    await _projectsBox?.put(project.id, project);
  }

  Future<void> updateProject(Project project) async {
    project.updatedAt = DateTime.now();
    await _projectsBox?.put(project.id, project);
  }

  Future<void> deleteProject(String projectId) async {
    // Delete associated phases and tasks
    final phases = getPhasesByProject(projectId);
    for (final phase in phases) {
      await deletePhase(phase.id);
    }
    await _projectsBox?.delete(projectId);
  }

  List<Project> getAllProjects({bool includeArchived = false}) {
    final projects = _projectsBox?.values.toList() ?? [];
    if (!includeArchived) {
      return projects.where((p) => !p.isArchived).toList();
    }
    return projects;
  }

  Project? getProjectById(String id) {
    return _projectsBox?.get(id);
  }

  List<Project> getProjectsByStatus(ProjectStatus status) {
    return _projectsBox?.values
            .where((p) => p.status == status && !p.isArchived)
            .toList() ??
        [];
  }

  Future<void> archiveProject(String projectId) async {
    final project = getProjectById(projectId);
    if (project != null) {
      project.isArchived = true;
      await updateProject(project);
    }
  }

  // === Phases ===
  Future<void> addPhase(ProjectPhase phase) async {
    await _phasesBox?.put(phase.id, phase);
    // Update project's phaseIds
    final project = getProjectById(phase.projectId);
    if (project != null) {
      final updatedPhases = List<String>.from(project.phaseIds)..add(phase.id);
      await updateProject(project.copyWith(phaseIds: updatedPhases));
    }
  }

  Future<void> updatePhase(ProjectPhase phase) async {
    await _phasesBox?.put(phase.id, phase);
  }

  Future<void> deletePhase(String phaseId) async {
    final phase = getPhaseById(phaseId);
    if (phase != null) {
      // Delete associated tasks
      final tasks = getTasksByPhase(phaseId);
      for (final task in tasks) {
        await deleteTask(task.id);
      }
      // Remove from project's phaseIds
      final project = getProjectById(phase.projectId);
      if (project != null) {
        final updatedPhases = List<String>.from(project.phaseIds)
          ..remove(phaseId);
        await updateProject(project.copyWith(phaseIds: updatedPhases));
      }
      await _phasesBox?.delete(phaseId);
    }
  }

  ProjectPhase? getPhaseById(String id) {
    return _phasesBox?.get(id);
  }

  List<ProjectPhase> getPhasesByProject(String projectId) {
    final phases =
        _phasesBox?.values.where((p) => p.projectId == projectId).toList() ??
        [];
    phases.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return phases;
  }

  // === Tasks ===
  Future<void> addTask(ProjectTask task) async {
    await _tasksBox?.put(task.id, task);
    // Update phase's taskIds
    final phase = getPhaseById(task.phaseId);
    if (phase != null) {
      final updatedTasks = List<String>.from(phase.taskIds)..add(task.id);
      await updatePhase(phase.copyWith(taskIds: updatedTasks));
    }
  }

  Future<void> updateTask(ProjectTask task) async {
    await _tasksBox?.put(task.id, task);
    // Auto-update phase status if all tasks completed
    await _updatePhaseStatusIfNeeded(task.phaseId);
  }

  Future<void> deleteTask(String taskId) async {
    final task = getTaskById(taskId);
    if (task != null) {
      // Remove from phase's taskIds
      final phase = getPhaseById(task.phaseId);
      if (phase != null) {
        final updatedTasks = List<String>.from(phase.taskIds)..remove(taskId);
        await updatePhase(phase.copyWith(taskIds: updatedTasks));
      }
      await _tasksBox?.delete(taskId);
    }
  }

  ProjectTask? getTaskById(String id) {
    return _tasksBox?.get(id);
  }

  List<ProjectTask> getTasksByPhase(String phaseId) {
    return _tasksBox?.values.where((t) => t.phaseId == phaseId).toList() ?? [];
  }

  List<ProjectTask> getTasksByProject(String projectId) {
    final phases = getPhasesByProject(projectId);
    final tasks = <ProjectTask>[];
    for (final phase in phases) {
      tasks.addAll(getTasksByPhase(phase.id));
    }
    return tasks;
  }

  Future<void> moveTask(String taskId, String newPhaseId, int newIndex) async {
    final task = getTaskById(taskId);
    if (task != null) {
      final oldPhaseId = task.phaseId;
      // Remove from old phase
      final oldPhase = getPhaseById(oldPhaseId);
      if (oldPhase != null) {
        final updatedOldTasks = List<String>.from(oldPhase.taskIds)
          ..remove(taskId);
        await updatePhase(oldPhase.copyWith(taskIds: updatedOldTasks));
      }
      // Add to new phase
      final newPhase = getPhaseById(newPhaseId);
      if (newPhase != null) {
        final updatedNewTasks = List<String>.from(newPhase.taskIds)
          ..insert(newIndex, taskId);
        await updatePhase(newPhase.copyWith(taskIds: updatedNewTasks));
      }
      // Update task
      await updateTask(task.copyWith(phaseId: newPhaseId));
    }
  }

  // === Analytics ===
  Future<void> _updatePhaseStatusIfNeeded(String phaseId) async {
    final phase = getPhaseById(phaseId);
    if (phase == null) return;

    final tasks = getTasksByPhase(phaseId);
    if (tasks.isEmpty) return;

    final allCompleted = tasks.every((t) => t.status == TaskStatus.completed);
    final anyInProgress = tasks.any((t) => t.status == TaskStatus.inProgress);

    PhaseStatus newStatus = phase.status;
    if (allCompleted) {
      newStatus = PhaseStatus.completed;
    } else if (anyInProgress) {
      newStatus = PhaseStatus.inProgress;
    }

    if (newStatus != phase.status) {
      await updatePhase(phase.copyWith(status: newStatus));
    }

    // Update project progress
    await _updateProjectProgress(phase.projectId);
  }

  Future<void> _updateProjectProgress(String projectId) async {
    final project = getProjectById(projectId);
    if (project == null) return;

    final tasks = getTasksByProject(projectId);
    if (tasks.isEmpty) return;

    final completedTasks = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final progress = ((completedTasks / tasks.length) * 100).round();

    if (progress != project.progress) {
      await updateProject(project.copyWith(progress: progress));
    }
  }

  Map<String, dynamic> getProjectStatistics(String projectId) {
    final tasks = getTasksByProject(projectId);
    final completedTasks = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final totalEstimatedHours = tasks.fold<int>(
      0,
      (sum, t) => sum + t.estimatedHours,
    );
    final totalActualHours = tasks.fold<int>(
      0,
      (sum, t) => sum + t.actualHours,
    );

    return {
      'totalTasks': tasks.length,
      'completedTasks': completedTasks,
      'progress': tasks.isEmpty ? 0 : (completedTasks / tasks.length * 100),
      'totalEstimatedHours': totalEstimatedHours,
      'totalActualHours': totalActualHours,
    };
  }
}
