// test/widget/common/loading_state_widget_test.dart
// اختبارات ويدجت حالة التحميل

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/common/widgets/loading_state_widget.dart';

void main() {
  group('LoadingStateWidget Tests', () {
    testWidgets('should display circular progress indicator', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display message when provided', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget(
              message: 'جاري التحميل...',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('جاري التحميل...'), findsOneWidget);
    });

    testWidgets('should not display message when not provided', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget(),
          ),
        ),
      );

      // Assert
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('should use custom size when provided', (tester) async {
      // Arrange
      const customSize = 60.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget(
              size: customSize,
            ),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, customSize);
      expect(sizedBox.height, customSize);
    });

    testWidgets('should center the content', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget(),
          ),
        ),
      );

      // Assert
      expect(find.byType(Center), findsOneWidget);
    });
  });
}
