// test/unit/models/task_model_test.dart
// اختبارات نموذج المهام

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('should create task with required fields', () {
      // Arrange
      final task = Task(
        id: 'task-1',
        title: 'مهمة اختبار',
        createdAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(task.id, 'task-1');
      expect(task.title, 'مهمة اختبار');
      expect(task.createdAt, DateTime(2024, 1, 1));
      expect(task.isCompleted, false); // default value
    });

    test('should mark task as completed', () {
      // Arrange
      final task = Task(
        id: 'task-2',
        title: 'مهمة للإكمال',
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      task.isCompleted = true;

      // Assert
      expect(task.isCompleted, true);
    });
  });

  group('TaskSheet Model Tests', () {
    test('should create task sheet with required fields', () {
      // Arrange
      final sheet = TaskSheet(
        id: 'sheet-1',
        name: 'ورقة مهام',
        tasks: [],
        createdAt: DateTime(2024, 1, 1),
        lastModified: DateTime(2024, 1, 1),
      );

      // Assert
      expect(sheet.id, 'sheet-1');
      expect(sheet.name, 'ورقة مهام');
      expect(sheet.tasks, isEmpty);
      expect(sheet.isActive, true);
    });

    test('should calculate completion percentage correctly', () {
      // Arrange
      final sheet = TaskSheet(
        id: 'sheet-2',
        name: 'ورقة اختبار',
        tasks: [
          Task(
            id: 'task-1',
            title: 'مهمة 1',
            createdAt: DateTime(2024, 1, 1),
            isCompleted: true,
          ),
          Task(
            id: 'task-2',
            title: 'مهمة 2',
            createdAt: DateTime(2024, 1, 1),
            isCompleted: true,
          ),
          Task(
            id: 'task-3',
            title: 'مهمة 3',
            createdAt: DateTime(2024, 1, 1),
            isCompleted: false,
          ),
          Task(
            id: 'task-4',
            title: 'مهمة 4',
            createdAt: DateTime(2024, 1, 1),
            isCompleted: false,
          ),
        ],
        createdAt: DateTime(2024, 1, 1),
        lastModified: DateTime(2024, 1, 1),
      );

      // Assert
      expect(sheet.totalTasks, 4);
      expect(sheet.completedTasks, 2);
      expect(sheet.completionPercentage, 50.0);
    });

    test('should return 0% when no tasks exist', () {
      // Arrange
      final sheet = TaskSheet(
        id: 'sheet-3',
        name: 'ورقة فارغة',
        tasks: [],
        createdAt: DateTime(2024, 1, 1),
        lastModified: DateTime(2024, 1, 1),
      );

      // Assert
      expect(sheet.completionPercentage, 0.0);
    });

    test('should count pending tasks correctly', () {
      // Arrange
      final sheet = TaskSheet(
        id: 'sheet-4',
        name: 'ورقة مهام',
        tasks: [
          Task(
            id: 'task-1',
            title: 'مهمة مكتملة',
            createdAt: DateTime(2024, 1, 1),
            isCompleted: true,
          ),
          Task(
            id: 'task-2',
            title: 'مهمة معلقة',
            createdAt: DateTime(2024, 1, 1),
            isCompleted: false,
          ),
        ],
        createdAt: DateTime(2024, 1, 1),
        lastModified: DateTime(2024, 1, 1),
      );

      // Assert
      expect(sheet.completedTasks, 1);
      expect(sheet.pendingTasks, 1);
    });
  });
}
