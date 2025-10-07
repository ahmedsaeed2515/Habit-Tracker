// lib/features/projects/providers/projects_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/projects_repository.dart';
import '../models/project_models.dart';

// Repository provider
final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepository();
});

// Init provider
final projectsInitProvider = FutureProvider<void>((ref) async {
  await ref.read(projectsRepositoryProvider).init();
});

// Projects list provider
final projectsListProvider =
    StateNotifierProvider<ProjectsListNotifier, AsyncValue<List<Project>>>((
      ref,
    ) {
      return ProjectsListNotifier(ref.read(projectsRepositoryProvider));
    });

class ProjectsListNotifier extends StateNotifier<AsyncValue<List<Project>>> {
  final ProjectsRepository _repository;

  ProjectsListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProjects();
  }

  Future<void> loadProjects({bool includeArchived = false}) async {
    state = const AsyncValue.loading();
    try {
      final projects = _repository.getAllProjects(
        includeArchived: includeArchived,
      );
      state = AsyncValue.data(projects);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProject(Project project) async {
    await _repository.addProject(project);
    await loadProjects();
  }

  Future<void> updateProject(Project project) async {
    await _repository.updateProject(project);
    await loadProjects();
  }

  Future<void> deleteProject(String projectId) async {
    await _repository.deleteProject(projectId);
    await loadProjects();
  }

  Future<void> archiveProject(String projectId) async {
    await _repository.archiveProject(projectId);
    await loadProjects();
  }
}

// Project detail provider
final projectDetailProvider = Provider.family<Project?, String>((
  ref,
  projectId,
) {
  final projects = ref.watch(projectsListProvider).value ?? [];
  return projects.where((p) => p.id == projectId).firstOrNull;
});

// Phases provider for a project
final projectPhasesProvider = Provider.family<List<ProjectPhase>, String>((
  ref,
  projectId,
) {
  return ref.read(projectsRepositoryProvider).getPhasesByProject(projectId);
});

// Tasks provider for a phase
final phaseTasksProvider = Provider.family<List<ProjectTask>, String>((
  ref,
  phaseId,
) {
  return ref.read(projectsRepositoryProvider).getTasksByPhase(phaseId);
});

// Project statistics provider
final projectStatisticsProvider = Provider.family<Map<String, dynamic>, String>(
  (ref, projectId) {
    return ref.read(projectsRepositoryProvider).getProjectStatistics(projectId);
  },
);
