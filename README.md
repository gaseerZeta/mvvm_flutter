# Flutter MVVM Riverpod App

A modern Flutter application built with MVVM architecture, Riverpod state management, and **Shorebird** for seamless live patch updates without app store releases.

## 🚀 Key Features

- **🔄 Live Updates**: Shorebird integration for instant app patches
- **🔐 Authentication**: Complete user registration, login, and secure token management
- **👤 Profile Management**: User profile view
- **🎨 Awesome UI**: Beautiful animations and modern theme design
- **🏗️ MVVM Architecture**: Clean separation with Riverpod for scalable state management

## 📱 Screenshots

<div align="center">
 <img width="250" alt="Simulator Screenshot - iPhone 16e - 2025-09-18 at 00 20 55" src="https://github.com/user-attachments/assets/42b23390-2f84-4b60-a953-d9be6e4bf9c8" />
<img width="250"   alt="Simulator Screenshot - iPhone 16e - 2025-09-18 at 00 20 45" src="https://github.com/user-attachments/assets/a96560aa-6e96-4446-a8be-c052f90a0f75" />
 <img width="250"  alt="Simulator Screenshot - iPhone 16e - 2025-09-18 at 00 20 37" src="https://github.com/user-attachments/assets/8c6dcdfd-35d8-4975-9182-6cc1c8cc27d5" />

</div>

## 🛠️ Tech Stack

- **Framework**: Flutter SDK with MVVM Architecture
- **State Management**: Riverpod for dependency injection and state
- **Live Updates**: Shorebird for over-the-air patches
- **HTTP Client**: Dio for API communication
- **Storage**: Flutter Secure Storage for encrypted data
- **UI/UX**: Custom animations with responsive design using ScreenUtil
- **Testing**: Comprehensive unit tests with Mockito

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_screenutil: ^5.9.3
  flutter_secure_storage: ^9.2.4
  dio: ^5.9.0
  flutter_riverpod: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mockito: ^5.5.0
  build_runner: ^2.7.1
```

## 🧪 Testing Coverage

Comprehensive test suite covering:
- **API Integration**: Network requests and error handling
- **Form Validators**: Input validation and sanitization
- **ViewModels**: Business logic and state management
- **Storage**: Secure data persistence functionality

Run all tests:
```bash
flutter test
```

## 🚀 Getting Started

1. **Clone and install**
   ```bash
   git clone https://github.com/yourusername/flutter-mvvm-app.git
   cd flutter-mvvm-app
   flutter pub get
   ```

2. **Generate mocks**
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## ⚡ Shorebird Setup

Install Shorebird CLI and initialize:
```bash
shorebird init
shorebird release android
shorebird patch android
```

## 🎨 Features Highlights

- **Smooth Animations**: Custom transitions and micro-interactions
- **Modern Theme**: Dark/light mode with beautiful color schemes
- **Responsive Design**: Adaptive UI across all screen sizes
- **Secure Authentication**: Token-based auth with encrypted storage
- **Live Patching**: Instant updates without app store approval
- **Clean Architecture**: MVVM pattern with Riverpod providers

---

<div align="center">
  Built with Flutter 💙 | Live Updates with Shorebird 🐦
</div>
