# 📁 Project Structure Guide - Habit Tracker

> **Last Updated**: October 2025  
> **Version**: 1.0.0  
> **Status**: Production Ready

---

## 🎯 Overview

This document provides a comprehensive guide to the Habit Tracker project structure, making it easy for developers to navigate and understand the codebase organization.

---

## 📂 Root Directory Structure

```
Habit-Tracker/
├── lib/                    # Main application code
├── android/                # Android platform configuration
├── ios/                    # iOS platform configuration
├── web/                    # Web platform configuration
├── assets/                 # Static assets (images, audio, icons)
├── docs/                   # Documentation files
├── test/                   # Test files
├── .gitignore             # Git ignore rules
├── pubspec.yaml           # Dependencies and project configuration
└── README.md              # Project overview
```

---

## 🏗️ Main Application Structure (`lib/`)

### 1. **Core Layer** (`lib/core/`)

Contains fundamental components used throughout the application.

```
lib/core/
├── models/                 # Data models with Hive adapters
│   ├── habit.dart         # Habit model (typeId: 5)
│   ├── task.dart          # Task model (typeId: 9)
│   ├── workout.dart       # Workout model (typeId: 0)
│   ├── settings.dart      # App settings (typeId: 16)
│   └── *.g.dart           # Generated adapter files
│
├── database/              # Database management
│   ├── database_manager.dart       # Main database interface
│   ├── adapters/                   # Custom adapters
│   │   ├── datetime_adapter.dart
│   │   └── duration_adapter.dart
│   └── managers/                   # Modular managers
│       ├── adapters_manager.dart   # Main adapter registrar
│       ├── adapters/               # Organized adapters
│       │   ├── core_adapters.dart      # Core adapters (IDs: 0-17)
│       │   ├── feature_adapters.dart   # Feature adapters (IDs: 18-48)
│       │   ├── health_adapters.dart    # Health adapters (IDs: 38-145)
│       │   ├── pomodoro_adapters.dart  # Pomodoro adapters (IDs: 81-110)
│       │   └── taskmeta_adapters.dart  # TaskMeta adapters (IDs: 250-270)
│       ├── habits_manager.dart     # Habit operations
│       └── workout_manager.dart    # Workout operations
│
├── providers/             # Global state providers
│   ├── settings_provider.dart
│   ├── habits_provider.dart
│   └── gym_provider.dart
│
├── services/              # Core services
│   ├── ai_service.dart
│   ├── health_service.dart
│   └── notification_service.dart
│
└── widgets/               # Shared core widgets
```

### 2. **Features Layer** (`lib/features/`)

Feature-based modular architecture. Each feature is self-contained.

```
lib/features/
├── [feature_name]/
│   ├── models/            # Feature-specific models
│   ├── screens/           # UI screens
│   ├── widgets/           # Feature widgets
│   ├── providers/         # State management
│   ├── services/          # Business logic
│   └── adapters/          # Hive adapters (if needed)
```

#### Key Features:

**🤖 AI & Intelligence Features:**
- `ai_assistant/` - AI Personal Assistant with chat interface
- `smart_recommendations/` - Intelligent habit recommendations
- `voice_commands/` - Voice interaction system
- `smart_notifications/` - Contextual notification system

**📊 Analytics & Tracking:**
- `analytics/` - Advanced analytics dashboard
- `dashboard/` - Main dashboard interface
- `daily_habits/` - Daily habit tracking
- `gym_tracker/` - Gym and exercise tracking
- `morning_exercises/` - Morning routine tracking

**🎮 Gamification:**
- `gamification_system/` - Points, levels, achievements
- `gamification/` - Enhanced gamification widgets

**💼 Productivity:**
- `smart_todo/` - Intelligent task management
- `pomodoro_task_management/` - Pomodoro timer with tasks
- `projects/` - Project management
- `notes/` - Note-taking system
- `budget/` - Budget tracking

**🏥 Health & Fitness:**
- `health_integration/` - Health data integration
- `intelligent_workout_planner/` - AI-powered workout planning

**👥 Social:**
- `social/` - Social features and community
- `mood_journal/` - Mood tracking and journaling

**⚙️ System Features:**
- `settings/` - App settings
- `onboarding/` - User onboarding flow
- `habit_builder/` - Guided habit creation
- `accessibility/` - Accessibility features
- `offline_mode/` - Offline functionality
- `widgets_system/` - Widget configuration system

### 3. **Shared Layer** (`lib/shared/`)

Shared resources used across features.

```
lib/shared/
├── themes/                # App themes
│   ├── app_theme.dart    # Theme definitions
│   └── colors.dart       # Color palette
│
├── localization/          # Internationalization
│   ├── app_localizations.dart
│   ├── en.json           # English translations
│   └── ar.json           # Arabic translations
│
├── design_system/         # Design system components
│   └── design_tokens.dart
│
└── widgets/               # Reusable UI widgets
    ├── buttons/
    ├── cards/
    └── inputs/
```

### 4. **Common Layer** (`lib/common/`)

Common utilities and components.

```
lib/common/
├── widgets/               # Common reusable widgets
├── mixins/               # Shared mixins
└── utils/                # Utility functions
```

---

## 🗄️ Database Architecture

### Hive Adapter Type IDs

The project uses Hive for local storage. Type IDs are organized as follows:

| Range | Category | Location |
|-------|----------|----------|
| 0-17 | Core Models | `core_adapters.dart` |
| 18-48 | Advanced Features | `feature_adapters.dart` |
| 38-145 | Health & Fitness | `health_adapters.dart` |
| 81-110 | Pomodoro System | `pomodoro_adapters.dart` |
| 250-270 | TaskMeta Features | `taskmeta_adapters.dart` |

### Database Boxes

- `habits` - User habits
- `habit_entries` - Habit completion records
- `workouts` - Gym workouts
- `tasks` - Smart todo tasks
- `task_sheets` - Task organization
- `settings` - App settings
- `morning_exercises` - Morning routines
- `pomodoro_sessions` - Pomodoro sessions
- `pomodoro_tasks` - Pomodoro-linked tasks
- `achievements` - Gamification achievements
- Plus many more feature-specific boxes

---

## 🎨 UI Architecture

### Theme System

The app supports:
- Light Theme (default)
- Dark Theme
- System theme following
- RTL support for Arabic

### Localization

Full support for:
- **English (en)**: Default language
- **Arabic (ar)**: Complete RTL implementation

---

## 📦 Dependencies

### Core Dependencies

**State Management:**
- `flutter_riverpod: ^2.5.1` - State management solution

**Database:**
- `hive: ^2.2.3` - NoSQL local database
- `hive_flutter: ^1.1.0` - Flutter integration
- `hive_generator: ^2.0.1` - Code generation

**UI Components:**
- `animations: ^2.0.11` - Advanced animations
- `flutter_slidable: ^3.1.1` - Slidable list items
- `flutter_staggered_animations: ^1.1.1` - Staggered animations

**Charts:**
- `fl_chart: ^0.69.0` - Data visualization

**Notifications:**
- `flutter_local_notifications: ^19.4.2` - Local notifications
- `awesome_notifications: ^0.10.1` - Advanced notifications
- `android_alarm_manager_plus: ^4.0.3` - Background alarms

**Audio & Voice:**
- `audioplayers: ^6.1.0` - Audio playback
- `speech_to_text: ^7.3.0` - Speech recognition
- `flutter_tts: ^4.2.3` - Text-to-speech

**Utilities:**
- `intl: ^0.20.2` - Internationalization
- `uuid: ^4.5.1` - UUID generation
- `table_calendar: ^3.1.2` - Calendar widget
- `google_fonts: ^6.2.1` - Google Fonts integration

---

## 🔧 Development Workflow

### Code Generation

Run build_runner to generate adapter files:

```bash
# One-time generation
flutter pub run build_runner build

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch

# Clean and rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

```bash
# Development mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📝 Coding Conventions

### File Naming
- Use `snake_case` for file names
- Group related files in folders
- Use descriptive names

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter_lints` for code quality
- Document public APIs
- Keep functions small and focused

### Architecture Patterns
- **Feature-based** module organization
- **Provider pattern** for state management
- **Repository pattern** for data access
- **Separation of concerns** (UI, Logic, Data)

---

## 🚀 Adding New Features

### Step-by-Step Guide

1. **Create Feature Folder**
   ```
   lib/features/my_new_feature/
   ├── models/
   ├── screens/
   ├── widgets/
   ├── providers/
   └── services/
   ```

2. **Define Models** (if needed)
   - Create model classes with `@HiveType`
   - Add to appropriate adapter registrar
   - Run build_runner

3. **Create Screens**
   - Design UI in `screens/`
   - Use shared widgets where possible

4. **Implement State Management**
   - Create providers in `providers/`
   - Use Riverpod for state

5. **Add Services** (if needed)
   - Implement business logic in `services/`
   - Keep UI logic separate

6. **Update Navigation**
   - Add routes in `app.dart`
   - Update navigation flow

7. **Test**
   - Write unit tests
   - Test UI manually
   - Verify integration

---

## 🔍 Troubleshooting

### Common Issues

**Build Runner Fails:**
- Check for naming conflicts in TypeIds
- Ensure all models have proper annotations
- Delete `.dart_tool/` and retry

**Hive Adapter Errors:**
- Verify adapters are registered in `adapters_manager.dart`
- Check TypeId uniqueness
- Ensure `.g.dart` files exist

**Import Errors:**
- Run `flutter pub get`
- Clean and rebuild: `flutter clean && flutter pub get`
- Check for circular dependencies

---

## 📚 Additional Resources

### Documentation Files

- `README.md` - Project overview
- `TESTING_COMPLETE.md` - Testing report
- `TESTING_SUMMARY.md` - Test summary
- `ARCHITECTURE_COMPLETION_REPORT.md` - Architecture details
- `CURRENT_STATUS.md` - Current development status
- `DEVELOPMENT_ROADMAP_UPDATED.md` - Future plans
- `lib/core/database/managers/adapters/README.md` - Adapters guide
- `lib/core/database/managers/adapters/QUICKSTART.md` - Quick start guide

### Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Hive Documentation](https://docs.hivedb.dev)
- [Material Design Guidelines](https://material.io/design)

---

## 🤝 Contributing

When contributing to this project:

1. Follow the established architecture patterns
2. Write clean, documented code
3. Update relevant documentation
4. Test thoroughly before submitting
5. Use meaningful commit messages

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Made with ❤️ using Flutter**
