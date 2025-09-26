# Database Architecture - بنية قاعدة البيانات

تم إعادة تنظيم مدير قاعدة البيانات إلى وحدات منطقية منفصلة لسهولة الصيانة والتطوير.

## 📁 البنية الجديدة

```
lib/core/database/
├── database_manager.dart          # المدير الرئيسي (محدود الوظائف)
├── database_exports.dart          # ملف التصدير الموحد
├── managers/                      # مجلد المديرين المتخصصين
│   ├── base_database_manager.dart # المدير الأساسي (وظائف مشتركة)
│   ├── adapters_manager.dart      # مدير تسجيل المحولات
│   ├── workout_manager.dart       # مدير التمارين
│   └── habits_manager.dart        # مدير العادات
└── README.md                      # هذا الملف
```

## 🔧 المديرين المتخصصين

### 1. BaseDatabaseManager

**الملف:** `managers/base_database_manager.dart`

- وظائف مساعدة مشتركة
- `registerAdapterSafe()` - تسجيل آمن للمحولات
- `openBoxSafe()` - فتح آمن للصناديق
- `createDefaultDataIfEmpty()` - إنشاء بيانات افتراضية

### 2. AdaptersManager

**الملف:** `managers/adapters_manager.dart`

- تسجيل جميع محولات Hive
- مُنظَّم حسب الوحدة (إشعارات، تمارين، عادات، إلخ)
- معرفات TypeId واضحة ومُوثقة

### 3. WorkoutManager

**الملف:** `managers/workout_manager.dart`

- إدارة كاملة لبيانات التمارين
- إحصائيات التمارين
- فلترة بالتاريخ
- `add()`, `update()`, `delete()`, `getAll()`

### 4. HabitsManager

**الملف:** `managers/habits_manager.dart`

- إدارة كاملة للعادات وإدخالاتها
- تتبع الخطوط (Streaks)
- إحصائيات العادات
- حساب معدل الإكمال

## 📖 كيفية الاستخدام

### الاستيراد

```dart
// استيراد جميع المديرين
import 'package:habit_tracker/core/database/database_exports.dart';

// أو استيراد مدير محدد
import 'package:habit_tracker/core/database/managers/workout_manager.dart';
```

### التهيئة

```dart
// تهيئة قاعدة البيانات (يتم تهيئة جميع المديرين)
await DatabaseManager.initialize();
```

### استخدام المديرين الجدد

```dart
// استخدام WorkoutManager
await WorkoutManager.add(workout);
final workouts = WorkoutManager.getAll();

// استخدام HabitsManager
await HabitsManager.addHabit(habit);
final stats = HabitsManager.getHabitsStats();
```

### التوافق مع النسخة القديمة

```dart
// الطرق القديمة تعمل لكن deprecated
await DatabaseManager.addWorkout(workout); // ❌ deprecated
await WorkoutManager.add(workout);          // ✅ الطريقة الجديدة
```

## ⚡ المميزات الجديدة

1. **تنظيم أفضل**: كل وحدة في ملف منفصل
2. **سهولة الصيانة**: تعديل وحدة واحدة فقط عند الحاجة
3. **إعادة الاستخدام**: المديرين قابلون للاستخدام بشكل مستقل
4. **التوافق**: الطرق القديمة تعمل لضمان عدم كسر الكود الموجود
5. **الإحصائيات**: إحصائيات مُحسَّنة وأكثر تفصيلاً
6. **معالجة الأخطاء**: معالجة آمنة مع رسائل واضحة

## 🚀 خطط المستقبل

- [ ] مدير للمهام (TasksManager)
- [ ] مدير لتمارين الصباح (MorningExerciseManager)
- [ ] مدير للإعدادات (SettingsManager)
- [ ] مدير للنسخ الاحتياطي (BackupManager)
- [ ] دعم قواعد البيانات السحابية
- [ ] تشفير البيانات

## 📝 ملاحظات للمطورين

- استخدم المديرين الجدد في الكود الجديد
- الطرق المُعلَّمة بـ `@deprecated` ستُحذف في النسخة القادمة
- تأكد من استدعاء `DatabaseManager.initialize()` قبل استخدام أي مدير
- راجع إحصائيات كل مدير للحصول على بيانات مفيدة

---

**تم إنشاء هذا التنظيم في**: سبتمبر 2025  
**آخر تحديث**: اليوم
