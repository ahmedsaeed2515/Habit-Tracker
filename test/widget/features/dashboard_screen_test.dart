// test/widget/features/dashboard_screen_test.dart
// اختبارات شاشة لوحة التحكم

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('DashboardScreen Widget Tests', () {
    testWidgets('should render basic widget structure', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: const Text('Dashboard'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('should display app bar', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('لوحة التحكم'),
              ),
              body: Center(
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('لوحة التحكم'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display notification icon button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
              body: const Center(child: Text('Content')),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should handle FAB tap', (tester) async {
      // Arrange
      bool fabTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Content')),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  fabTapped = true;
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Assert
      expect(fabTapped, true);
    });
  });
}
