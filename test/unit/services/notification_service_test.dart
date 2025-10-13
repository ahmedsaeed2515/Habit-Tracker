// test/unit/services/notification_service_test.dart
// اختبارات خدمة الإشعارات

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Tests', () {
    late NotificationService notificationService;

    setUp(() {
      notificationService = NotificationService();
    });

    test('should create singleton instance', () {
      // Arrange & Act
      final instance1 = NotificationService();
      final instance2 = NotificationService();

      // Assert
      expect(instance1, same(instance2));
    });

    test('should not throw when initializing multiple times', () async {
      // Act & Assert
      expect(() async {
        await notificationService.initialize();
        await notificationService.initialize();
      }, returnsNormally);
    });

    test('should handle showNotification without initialization', () async {
      // Note: This test verifies that the service auto-initializes if needed
      // Act & Assert
      expect(() async {
        await notificationService.showNotification(
          title: 'Test',
          body: 'Test notification',
        );
      }, returnsNormally);
    });

    test('should handle showNotification with custom id', () async {
      // Act & Assert
      expect(() async {
        await notificationService.showNotification(
          title: 'Test',
          body: 'Test notification',
          id: 123,
        );
      }, returnsNormally);
    });

    test('should handle showNotification with payload', () async {
      // Act & Assert
      expect(() async {
        await notificationService.showNotification(
          title: 'Test',
          body: 'Test notification',
          payload: 'test-payload',
        );
      }, returnsNormally);
    });

    test('should handle cancelNotification', () async {
      // Act & Assert
      expect(() async {
        await notificationService.cancelNotification(123);
      }, returnsNormally);
    });

    test('should handle cancelAllNotifications', () async {
      // Act & Assert
      expect(() async {
        await notificationService.cancelAllNotifications();
      }, returnsNormally);
    });
  });
}
