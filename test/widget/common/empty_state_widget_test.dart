// test/widget/common/empty_state_widget_test.dart
// اختبارات ويدجت الحالة الفارغة

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/common/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget Tests', () {
    testWidgets('should display icon, title and description', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'لا توجد عناصر',
              description: 'قم بإضافة عنصر جديد للبدء',
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('لا توجد عناصر'), findsOneWidget);
      expect(find.text('قم بإضافة عنصر جديد للبدء'), findsOneWidget);
    });

    testWidgets('should display button when provided', (tester) async {
      // Arrange
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'لا توجد عناصر',
              description: 'قم بإضافة عنصر جديد للبدء',
              buttonText: 'إضافة',
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('إضافة'), findsOneWidget);

      // Act
      await tester.tap(find.text('إضافة'));
      await tester.pump();

      // Assert
      expect(buttonPressed, true);
    });

    testWidgets('should not display button when not provided', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'لا توجد عناصر',
              description: 'قم بإضافة عنصر جديد للبدء',
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('should use custom color when provided', (tester) async {
      // Arrange
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'لا توجد عناصر',
              description: 'قم بإضافة عنصر جديد للبدء',
              color: customColor,
            ),
          ),
        ),
      );

      // Assert
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(iconWidget.color, customColor);
    });

    testWidgets('should use custom icon size when provided', (tester) async {
      // Arrange
      const customSize = 100.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'لا توجد عناصر',
              description: 'قم بإضافة عنصر جديد للبدء',
              iconSize: customSize,
            ),
          ),
        ),
      );

      // Assert
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(iconWidget.size, customSize);
    });
  });
}
