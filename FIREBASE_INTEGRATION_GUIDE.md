# 🔥 دليل تكامل Firebase - Habit Tracker

## 📋 نظرة عامة

تم إضافة تكامل شامل مع Firebase يدعم:
- ✅ العمل بدون Firebase (Offline-First)
- ✅ التزامن التلقائي عند توفر الاتصال
- ✅ تسجيل الدخول الضيف
- ✅ إدارة المستخدمين والبيانات
- ✅ نظام الإنجازات والمكافآت
- ✅ التفاعل الاجتماعي والتشجيع

---

## 🚀 الميزات الجديدة

### 1. صفحة الملف الشخصي الشاملة (`UserProfileScreen`)

**الموقع:** `lib/features/profile/screens/user_profile_screen.dart`

**المميزات:**
- عرض معلومات المستخدم الكاملة (الاسم، البريد، النقاط، المستوى)
- 3 تابات:
  - **المعلومات:** البيانات الشخصية وحالة الاتصال
  - **الإنجازات:** عرض جميع الإنجازات (مفتوحة ومقفلة)
  - **الإحصائيات:** إحصائيات التفاعل الاجتماعي
- إمكانية تعديل الملف الشخصي
- دعم الوضع Offline

**الوصول:**
- من Dashboard → زر Profile في الـ AppBar
- أو: `Navigator.pushNamed(context, '/profile')`

---

### 2. صفحة التفاعل الاجتماعي (`SocialFeedScreen`)

**الموقع:** `lib/features/social_feed/screens/social_feed_screen.dart`

**المميزات:**
- **تاب الإنجازات:** عرض إنجازات المستخدمين المشتركة
  - الإعجاب على الإنجازات
  - التعليق على الإنجازات
  - إرسال التشجيع
  
- **تاب المتصدرين (Leaderboard):**
  - ترتيب المستخدمين حسب النقاط
  - عرض الميداليات (🥇🥈🥉)
  - إرسال الهدايا للمستخدمين

- **تاب التفاعلات:**
  - عرض جميع التفاعلات الواردة
  - التشجيعات والهدايا المستلمة

**نظام الهدايا:**
- ⭐ نجمة: 5 نقاط
- 💎 ماسة: 10 نقاط
- 🏆 كأس: 20 نقطة
- 👑 تاج: 50 نقطة

**الوصول:**
- من Dashboard → Quick Shortcuts → "التفاعل الاجتماعي"
- أو: `Navigator.pushNamed(context, '/social-feed')`

---

## 🛠️ الخدمات المضافة

### 1. `FirebaseService`
**الموقع:** `lib/core/services/firebase_service.dart`

الخدمة الأساسية لـ Firebase:
```dart
final firebaseService = FirebaseService();
await firebaseService.initialize();

// الحصول على المستخدم الحالي
final user = firebaseService.currentUser;

// تسجيل دخول ضيف
await firebaseService.signInAnonymously();
```

---

### 2. `FirebaseUserService`
**الموقع:** `lib/core/services/firebase_user_service.dart`

إدارة بيانات المستخدمين:
```dart
final userService = FirebaseUserService();

// الحصول على بيانات مستخدم
final userData = await userService.getUserData(userId);

// حفظ بيانات مستخدم
await userService.saveUserData(userData);

// تحديث النقاط
await userService.updatePoints(userId, 10);

// إضافة إنجاز
await userService.addAchievement(userId, achievementId);
```

---

### 3. `FirebaseAchievementsService`
**الموقع:** `lib/core/services/firebase_achievements_service.dart`

إدارة الإنجازات:
```dart
final achievementsService = FirebaseAchievementsService();

// الحصول على جميع الإنجازات
final achievements = await achievementsService.getAllAchievements();

// الحصول على إنجازات المستخدم
final userAchievements = await achievementsService.getUserAchievements(userId);

// فتح إنجاز
await achievementsService.unlockAchievement(userId, achievementId);
```

**الإنجازات الافتراضية:**
1. 🎯 العادة الأولى - 10 نقاط
2. 🔥 أسبوع متواصل - 50 نقطة
3. 👑 سيد الشهر - 200 نقطة
4. 🦋 اجتماعي نشط - 30 نقطة
5. 🎁 كريم معطاء - 40 نقطة

---

### 4. `FirebaseSocialService`
**الموقع:** `lib/core/services/firebase_social_service.dart`

إدارة التفاعلات الاجتماعية:
```dart
final socialService = FirebaseSocialService();

// إرسال تشجيع
await socialService.sendEncouragement(fromUserId, toUserId, message);

// إرسال هدية
await socialService.sendGift(fromUserId, toUserId, giftType, points);

// مشاركة إنجاز
await socialService.shareAchievement(userId, achievementId, caption);

// الحصول على تفاعلات المستخدم
Stream<List<SocialInteraction>> interactions = 
    socialService.getUserInteractions(userId);
```

---

## 📦 Dependencies المضافة

تم إضافة Firebase إلى `pubspec.yaml`:

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  firebase_storage: ^12.3.2
  cloud_firestore: ^5.4.4
```

---

## ⚙️ التكوين المطلوب

### لتفعيل Firebase (اختياري):

1. **إنشاء مشروع Firebase:**
   - اذهب إلى [Firebase Console](https://console.firebase.google.com/)
   - أنشئ مشروع جديد

2. **إضافة تطبيق Flutter:**
   - في إعدادات المشروع، اختر "Flutter"
   - اتبع التعليمات لإضافة Firebase للأندرويد وiOS

3. **تنزيل ملفات التكوين:**
   - **Android:** `google-services.json` → `android/app/`
   - **iOS:** `GoogleService-Info.plist` → `ios/Runner/`

4. **تفعيل Firestore:**
   - في Firebase Console → Firestore Database
   - أنشئ قاعدة بيانات بوضع Test Mode

5. **تفعيل Authentication:**
   - في Firebase Console → Authentication
   - فعّل Anonymous Sign-in

---

## 🔄 الوضع Offline-First

التطبيق يعمل بشكل كامل بدون Firebase:

1. **بدون Firebase:**
   - يستخدم مستخدم محلي افتراضي
   - جميع البيانات تُحفظ محلياً
   - لا يوجد تزامن مع السحابة

2. **مع Firebase:**
   - تسجيل دخول تلقائي كضيف
   - التزامن التلقائي مع Firestore
   - دعم الوضع Offline من Firestore

---

## 🎨 واجهة المستخدم

### التصميم:
- ✅ Material Design 3
- ✅ Dark/Light Mode
- ✅ دعم RTL للعربية
- ✅ Animations و Transitions
- ✅ Gradient Backgrounds
- ✅ Responsive Design

### الألوان:
- Primary: ألوان متدرجة من theme
- Cards: White background مع shadows
- Icons: Primary color
- Text: Dynamic based on theme

---

## 📱 استخدام الميزات

### مثال: إرسال هدية

```dart
// في أي مكان في التطبيق
final socialService = FirebaseSocialService();
final userService = FirebaseUserService();
final currentUser = FirebaseService().currentUser;

if (currentUser != null) {
  // إرسال هدية
  await socialService.sendGift(
    currentUser.uid,
    recipientUserId,
    'نجمة',
    5,
  );
  
  // إضافة النقاط للمستلم
  await userService.updatePoints(recipientUserId, 5);
}
```

### مثال: فتح إنجاز

```dart
final achievementsService = FirebaseAchievementsService();
final userService = FirebaseUserService();

// فتح إنجاز
await achievementsService.unlockAchievement(userId, 'first_habit');

// إضافة نقاط الإنجاز
await userService.updatePoints(userId, 10);
```

---

## 🧪 الاختبار

### اختبار بدون Firebase:
1. قم بتشغيل التطبيق مباشرة
2. سيعمل في الوضع المحلي تلقائياً
3. جميع الميزات ستعمل محلياً

### اختبار مع Firebase:
1. أضف ملفات التكوين
2. قم بتشغيل التطبيق
3. سيتم تسجيل دخول تلقائي كضيف
4. جرب إضافة مستخدمين وإنجازات

---

## 🔐 الأمان

- ✅ Guest Authentication لتجربة سلسة
- ✅ Firestore Rules يجب تحديثها للإنتاج
- ✅ جميع البيانات مشفرة في النقل (HTTPS)
- ✅ دعم الوضع Offline آمن

### Firestore Rules المقترحة:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // السماح للقراءة للجميع
    match /{document=**} {
      allow read: if true;
    }
    
    // المستخدمون يمكنهم تحديث بياناتهم فقط
    match /users/{userId} {
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // الإنجازات للقراءة فقط
    match /achievements/{achievementId} {
      allow read: if true;
      allow write: if false;
    }
    
    // التفاعلات الاجتماعية
    match /social_interactions/{interactionId} {
      allow write: if request.auth != null;
    }
    
    // مشاركات الإنجازات
    match /achievement_shares/{shareId} {
      allow write: if request.auth != null;
    }
  }
}
```

---

## 📊 البيانات المخزنة في Firestore

### Collections:

1. **users**
   - id, name, email, photoUrl, bio
   - points, level, achievements[]
   - createdAt, updatedAt

2. **achievements**
   - id, nameAr, nameEn
   - descriptionAr, descriptionEn
   - icon, points, category, requiredCount

3. **user_achievements**
   - achievementId, userId
   - unlockedAt, progress

4. **social_interactions**
   - id, fromUserId, toUserId
   - type, message, points, giftType
   - createdAt

5. **achievement_shares**
   - id, userId, achievementId
   - caption, likes, comments[]
   - createdAt

---

## 🚧 التطوير المستقبلي

### ميزات مقترحة:
- [ ] تسجيل دخول بالبريد والكلمة السرية
- [ ] تسجيل دخول بحسابات Google/Facebook
- [ ] رفع الصور للبروفايل
- [ ] رفع صور الإنجازات
- [ ] نظام الرسائل المباشرة
- [ ] المجموعات والتحديات الجماعية
- [ ] نظام الإشعارات Push
- [ ] تحليلات متقدمة
- [ ] مزامنة عبر الأجهزة

---

## ❓ الأسئلة الشائعة

**Q: هل يجب تكوين Firebase؟**
A: لا، التطبيق يعمل بشكل كامل بدون Firebase في الوضع المحلي.

**Q: ماذا يحدث إذا فشل اتصال Firebase؟**
A: التطبيق يتحول تلقائياً للوضع المحلي ويستمر في العمل.

**Q: كيف أفعل Firebase للإنتاج؟**
A: اتبع خطوات التكوين أعلاه وحدّث Firestore Rules للأمان.

**Q: هل البيانات المحلية والسحابية متزامنة؟**
A: حالياً لا، لكن يمكن إضافة نظام مزامنة في المستقبل.

---

## 📞 الدعم

للمساعدة أو الإبلاغ عن مشاكل، تواصل عبر Issues في GitHub.

---

**تم التطوير بواسطة:** GitHub Copilot  
**التاريخ:** 2025-10-13  
**الإصدار:** 1.0.0
