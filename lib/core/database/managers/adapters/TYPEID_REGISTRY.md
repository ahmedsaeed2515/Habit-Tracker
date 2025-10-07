# TypeID Registry - سجل معرفات النماذج

> **مهم**: عند إضافة نماذج جديدة، تأكد من استخدام TypeID غير مستخدم من هذا الجدول

## 📊 TypeID Allocation Table

### Core System (0-17)

| TypeID | النموذج              | الميزة        | الملف                   |
| ------ | -------------------- | ------------- | ----------------------- |
| 0      | Workout              | التمارين      | workout.dart            |
| 1      | ExerciseSet          | التمارين      | workout.dart            |
| 2      | MorningExercise      | تمارين الصباح | morning_exercise.dart   |
| 3      | ExerciseType         | تمارين الصباح | morning_exercise.dart   |
| 4      | ExerciseGoal         | تمارين الصباح | morning_exercise.dart   |
| 5      | Habit                | العادات       | habit.dart              |
| 6      | HabitEntry           | العادات       | habit.dart              |
| 7      | HabitType            | العادات       | habit.dart              |
| 8      | TaskSheet            | المهام        | task.dart               |
| 9      | Task                 | المهام        | task.dart               |
| 10     | SmartNotification    | الإشعارات     | smart_notification.dart |
| 11     | NotificationType     | الإشعارات     | smart_notification.dart |
| 12     | NotificationPriority | الإشعارات     | smart_notification.dart |
| 13     | SubTask              | المهام        | task.dart               |
| 14     | TaskPriority         | المهام        | task.dart               |
| 15     | TaskStatus           | المهام        | task.dart               |
| 16     | AppSettings          | الإعدادات     | settings.dart           |
| 17     | AppTimeOfDay         | الإعدادات     | settings.dart           |

---

### Features (18-48, 73-80)

| TypeID | النموذج                    | الميزة             | الملف                    |
| ------ | -------------------------- | ------------------ | ------------------------ |
| 18     | VoiceCommandType           | الأوامر الصوتية    | voice_command.dart       |
| 19     | CommandStatus              | الأوامر الصوتية    | voice_command.dart       |
| 20     | VoiceCommand               | الأوامر الصوتية    | voice_command.dart       |
| 20     | Achievement                | التحفيز            | achievement_adapter.dart |
| 21     | HabitTemplate              | بناء العادات       | habit_template.dart      |
| 21     | WorkoutPlan                | مخطط التمارين      | adapters.dart            |
| 22     | HabitCategory              | بناء العادات       | habit_template.dart      |
| 22     | WorkoutDay                 | مخطط التمارين      | adapters.dart            |
| 23     | UserProfile (HabitBuilder) | بناء العادات       | habit_template.dart      |
| 23     | Exercise (WorkoutPlanner)  | مخطط التمارين      | adapters.dart            |
| 23     | Badge                      | التحفيز            | badge_adapter.dart       |
| 24     | AIMessage                  | المساعد الذكي      | ai_message.dart          |
| 24     | AIRecommendation           | مخطط التمارين      | adapters.dart            |
| 25     | AIMessageType              | المساعد الذكي      | ai_message.dart          |
| 25     | UserProfile (Main)         | الملف الشخصي       | user_profile.dart        |
| 26     | AIPersonalityProfile       | المساعد الذكي      | ai_message.dart          |
| 26     | Points                     | التحفيز            | points_adapter.dart      |
| 27     | PersonalityType            | المساعد الذكي      | ai_message.dart          |
| 27     | PointsTransaction          | التحفيز            | points_adapter.dart      |
| 29     | Level                      | التحفيز            | level_adapter.dart       |
| 31     | Challenge                  | التحفيز            | challenge_adapter.dart   |
| 35     | Reward                     | التحفيز            | reward_adapter.dart      |
| 45     | SocialUser                 | الشبكات الاجتماعية | social_user.dart         |
| 46     | SocialPost                 | الشبكات الاجتماعية | social_user.dart         |
| 47     | SocialComment              | الشبكات الاجتماعية | social_user.dart         |
| 48     | PostType                   | الشبكات الاجتماعية | social_user.dart         |
| 73     | WidgetConfig               | نظام الودجت        | widget_config.dart       |
| 74     | WidgetType                 | نظام الودجت        | widget_config.dart       |
| 75     | WidgetSize                 | نظام الودجت        | widget_config.dart       |
| 76     | WidgetTheme                | نظام الودجت        | widget_config.dart       |
| 77     | RefreshInterval            | نظام الودجت        | widget_config.dart       |
| 78     | WidgetData                 | نظام الودجت        | widget_config.dart       |
| 79     | WidgetLayout               | نظام الودجت        | widget_config.dart       |
| 80     | WidgetPosition             | نظام الودجت        | widget_config.dart       |

---

### Pomodoro System (81-110)

| TypeID | النموذج                  | الفئة           | الملف                 |
| ------ | ------------------------ | --------------- | --------------------- |
| 81     | PomodoroSession          | Core            | pomodoro_models.dart  |
| 82     | SessionType              | Core            | pomodoro_models.dart  |
| 83     | SessionStatus            | Core            | pomodoro_models.dart  |
| 84     | PomodoroSettings         | Core            | pomodoro_models.dart  |
| 85     | AdvancedTask             | Task Management | pomodoro_models.dart  |
| 86     | TaskPriority (Pomodoro)  | Task Management | pomodoro_models.dart  |
| 87     | TaskStatus (Pomodoro)    | Task Management | pomodoro_models.dart  |
| 88     | Subtask                  | Task Management | pomodoro_models.dart  |
| 89     | PomodoroStats            | Statistics      | pomodoro_models.dart  |
| 90     | RecurrenceRule           | Statistics      | pomodoro_models.dart  |
| 91     | Project (Pomodoro)       | Statistics      | pomodoro_models.dart  |
| 92     | Achievement (Pomodoro)   | Gamification    | pomodoro_models.dart  |
| 93     | AchievementType          | Gamification    | pomodoro_models.dart  |
| 94     | MultiTimer               | Multi-Timer     | pomodoro_models.dart  |
| 95     | AITaskSuggestion         | AI Features     | pomodoro_models.dart  |
| 96     | PomodoroTheme            | AI Features     | pomodoro_models.dart  |
| 97     | BreakSuggestion          | AI Features     | pomodoro_models.dart  |
| 98     | RecurrenceType           | Enums           | pomodoro_models.dart  |
| 99     | ProjectStatus (Pomodoro) | Enums           | pomodoro_models.dart  |
| 100    | AchievementCategory      | Enums           | pomodoro_models.dart  |
| 101    | SuggestionType           | Enums           | pomodoro_models.dart  |
| 102    | DateTime                 | Core            | datetime_adapter.dart |
| 103    | NullableDateTime         | Core            | datetime_adapter.dart |
| 104    | Duration                 | Core            | duration_adapter.dart |
| 105    | NullableDuration         | Core            | duration_adapter.dart |

---

### Health & Fitness (38-42, 133-145)

| TypeID | النموذج                     | الفئة         | الملف              |
| ------ | --------------------------- | ------------- | ------------------ |
| 38     | HealthData                  | Health Data   | health_data.dart   |
| 39     | ActivityLevel               | Health Data   | health_data.dart   |
| 40     | SleepQuality                | Health Data   | health_data.dart   |
| 41     | HealthGoal                  | Health Data   | health_data.dart   |
| 42     | HealthMetricType            | Health Data   | health_data.dart   |
| 133    | HealthProfile               | Health Models | health_models.dart |
| 134    | HealthMetric                | Health Models | health_models.dart |
| 135    | HealthDataPoint             | Health Models | health_models.dart |
| 136    | HealthGoal (Advanced)       | Health Models | health_models.dart |
| 137    | HealthInsight               | Health Models | health_models.dart |
| 138    | HealthTrend                 | Health Models | health_models.dart |
| 139    | HealthPrivacySettings       | Health Models | health_models.dart |
| 140    | HealthMetricType (Advanced) | Health Models | health_models.dart |
| 141    | HealthDataSource            | Health Models | health_models.dart |
| 142    | HealthTrendDirection        | Health Models | health_models.dart |
| 143    | HealthGoalType              | Health Models | health_models.dart |
| 144    | HealthInsightType           | Health Models | health_models.dart |
| 145    | HealthInsightPriority       | Health Models | health_models.dart |

---

### 🌟 Task Meta Features (250-299) - الميزات الجديدة

#### Notes System (250-254)

| TypeID | النموذج        | الوصف        | الملف            |
| ------ | -------------- | ------------ | ---------------- |
| 250    | Note           | ملاحظة كاملة | note_models.dart |
| 251    | NoteAttachment | مرفق ملاحظة  | note_models.dart |
| 252    | NoteLink       | رابط ملاحظة  | note_models.dart |
| 253    | AttachmentType | نوع المرفق   | note_models.dart |
| 254    | LinkTargetType | نوع الرابط   | note_models.dart |

#### Mood & Journal (255-257)

| TypeID | النموذج       | الوصف          | الملف            |
| ------ | ------------- | -------------- | ---------------- |
| 255    | MoodEntry     | إدخال مزاج     | mood_models.dart |
| 256    | JournalEntry  | إدخال يومية    | mood_models.dart |
| 257    | MoodAnalytics | تحليلات المزاج | mood_models.dart |

#### Budget System (258-262)

| TypeID | النموذج                 | الوصف       | الملف              |
| ------ | ----------------------- | ----------- | ------------------ |
| 258    | Expense                 | مصروف       | budget_models.dart |
| 259    | Income                  | دخل         | budget_models.dart |
| 260    | BudgetCategory          | فئة ميزانية | budget_models.dart |
| 261    | FinancialReport         | تقرير مالي  | budget_models.dart |
| 262    | RecurrenceType (Budget) | نوع التكرار | budget_models.dart |

#### Projects System (263-270)

| TypeID | النموذج                | الوصف         | الملف               |
| ------ | ---------------------- | ------------- | ------------------- |
| 263    | Project                | مشروع         | project_models.dart |
| 264    | ProjectStatus          | حالة المشروع  | project_models.dart |
| 265    | ProjectPhase           | مرحلة مشروع   | project_models.dart |
| 266    | PhaseStatus            | حالة المرحلة  | project_models.dart |
| 267    | ProjectTask            | مهمة مشروع    | project_models.dart |
| 268    | TaskPriority (Project) | أولوية المهمة | project_models.dart |
| 269    | TaskStatus (Project)   | حالة المهمة   | project_models.dart |
| 270    | ProjectViewMode        | وضع العرض     | project_models.dart |

#### Inbox/Ideas System (271-278)

| TypeID | النموذج         | الوصف              | الملف             |
| ------ | --------------- | ------------------ | ----------------- |
| 271    | Idea            | فكرة               | inbox_models.dart |
| 272    | IdeaStatus      | حالة الفكرة        | inbox_models.dart |
| 273    | IdeaPriority    | أولوية الفكرة      | inbox_models.dart |
| 274    | LinkedItemType  | نوع العنصر المرتبط | inbox_models.dart |
| 275    | IdeaCategory    | فئة الفكرة         | inbox_models.dart |
| 276    | InboxItem       | عنصر Inbox         | inbox_models.dart |
| 277    | InboxItemType   | نوع عنصر Inbox     | inbox_models.dart |
| 278    | ConvertedToType | نوع التحويل        | inbox_models.dart |

---

## 🔮 Reserved Ranges (مناطق محجوزة للمستقبل)

| النطاق  | الاستخدام المخطط         |
| ------- | ------------------------ |
| 279-299 | ميزات Task Meta الإضافية |
| 300-349 | File & Link Library      |
| 350-399 | Advanced Task System     |
| 400-449 | AI Copilot Multi-Model   |
| 450-499 | Security & Privacy       |
| 500-549 | Dashboard & Analytics    |
| 550-599 | Export/Import System     |
| 600-649 | Bluetooth & Sync         |
| 650-699 | Advanced Filters         |
| 700-749 | UI/UX Design System      |

---

## ⚠️ تعارضات TypeID المعروفة

> **ملاحظة**: بعض TypeIDs مستخدمة لأكثر من نموذج واحد (legacy code)

| TypeID | النماذج المتعارضة                                      | الحل                    |
| ------ | ------------------------------------------------------ | ----------------------- |
| 20     | VoiceCommand & Achievement                             | استخدام contexts مختلفة |
| 21     | HabitTemplate & WorkoutPlan & HabitBuilder.UserProfile | استخدام prefixes        |
| 23     | Badge & Exercise & HabitBuilder.UserProfile            | استخدام namespaces      |

**التوصية**: عند إعادة الهيكلة، استخدم TypeIDs جديدة من النطاقات المحجوزة.

---

## 📝 قواعد تخصيص TypeID

1. **لا تعيد استخدام TypeID** حتى لو حذفت النموذج
2. **استخدم نطاقات متسلسلة** لميزة واحدة
3. **سجل TypeID فوراً** في هذا الملف
4. **اترك فجوات** للتوسع المستقبلي (مثلاً 250-299 لـ Task Meta)
5. **استخدم Enums بعد Models** في نفس النطاق

---

## 🔧 كيفية إضافة نموذج جديد

### 1. اختر TypeID

```dart
// تحقق من هذا الملف - آخر TypeID مستخدم في Task Meta: 278
// النطاق المتاح: 279-299
```

### 2. أضف في النموذج

```dart
@HiveType(typeId: 279)
class MyNewModel {
  @HiveField(0)
  String id;
  // ...
}
```

### 3. سجل في هذا الملف

أضف سطر في الجدول المناسب.

### 4. سجل المحول

```dart
if (!Hive.isAdapterRegistered(279)) {
  Hive.registerAdapter(MyNewModelAdapter());
}
```

---

**آخر تحديث**: 6 أكتوبر 2025  
**آخر TypeID مستخدم**: 278 (InboxItem)  
**التالي المتاح**: 279-299 (Task Meta Extensions)
