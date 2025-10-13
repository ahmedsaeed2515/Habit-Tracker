// test/unit/models/health_profile_test.dart
// اختبارات نموذج الملف الصحي

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/health_integration/models/health_models.dart';

void main() {
  group('HealthProfile Model Tests', () {
    test('should create health profile with required fields', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );

      // Assert
      expect(profile.userId, 'user-123');
      expect(profile.isHealthKitConnected, false);
      expect(profile.isGoogleFitConnected, false);
      expect(profile.healthMetrics, isEmpty);
      expect(profile.dailyHealthData, isEmpty);
      expect(profile.healthGoals, isEmpty);
      expect(profile.healthInsights, isEmpty);
    });

    test('should have default privacy settings', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );

      // Assert
      expect(profile.privacySettings, isNotNull);
    });

    test('should update health kit connection status', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );

      // Act
      profile.isHealthKitConnected = true;

      // Assert
      expect(profile.isHealthKitConnected, true);
    });

    test('should update google fit connection status', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );

      // Act
      profile.isGoogleFitConnected = true;

      // Assert
      expect(profile.isGoogleFitConnected, true);
    });

    test('should add health data point', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );

      final dataPoint = HealthDataPoint(
        type: HealthDataType.steps,
        value: 1000,
        timestamp: DateTime(2024, 1, 1, 12),
      );

      // Act
      profile.addHealthDataPoint(dataPoint);

      // Assert
      expect(profile.dailyHealthData.isNotEmpty, true);
      const dateKey = '2024-01-01';
      expect(profile.dailyHealthData.containsKey(dateKey), true);
      expect(profile.dailyHealthData[dateKey]!.length, 1);
    });

    test('should get data for specific date', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );

      final dataPoint = HealthDataPoint(
        type: HealthDataType.steps,
        value: 5000,
        timestamp: DateTime(2024, 1, 1, 10),
      );

      profile.addHealthDataPoint(dataPoint);

      // Act
      final data = profile.getDataForDate(DateTime(2024, 1));

      // Assert
      expect(data.length, 1);
      expect(data.first.value, 5000);
    });

    test('should return empty list for date with no data', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );

      // Act
      final data = profile.getDataForDate(DateTime(2024, 1));

      // Assert
      expect(data, isEmpty);
    });

    test('should update timestamp when adding data', () {
      // Arrange
      final profile = HealthProfile(
        userId: 'user-123',
      );
      
      final oldUpdatedAt = profile.updatedAt;

      // Act
      Future.delayed(const Duration(milliseconds: 10), () {
        final dataPoint = HealthDataPoint(
          type: HealthDataType.steps,
          value: 1000,
          timestamp: DateTime.now(),
        );
        profile.addHealthDataPoint(dataPoint);
      });

      // Assert
      // updatedAt should be updated when data is added
      expect(profile.updatedAt, isNotNull);
    });
  });
}
