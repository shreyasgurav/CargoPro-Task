# CargoPro Flutter App

A Flutter application with Firebase OTP authentication and CRUD operations.

## 🚀 Features

- **Firebase Phone OTP Authentication** (Mobile & Web)
- **CRUD Operations** using REST API
- **GetX** for state management, navigation, and dependency injection
- **Responsive Design** for mobile and web
- **Error Handling** with user-friendly messages
- **Pagination** support
- **Unit Tests** with mocked dependencies

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── routes/
│   ├── app_pages.dart       # Route definitions
│   └── app_routes.dart      # Route names
├── models/
│   └── api_object_model.dart # Data model for API objects
├── controllers/
│   ├── auth_controller.dart # Authentication logic
│   └── object_controller.dart # CRUD operations logic
├── views/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── otp_screen.dart
│   └── home/
│       ├── home_screen.dart
│       ├── object_list_screen.dart
│       ├── object_detail_screen.dart
│       ├── create_object_screen.dart
│       └── edit_object_screen.dart
├── services/
│   ├── auth_service.dart    # Firebase authentication
│   └── api_service.dart     # REST API calls
├── utils/
│   ├── constants.dart       # App constants
│   ├── validators.dart      # Input validation
│   └── theme.dart           # App theme
└── bindings/
    ├── auth_binding.dart    # Auth dependencies
    └── home_binding.dart    # Home dependencies

test/
├── services/
│   └── api_service_test.dart
└── controllers/
    └── object_controller_test.dart
```

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase project with Phone Authentication enabled
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd CargoPro
```

2. Install dependencies:
```bash
flutter pub get
```

3. Platform configuration:

- Ensure required platform services are configured (e.g., auth, keys) as per your environment.

4. Run the app:

For mobile:
```bash
flutter run
```

For web:
```bash
flutter run -d chrome
```

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run specific test:
```bash
flutter test test/services/api_service_test.dart
```

## 🌐 API Details

**Base URL:** https://api.restful-api.dev/objects

**Endpoints:**
- `GET /objects` - List all objects
- `GET /objects/{id}` - Get object by ID
- `POST /objects` - Create new object
- `PUT /objects/{id}` - Update object
- `DELETE /objects/{id}` - Delete object

## 🏗️ Architecture

This app follows a clean architecture pattern with:

- **Models:** Data structures matching API responses
- **Controllers:** Business logic and state management (GetX)
- **Views:** UI components (kept as dumb as possible)
- **Services:** API calls and Firebase operations
- **Utils:** Helper functions, validators, constants
- **Bindings:** Dependency injection setup

## 🎨 Design Choices

1. **GetX:** Chosen for its simplicity and performance
2. **Firebase Auth:** Industry-standard authentication
3. **Material Design:** Clean and familiar UI/UX
4. **Optimistic Updates:** Better UX for delete operations
5. **JSON Validation:** Ensures data integrity before API calls

## 🚀 Deployment

### Android APK

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## 📝 Known Limitations & Future Improvements

1. **Pagination:** Currently implements basic "load more" - could add infinite scroll
2. **Offline Support:** No local caching yet
3. **Image Support:** API supports images but not implemented in UI
4. **Search/Filter:** Not implemented yet
5. **iOS Build:** Not included in this submission

## 📄 License

This project is provided as-is for demonstration purposes.
