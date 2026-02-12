# Wasl - Frontend (Flutter)

تطبيق Wasl للهواتف الذكية مبني باستخدام Flutter.

## 🚀 البدء السريع

### المتطلبات
- Flutter SDK (الإصدار الأخير)
- Dart SDK
- Android Studio / Xcode (للتطوير على Android/iOS)

### التثبيت

1. **انتقل إلى مجلد Frontend:**
   ```bash
   cd frontend
   ```

2. **تثبيت الـ Dependencies:**
   ```bash
   flutter pub get
   ```

3. **تشغيل التطبيق:**
   ```bash
   flutter run
   ```

## 📱 المنصات المدعومة

- ✅ Android
- ✅ Web
- ✅ Windows
- ✅ Linux
- ✅ macOS

## 🏗️ هيكلة المشروع

```
frontend/
├── lib/
│   ├── core/              # المكونات الأساسية
│   │   ├── components/    # Widgets قابلة لإعادة الاستخدام
│   │   ├── router/        # Routing
│   │   └── theme/         # Theme & Styling
│   └── features/          # Features
│       ├── auth/          # المصادقة
│       ├── student/       # واجهة الطالب
│       └── service_provider/  # واجهة مزود الخدمة
├── test/                  # الاختبارات
├── android/               # Android platform
├── ios/                   # iOS platform (if needed)
├── web/                   # Web platform
└── pubspec.yaml           # Dependencies
```

## 🔧 أوامر مفيدة

```bash
# تشغيل التطبيق
flutter run

# بناء APK لـ Android
flutter build apk

# بناء للويب
flutter build web

# تشغيل الاختبارات
flutter test

# تحليل الكود
flutter analyze

# تنظيف Build artifacts
flutter clean
```

## 📦 Dependencies الرئيسية

راجع ملف `pubspec.yaml` لقائمة كاملة بالـ dependencies.

## 🐛 استكشاف الأخطاء

### المشكلة: `flutter` command not found
**الحل:** تأكد أن Flutter SDK مثبت ومضاف للـ PATH

### المشكلة: Build errors
**الحل:** 
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 ملاحظات مهمة

⚠️ **تنبيه:** لازم تكون داخل مجلد `frontend/` قبل تشغيل أي أمر Flutter!

```bash
# ❌ خطأ - من الجذر
flutter run

# ✅ صحيح - من داخل frontend
cd frontend
flutter run
```

## 🤝 المساهمة

راجع الـ README الرئيسي في الجذر للمزيد من المعلومات.
