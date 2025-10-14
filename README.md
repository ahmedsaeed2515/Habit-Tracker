# 🏆 Habit Tracker - AI-Powered Personal Development App

[![Netlify Status](https://api.netlify.com/api/v1/badges/your-site-id/deploy-status)](https://app.netlify.com/sites/your-site-name/deploys)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Android APK](https://img.shields.io/badge/Android-APK%20Ready-green?logo=android)](APK_BUILD_GUIDE_AR.md)

> **Status**: ✅ Production Ready | **Version**: 1.0.0 | **Last Updated**: October 2025

A comprehensive Flutter application for building and maintaining habits with artificial intelligence features, analytics, and personalized recommendations. Built with a modular architecture for easy maintenance and scalability.

---

## 📚 الدليل الشامل - Complete Guide

> **🎯 ابدأ هنا! هذا الدليل يشمل كل شيء**  
> **🎯 Start here! This guide includes everything**

### **[📖 الدليل الشامل بالعربية - COMPLETE_GUIDE_AR.md](COMPLETE_GUIDE_AR.md)**

**هذا الدليل الشامل يتضمن:**
- ✅ المتطلبات الأساسية والتثبيت الكامل
- ✅ الإعداد والتكوين خطوة بخطوة
- ✅ تشغيل التطبيق على جميع المنصات
- ✅ بناء APK بجميع الطرق (عادي، مقسم، موقّع)
- ✅ النشر على الويب (Netlify، Vercel)
- ✅ إعداد Firebase الكامل (اختياري)
- ✅ شرح مفصل لجميع الميزات (39 ميزة)
- ✅ هيكل المشروع والمعمارية
- ✅ حل جميع المشاكل الشائعة
- ✅ روابط لجميع الوثائق الإضافية

**This comprehensive guide includes:**
- ✅ Complete prerequisites and installation
- ✅ Step-by-step setup and configuration
- ✅ Running the app on all platforms
- ✅ Building APK (standard, split, signed)
- ✅ Web deployment (Netlify, Vercel)
- ✅ Complete Firebase setup (optional)
- ✅ Detailed explanation of all features (39 features)
- ✅ Project structure and architecture
- ✅ Troubleshooting all common issues
- ✅ Links to all additional documentation

---

## 📱 Build APK / بناء APK

**المشروع جاهز بالكامل لبناء APK لنظام أندرويد!**  
**The project is fully ready to build Android APK!**

```bash
# بناء سريع - Quick build
flutter build apk --release

# أو إستخدام السكريبت - Or use the script
./build-all.sh

# التحقق من الجاهزية - Verify readiness
./verify-apk-readiness.sh
```

📚 **للتفاصيل الكاملة بالعربية - For full details in Arabic**: [APK_BUILD_GUIDE_AR.md](APK_BUILD_GUIDE_AR.md)

## 🌐 Live Demo

🚀 **[View Live Demo on Netlify](https://your-app-name.netlify.app)** *(Coming soon - deploy your own!)*

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

### Quick Start

See the [Quick Start Guide](QUICK_START.md) for detailed setup instructions.

### Prerequisites

- ✅ Flutter SDK 3.9.2 or higher
- ✅ Dart SDK 3.0.0 or higher
- ✅ Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/ahmedsaeed2515/Habit-Tracker.git
   cd Habit-Tracker
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Generate code files**:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

### Quick Build (Android + Web)

Use the provided build script to build both platforms at once:

```bash
# Build Android APK and Web
./build-all.sh

# Or manually:
flutter build apk --release          # Android
flutter build web --release          # Web
```

### Verify Deployment Setup

Check if all deployment configurations are ready:

```bash
./verify-deployment-setup.sh
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

### ✅ Completed Features

**Core System (100%)**
- ✅ Modular adapter system with organized TypeIds
- ✅ Database management with Hive
- ✅ Feature-based modular architecture
- ✅ Comprehensive error handling

**AI & Intelligence (100%)**
- ✅ AI Personal Assistant with personality profiling
- ✅ Smart Recommendations based on patterns
- ✅ Voice Commands in Arabic
- ✅ Smart Notifications with optimal timing
- ✅ Analytics Dashboard with visual charts

**Core Features (100%)**
- ✅ Habit Builder with templates
- ✅ Daily Habit Tracking
- ✅ Smart Todo Management with export
- ✅ Gym & Exercise Tracking
- ✅ Morning Exercise Routines

**Advanced Features (100%)**
- ✅ Gamification System (points, levels, achievements)
- ✅ Social Features (posts, comments, interactions)
- ✅ Projects Management with Kanban view
- ✅ Pomodoro Task Management
- ✅ Budget Tracking
- ✅ Mood Journal & Notes

### 🚀 Future Enhancements

- 🔄 Health Data Integration (Apple Health/Google Fit)
- 🔄 Advanced Analytics & Predictions
- 🔄 Cloud Sync & Backup
- 🔄 Widget System for Home Screen
- 🔄 Advanced Accessibility Features

## 📚 Documentation

Comprehensive documentation is available:

### Getting Started
- **[Quick Start Guide](QUICK_START.md)** - Get started in minutes
- **[Project Structure](PROJECT_STRUCTURE.md)** - Detailed architecture guide

### Deployment
- **[Deployment Guide (EN)](DEPLOYMENT_GUIDE.md)** - Deploy to Android, Web (Netlify, Vercel)
- **[Netlify Deployment (AR) 🇸🇦](NETLIFY_DEPLOYMENT_AR.md)** - دليل النشر على Netlify بالعربية
- **[Web Deployment](WEB_DEPLOYMENT.md)** - Quick web deployment reference
- **[Quick Deploy](QUICK_DEPLOY.md)** - 5-minute deployment guide

### Development & Quality
- **[Code Quality Improvements](CODE_QUALITY_IMPROVEMENTS.md)** - Code quality guide
- **[Refactoring Report](REFACTORING_REPORT.md)** - Code refactoring details
- **[Testing Report](TESTING_COMPLETE.md)** - Complete testing coverage
- **[Current Status](CURRENT_STATUS.md)** - Development progress
- **[Development Roadmap](DEVELOPMENT_ROADMAP_UPDATED.md)** - Future plans

### Technical
- **[Adapter System Guide](lib/core/database/managers/adapters/README.md)** - Database adapters
- **[Component Architecture](COMPONENT_ARCHITECTURE.md)** - UI component design

## 🤝 Contributing

We welcome contributions! Please see our documentation for guidelines.

### Development Guidelines

1. ✅ Follow the existing modular architecture pattern
2. ✅ Maintain consistent code style and naming conventions
3. ✅ Add comprehensive documentation for new features
4. ✅ Ensure all features work with both Arabic and English localization
5. ✅ Test thoroughly on multiple platforms
6. ✅ Run `flutter analyze` before committing
7. ✅ Keep commits small and focused

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
