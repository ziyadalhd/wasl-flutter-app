# Wasl - Monorepo

مشروع Wasl - منصة خدمات جامعية شاملة

## 📁 هيكلة المشروع (Monorepo)

```
wasl-flutter-app/
├── frontend/          # تطبيق Flutter (Android, iOS, Web, Desktop)
├── backend/           # Spring Boot Backend API
├── README.md          # هذا الملف
└── .gitignore
```

## 🚀 البدء السريع

### Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

📖 **للمزيد من التفاصيل:** راجع [`frontend/README.md`](frontend/README.md)

### Backend (Spring Boot)

```bash
cd backend
./mvnw spring-boot:run    # Linux/Mac
mvnw.cmd spring-boot:run  # Windows
```

📖 **للمزيد من التفاصيل:** راجع [`backend/README.md`](backend/README.md)

## ⚠️ ملاحظات مهمة

> **تنبيه:** بعد إعادة هيكلة المشروع إلى Monorepo، يجب تشغيل جميع الأوامر من داخل المجلدات الفرعية المناسبة!

### ❌ القديم (لن يعمل)
```bash
flutter run              # من الجذر
./mvnw spring-boot:run   # من الجذر
```

### ✅ الصحيح
```bash
cd frontend && flutter run
cd backend && ./mvnw spring-boot:run
```

## 🛠️ VS Code Workspace

لتجربة تطوير أفضل، افتح المشروع باستخدام workspace file:

```bash
code wasl.code-workspace
```

هذا سيفتح المشروع بمجلدات منفصلة للـ frontend والـ backend مع الإعدادات المناسبة.

## 📚 الوثائق

- **Frontend Documentation**: [`frontend/README.md`](frontend/README.md)
- **Backend Documentation**: [`backend/README.md`](backend/README.md)

## 🏗️ التقنيات المستخدمة

### Frontend
- Flutter SDK
- Dart
- المنصات: Android, iOS, Web, Windows, Linux, macOS

### Backend
- Spring Boot 3
- Java 17+
- Maven

## 🤝 المساهمة

1. Fork المشروع
2. أنشئ branch جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push للـ branch (`git push origin feature/amazing-feature`)
5. افتح Pull Request

## 📄 الترخيص

راجع ملف LICENSE للمزيد من التفاصيل.
