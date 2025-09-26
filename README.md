# 🏆 Habit Tracker - AI-Powered Personal Development App

A comprehensive Flutter application for building and maintaining habits with artificial intelligence features, analytics, and personalized recommendations.

## ✨ Features

### 🤖 AI-Powered Features

- **AI Personal Assistant**: Conversational AI with personality profiling and behavioral analysis
- **Smart Recommendations**: Intelligent habit suggestions based on behavioral patterns
- **Voice Commands**: Hands-free interaction with speech recognition
- **Smart Notifications**: Contextual reminders with optimal timing

### 📊 Analytics & Insights

- **Advanced Analytics Dashboard**: Visual charts and comprehensive habit tracking
- **Behavior Pattern Analysis**: 7 different pattern types with confidence scoring
- **Progress Tracking**: Streak counting and success rate calculations
- **Performance Insights**: KPI cards and trend analysis

### 🛠️ Core Features

- **Habit Builder**: Guided habit creation with templates and categories
- **Daily Habit Tracking**: Simple and intuitive habit completion interface
- **Smart Todo Management**: Intelligent task organization
- **Gym & Exercise Tracking**: Workout logging and progress monitoring
- **Morning Exercise Routines**: Specialized exercise tracking

### 🌐 Localization & UI

- **Full Arabic Support**: Complete RTL localization
- **Modern Material Design**: Clean and intuitive interface
- **Dark/Light Theme**: Comprehensive theme system
- **Responsive Design**: Optimized for all screen sizes

## 🏗️ Architecture

### Tech Stack

- **Framework**: Flutter 3.9.2
- **State Management**: Riverpod 2.5.1
- **Database**: Hive 2.2.3 (NoSQL local storage)
- **UI Components**: Material Design 3
- **Localization**: Custom localization system with JSON files

### Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── models/                    # Data models and Hive adapters
│   ├── providers/                 # Global state providers
│   └── database/                  # Database management
├── features/                      # Feature-based modules
│   ├── ai_assistant/             # AI Personal Assistant
│   ├── analytics/                # Analytics Dashboard
│   ├── habit_builder/            # Habit creation system
│   ├── smart_notifications/      # Intelligent notifications
│   ├── smart_recommendations/    # AI recommendations
│   ├── voice_commands/           # Voice interaction
│   ├── daily_habits/             # Daily tracking
│   ├── dashboard/                # Main dashboard
│   ├── gym_tracker/              # Workout tracking
│   ├── morning_exercises/        # Exercise routines
│   ├── settings/                 # App settings
│   └── smart_todo/               # Task management
├── shared/                       # Shared resources
│   ├── localization/             # i18n files
│   └── themes/                   # App themes
└── common/                       # Common widgets
    └── widgets/                  # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/habit-tracker.git
   cd habit-tracker
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Generate code files**:

   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## 📱 Screenshots

### AI Features

- AI Personal Assistant with chat interface
- Smart Recommendations with behavioral insights
- Voice Commands integration
- Intelligent notification system

### Analytics Dashboard

- Comprehensive habit tracking charts
- Progress visualization with heatmaps
- KPI cards showing key metrics
- Trend analysis and insights

### Core Interface

- Modern Material Design interface
- Intuitive habit tracking cards
- Streamlined navigation system
- Responsive layout design

## � Configuration

### Database

The app uses Hive for local data storage with the following type adapters:

- Habits (typeId: 0)
- Settings (typeId: 1)
- Tasks (typeId: 2)
- Workouts (typeId: 3)
- Morning Exercises (typeId: 4)
- AI Messages (typeId: 24-31)

### Localization

- English (en): Default language
- Arabic (ar): Full RTL support
- Extensible system for additional languages

## 📈 Development Status

### Phase 1 - Complete ✅

- ✅ Smart Notifications (95% complete)
- ✅ Analytics Dashboard (100% complete)
- ✅ Voice Commands (90% complete)
- ✅ Habit Builder (95% complete)

### Phase 2 - Complete ✅

- ✅ AI Personal Assistant (100% complete)
- ✅ Smart Recommendations (100% complete)

### Phase 3 - Planned

- 🔄 Gamification System (High Priority)
- 🔄 Health Data Integration
- 🔄 Dynamic Theming System

## 🤝 Contributing

We welcome contributions! Please see our [Development Roadmap](DEVELOPMENT_ROADMAP_UPDATED.md) for planned features and priorities.

### Development Guidelines

1. Follow the existing modular architecture pattern
2. Maintain consistent code style and naming conventions
3. Add comprehensive documentation for new features
4. Ensure all features work with both Arabic and English localization
5. Test thoroughly on multiple platforms

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions, suggestions, or support:

- Create an issue in this repository
- Review the [Development Roadmap](DEVELOPMENT_ROADMAP_UPDATED.md) for planned features
- Check the [Current Status](CURRENT_STATUS.md) for implementation details

## 🙏 Acknowledgments

- Flutter team for the excellent framework
- Riverpod for robust state management
- Hive for efficient local storage
- Material Design team for UI guidelines

---

**Made with ❤️ using Flutter**
