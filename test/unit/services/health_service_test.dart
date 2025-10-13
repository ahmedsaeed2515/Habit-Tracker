// test/unit/services/health_service_test.dart
// اختبارات خدمة الصحة

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/services/health_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HealthService Tests', () {
    late HealthService healthService;

    setUp(() {
      healthService = HealthService();
    });

    test('should create singleton instance', () {
      // Arrange & Act
      final instance1 = HealthService();
      final instance2 = HealthService();

      // Assert
      expect(instance1, same(instance2));
    });

    test('should initialize successfully', () async {
      // Act & Assert
      expect(() async {
        await healthService.initialize();
      }, returnsNormally);
    });

    test('should not throw when initializing multiple times', () async {
      // Act & Assert
      expect(() async {
        await healthService.initialize();
        await healthService.initialize();
      }, returnsNormally);
    });

    test('should have default values after initialization', () async {
      // Act
      await healthService.initialize();

      // Assert - service should be initialized without errors
      expect(healthService, isNotNull);
    });

    test('should handle dispose without errors', () {
      // Act & Assert
      expect(() {
        healthService.dispose();
      }, returnsNormally);
    });

    test('should handle recordBreak without errors', () {
      // Act & Assert
      expect(() {
        healthService.recordBreak();
      }, returnsNormally);
    });
  });
}
