# 🚀 دليل الاستخدام السريع - Adapters Manager

## الملف القديم → الملفات الجديدة

### قبل (ملف واحد كبير):

```
adapters_manager.dart (400+ سطر) ❌
```

### بعد (6 ملفات منظمة):

```
adapters_manager_new.dart (واجهة بسيطة) ✅
└── adapters/
    ├── core_adapters.dart
    ├── feature_adapters.dart
    ├── health_adapters.dart
    ├── pomodoro_adapters.dart
    └── taskmeta_adapters.dart
```

---

## 🎯 الخطوات المطلوبة الآن

### 1. تشغيل Build Runner (إلزامي)

```bash
cd d:\FlutterProjects\habit-tracker
flutter pub run build_runner build --delete-conflicting-outputs
```

**ما يفعله**: يقوم بإنشاء ملفات `.g.dart` لكل النماذج:

- `note_models.g.dart`
- `mood_models.g.dart`
- `budget_models.g.dart`
- `project_models.g.dart`
- `inbox_models.g.dart`

---

### 2. تحديث main.dart

**البحث عن**:

```dart
import 'package:habit_tracker/core/database/managers/adapters_manager.dart';
```

**استبدل بـ**:

```dart
import 'package:habit_tracker/core/database/managers/adapters_manager_new.dart';
```

**لا تغيير آخر مطلوب!** الـ API متطابق:

```dart
AdaptersManager.registerAllAdapters();
```

---

### 3. فك تعليق المحولات (بعد build_runner)

افتح `adapters/taskmeta_adapters.dart` وقم بإزالة `//` من:

#### في `registerNotesAdapters()`:

```dart
// كان:
// if (!Hive.isAdapterRegistered(250)) Hive.registerAdapter(NoteAdapter());

// سيصبح:
if (!Hive.isAdapterRegistered(250)) Hive.registerAdapter(NoteAdapter());
if (!Hive.isAdapterRegistered(251)) Hive.registerAdapter(NoteAttachmentAdapter());
if (!Hive.isAdapterRegistered(252)) Hive.registerAdapter(NoteLinkAdapter());
if (!Hive.isAdapterRegistered(253)) Hive.registerAdapter(AttachmentTypeAdapter());
if (!Hive.isAdapterRegistered(254)) Hive.registerAdapter(LinkTargetTypeAdapter());
```

#### في `registerMoodJournalAdapters()`:

```dart
if (!Hive.isAdapterRegistered(255)) Hive.registerAdapter(MoodEntryAdapter());
if (!Hive.isAdapterRegistered(256)) Hive.registerAdapter(JournalEntryAdapter());
if (!Hive.isAdapterRegistered(257)) Hive.registerAdapter(MoodAnalyticsAdapter());
```

#### في `registerBudgetAdapters()`:

```dart
if (!Hive.isAdapterRegistered(258)) Hive.registerAdapter(ExpenseAdapter());
if (!Hive.isAdapterRegistered(259)) Hive.registerAdapter(IncomeAdapter());
if (!Hive.isAdapterRegistered(260)) Hive.registerAdapter(BudgetCategoryAdapter());
if (!Hive.isAdapterRegistered(261)) Hive.registerAdapter(FinancialReportAdapter());
if (!Hive.isAdapterRegistered(262)) Hive.registerAdapter(RecurrenceTypeAdapter());
```

#### في `registerProjectsAdapters()`:

```dart
if (!Hive.isAdapterRegistered(263)) Hive.registerAdapter(ProjectAdapter());
if (!Hive.isAdapterRegistered(264)) Hive.registerAdapter(ProjectStatusAdapter());
if (!Hive.isAdapterRegistered(265)) Hive.registerAdapter(ProjectPhaseAdapter());
if (!Hive.isAdapterRegistered(266)) Hive.registerAdapter(PhaseStatusAdapter());
if (!Hive.isAdapterRegistered(267)) Hive.registerAdapter(ProjectTaskAdapter());
if (!Hive.isAdapterRegistered(268)) Hive.registerAdapter(TaskPriorityAdapter());
if (!Hive.isAdapterRegistered(269)) Hive.registerAdapter(TaskStatusAdapter());
if (!Hive.isAdapterRegistered(270)) Hive.registerAdapter(ProjectViewModeAdapter());
```

**ملاحظة**: أضف أيضاً:

```dart
import 'package:hive/hive.dart';
```

في أول الملف.

---

### 4. الاختبار

```bash
flutter run
```

**تحقق من**:

- ✅ عدم وجود أخطاء في Console
- ✅ ظهور: `✅ تم تسجيل جميع محولات Hive بنجاح`
- ✅ عمل الملاحظات/المزاج/الميزانية/المشاريع

---

## 🔍 استكشاف الأخطاء الشائعة

### خطأ: `Unable to determine engine version`

**السبب**: مشكلة في Git ownership  
**الحل**: تجاهلها وشغل build_runner من VS Code Terminal

### خطأ: `Adapter for type X not found`

**السبب**: build_runner لم يتم تشغيله  
**الحل**: نفذ الخطوة 1

### خطأ: `Adapter already registered`

**السبب**: تم تسجيل المحول مرتين  
**الحل**: تأكد من وجود `if (!Hive.isAdapterRegistered(X))`

### خطأ: `URI hasn't been generated`

**السبب**: ملف `.g.dart` مفقود  
**الحل**: نفذ الخطوة 1

---

## 📱 API للاستخدام المتقدم

### تسجيل كل شيء (الوضع العادي):

```dart
AdaptersManager.registerAllAdapters();
```

### تسجيل الأساسية فقط (للاختبار):

```dart
AdaptersManager.registerCoreOnly();
```

### تسجيل الأساسية + Task Meta (تطوير):

```dart
AdaptersManager.registerTaskMetaOnly();
```

### تسجيل مجموعة محددة:

```dart
import 'package:habit_tracker/core/database/managers/adapters/core_adapters.dart';
import 'package:habit_tracker/core/database/managers/adapters/taskmeta_adapters.dart';

CoreAdaptersRegistrar.registerAll();
TaskMetaAdaptersRegistrar.registerAll();
```

---

## ✅ Checklist

- [ ] تشغيل build_runner بنجاح
- [ ] فك تعليق المحولات في `taskmeta_adapters.dart`
- [ ] إضافة `import 'package:hive/hive.dart';` في `taskmeta_adapters.dart`
- [ ] تحديث import في `main.dart`
- [ ] اختبار التطبيق
- [ ] التحقق من عمل Notes/Mood/Budget/Projects
- [ ] حذف `adapters_manager.dart` القديم (اختياري)

---

## 🎉 النتيجة

بعد اتباع الخطوات:

- ✅ كود منظم وسهل الصيانة
- ✅ سهولة إضافة ميزات جديدة
- ✅ تقليل الأخطاء
- ✅ تحسين أداء التطوير

**الوقت المتوقع**: 5-10 دقائق

---

**أي أسئلة؟** راجع `README.md` في نفس المجلد.
