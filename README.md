# Aether Android Client ⚡

**[راهنمای فارسی](#راهنمای-فارسی)** · **[English Guide](#english-guide)**

A modern, highly-optimized Android client application for **[CluvexStudio/Aether](https://github.com/CluvexStudio/Aether)** built with **Flutter (Dart)** & **Kotlin**, featuring full **R8 Minification**, **In-App Publisher Updates**, and **One-Click Google Colab / Kaggle Cloud Builds**.

---

## English Guide

### Overview
**Aether Android** provides a sleek, modern UI for running the Aether censorship circumvention client on Android devices. It encapsulates MASQUE (HTTP/3 & HTTP/2 with TLS ClientHello fragmentation), WireGuard, and GOOL (Nested WireGuard) tunnels into an intuitive application with real-time speed & latency telemetry, live engine logs, and automated publisher updates.

### Key Features
- 🚀 **Next-Gen Protocol Support**:
  - **MASQUE**: HTTP/3 (QUIC) & HTTP/2 (TLS over TCP)
  - **TLS ClientHello Fragmentation**: Anti-DPI technique for heavily censored networks
  - **WireGuard & GOOL**: Fast single-layer or nested tunnel mode
- ⚡ **Optimization & Lightweight Engine**:
  - Full **R8 Minification & Code Shrinking** configured via Kotlin DSL & ProGuard rules
  - Optimized native ABI binary bundling (`arm64-v8a`, `armeabi-v7a`, `x86_64`)
- 🔄 **In-App Updater**:
  - Automatically checks `CluvexStudio/Aether` publisher releases
  - Downloads & updates native core binaries and application APK directly inside the app
- 🌐 **Bilingual UI (Persian & English)**:
  - Full RTL (Right-to-Left) & LTR support with dynamic language switching
  - **No flags used** in language selection controls
- 🎨 **Modern Cyber Aesthetics**:
  - AMOLED dark theme with glowing celestial aether logo, neon status indicators, glassmorphism card UI
- 📊 **Telemetry & Utilities**:
  - Real-time ping / latency tester against local SOCKS5 proxy (`127.0.0.1:1819`)
  - Live streaming log viewer with copy & filter tools

---

### Building on Google Colab & Kaggle

You can easily compile the release APK without installing Android Studio or Flutter on your local machine:

#### Google Colab (One-Click Build)
1. Open [`Colab_Build_Aether.ipynb`](Colab_Build_Aether.ipynb) in Google Colab.
2. Run all cells (`Ctrl + F9`).
3. The notebook will automatically download dependencies, bundle native Aether engine binaries, enable R8 minification, compile the APK, and download `app-release.apk` directly to your computer.

#### Kaggle Notebooks
1. Import [`Kaggle_Build_Aether.ipynb`](Kaggle_Build_Aether.ipynb) into Kaggle.
2. Click **Run All**.
3. Download the compiled `Aether-v1.2.0-release.apk` from the Kaggle Output section.

---

## راهنمای فارسی

### درباره برنامه
برنامه **Aether Android** یک کلاینت پیشرفته، بهینه‌سازی‌شده و مدرن برای اندروید است که بر اساس ریپوزیتوری رسمی **[CluvexStudio/Aether](https://github.com/CluvexStudio/Aether)** با استفاده از **فلاتر (Dart)** و **کاتلین (Kotlin)** پیاده‌سازی شده است.

این برنامه امکان عبور از محدودیت‌های شدید اینترنت و DPI را فراهم کرده و قابلیت اجرا در دو حالت وی‌پی‌ان سراسری (System-wide VPN via VpnService) و پراکسی محلی ساکس۵ (`127.0.0.1:1819`) را دارا می‌باشد.

---

### ویژگی‌های برجسته
- 🛡️ **پشتیبانی کامل از پروتکل‌های Aether**:
  - **MASQUE**: پشتیبانی از HTTP/3 (QUIC) و HTTP/2 (TCP)
  - **فرگمنتیشن TLS ClientHello**: تکه‌تکه کردن دست‌دادن اولیه جهت دور زدن سیستم‌های DPI
  - **پروفایل‌های استتار نویز**: Firewall (مخصوص ایران)، GFW، Aggressive، Balanced، Light، Off
  - **پروتکل‌های WireGuard و GOOL**: تونل تک‌لایه‌ای یا دو لایه برای سرعت و پایداری حداکثری
- ⚡ **سبک‌سازی و بهینه‌سازی حرفه‌ای (R8 Optimization)**:
  - فعال‌سازی کامل R8، Minification، Resource Shrinking و قواعد ProGuard جهت کاهش حجم فایل APK به حداقل ممکن
- 🔄 **سیستم آپدیت داخل برنامه‌ای (In-App Updater)**:
  - قابلیت استعلام خودکار آخرین آپدیت‌ها از ریپوزیتوری ناشر (`CluvexStudio/Aether`)
  - دانلود و بروزرسانی مستقیم هسته باینری برنامه و فایل APK از داخل منوی برنامه
- 🌍 **پشتیبانی کامل از زبان فارسی و انگلیسی**:
  - رابط کاربری کاملاً دو زبانه با پشتیبانی عالی از چیدمان راست‌چین (RTL) و چپ‌چین (LTR)
  - **بدون استفاده از پرچم** در کل رابط کاربری و کنترل‌های انتخاب زبان
- 🎨 **طراحی مدرن و لوگوی اختصاصی Aether**:
  - تم تاریک اختصاصی AMOLED Cyber-Aether، کارت‌های Glassmorphism و دکمه پالس‌دار انیمیشنی
- 📈 **امکانات جانبی**:
  - سنجش زنده سرعت و پینگ پراکسی ساکس۵
  - مشاهده زنده لاگ‌های خروجی هسته با امکان کپی‌برداری سریع

---

### راهنمای بیلد روی گوگل کولب (Google Colab) و کاگل (Kaggle)

شما می‌توانید بدون نیاز به نصب فلاتر یا اندروید استودیو روی سیستم خود، فایل APK را مستقیماً روی سرورهای ابری بسازید:

#### گوگل کولب (Google Colab - یک کلیک)
۱. فایل [`Colab_Build_Aether.ipynb`](Colab_Build_Aether.ipynb) را در محیط Google Colab باز کنید.
۲. گزینه **Run all** (اجرای همه سلول‌ها) را بزنید.
۳. نوت‌بوک به طور خودکار وابستگی‌ها را نصب کرده، باینری‌های نیتیو Aether را دانلود می‌کند، کدها را با R8 بهینه‌سازی کرده و فایل `app-release.apk` را دانلود می‌کند.

#### کاگل (Kaggle Notebook)
۱. نوت‌بوک [`Kaggle_Build_Aether.ipynb`](Kaggle_Build_Aether.ipynb) را در کاگل ایمپورت کنید.
۲. گزینه **Run All** را انتخاب کنید.
۳. فایل APK بیلد شده را از تب Output دانلود کنید.

---

### ساختار پروژه (Directory Architecture)
```text
Aether_app/
├── android/                   # پیکربندی Gradle و کد نیتیو اندروید (Kotlin DSL + R8 rules)
│   ├── app/build.gradle.kts   # R8 Shrinking, Minification & ABI Filtering
│   ├── app/proguard-rules.pro # قواعد بهینه‌سازی R8
│   └── app/src/main/kotlin/   # سرویس VpnService و مدیریت باینری‌های نیتیو Aether
├── lib/                       # کد اصلی سورس فلاتر (Dart)
│   ├── main.dart              # نقطه شروع برنامه و مدیریت زبان/تم
│   ├── l10n/                  # دیکشنری کامل فارسی و انگلیسی
│   ├── models/                # مدلهای کانفیگ Aether
│   ├── services/              # سرویس‌های ارتباط نیتیو، تست پینگ و آپدیت
│   ├── screens/               # صفحات اصلی (Tunnel, Config, Logs, Updates)
│   └── widgets/               # المان‌های مدرن UI و لوگوی اختصاصی
├── assets/                    # لوگوی اختصاصی SVG/PNG و آیکون‌ها
├── scripts/                   # اسکریپت‌های اتوماتیک دانلود باینری‌ها و بیلد
├── Colab_Build_Aether.ipynb   # نوت‌بوک بیلد کولب
├── Kaggle_Build_Aether.ipynb  # نوت‌بوک بیلد کاگل
└── pubspec.yaml               # مدیریت پکیج‌های فلاتر
```

---

### توسعه‌یافته بر اساس
هسته اصلی و پروتکل‌های ضدسانسور بر پایه پروژه قدرتمند **[CluvexStudio/Aether](https://github.com/CluvexStudio/Aether)** پیاده‌سازی شده است.
