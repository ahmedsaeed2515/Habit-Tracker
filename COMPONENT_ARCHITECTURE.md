# 🏗️ بنية المكونات وإرشادات التطوير

> **دليل شامل لفهم البنية المعمارية للمكونات وكيفية إضافة ميزات جديدة**

---

## 📐 نظرة عامة على البنية

### الهيكل الهرمي

```
lib/
├── common/                      # المكونات المشتركة
│   ├── widgets/                # Widgets قابلة لإعادة الاستخدام
│   │   ├── feature_grid_widget.dart
│   │   ├── search_bar_widget.dart
│   │   ├── custom_tab_switcher.dart
│   │   └── ...
│   └── mixins/                 # Mixins مشتركة
│
├── core/                       # النواة الأساسية
│   ├── models/                # نماذج البيانات الأساسية
│   ├── providers/             # مزودو الحالة العامة
│   ├── services/              # الخدمات الأساسية
│   └── widgets/               # Widgets أساسية
│
├── features/                   # الميزات المستقلة
│   ├── [feature_name]/
│   │   ├── models/           # نماذج خاصة بالميزة
│   │   ├── providers/        # مزودو حالة الميزة
│   │   ├── screens/          # شاشات الميزة
│   │   ├── services/         # خدمات الميزة
│   │   └── widgets/          # Widgets خاصة بالميزة
│   └── ...
│
└── shared/                     # موارد مشتركة
    ├── themes/               # السمات والألوان
    ├── localization/        # الترجمة
    └── constants/           # الثوابت
```

---

## 🧩 المكونات الرئيسية

### 1. FeatureGridWidget

**الغرض**: عرض شبكة من الميزات بطريقة موحدة

**الموقع**: `lib/common/widgets/feature_grid_widget.dart`

#### البنية

```dart
class FeatureItem {
  final String title;        // العنوان بالإنجليزية
  final String titleAr;      // العنوان بالعربية
  final IconData icon;       // الأيقونة
  final String route;        // مسار التنقل
  final Color? iconColor;    // لون الأيقونة (اختياري)
  final List<Color>? gradientColors;  // ألوان التدرج (اختياري)
}

class FeatureGridWidget extends StatelessWidget {
  final List<FeatureItem> items;
  final Function(String route) onItemTap;
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;
}
```

#### مثال الاستخدام

```dart
// 1. تعريف الميزات
final myFeatures = [
  const FeatureItem(
    title: 'Feature 1',
    titleAr: 'ميزة 1',
    icon: Icons.star,
    route: 'feature1',
    iconColor: Color(0xFF4CAF50),
    gradientColors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
  ),
  // ... المزيد من الميزات
];

// 2. الاستخدام في build method
@override
Widget build(BuildContext context) {
  return FeatureGridWidget(
    items: myFeatures,
    onItemTap: (route) => _navigateToFeature(context, route),
    crossAxisCount: 2,
    childAspectRatio: 1.2,
  );
}

// 3. معالج التنقل
void _navigateToFeature(BuildContext context, String route) {
  Widget? screen;
  switch (route) {
    case 'feature1':
      screen = const Feature1Screen();
      break;
    // ... حالات أخرى
  }
  
  if (screen != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen!),
    );
  }
}
```

---

### 2. SearchBarWidget

**الغرض**: شريط بحث موحد مع تأثيرات حركية

**الموقع**: `lib/common/widgets/search_bar_widget.dart`

#### الخصائص

```dart
class SearchBarWidget extends StatefulWidget {
  final String hintText;                    // نص الإرشاد
  final ValueChanged<String> onChanged;     // callback للتغييرات
  final VoidCallback? onClear;              // callback للمسح
  final bool showClearButton;               // إظهار زر المسح
  final Color? backgroundColor;             // لون الخلفية
  final Color? textColor;                   // لون النص
  final double? height;                     // الارتفاع
}
```

#### مثال الاستخدام

```dart
SearchBarWidget(
  hintText: isArabic ? 'البحث...' : 'Search...',
  onChanged: (value) {
    setState(() {
      _searchQuery = value;
    });
  },
  onClear: () {
    setState(() {
      _searchQuery = '';
    });
  },
)
```

---

### 3. PomodoroHeaderWidget

**الغرض**: رأس شاشة Pomodoro مع المؤقت والإحصائيات

**الموقع**: `lib/features/pomodoro_task_management/widgets/pomodoro_header_widget.dart`

#### الخصائص

```dart
class PomodoroHeaderWidget extends ConsumerWidget {
  final AnimationController animationController;
}
```

#### الميزات

- ✅ عرض رسالة ترحيب ديناميكية (صباح/مساء)
- ✅ أزرار سريعة للإعدادات والتحليلات
- ✅ عرض المؤقت النشط أو الإحصائيات السريعة
- ✅ تأثيرات حركية (SlideTransition)
- ✅ تدرج لوني جذاب

---

### 4. SearchFilterBarWidget

**الغرض**: شريط بحث وتصفية متقدم

**الموقع**: `lib/features/pomodoro_task_management/widgets/search_filter_bar_widget.dart`

#### الخصائص

```dart
class SearchFilterBarWidget extends ConsumerStatefulWidget {
  final AnimationController animationController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<bool>? onShowCompletedChanged;
  final ValueChanged<bool>? onViewModeChanged;
}
```

#### الميزات

- ✅ بحث في المهام
- ✅ تصفية سريعة (الكل، عالي الأولوية، مستحقة اليوم)
- ✅ تبديل وضع العرض (مدمج/عادي)
- ✅ إظهار/إخفاء المهام المكتملة

---

## 📝 إرشادات إضافة ميزة جديدة

### الخطوة 1: إنشاء هيكل الميزة

```bash
lib/features/my_new_feature/
├── models/
│   └── my_feature_models.dart
├── providers/
│   └── my_feature_providers.dart
├── screens/
│   └── my_feature_screen.dart
├── services/
│   └── my_feature_service.dart
└── widgets/
    └── my_feature_widget.dart
```

### الخطوة 2: تعريف النماذج

```dart
// lib/features/my_new_feature/models/my_feature_models.dart
import 'package:hive/hive.dart';

part 'my_feature_models.g.dart';

@HiveType(typeId: XX)  // اختر رقم فريد
class MyFeatureModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final DateTime createdAt;
  
  MyFeatureModel({
    required this.id,
    required this.title,
    required this.createdAt,
  });
}
```

### الخطوة 3: إنشاء الشاشة

```dart
// lib/features/my_new_feature/screens/my_feature_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyFeatureScreen extends ConsumerStatefulWidget {
  const MyFeatureScreen({super.key});

  @override
  ConsumerState<MyFeatureScreen> createState() => _MyFeatureScreenState();
}

class _MyFeatureScreenState extends ConsumerState<MyFeatureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feature'),
      ),
      body: const Center(
        child: Text('My Feature Content'),
      ),
    );
  }
}
```

### الخطوة 4: إضافة الميزة إلى الشبكة

```dart
// في daily_screen.dart أو productivity_screen.dart
static final List<FeatureItem> _features = [
  // ... الميزات الموجودة
  const FeatureItem(
    title: 'My Feature',
    titleAr: 'ميزتي الجديدة',
    icon: Icons.new_feature,
    route: 'my_feature',
    iconColor: Color(0xFF9C27B0),
    gradientColors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
  ),
];

// في معالج التنقل
void _navigateToFeature(BuildContext context, String route) {
  Widget? screen;
  switch (route) {
    // ... الحالات الموجودة
    case 'my_feature':
      screen = const MyFeatureScreen();
      break;
  }
  
  if (screen != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen!),
    );
  }
}
```

---

## 🎨 معايير التصميم

### ألوان موصى بها للميزات

```dart
// ألوان أساسية
const Color green = Color(0xFF4CAF50);      // للنجاح والإكمال
const Color blue = Color(0xFF2196F3);       // للمعلومات
const Color orange = Color(0xFFFF9800);     // للتحذير
const Color red = Color(0xFFF44336);        // للخطر
const Color purple = Color(0xFF9C27B0);     // للمميز
const Color teal = Color(0xFF009688);       // للتقدم
const Color indigo = Color(0xFF3F51B5);     // للأساسي
const Color pink = Color(0xFFE91E63);       // للإبداع

// تدرجات لونية موصى بها
final lightGreen = [Color(0xFFE8F5E9), Color(0xFFC8E6C9)];
final lightBlue = [Color(0xFFE3F2FD), Color(0xFFBBDEFB)];
final lightOrange = [Color(0xFFFFF3E0), Color(0xFFFFE0B2)];
final lightPurple = [Color(0xFFF3E5F5), Color(0xFFE1BEE7)];
```

### أيقونات موصى بها

```dart
// للأنشطة اليومية
Icons.track_changes_rounded    // عادات
Icons.checklist_rounded        // مهام
Icons.wb_sunny_rounded        // صباح
Icons.fitness_center_rounded  // رياضة

// للإنتاجية
Icons.emoji_events_rounded    // إنجازات
Icons.timer_rounded           // مؤقت
Icons.note_rounded            // ملاحظات
Icons.mood_rounded            // مزاج
Icons.folder_rounded          // مشاريع

// للإعدادات
Icons.settings_rounded        // إعدادات
Icons.person_rounded          // ملف شخصي
Icons.notifications_rounded   // إشعارات
Icons.language_rounded        // لغة
```

---

## 🔄 أنماط الحالة (State Management)

### استخدام Riverpod

```dart
// Provider بسيط
final myProvider = Provider<MyService>((ref) {
  return MyService();
});

// StateProvider للقيم البسيطة
final counterProvider = StateProvider<int>((ref) => 0);

// FutureProvider للبيانات غير المتزامنة
final dataProvider = FutureProvider<List<Data>>((ref) async {
  final service = ref.watch(myProvider);
  return service.getData();
});

// StreamProvider للبث المباشر
final streamProvider = StreamProvider<Data>((ref) {
  final service = ref.watch(myProvider);
  return service.dataStream;
});

// StateNotifierProvider للحالة المعقدة
final notifierProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});
```

---

## 🧪 الاختبار

### اختبار المكونات

```dart
// test/widgets/feature_grid_widget_test.dart
void main() {
  testWidgets('FeatureGridWidget displays items correctly', (tester) async {
    final items = [
      const FeatureItem(
        title: 'Test',
        titleAr: 'اختبار',
        icon: Icons.star,
        route: 'test',
      ),
    ];
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FeatureGridWidget(
            items: items,
            onItemTap: (route) {},
          ),
        ),
      ),
    );
    
    expect(find.text('Test'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
```

---

## 📊 معايير الجودة

### حجم الملفات
- ✅ الشاشات: أقل من 300 سطر
- ✅ Widgets: أقل من 200 سطر
- ✅ Services: أقل من 500 سطر
- ✅ Models: أقل من 100 سطر

### الأداء
- ✅ وقت البناء: أقل من 16ms
- ✅ استهلاك الذاكرة: معقول
- ✅ عدد إعادة البناء: محدود

### الكود
- ✅ تعليقات توضيحية
- ✅ أسماء واضحة ومفهومة
- ✅ تنسيق موحد
- ✅ لا توجد أخطاء أو تحذيرات

---

## 🚀 أفضل الممارسات

### 1. استخدام const constructors
```dart
// ✅ جيد
const MyWidget();

// ❌ سيئ
MyWidget();
```

### 2. استخراج Widgets المعقدة
```dart
// ✅ جيد
Widget _buildHeader() => const HeaderWidget();

// ❌ سيئ - كل الكود في build method
```

### 3. استخدام keys عند الضرورة
```dart
// ✅ جيد
ListView.builder(
  itemBuilder: (context, index) {
    return MyWidget(key: ValueKey(items[index].id));
  },
)
```

### 4. التعامل مع الأخطاء
```dart
// ✅ جيد
try {
  await service.getData();
} catch (e) {
  debugPrint('Error: $e');
  // عرض رسالة للمستخدم
}
```

---

## 📚 مراجع مفيدة

### الوثائق
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Hive Documentation](https://docs.hivedb.dev)

### أنماط التصميم
- Clean Architecture
- BLoC Pattern
- Provider Pattern
- Repository Pattern

---

## ✨ الخلاصة

هذا الدليل يوفر:
- 🏗️ فهم شامل للبنية المعمارية
- 🧩 كيفية استخدام المكونات الموجودة
- 📝 خطوات واضحة لإضافة ميزات جديدة
- 🎨 معايير التصميم الموحدة
- 🧪 إرشادات الاختبار
- 🚀 أفضل الممارسات

استخدم هذا الدليل كمرجع عند تطوير ميزات جديدة! 💪

---

**آخر تحديث**: 13 أكتوبر 2025
