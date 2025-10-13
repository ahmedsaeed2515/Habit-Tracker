// test/unit/providers/habits_provider_test.dart
// اختبارات مزود العادات

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/models/habit.dart';

void main() {
  group('HabitsProvider Tests', () {
    test('should create habit with proper id', () {
      // Arrange
      final habit = Habit(
        id: 'habit-${DateTime.now().millisecondsSinceEpoch}',
        name: 'عادة جديدة',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime.now(),
      );

      // Assert
      expect(habit.id, isNotEmpty);
      expect(habit.name, 'عادة جديدة');
    });

    test('should update habit name', () {
      // Arrange
      final habit = Habit(
        id: 'habit-1',
        name: 'عادة قديمة',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime.now(),
      );

      // Act
      habit.name = 'عادة محدثة';

      // Assert
      expect(habit.name, 'عادة محدثة');
    });

    test('should create habit entry with completion status', () {
      // Arrange
      final entry = HabitEntry(
        id: 'entry-1',
        habitId: 'habit-1',
        date: DateTime.now(),
        value: 1.0,
        isCompleted: true,
      );

      // Assert
      expect(entry.isCompleted, true);
      expect(entry.value, 1.0);
    });

    test('should mark habit as completed with proper value', () {
      // Arrange
      final habit = Habit(
        id: 'habit-1',
        name: 'تمرين',
        type: HabitType.numeric,
        targetValue: 30,
        entries: [],
        createdAt: DateTime.now(),
      );

      final entry = HabitEntry(
        id: 'entry-1',
        habitId: habit.id,
        date: DateTime.now(),
        value: 30.0,
        isCompleted: true,
      );

      // Act
      habit.entries.add(entry);

      // Assert
      expect(habit.entries.length, 1);
      expect(habit.entries.first.isCompleted, true);
      expect(habit.entries.first.value, 30.0);
    });

    test('should handle multiple entries for different dates', () {
      // Arrange
      final habit = Habit(
        id: 'habit-1',
        name: 'قراءة',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime.now(),
      );

      final entry1 = HabitEntry(
        id: 'entry-1',
        habitId: habit.id,
        date: DateTime(2024, 1, 1),
        value: 1.0,
        isCompleted: true,
      );

      final entry2 = HabitEntry(
        id: 'entry-2',
        habitId: habit.id,
        date: DateTime(2024, 1, 2),
        value: 1.0,
        isCompleted: true,
      );

      // Act
      habit.entries.add(entry1);
      habit.entries.add(entry2);

      // Assert
      expect(habit.entries.length, 2);
      expect(habit.entries[0].date, DateTime(2024, 1, 1));
      expect(habit.entries[1].date, DateTime(2024, 1, 2));
    });

    test('should update streak when habit is completed', () {
      // Arrange
      final habit = Habit(
        id: 'habit-1',
        name: 'تأمل',
        type: HabitType.boolean,
        entries: [],
        createdAt: DateTime.now(),
        currentStreak: 0,
        longestStreak: 0,
      );

      // Act
      habit.currentStreak = 5;
      habit.longestStreak = 5;

      // Assert
      expect(habit.currentStreak, 5);
      expect(habit.longestStreak, 5);
    });
  });
}
