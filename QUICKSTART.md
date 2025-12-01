# Quick Start Guide

Get up and running with the CargoPro Flutter app in minutes!

## 🚀 Quick Setup (Without Firebase - Development Mode)

The app is configured to work in development mode without Firebase setup for quick testing.

### 1. Install Flutter

If you haven't installed Flutter yet:

**macOS:**
```bash
# Using Homebrew
brew install flutter

# Or download from
# https://docs.flutter.dev/get-started/install/macos
```

**Check installation:**
```bash
flutter doctor
```

### 2. Get Dependencies

```bash
cd /Users/shreyasgurav/Desktop/CargoPro
flutter pub get
```

### 3. Run the App

**For Android (with emulator or device connected):**
```bash
flutter run -d android
```

**For Web:**
```bash
flutter run -d chrome --web-port 8080
```

**List available devices:**
```bash
flutter devices
```

### 4. Test the App (Development Mode)

The app runs in development mode with mock authentication:

1. **Login Screen**: Enter any phone number (e.g., +1234567890)
2. **OTP Screen**: Use OTP: `123456`
3. You'll be logged in and can test all features!

### 5. Test CRUD Operations

Once logged in:

- **View Objects**: Fetches from real API (https://api.restful-api.dev/objects)
- **Create Object**: Add new objects with JSON data
- **Edit Object**: Modify existing objects
- **Delete Object**: Remove objects (with confirmation)

## 📱 Running on Specific Platforms

### Android

**Prerequisites:**
- Android Studio installed
- Android SDK configured
- Emulator running or device connected via USB

```bash
# Create and start an emulator
flutter emulators --launch <emulator_id>

# Run the app
flutter run -d android

# Or specify device
flutter run -d <device_id>
```

### Web

```bash
# Run in Chrome
flutter run -d chrome

# Build for web
flutter build web --release

# Serve the build
cd build/web
python3 -m http.server 8000
```

Then open: http://localhost:8000

### iOS (if on macOS)

```bash
# Open iOS Simulator
open -a Simulator

# Run the app
flutter run -d ios
```

## 🧪 Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/api_service_test.dart

# Run with coverage
flutter test --coverage
```

## 🛠 Development Commands

### Hot Reload
When the app is running, press:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

### Clean and Rebuild

```bash
flutter clean
flutter pub get
flutter run
```

### Analyze Code

```bash
# Check for issues
flutter analyze

# Format code
dart format .
```

### Build APK (Debug)

```bash
flutter build apk --debug

# APK location:
# build/app/outputs/flutter-apk/app-debug.apk
```

## 🔥 Full Firebase Setup (Production)

For production with real Firebase authentication, follow these steps:

### 1. Complete Firebase Setup

Follow the detailed guide in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

Key steps:
1. Create Firebase project
2. Enable Phone Authentication
3. Add Android and Web apps
4. Download configuration files
5. Run `flutterfire configure`

### 2. Update Code

Uncomment Firebase initialization in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Uncomment Firebase code in `lib/services/auth_service.dart`

### 3. Test with Real Firebase

```bash
flutter run
```

Now the app will use real Firebase phone authentication!

## 📦 Project Structure

```
lib/
├── main.dart                    # App entry point
├── routes/                      # Navigation routes
├── models/                      # Data models
├── controllers/                 # Business logic (GetX)
├── views/                       # UI screens
│   ├── auth/                   # Authentication screens
│   └── home/                   # Main app screens
├── services/                    # API and Firebase services
├── utils/                       # Helpers and utilities
└── bindings/                    # Dependency injection

test/
├── services/                    # Service tests
└── controllers/                 # Controller tests
```

## 🎨 Customization

### Change Theme Colors

Edit `lib/utils/theme.dart`:

```dart
static const Color primaryColor = Color(0xFF2196F3); // Your color
```

### Change App Name

Update `pubspec.yaml`:

```yaml
name: your_app_name
description: Your app description
```

### Change Package Name

```bash
# Install package
flutter pub add change_app_package_name

# Change package name
flutter pub run change_app_package_name:main com.yourcompany.appname
```

## 🐛 Troubleshooting

### Flutter Command Not Found

```bash
# Add to PATH (macOS/Linux)
export PATH="$PATH:/path/to/flutter/bin"

# Or in ~/.zshrc or ~/.bashrc
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Android SDK Issues

```bash
flutter doctor --android-licenses
```

### Gradle Build Errors

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Web Port Already in Use

```bash
flutter run -d chrome --web-port 8081
```

### Hot Reload Not Working

Press `R` for full restart instead of `r`

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [GetX Documentation](https://pub.dev/packages/get)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [API Documentation](https://restful-api.dev/)

## 💡 Development Tips

### Use Flutter DevTools

```bash
# Run the app first, then in another terminal:
flutter pub global activate devtools
flutter pub global run devtools
```

### VS Code Extensions (Recommended)

- Flutter
- Dart
- Flutter Widget Snippets
- Bracket Pair Colorizer

### Android Studio Plugins

- Flutter
- Dart

### Useful Shortcuts

**VS Code:**
- `Cmd/Ctrl + Shift + P` - Command palette
- `F5` - Start debugging
- Type `Flutter: New Widget` - Create widget

## 🎯 Next Steps

1. ✅ Run the app in development mode
2. ✅ Test all CRUD operations
3. ✅ Run the unit tests
4. 📖 Read [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for production setup
5. 📖 Read [DEPLOYMENT.md](DEPLOYMENT.md) for deployment instructions
6. 🎨 Customize the app theme and branding
7. 📹 Record your walkthrough video
8. 🚀 Deploy to Firebase Hosting and create APK
9. 📧 Submit your project

## 📧 Support

For questions about the assignment, contact: careers@cargopro.ai

## 📝 Notes

- The app currently uses mock authentication (OTP: 123456)
- API calls are real to https://api.restful-api.dev/objects
- All CRUD operations are functional
- Unit tests are included
- Firebase setup is optional for initial testing

Happy Coding! 🎉
