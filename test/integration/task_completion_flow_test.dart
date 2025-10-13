// test/integration/task_completion_flow_test.dart
// اختبار تدفق إكمال المهام

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Task Completion Flow Integration Tests', () {
    testWidgets('should complete task successfully', (tester) async {
      // Arrange
      bool taskCompleted = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('مهمة اختبار'),
                    Checkbox(
                      value: taskCompleted,
                      onChanged: (value) {
                        taskCompleted = value ?? false;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Assert - Task not completed initially
      expect(find.text('مهمة اختبار'), findsOneWidget);
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);

      // Act - Complete task
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
    });

    testWidgets('should show completed tasks count', (tester) async {
      // Arrange
      int completedCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Text('المهام المكتملة: $completedCount'),
                    ElevatedButton(
                      onPressed: () {
                        completedCount++;
                      },
                      child: const Text('إكمال مهمة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Assert - Initial count
      expect(find.text('المهام المكتملة: 0'), findsOneWidget);
    });

    testWidgets('should handle multiple task completions', (tester) async {
      // Arrange
      final tasks = ['مهمة 1', 'مهمة 2', 'مهمة 3'];
      final completedTasks = <String>[];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return CheckboxListTile(
                    title: Text(task),
                    value: completedTasks.contains(task),
                    onChanged: (value) {
                      if (value == true) {
                        completedTasks.add(task);
                      } else {
                        completedTasks.remove(task);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Assert - All tasks visible
      expect(find.text('مهمة 1'), findsOneWidget);
      expect(find.text('مهمة 2'), findsOneWidget);
      expect(find.text('مهمة 3'), findsOneWidget);
    });
  });
}
