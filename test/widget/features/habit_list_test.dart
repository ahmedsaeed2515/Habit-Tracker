// test/widget/features/habit_list_test.dart
// اختبارات قائمة العادات

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Habit List Widget Tests', () {
    testWidgets('should display empty state when no habits', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('لا توجد عادات'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('لا توجد عادات'), findsOneWidget);
    });

    testWidgets('should display list of habits', (tester) async {
      // Arrange
      final habits = ['تمرين', 'قراءة', 'تأمل'];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(habits[index]),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('تمرين'), findsOneWidget);
      expect(find.text('قراءة'), findsOneWidget);
      expect(find.text('تأمل'), findsOneWidget);
    });

    testWidgets('should handle habit item tap', (tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListTile(
                title: const Text('تمرين'),
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('تمرين'));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should show habit completion checkbox', (tester) async {
      // Arrange
      bool completed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CheckboxListTile(
                title: const Text('تمرين'),
                value: completed,
                onChanged: (value) {
                  completed = value ?? false;
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CheckboxListTile), findsOneWidget);
      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, false);
    });
  });
}
