// test/integration/navigation_flow_test.dart
// اختبار تدفق التنقل في التطبيق

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation Flow Integration Tests', () {
    testWidgets('should navigate to different screens', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomeScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
              '/habits': (context) => const HabitsScreen(),
            },
          ),
        ),
      );

      // Assert - On home screen
      expect(find.text('الرئيسية'), findsOneWidget);

      // Act - Navigate to settings
      await tester.tap(find.text('الإعدادات'));
      await tester.pumpAndSettle();

      // Assert - On settings screen
      expect(find.text('شاشة الإعدادات'), findsOneWidget);
    });

    testWidgets('should navigate back', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('الرئيسية')),
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('التفاصيل')),
                            body: const Center(child: Text('صفحة التفاصيل')),
                          ),
                        ),
                      );
                    },
                    child: const Text('التفاصيل'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Act - Navigate to details
      await tester.tap(find.text('التفاصيل'));
      await tester.pumpAndSettle();

      // Assert - On details screen
      expect(find.text('صفحة التفاصيل'), findsOneWidget);

      // Act - Navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Assert - Back on home screen
      expect(find.text('التفاصيل'), findsOneWidget);
    });

    testWidgets('should handle bottom navigation', (tester) async {
      // Arrange
      int currentIndex = 0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Center(
                    child: Text('صفحة $currentIndex'),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'الرئيسية',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        label: 'العادات',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'الإعدادات',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Assert - On first tab
      expect(find.text('صفحة 0'), findsOneWidget);

      // Act - Tap second tab
      await tester.tap(find.text('العادات'));
      await tester.pumpAndSettle();

      // Assert - Shows second tab content
      expect(find.text('صفحة 1'), findsOneWidget);
    });
  });
}

// Test screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('الرئيسية'),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('الإعدادات'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/habits'),
              child: const Text('العادات'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: const Center(child: Text('شاشة الإعدادات')),
    );
  }
}

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العادات')),
      body: const Center(child: Text('شاشة العادات')),
    );
  }
}
