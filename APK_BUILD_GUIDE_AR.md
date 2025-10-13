# 📱 دليل بناء APK - Android APK Build Guide

## 🎯 نظرة عامة - Overview

هذا الدليل يشرح كيفية بناء ملف APK لنظام أندرويد من مشروع Habit Tracker.

This guide explains how to build an Android APK file from the Habit Tracker project.

---

## ✅ المتطلبات الأساسية - Prerequisites

قبل البدء، تأكد من تثبيت:
- Flutter SDK (الإصدار 3.9.2 أو أحدث)
- Android Studio أو Android SDK
- Java Development Kit (JDK 11 أو أحدث)

Before starting, make sure you have:
- Flutter SDK (version 3.9.2 or newer)
- Android Studio or Android SDK
- Java Development Kit (JDK 11 or newer)

### التحقق من التثبيت - Verify Installation

```bash
flutter --version
flutter doctor
```

---

## 🚀 طرق بناء APK - Ways to Build APK

### الطريقة 1: البناء المحلي السريع - Quick Local Build

الأسهل والأسرع للاختبار:
**Easiest and fastest for testing:**

```bash
# 1. تثبيت التبعيات - Install dependencies
flutter pub get

# 2. توليد الملفات المطلوبة - Generate required files
dart run build_runner build --delete-conflicting-outputs

# 3. بناء APK - Build APK
flutter build apk --release

# مكان الملف - File location:
# build/app/outputs/flutter-apk/app-release.apk
```

### الطريقة 2: إستخدام سكريبت البناء - Using Build Script

أسهل طريقة لبناء كل المنصات:
**Easiest way to build all platforms:**

```bash
./build-all.sh
```

هذا السكريبت سوف:
This script will:
- ✅ تثبيت التبعيات - Install dependencies
- ✅ توليد الملفات - Generate files
- ✅ بناء APK - Build APK
- ✅ بناء Web - Build Web
- ✅ عرض الملخص - Show summary

### الطريقة 3: البناء التلقائي عبر CI/CD - Automatic Build via CI/CD

الأفضل للإنتاج:
**Best for production:**

1. قم برفع الكود إلى GitHub
   **Push code to GitHub:**
   ```bash
   git add .
   git commit -m "تحديث المشروع"
   git push origin main
   ```

2. إذهب إلى تبويب Actions في GitHub
   **Go to Actions tab on GitHub**

3. إنتظر حتى ينتهي البناء (حوالي 5-10 دقائق)
   **Wait for build to complete (about 5-10 minutes)**

4. حمّل ملف APK من Artifacts
   **Download APK from Artifacts**

---

## 🔐 إعداد التوقيع للإصدار - Release Signing Setup

لإنشاء APK جاهز للنشر على Google Play Store، تحتاج لتوقيع التطبيق:

To create APK ready for Google Play Store, you need to sign the app:

### 1. إنشاء مفتاح التوقيع - Generate Signing Key

```bash
cd android

keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

سيطلب منك:
**You'll be asked for:**
- كلمة السر للمخزن - Store password
- كلمة السر للمفتاح - Key password
- معلومات شخصية - Personal information

⚠️ **مهم جداً / VERY IMPORTANT:**
- إحفظ كلمات السر في مكان آمن!
- لا ترفع ملف المفتاح إلى GitHub!
- **Keep passwords in a safe place!**
- **Never upload keystore to GitHub!**

### 2. إنشاء ملف التكوين - Create Configuration File

```bash
cd android
cp key.properties.example key.properties
```

ثم إفتح `key.properties` وضع المعلومات:
**Then open `key.properties` and add your info:**

```properties
storePassword=your_actual_password
keyPassword=your_actual_password
keyAlias=upload
storeFile=../upload-keystore.jks
```

### 3. بناء APK موقّع - Build Signed APK

```bash
flutter build apk --release
```

الآن APK جاهز للنشر! 🎉
**Now APK is ready for publishing!** 🎉

---

## 📦 أنواع البناء - Build Types

### APK عادي - Standard APK

```bash
flutter build apk --release
```

✅ **مناسب لـ:**
- التوزيع المباشر
- الاختبار
- التثبيت على الأجهزة

✅ **Good for:**
- Direct distribution
- Testing
- Device installation

### APK مقسم حسب المعمارية - Split APK by ABI

```bash
flutter build apk --split-per-abi --release
```

✅ **الفوائد:**
- حجم أصغر لكل معمارية
- تحميل أسرع
- **Benefits:**
- Smaller size per architecture
- Faster downloads

سينتج 3 ملفات:
**Produces 3 files:**
- `app-armeabi-v7a-release.apk` - أجهزة ARM 32-bit
- `app-arm64-v8a-release.apk` - أجهزة ARM 64-bit
- `app-x86_64-release.apk` - أجهزة Intel 64-bit

### App Bundle للـ Google Play

```bash
flutter build appbundle --release
```

✅ **مطلوب لـ Google Play Store**
✅ **Required for Google Play Store**

---

## 🧪 الاختبار قبل النشر - Testing Before Release

### 1. إختبار APK محلياً - Test APK Locally

```bash
# بناء وتثبيت على جهاز متصل
# Build and install on connected device
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 2. التحقق من الحجم - Check Size

```bash
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

الحجم المثالي: أقل من 50 ميغابايت
**Ideal size: Less than 50 MB**

### 3. إختبار على أجهزة مختلفة - Test on Different Devices

- جرب على أجهزة Android مختلفة (إن أمكن)
- تحقق من كل الميزات تعمل
- **Try on different Android devices (if possible)**
- **Verify all features work**

---

## 🐛 حل المشاكل الشائعة - Common Issues

### مشكلة: Flutter ليس مثبت
**Issue: Flutter not installed**

```bash
# تثبيت Flutter - Install Flutter
# إتبع الدليل: https://flutter.dev/docs/get-started/install
```

### مشكلة: فشل توليد الملفات
**Issue: Code generation fails**

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### مشكلة: خطأ في البناء
**Issue: Build error**

```bash
# تنظيف المشروع - Clean project
flutter clean

# حذف مجلدات البناء - Remove build folders
rm -rf build/
rm -rf android/app/build/

# إعادة البناء - Rebuild
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

### مشكلة: ملف APK كبير جداً
**Issue: APK too large**

```bash
# إستخدام APK مقسم - Use split APK
flutter build apk --split-per-abi --release

# أو تفعيل ProGuard/R8
# Or enable ProGuard/R8 (advanced)
```

---

## 📤 توزيع APK - Distributing APK

### 1. التوزيع المباشر - Direct Distribution

- أرسل ملف APK مباشرة للمستخدمين
- إرفعه على موقعك
- **Send APK file directly to users**
- **Upload to your website**

⚠️ يحتاج المستخدمون تفعيل "مصادر غير معروفة"
**⚠️ Users need to enable "Unknown Sources"**

### 2. Google Play Store

1. إنشاء حساب مطور - Create developer account
2. بناء App Bundle: `flutter build appbundle --release`
3. رفع على Play Console
4. إتباع عملية المراجعة
   **Follow review process**

### 3. منصات بديلة - Alternative Platforms

- Amazon Appstore
- Samsung Galaxy Store
- APKPure
- F-Droid (للتطبيقات مفتوحة المصدر)

---

## ✅ قائمة التحقق النهائية - Final Checklist

قبل النشر، تأكد من:
**Before publishing, ensure:**

- [ ] تم اختبار التطبيق على أجهزة مختلفة
- [ ] كل الميزات تعمل بشكل صحيح
- [ ] تم تحديث رقم الإصدار في `pubspec.yaml`
- [ ] تم إنشاء مفتاح توقيع للإنتاج
- [ ] تم اختبار APK الموقّع
- [ ] الحجم مقبول (< 50 MB)
- [ ] أيقونة التطبيق جاهزة
- [ ] الوصف والصور جاهزة للمتجر

- [ ] App tested on different devices
- [ ] All features work correctly
- [ ] Version number updated in `pubspec.yaml`
- [ ] Production signing key created
- [ ] Signed APK tested
- [ ] Size acceptable (< 50 MB)
- [ ] App icon ready
- [ ] Store description and images ready

---

## 📚 مصادر إضافية - Additional Resources

- [Flutter Deployment Guide](DEPLOYMENT_GUIDE.md)
- [Quick Deploy Guide](QUICK_DEPLOY.md)
- [Production Readiness Checklist](PRODUCTION_READINESS_CHECKLIST.md)
- [Build Script](build-all.sh)

---

## 🎉 نجاح! - Success!

الآن مشروعك جاهز تماماً لبناء APK! 🚀

**Your project is now fully ready to build APK!** 🚀

### الخطوات التالية - Next Steps:

1. ✅ بناء APK للاختبار
2. ✅ إختبار على أجهزة مختلفة
3. ✅ إنشاء مفتاح توقيع للإنتاج
4. ✅ بناء APK موقّع
5. ✅ النشر على المتجر أو التوزيع المباشر

1. ✅ Build APK for testing
2. ✅ Test on different devices
3. ✅ Create production signing key
4. ✅ Build signed APK
5. ✅ Publish to store or direct distribution

---

**تم تجهيز المشروع بنجاح! 🎊**

**Project successfully prepared! 🎊**
