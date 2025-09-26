import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/simple_theming_models.dart';

// Mock providers for theme widgets
final availableThemesProvider = FutureProvider<List<DynamicTheme>>((ref) async {
  // Return some mock themes
  return [
    DynamicTheme(
      id: '1',
      name: 'الثيم الافتراضي',
      description: 'ثيم افتراضي بسيط',
      category: ThemeCategory.light,
      lightColorPalette: const ColorPalette(
        primary: 0xFF2196F3,
        onPrimary: 0xFFFFFFFF,
        secondary: 0xFF03DAC6,
        onSecondary: 0xFF000000,
        tertiary: 0xFFFF5722,
        onTertiary: 0xFFFFFFFF,
        error: 0xFFB00020,
        onError: 0xFFFFFFFF,
        surface: 0xFFFFFFFF,
        onSurface: 0xFF000000,
        onSurfaceVariant: 0xFF757575,
        outline: 0xFFBDBDBD,
        shadow: 0xFF000000,
        surfaceVariant: 0xFFF5F5F5,
        background: 0xFFFFFFFF,
        onBackground: 0xFF000000,
        success: 0xFF4CAF50,
        warning: 0xFFFF9800,
        info: 0xFF2196F3,
      ),
      darkColorPalette: ColorPalette.defaultDark(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
});

final customThemesProvider = FutureProvider<List<DynamicTheme>>((ref) async {
  return [];
});

final currentThemeProvider = StateProvider<ThemeState>((ref) {
  return const ThemeState(themeId: '1');
});

// Mock service provider
final dynamicThemingServiceProvider = Provider<DynamicThemingService>((ref) {
  return MockDynamicThemingService();
});

class MockDynamicThemingService implements DynamicThemingService {
  @override
  Future<void> createTheme(DynamicTheme theme) async {
    // Mock implementation
  }

  @override
  Future<void> deleteTheme(String themeId) async {
    // Mock implementation
  }

  @override
  Future<void> setTheme(String themeId) async {
    // Mock implementation
  }

  @override
  Future<void> updateTheme(DynamicTheme theme) async {
    // Mock implementation
  }
}