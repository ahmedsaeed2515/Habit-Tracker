// test/unit/models/user_profile_test.dart
// اختبارات نموذج ملف المستخدم

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/models/user_profile.dart';

void main() {
  group('UserProfile Model Tests', () {
    test('should create user profile with required fields', () {
      // Arrange
      final profile = UserProfile(
        id: 'user-1',
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
        createdAt: DateTime(2024, 1),
      );

      // Assert
      expect(profile.id, 'user-1');
      expect(profile.name, 'أحمد محمد');
      expect(profile.email, 'ahmed@example.com');
      expect(profile.createdAt, DateTime(2024, 1));
    });

    test('should update profile name', () {
      // Arrange
      final profile = UserProfile(
        id: 'user-1',
        name: 'أحمد',
        email: 'ahmed@example.com',
        createdAt: DateTime(2024, 1),
      );

      // Act
      profile.name = 'أحمد محمد';

      // Assert
      expect(profile.name, 'أحمد محمد');
    });

    test('should update profile email', () {
      // Arrange
      final profile = UserProfile(
        id: 'user-1',
        name: 'أحمد',
        email: 'old@example.com',
        createdAt: DateTime(2024, 1),
      );

      // Act
      profile.email = 'new@example.com';

      // Assert
      expect(profile.email, 'new@example.com');
    });
  });
}
