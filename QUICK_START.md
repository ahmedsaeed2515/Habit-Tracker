# 🚀 Quick Start Guide - Habit Tracker

> Get up and running with the Habit Tracker app in minutes!

---

## ⚡ Prerequisites

Before you begin, ensure you have:

- ✅ Flutter SDK 3.9.2 or higher
- ✅ Dart SDK 3.0.0 or higher
- ✅ Android Studio or VS Code with Flutter extensions
- ✅ Git installed

Check your Flutter installation:

```bash
flutter doctor
```

---

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/ahmedsaeed2515/Habit-Tracker.git
cd Habit-Tracker
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code Files

The project uses code generation for Hive adapters. Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate all `.g.dart` files needed for the app.

### 4. Run the App

```bash
flutter run
```

Or select a device in your IDE and press Run (F5).

---

## 🎯 First Time Setup

### Understanding the App Structure

The app follows a **feature-based modular architecture**:

```
lib/
├── core/          # Core functionality (models, database, providers)
├── features/      # Feature modules (ai_assistant, analytics, etc.)
├── shared/        # Shared resources (themes, localization)
└── common/        # Common utilities and widgets
```

### Key Entry Points

- **Main Entry**: `lib/main.dart`
- **App Configuration**: `lib/app.dart`
- **Database Setup**: `lib/core/database/database_manager.dart`
- **Theme**: `lib/shared/themes/app_theme.dart`

---

## 🔧 Development Commands

### Code Generation

```bash
# One-time generation
flutter pub run build_runner build

# Watch mode (auto-regenerate)
flutter pub run build_runner watch

# Clean and rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running & Building

```bash
# Debug mode
flutter run

# Release mode (optimized)
flutter run --release

# Profile mode (for performance testing)
flutter run --profile

# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Fix common issues
dart fix --apply
```

---

## 🎨 Working with Themes

The app supports light and dark themes with full RTL support for Arabic.

### Changing Theme

Edit `lib/shared/themes/app_theme.dart`:

```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    // Customize your light theme
  );
  
  static ThemeData get darkTheme => ThemeData(
    // Customize your dark theme
  );
}
```

---

## 🌐 Adding Localization

The app supports English and Arabic. To add translations:

1. Add translation keys in `lib/shared/localization/en.json`
2. Add Arabic translations in `lib/shared/localization/ar.json`
3. Use in code:

```dart
AppLocalizations.of(context).translate('your_key')
```

---

## 🗄️ Working with Database

### Adding a New Model

1. **Create Model Class** (`lib/core/models/my_model.dart`):

```dart
import 'package:hive/hive.dart';

part 'my_model.g.dart';

@HiveType(typeId: 999) // Use unique typeId
class MyModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  MyModel({required this.id, required this.name});
}
```

2. **Register Adapter**:

Add to appropriate registrar in `lib/core/database/managers/adapters/`:

```dart
BaseDatabaseManager.registerAdapterSafe(MyModelAdapter(), 999);
```

3. **Generate Code**:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Use in App**:

```dart
final box = await Hive.openBox<MyModel>('my_models');
await box.put('key', MyModel(id: '1', name: 'Test'));
```

---

## 🎯 Adding a New Feature

### Step-by-Step

1. **Create Feature Directory**:

```
lib/features/my_feature/
├── models/         # Data models
├── screens/        # UI screens
├── widgets/        # Feature widgets
├── providers/      # State management
└── services/       # Business logic
```

2. **Create Screen**:

```dart
// lib/features/my_feature/screens/my_screen.dart
import 'package:flutter/material.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: Center(child: Text('Hello Feature!')),
    );
  }
}
```

3. **Add Provider** (if needed):

```dart
// lib/features/my_feature/providers/my_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});

class MyNotifier extends StateNotifier<MyState> {
  MyNotifier() : super(MyState());
  
  // Add methods
}

class MyState {
  // Add state properties
}
```

4. **Add Navigation**:

Update your navigation to include the new screen.

---

## 🐛 Troubleshooting

### Common Issues

#### Build Runner Fails

**Problem**: `build_runner` command fails

**Solution**:
```bash
# Clean and retry
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Hive Adapter Not Found

**Problem**: `Adapter for type X not found`

**Solution**:
- Check adapter is registered in `adapters_manager.dart`
- Verify `.g.dart` file exists
- Ensure TypeId is unique

#### Import Errors

**Problem**: Cannot resolve imports

**Solution**:
```bash
flutter clean
flutter pub get
```

#### App Won't Start

**Problem**: App crashes on startup

**Solution**:
- Check console for error messages
- Verify database initialization
- Clear app data and retry

---

## 📱 Testing on Devices

### Android

```bash
# List devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Install APK
flutter install
```

### iOS

```bash
# Open iOS simulator
open -a Simulator

# Run on iOS
flutter run -d <ios-device-id>
```

---

## 🔍 Debugging Tips

### VS Code

1. Set breakpoints by clicking line numbers
2. Press F5 to start debugging
3. Use Debug Console for logs

### Android Studio

1. Set breakpoints in code
2. Click Debug button
3. Use Logcat for system logs

### Flutter DevTools

```bash
# Start DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

Then open the URL shown in your browser.

---

## 📚 Key Files to Know

### Configuration

- `pubspec.yaml` - Dependencies and assets
- `analysis_options.yaml` - Linting rules
- `build.yaml` - Build configuration

### Main Files

- `lib/main.dart` - App entry point
- `lib/app.dart` - App configuration
- `lib/core/database/database_manager.dart` - Database setup

### Documentation

- `README.md` - Project overview
- `PROJECT_STRUCTURE.md` - Detailed structure guide
- `TESTING_COMPLETE.md` - Testing report
- `CURRENT_STATUS.md` - Development status

---

## 🎓 Learning Resources

### Flutter

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

### State Management

- [Riverpod Documentation](https://riverpod.dev)
- [Riverpod Examples](https://github.com/rrousselGit/river_pod/tree/master/examples)

### Database

- [Hive Documentation](https://docs.hivedb.dev)
- [Hive Examples](https://github.com/hivedb/hive/tree/master/hive/example)

---

## 💡 Pro Tips

1. **Hot Reload**: Press `r` in terminal for hot reload
2. **Hot Restart**: Press `R` for full restart
3. **DevTools**: Use Flutter DevTools for debugging
4. **Widgets**: Use `const` constructors where possible
5. **State**: Keep state management simple with Riverpod
6. **Testing**: Write tests as you develop
7. **Documentation**: Document public APIs

---

## 🤝 Need Help?

- Check existing issues on GitHub
- Review documentation in the `docs/` folder
- Read code comments and examples
- Ask questions in project discussions

---

## ✅ Checklist

Before starting development, ensure:

- [ ] Flutter SDK installed and working
- [ ] Repository cloned
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Code generated (`build_runner build`)
- [ ] App runs successfully (`flutter run`)
- [ ] DevTools accessible
- [ ] IDE configured with Flutter extensions

---

**Happy Coding! 🎉**

*For more detailed information, see [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)*
