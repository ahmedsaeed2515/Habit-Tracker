// test/integration/habit_creation_flow_test.dart
// اختبار تدفق إنشاء عادة جديدة

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/models/habit.dart';

void main() {
  group('Habit Creation Flow Integration Tests', () {
    testWidgets('should complete full habit creation flow', (tester) async {
      // Arrange - Setup app
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HabitCreationTestScreen(),
          ),
        ),
      );

      // Assert - Initial state
      expect(find.text('إنشاء عادة جديدة'), findsOneWidget);

      // Act - Enter habit name
      await tester.enterText(find.byKey(const Key('habit_name_field')), 'تمرين صباحي');
      await tester.pump();

      // Assert - Name entered
      expect(find.text('تمرين صباحي'), findsOneWidget);

      // Act - Tap save button
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      // Assert - Success message
      expect(find.text('تم حفظ العادة بنجاح'), findsOneWidget);
    });

    testWidgets('should validate required fields', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HabitCreationTestScreen(),
          ),
        ),
      );

      // Act - Try to save without entering data
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pump();

      // Assert - Error message shown
      expect(find.textContaining('مطلوب'), findsOneWidget);
    });

    testWidgets('should navigate back after saving', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HabitCreationTestScreen(),
                        ),
                      );
                    },
                    child: const Text('إضافة عادة'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Act - Navigate to habit creation
      await tester.tap(find.text('إضافة عادة'));
      await tester.pumpAndSettle();

      // Assert - On habit creation screen
      expect(find.text('إنشاء عادة جديدة'), findsOneWidget);

      // Act - Enter data and save
      await tester.enterText(find.byKey(const Key('habit_name_field')), 'عادة جديدة');
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      // Assert - Back on previous screen
      expect(find.text('إضافة عادة'), findsOneWidget);
    });
  });
}

// Test screen for habit creation
class HabitCreationTestScreen extends StatefulWidget {
  const HabitCreationTestScreen({super.key});

  @override
  State<HabitCreationTestScreen> createState() => _HabitCreationTestScreenState();
}

class _HabitCreationTestScreenState extends State<HabitCreationTestScreen> {
  final _nameController = TextEditingController();
  String? _errorMessage;
  bool _saved = false;

  void _saveHabit() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'الاسم مطلوب';
      });
      return;
    }

    // Create habit
    final habit = Habit(
      id: 'test-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      type: HabitType.boolean,
      entries: [],
      createdAt: DateTime.now(),
    );

    setState(() {
      _saved = true;
    });

    // Navigate back after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context, habit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء عادة جديدة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('habit_name_field'),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'اسم العادة',
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('save_button'),
              onPressed: _saveHabit,
              child: const Text('حفظ'),
            ),
            if (_saved)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('تم حفظ العادة بنجاح'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
