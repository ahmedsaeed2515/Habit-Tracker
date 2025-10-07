# Modern Design System & UI Components

## Overview

This is a comprehensive design system for the Habit Tracker app with reusable UI components following modern design principles including glassmorphism, soft shadows, rounded corners, and smooth animations.

## Design System Structure

### 📐 AppDesignSystem (`lib/shared/design_system/app_design_system.dart`)

The central design tokens and constants:

#### Colors

- **Primary Colors**: `primary`, `secondary`, `accent`
- **Neutral Colors**: `neutral50` to `neutral900`
- **Semantic Colors**: `success`, `warning`, `error`, `info`
- **Category Colors**: Predefined colors for different feature categories (habits, tasks, exercises, etc.)

#### Typography

- **8-Level Scale**: From `displayLarge` (32px) to `bodySmall` (12px)
- **Helper Methods**:
  - `headlineLarge()`, `headlineMedium()`, `titleLarge()`
  - `bodyLarge()`, `bodySmall()`

#### Spacing

- **Scale**: 4px to 64px (`spacingXSmall` to `spacingXXXLarge`)
- **EdgeInsets Constants**: Pre-defined padding/margin values

#### Border Radius

- **Scale**: 8px to 100px (`radiusSmall` to `radiusCircular`)
- **BorderRadius Constants**: Pre-defined border radius values

#### Shadows

- **4 Levels**: `sm`, `md`, `lg`, `xl`
- Each with appropriate blur radius and offset

#### Animations

- **Durations**: `fast` (150ms), `medium` (300ms), `slow` (500ms)
- **Curves**: `easeInOut`, `easeIn`, `easeOut`, `spring`

#### Icons & Category Colors

- Pre-mapped icons and colors for all feature categories

## 🎨 Component Library

### 1. Containers & Cards

#### `GlassContainer`

Glassmorphism effect container with blur backdrop.

```dart
GlassContainer(
  blur: 10,
  opacity: 0.8,
  borderRadius: AppDesignSystem.borderRadiusMedium,
  child: YourWidget(),
)
```

#### `ModernCard`

Elevated card with shadow, border, and tap animation.

```dart
ModernCard(
  onTap: () {},
  elevation: AppDesignSystem.shadowMedium,
  child: YourWidget(),
)
```

### 2. Buttons & FABs

#### `GradientButton`

Button with gradient background and haptic feedback.

```dart
GradientButton(
  onPressed: () {},
  isLoading: false,
  child: Text('Submit'),
)
```

#### `ModernFloatingActionButton`

Gradient FAB with scale animation.

```dart
ModernFloatingActionButton(
  icon: Icons.add,
  label: 'Add New',  // Optional
  onPressed: () {},
)
```

#### `ModernSmallFAB`

Compact floating action button.

```dart
ModernSmallFAB(
  icon: Icons.edit,
  onPressed: () {},
)
```

### 3. Input Fields

#### `ModernTextField`

Enhanced text field with focus animation.

```dart
ModernTextField(
  hintText: 'Enter text',
  labelText: 'Label',
  prefixIcon: Icon(Icons.search),
  validator: (value) => value!.isEmpty ? 'Required' : null,
)
```

#### `ModernSearchField`

Pre-configured search field.

```dart
ModernSearchField(
  hintText: 'Search...',
  onChanged: (value) {},
)
```

### 4. App Bars

#### `ModernAppBar`

Glassmorphism app bar with blur effect.

```dart
ModernAppBar(
  title: Text('Title'),
  useGlassmorphism: true,
  actions: [IconButton(...)],
)
```

#### `GradientAppBar`

App bar with gradient background.

```dart
GradientAppBar(
  title: Text('Title'),
  gradient: LinearGradient(...),
)
```

### 5. Bottom Sheets & Dialogs

#### `showModernBottomSheet`

Modern bottom sheet with rounded corners.

```dart
showModernBottomSheet(
  context: context,
  child: YourWidget(),
)
```

#### `ModernBottomSheetWithHeader`

Bottom sheet with header and close button.

```dart
showModernBottomSheet(
  context: context,
  child: ModernBottomSheetWithHeader(
    title: 'Title',
    child: YourWidget(),
  ),
)
```

#### `ModernAlertDialog`

Modern alert dialog with icon.

```dart
showModernDialog(
  context: context,
  child: ModernAlertDialog(
    title: 'Confirm',
    icon: Icons.check_circle,
    content: Text('Are you sure?'),
    actions: [
      TextButton(...),
      GradientButton(...),
    ],
  ),
)
```

#### `ModernConfirmDialog`

Pre-configured confirmation dialog.

```dart
final confirmed = await showModernDialog<bool>(
  context: context,
  child: ModernConfirmDialog(
    title: 'Delete Item',
    message: 'This action cannot be undone.',
    isDestructive: true,
  ),
);
```

#### Helper Functions

```dart
showSuccessDialog(context: context, title: 'Success', message: '...');
showErrorDialog(context: context, title: 'Error', message: '...');
```

### 6. List Items

#### `ModernListTile`

Enhanced list tile with custom styling.

```dart
ModernListTile(
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  leading: Icon(Icons.star),
  trailing: Icon(Icons.arrow_forward),
  onTap: () {},
)
```

#### `ModernIconListTile`

List tile with colored icon container.

```dart
ModernIconListTile(
  title: 'Settings',
  subtitle: 'Configure app',
  icon: Icons.settings,
  iconColor: Colors.blue,
  onTap: () {},
)
```

#### `ModernSwitchListTile`

List tile with integrated switch.

```dart
ModernSwitchListTile(
  title: 'Enable Feature',
  value: isEnabled,
  onChanged: (value) {},
  icon: Icons.notifications,
)
```

### 7. Chips & Badges

#### `ModernChip`

Selectable chip component.

```dart
ModernChip(
  label: 'Tag',
  icon: Icons.tag,
  selected: true,
  onTap: () {},
  onDeleted: () {},  // Optional
)
```

#### `ModernBadge`

Badge overlay for notifications.

```dart
ModernBadge(
  count: 5,
  child: Icon(Icons.notifications),
)
```

#### `ModernChipGroup`

Group of selectable chips.

```dart
ModernChipGroup(
  labels: ['All', 'Active', 'Completed'],
  selectedIndices: {0},
  multiSelect: false,
  onSelectionChanged: (indices) {},
)
```

### 8. Animations

#### `FadeInWidget`

Fade in animation.

```dart
FadeInWidget(
  delay: Duration(milliseconds: 100),
  child: YourWidget(),
)
```

#### `SlideInWidget`

Slide in from direction.

```dart
SlideInWidget(
  direction: AxisDirection.up,
  delay: Duration(milliseconds: 100),
  child: YourWidget(),
)
```

#### `ScaleInWidget`

Scale up animation.

```dart
ScaleInWidget(
  initialScale: 0.8,
  delay: Duration(milliseconds: 100),
  child: YourWidget(),
)
```

#### `ShakeWidget`

Shake animation (useful for errors).

```dart
ShakeWidget(
  shake: hasError,
  child: YourWidget(),
)
```

#### `AnimatedListView`

ListView with staggered animations.

```dart
AnimatedListView(
  itemCount: items.length,
  animationType: AnimationType.fadeIn,
  staggerDelay: Duration(milliseconds: 50),
  itemBuilder: (context, index) => YourWidget(),
)
```

## 🚀 Usage

### Import Everything

```dart
import 'package:habit_tracker/shared/widgets/modern_widgets.dart';
```

### Or Import Specific Components

```dart
import 'package:habit_tracker/shared/design_system/app_design_system.dart';
import 'package:habit_tracker/shared/widgets/modern_card.dart';
import 'package:habit_tracker/shared/widgets/gradient_button.dart';
```

## 📝 Best Practices

1. **Always use design tokens** from `AppDesignSystem` instead of hardcoded values
2. **Leverage helper methods** for typography (e.g., `AppDesignSystem.bodyLarge(context)`)
3. **Use semantic colors** for consistent meaning across the app
4. **Apply consistent spacing** using predefined spacing constants
5. **Enable haptic feedback** for better UX (most components support this)
6. **Animate interactions** to make the app feel more responsive
7. **Test on multiple screen sizes** to ensure responsive behavior

## 🎯 Design Principles

- **Glassmorphism**: Frosted glass effect for modern look
- **Soft Shadows**: Elevation through subtle shadows
- **Rounded Corners**: Friendly and approachable interface
- **Consistent Spacing**: 8px grid system (4px base unit)
- **Smooth Animations**: 150-300ms duration for most interactions
- **Accessibility**: High contrast ratios, RTL support, scalable fonts
- **Responsive**: Adapts to different screen sizes automatically

## 🔧 Customization

All components accept customization parameters:

```dart
ModernCard(
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(20),
  elevation: AppDesignSystem.shadowLarge,
  padding: EdgeInsets.all(24),
  onTap: () {},
  child: YourWidget(),
)
```

## 📐 Color Palette

The design system uses Material Design 3 color scheme from `Theme.of(context).colorScheme`:

- `primary` - Primary brand color
- `secondary` - Secondary brand color
- `surface` - Background surfaces
- `error` - Error states
- `onPrimary` - Text on primary color
- `onSurface` - Text on surface color

Additional semantic colors available in `AppDesignSystem.success`, `warning`, `info`.

## 🎨 Typography Scale

- **Display Large** (32px) - Hero headlines
- **Headline Large** (28px) - Screen titles
- **Headline Medium** (24px) - Section headers
- **Title Large** (20px) - Card titles
- **Title Medium** (16px) - List item titles
- **Body Large** (16px) - Body text
- **Body Medium** (14px) - Secondary text
- **Body Small** (12px) - Captions

## 🔄 Migration Guide

To migrate existing components to use the new design system:

### Before

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Text('Hello'),
)
```

### After

```dart
ModernCard(
  padding: AppDesignSystem.paddingMedium,
  child: Text(
    'Hello',
    style: AppDesignSystem.bodyLarge(context),
  ),
)
```

## 📱 Responsive Behavior

Components automatically adapt to screen size using `MediaQuery` and `LayoutBuilder`:

- Spacing scales appropriately
- Typography remains readable
- Touch targets maintain minimum 48px size
- Flexible layouts adjust to available space

## 🌐 RTL Support

All components fully support right-to-left languages:

- Text alignment respects directionality
- Icons and arrows flip appropriately
- Padding/margin mirrors correctly

## ♿ Accessibility

Built-in accessibility features:

- Semantic labels on interactive elements
- High contrast color ratios (WCAG AA compliant)
- Haptic feedback for important actions
- Keyboard navigation support (where applicable)
- Screen reader compatibility

---

**Last Updated**: 2024
**Version**: 1.0.0
