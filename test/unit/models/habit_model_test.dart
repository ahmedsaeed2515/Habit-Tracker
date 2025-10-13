// test/unit/models/habit_model_test.dart
// اختبارات نموذج العادات

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/models/habit.dart';

void main() {
  group('Habit Model Tests', () {
    test('should create habit with required fields', () {
      // Arrange
      final habit = Habit(
        id: 'test-id',
        name: 'تمرين صباحي',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(habit.id, 'test-id');
      expect(habit.name, 'تمرين صباحي');
      expect(habit.type, HabitType.boolean);
      expect(habit.entries, isEmpty);
      expect(habit.createdAt, DateTime(2024, 1, 1));
      expect(habit.isActive, true); // default value
      expect(habit.currentStreak, 0); // default value
      expect(habit.longestStreak, 0); // default value
    });

    test('should create habit with all fields', () {
      // Arrange
      final habit = Habit(
        id: 'test-id-2',
        name: 'شرب ماء',
        description: 'شرب 8 أكواب ماء يومياً',
        icon: '💧',
        type: HabitType.numeric,
        targetValue: 8,
        unit: 'كوب',
        entries: [],
        createdAt: DateTime(2024, 1, 1),
        isActive: true,
        currentStreak: 5,
        longestStreak: 10,
      );

      // Assert
      expect(habit.id, 'test-id-2');
      expect(habit.name, 'شرب ماء');
      expect(habit.description, 'شرب 8 أكواب ماء يومياً');
      expect(habit.icon, '💧');
      expect(habit.type, HabitType.numeric);
      expect(habit.targetValue, 8);
      expect(habit.unit, 'كوب');
      expect(habit.currentStreak, 5);
      expect(habit.longestStreak, 10);
    });

    test('should have default values for optional fields', () {
      // Arrange
      final habit = Habit(
        id: 'test-id-3',
        name: 'قراءة',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(habit.description, '');
      expect(habit.icon, '⭐');
      expect(habit.targetValue, 1);
      expect(habit.unit, '');
      expect(habit.isActive, true);
      expect(habit.currentStreak, 0);
      expect(habit.longestStreak, 0);
    });

    test('should update habit fields', () {
      // Arrange
      final habit = Habit(
        id: 'test-id-4',
        name: 'تمرين',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      habit.name = 'تمرين محدّث';
      habit.description = 'وصف جديد';
      habit.currentStreak = 3;

      // Assert
      expect(habit.name, 'تمرين محدّث');
      expect(habit.description, 'وصف جديد');
      expect(habit.currentStreak, 3);
    });

    test('should handle numeric habit type correctly', () {
      // Arrange
      final habit = Habit(
        id: 'test-id-5',
        name: 'خطوات',
        type: HabitType.numeric,
        targetValue: 10000,
        unit: 'خطوة',
        entries: [],
        createdAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(habit.type, HabitType.numeric);
      expect(habit.targetValue, 10000);
      expect(habit.unit, 'خطوة');
    });

    test('should add entries to habit', () {
      // Arrange
      final habit = Habit(
        id: 'test-id-6',
        name: 'تأمل',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime(2024, 1, 1),
      );

      final entry = HabitEntry(
        date: DateTime(2024, 1, 2),
        completed: true,
        value: 1,
      );

      // Act
      habit.entries.add(entry);

      // Assert
      expect(habit.entries.length, 1);
      expect(habit.entries.first.completed, true);
      expect(habit.entries.first.date, DateTime(2024, 1, 2));
    });
  });
}
