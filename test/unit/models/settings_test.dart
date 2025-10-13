// test/unit/models/settings_test.dart
// اختبارات نموذج الإعدادات

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/models/settings.dart';

void main() {
  group('Settings Model Tests', () {
    test('should create settings with default values', () {
      // Arrange
      final settings = Settings();

      // Assert
      expect(settings, isNotNull);
      expect(settings.themeMode, isNotNull);
    });

    test('should update theme mode', () {
      // Arrange
      final settings = Settings();
      
      // Act
      settings.themeMode = ThemeMode.dark;

      // Assert
      expect(settings.themeMode, ThemeMode.dark);
    });

    test('should update language', () {
      // Arrange
      final settings = Settings();
      
      // Act
      settings.language = 'en';

      // Assert
      expect(settings.language, 'en');
    });

    test('should toggle notifications', () {
      // Arrange
      final settings = Settings();
      final oldValue = settings.notificationsEnabled;
      
      // Act
      settings.notificationsEnabled = !oldValue;

      // Assert
      expect(settings.notificationsEnabled, !oldValue);
    });
  });
}
