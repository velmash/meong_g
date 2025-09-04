# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**meong_g** is a Flutter application for pet location tracking with map integration. The app follows Clean Architecture principles with MVVM pattern, using Flutter Riverpod for state management.

## Development Commands

### Core Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app on connected device/emulator
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter analyze` - Run static analysis
- `flutter test` - Run tests
- `flutter pub upgrade` - Update dependencies

### Code Generation
- `flutter packages pub run build_runner build` - Generate code (for freezed, json_serializable, etc.)
- `flutter packages pub run build_runner build --delete-conflicting-outputs` - Force regenerate code

## Architecture

### Clean Architecture + MVVM Structure
```
lib/
├── core/                    # Shared components and utilities
│   ├── theme/              # App styling and themes
│   └── widget/             # Reusable widgets
└── features/               # Feature modules
    └── [feature_name]/
        ├── data/           # Data layer (repositories, data sources)
        ├── domain/         # Business logic layer
        │   ├── entity/     # Business entities
        │   ├── repository/ # Repository interfaces
        │   └── usecase/    # Business use cases
        └── presentation/   # UI layer
            ├── view/       # UI screens/widgets
            └── viewmodel/  # State management with Riverpod
```

### Key Architectural Patterns
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **MVVM**: Model-View-ViewModel pattern with Riverpod StateNotifier
- **Repository Pattern**: Data access abstraction in domain layer
- **Dependency Injection**: Using Riverpod providers for DI

### State Management
- **Flutter Riverpod**: Primary state management solution
- **StateNotifier**: For complex state management in ViewModels
- **StateNotifierProvider**: For providing ViewModels to UI

## Key Dependencies
- `flutter_riverpod`: State management and dependency injection
- `geolocator`: Location services
- `freezed_annotation`: Code generation for immutable classes
- `build_runner`: Code generation support

## Custom Fonts
The app uses **Pretendard** font family with weights from 100-900, configured in pubspec.yaml.

## Assets Structure
- `assets/img/` - Image assets
- `assets/fonts/` - Custom fonts (Pretendard family)

## Navigation
The app uses a bottom navigation structure with three main sections:
- History (기록)
- Home (홈) - default selected
- My Page (마이페이지)

Main navigation handled by `HomeNavigationBar` widget in `lib/core/widget/`.

## Location Features
The app includes location tracking capabilities:
- Current location fetching via Geolocator
- Kakao Map integration for location display
- Location entities and repositories following Clean Architecture

## Development Notes
- Use `flutter analyze` before committing to ensure code quality
- Follow the established Clean Architecture patterns when adding new features
- ViewModels should extend StateNotifier and be provided via StateNotifierProvider
- Entities should be simple data classes without external dependencies
- Repository implementations should be in the data layer, interfaces in domain layer