// test/widget/common/search_bar_widget_test.dart
// اختبارات ويدجت شريط البحث

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchBar Widget Tests', () {
    testWidgets('should render search text field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              key: const Key('search_field'),
              decoration: const InputDecoration(
                hintText: 'بحث...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(const Key('search_field')), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should handle text input', (tester) async {
      // Arrange
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'بحث...'),
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'test search');
      await tester.pump();

      // Assert
      expect(controller.text, 'test search');
      expect(find.text('test search'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should show clear button when text is entered', (tester) async {
      // Arrange
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'بحث...',
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.clear(),
                      )
                    : null,
              ),
            ),
          ),
        ),
      );

      // Act
      controller.text = 'search text';
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.clear), findsOneWidget);

      controller.dispose();
    });
  });
}
