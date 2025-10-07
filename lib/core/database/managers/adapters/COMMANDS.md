# 🎯 الأوامر المطلوبة - إعادة هيكلة Adapters

## ⚡ تنفيذ سريع (5 دقائق)

### الخطوة 1: تشغيل Build Runner

```bash
cd d:\FlutterProjects\habit-tracker
flutter pub run build_runner build --delete-conflicting-outputs
```

**الانتظار**: 2-3 دقائق  
**النتيجة المتوقعة**: إنشاء ملفات `.g.dart` في:

- `lib/features/notes/models/note_models.g.dart`
- `lib/features/mood_journal/models/mood_models.g.dart`
- `lib/features/budget/models/budget_models.g.dart`
- `lib/features/projects/models/project_models.g.dart`
- `lib/features/inbox/models/inbox_models.g.dart`

---

### الخطوة 2: فتح ملف taskmeta_adapters.dart

**المسار**:

```
d:\FlutterProjects\habit-tracker\lib\core\database\managers\adapters\taskmeta_adapters.dart
```

**التعديلات المطلوبة**:

#### أ) إضافة import في البداية:

```dart
import 'package:hive/hive.dart';
import '../../../../features/notes/models/note_models.dart';
import '../../../../features/mood_journal/models/mood_models.dart';
import '../../../../features/budget/models/budget_models.dart';
import '../../../../features/projects/models/project_models.dart';
```

#### ب) في دالة `registerNotesAdapters()` - أزل `//` من:

```dart
if (!Hive.isAdapterRegistered(250)) Hive.registerAdapter(NoteAdapter());
if (!Hive.isAdapterRegistered(251)) Hive.registerAdapter(NoteAttachmentAdapter());
if (!Hive.isAdapterRegistered(252)) Hive.registerAdapter(NoteLinkAdapter());
if (!Hive.isAdapterRegistered(253)) Hive.registerAdapter(AttachmentTypeAdapter());
if (!Hive.isAdapterRegistered(254)) Hive.registerAdapter(LinkTargetTypeAdapter());
```

#### ج) في دالة `registerMoodJournalAdapters()` - أزل `//` من:

```dart
if (!Hive.isAdapterRegistered(255)) Hive.registerAdapter(MoodEntryAdapter());
if (!Hive.isAdapterRegistered(256)) Hive.registerAdapter(JournalEntryAdapter());
if (!Hive.isAdapterRegistered(257)) Hive.registerAdapter(MoodAnalyticsAdapter());
```

#### د) في دالة `registerBudgetAdapters()` - أزل `//` من:

```dart
if (!Hive.isAdapterRegistered(258)) Hive.registerAdapter(ExpenseAdapter());
if (!Hive.isAdapterRegistered(259)) Hive.registerAdapter(IncomeAdapter());
if (!Hive.isAdapterRegistered(260)) Hive.registerAdapter(BudgetCategoryAdapter());
if (!Hive.isAdapterRegistered(261)) Hive.registerAdapter(FinancialReportAdapter());
if (!Hive.isAdapterRegistered(262)) Hive.registerAdapter(RecurrenceTypeAdapter());
```

#### هـ) في دالة `registerProjectsAdapters()` - أزل `//` من:

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

#### و) غير رسائل debugPrint من:

```dart
debugPrint('⏳ محولات الملاحظات جاهزة للتسجيل (typeIds: 250-254)');
```

إلى:

```dart
debugPrint('✅ تم تسجيل محولات الملاحظات (typeIds: 250-254)');
```

---

### الخطوة 3: تحديث main.dart

**البحث عن**:

```dart
import 'package:habit_tracker/core/database/managers/adapters_manager.dart';
```

**استبدال بـ**:

```dart
import 'package:habit_tracker/core/database/managers/adapters_manager_new.dart';
```

**الكود يبقى كما هو**:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await Hive.initFlutter();

  // تسجيل المحولات
  AdaptersManager.registerAllAdapters(); // لا تغيير هنا

  // باقي الكود...
}
```

---

### الخطوة 4: الاختبار

```bash
flutter run
```

**تحقق من Console للرسائل**:

```
✅ تم تسجيل المحولات الأساسية
✅ تم تسجيل محولات الميزات المتقدمة
✅ تم تسجيل محولات الصحة واللياقة
✅ تم تسجيل محولات بومودورو
✅ تم تسجيل محولات الملاحظات (typeIds: 250-254)
✅ تم تسجيل محولات المزاج (typeIds: 255-257)
✅ تم تسجيل محولات الميزانية (typeIds: 258-262)
✅ تم تسجيل محولات المشاريع (typeIds: 263-270)
✅ تم تسجيل محولات Task Meta
✅ تم تسجيل جميع محولات Hive بنجاح
```

---

### الخطوة 5: اختبار الميزات

#### أ) اختبار الملاحظات:

1. افتح التطبيق
2. اذهب إلى Productivity → Notes
3. أضف ملاحظة جديدة
4. تحقق من الحفظ

#### ب) اختبار المزاج:

1. Productivity → Mood & Journal
2. سجل المزاج (1-10)
3. اكتب يومية
4. احفظ

#### ج) اختبار الميزانية:

1. Productivity → Budget
2. أضف مصروف
3. أضف دخل
4. تحقق من الملخص

#### د) اختبار المشاريع:

1. Productivity → Projects
2. أنشئ مشروع جديد
3. أضف مرحلة
4. أضف مهمة
5. تحقق من Kanban view

---

## 🎯 Checklist

- [ ] ✅ تشغيل build_runner بنجاح
- [ ] ✅ فك تعليق كل المحولات في taskmeta_adapters.dart
- [ ] ✅ إضافة imports في taskmeta_adapters.dart
- [ ] ✅ تحديث debugPrint messages
- [ ] ✅ تحديث import في main.dart
- [ ] ✅ flutter run بدون أخطاء
- [ ] ✅ اختبار Notes
- [ ] ✅ اختبار Mood & Journal
- [ ] ✅ اختبار Budget
- [ ] ✅ اختبار Projects
- [ ] ✅ التحقق من رسائل Console

---

## 🔧 استكشاف الأخطاء

### خطأ: `Unable to determine engine version`

**التجاهل**: هذا خطأ في Git - لا يؤثر على build_runner  
**الحل البديل**: استخدم VS Code Terminal بدلاً من PowerShell

### خطأ: `Target of URI hasn't been generated`

**السبب**: build_runner لم يكتمل  
**الحل**: انتظر انتهاء build_runner وأعد المحاولة

### خطأ: `Adapter for type X not found`

**السبب**: نسيت فك تعليق المحول  
**الحل**: راجع الخطوة 2

### خطأ: `Adapter already registered`

**السبب**: تم تسجيل المحول مرتين  
**الحل**: تأكد من وجود `if (!Hive.isAdapterRegistered(X))`

---

## 📞 الدعم

- **للمزيد من التفاصيل**: راجع `README.md`
- **للشرح السريع**: راجع `QUICKSTART.md`
- **لسجل TypeIDs**: راجع `TYPEID_REGISTRY.md`
- **للملخص الكامل**: راجع `REFACTORING_SUMMARY.md`

---

**الوقت المتوقع**: 5-10 دقائق  
**الصعوبة**: سهلة (نسخ ولصق)  
**النتيجة**: تطبيق منظم وقابل للتطوير

🚀 **حظاً موفقاً!**
