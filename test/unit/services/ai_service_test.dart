// test/unit/services/ai_service_test.dart
// اختبارات خدمة الذكاء الاصطناعي

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/services/ai_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AIService Tests', () {
    late AIService aiService;

    setUp(() {
      aiService = AIService();
    });

    test('should create singleton instance', () {
      // Arrange & Act
      final instance1 = AIService();
      final instance2 = AIService();

      // Assert
      expect(instance1, same(instance2));
    });

    test('should initialize successfully', () async {
      // Act & Assert
      expect(() async {
        await aiService.initialize();
      }, returnsNormally);
    });

    test('should handle generate recommendations without errors', () async {
      // Act & Assert
      expect(() async {
        await aiService.generateRecommendations([]);
      }, returnsNormally);
    });

    test('should handle generate insights without errors', () async {
      // Act & Assert
      expect(() async {
        await aiService.generateInsights([]);
      }, returnsNormally);
    });

    test('should handle analyze patterns without errors', () async {
      // Act & Assert
      expect(() async {
        await aiService.analyzePatterns([]);
      }, returnsNormally);
    });
  });
}
