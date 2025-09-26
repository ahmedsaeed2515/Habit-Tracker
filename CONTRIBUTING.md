# Contributing to Habit Tracker

Thank you for your interest in contributing to Habit Tracker! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0.0 or higher
- Git knowledge
- Basic understanding of Flutter, Riverpod, and Hive

### Development Setup

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/yourusername/habit-tracker.git
   cd habit-tracker
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Generate code files**:
   ```bash
   dart run build_runner build
   ```
5. **Run the app**:
   ```bash
   flutter run
   ```

## 🏗️ Project Architecture

### Core Principles

- **Modular Architecture**: Each feature should be self-contained
- **Separation of Concerns**: Models, Services, Providers, and UI components are separated
- **Localization First**: All features must support both Arabic and English
- **Clean Code**: Follow Dart/Flutter best practices

### Folder Structure Pattern

For each new feature, follow this pattern:

```
lib/features/feature_name/
├── models/           # Data models with Hive adapters
├── services/         # Business logic and external integrations
├── providers/        # Riverpod state management
├── screens/          # UI screens
└── widgets/          # Reusable UI components
```

## 📝 Contribution Guidelines

### Code Style

- Follow the existing code style and naming conventions
- Use meaningful variable and function names
- Add comprehensive comments for complex logic
- Ensure consistent indentation (2 spaces)

### Feature Development

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. **Follow the modular architecture pattern**
3. **Add comprehensive documentation**
4. **Test on multiple platforms**
5. **Ensure localization support**

### Commit Guidelines

Follow conventional commit format:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `refactor:` for code refactoring
- `test:` for adding tests
- `chore:` for maintenance tasks

Example:

```bash
git commit -m "feat: add gamification system with points and achievements"
```

### Pull Request Process

1. **Update documentation** if necessary
2. **Test thoroughly** on iOS and Android
3. **Ensure all features work** in both Arabic and English
4. **Create descriptive PR title** and description
5. **Link related issues** if applicable

## 🔧 Technical Requirements

### Database (Hive)

- All new models must extend HiveObject
- Assign unique typeId (check existing ones in core/models/)
- Generate adapters with build_runner
- Follow the existing pattern for database operations

### State Management (Riverpod)

- Use appropriate provider types (StateProvider, NotifierProvider, etc.)
- Keep providers focused and single-responsibility
- Follow the existing provider patterns

### Localization

- Add new strings to both `ar.json` and `en.json`
- Use the existing localization system
- Test RTL layout for Arabic text
- Ensure proper text direction handling

### UI/UX Guidelines

- Follow Material Design 3 principles
- Maintain consistency with existing theme
- Support both light and dark modes
- Ensure responsive design for all screen sizes

## 🐛 Bug Reports

When reporting bugs, please include:

- Flutter version and platform (iOS/Android)
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots if applicable
- Error logs or stack traces

## 💡 Feature Requests

For new features:

- Check the [Development Roadmap](DEVELOPMENT_ROADMAP_UPDATED.md) first
- Describe the feature and its benefits
- Consider implementation complexity
- Discuss how it fits with existing architecture

## 📈 Development Priorities

Current high-priority areas for contribution:

1. **Gamification System** - Points, achievements, leaderboards
2. **Health Data Integration** - Fitness tracking APIs
3. **Dynamic Theming** - Customizable color schemes
4. **Advanced Analytics** - More chart types and insights
5. **Social Features** - Sharing and community aspects

## 🤝 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Maintain a positive and collaborative environment

## 📞 Getting Help

If you need help:

- Create an issue with the `question` label
- Check existing issues and discussions
- Review the project documentation
- Ask specific technical questions with context

## 🎯 Testing

- Write unit tests for new business logic
- Test UI components thoroughly
- Verify localization works correctly
- Test on both iOS and Android platforms
- Check performance impact of new features

---

Thank you for contributing to make Habit Tracker better for everyone! 🚀
