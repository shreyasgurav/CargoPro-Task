# Getting Started - CargoPro Flutter App

## 🎯 Your Flutter Project is Ready!

Everything has been set up for you. Follow these simple steps to run your app.

## ⚠️ Important: You Need Flutter Installed

First, check if Flutter is installed:

```bash
flutter --version
```

If you see "command not found", you need to install Flutter first.

### Install Flutter (macOS)

**Option 1: Using Homebrew (Easiest)**
```bash
brew install flutter
```

**Option 2: Manual Installation**
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/macos
2. Extract it to a location (e.g., `~/development/flutter`)
3. Add to PATH in `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Restart terminal and run:
   ```bash
   flutter doctor
   ```

## 🚀 Quick Start (3 Simple Steps)

### Step 1: Get Dependencies

```bash
cd /Users/shreyasgurav/Desktop/CargoPro
flutter pub get
```

This downloads all required packages.

### Step 2: Run the App

**For Web (Easiest):**
```bash
flutter run -d chrome
```

**For Android (if you have Android Studio/emulator):**
```bash
# List available devices
flutter devices

# Run on Android
flutter run -d android
```

### Step 3: Test the App

The app runs in **development mode** (no Firebase needed for testing):

1. **Login Screen**: Enter any phone number (e.g., `+1234567890`)
2. **Click "Send OTP"**
3. **OTP Screen**: Enter `123456`
4. **Click "Verify & Continue"**
5. **You're in!** Test all features

## ✅ What Works Without Firebase

✅ **Everything except real phone authentication!**

- Login (with mock OTP: 123456)
- All CRUD operations (real API)
- List objects
- View details
- Create new objects
- Edit objects
- Delete objects
- Error handling
- Form validation
- All UI features

## 🔥 To Enable Real Firebase Auth

1. Read `FIREBASE_SETUP.md`
2. Create Firebase project
3. Add Android/Web apps
4. Download config files
5. Uncomment Firebase code in:
   - `lib/main.dart`
   - `lib/services/auth_service.dart`

## 📁 Project Structure

```
CargoPro/
├── lib/
│   ├── main.dart                 # Start here
│   ├── routes/                   # Navigation
│   ├── models/                   # Data models
│   ├── controllers/              # Business logic
│   ├── views/                    # UI screens
│   ├── services/                 # API & Firebase
│   ├── utils/                    # Helpers
│   └── bindings/                 # DI setup
├── test/                         # Unit tests
├── android/                      # Android config
├── web/                          # Web config
└── *.md                          # Documentation
```

## 🧪 Run Tests

```bash
flutter test
```

All tests should pass!

## 🎨 Customize the App

### Change Colors

Edit `lib/utils/theme.dart`:

```dart
static const Color primaryColor = Color(0xFF2196F3); // Change this
```

### Change App Name

Edit `pubspec.yaml`:

```yaml
name: cargo_pro_app  # Change this
description: Your description
```

## 📱 Test Features

### Authentication Flow
1. Login screen → Enter phone
2. OTP screen → Enter 123456
3. Home screen → See menu options

### CRUD Operations
1. **List**: Click "View Objects" → See all objects
2. **Detail**: Tap any object → See full details
3. **Create**: Click "Create Object" or FAB → Fill form → Submit
4. **Update**: Open detail → Click Edit → Modify → Update
5. **Delete**: Open detail → Click Delete → Confirm

### Test Data for Create/Edit
```json
{
  "color": "blue",
  "capacity": "256 GB",
  "price": 999
}
```

## 🐛 Troubleshooting

### "Flutter command not found"
- Install Flutter (see instructions above)
- Add Flutter to PATH
- Restart terminal

### "No devices found"
- For web: Install Chrome
- For Android: Install Android Studio and create emulator

### "Failed to get dependencies"
```bash
flutter clean
flutter pub get
```

### "Cannot find package:get"
```bash
flutter pub get
```

### Port 8080 already in use
```bash
flutter run -d chrome --web-port 8081
```

### Android build errors
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📚 Documentation Files

- **README.md** - Main documentation
- **QUICKSTART.md** - Quick setup (this is more detailed)
- **FIREBASE_SETUP.md** - Firebase configuration
- **DEPLOYMENT.md** - How to deploy
- **ARCHITECTURE.md** - Code structure explanation
- **VIDEO_SCRIPT.md** - Video recording guide
- **SUBMISSION_CHECKLIST.md** - Before you submit
- **PROJECT_SUMMARY.md** - What's included

## 🎓 Learning Resources

### New to Flutter?
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Flutter YouTube Channel](https://www.youtube.com/c/flutterdev)

### New to GetX?
- [GetX Documentation](https://pub.dev/packages/get)
- [GetX Tutorial](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d)

### API Reference
- [REST API Docs](https://restful-api.dev/)

## 💻 IDE Setup

### VS Code (Recommended)
1. Install Flutter extension
2. Install Dart extension
3. Open project folder
4. Press F5 to run with debugging

### Android Studio
1. Install Flutter plugin
2. Install Dart plugin
3. Open project
4. Click Run button

## 🎯 Next Steps After Testing

1. ✅ **Test all features** - Make sure everything works
2. ✅ **Read FIREBASE_SETUP.md** - For production auth
3. ✅ **Read DEPLOYMENT.md** - To deploy
4. ✅ **Read VIDEO_SCRIPT.md** - To record video
5. ✅ **Read SUBMISSION_CHECKLIST.md** - Before submitting

## 📧 Assignment Submission

When ready to submit:
1. Set up Firebase (optional for initial testing)
2. Deploy web app to Firebase Hosting
3. Build Android APK
4. Record video walkthrough
5. Push code to GitHub
6. Email to: careers@cargopro.ai
   - Subject: YourName_FrontendDevelopment_Internship
   - Include: GitHub link, live URL, APK link, video link

## ✨ Quick Commands Reference

```bash
# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android
flutter run -d android

# Run tests
flutter test

# Format code
dart format .

# Check for issues
flutter analyze

# Build for web
flutter build web --release

# Build APK
flutter build apk --release

# Clean project
flutter clean
```

## 🎉 You're All Set!

Your Flutter project is complete with:
- ✅ Clean architecture
- ✅ GetX state management
- ✅ Firebase auth support
- ✅ Full CRUD operations
- ✅ Comprehensive tests
- ✅ Beautiful UI
- ✅ Complete documentation

**Start exploring and good luck with your assignment!** 🚀

---

Need help? Check the other documentation files or refer to Flutter documentation.
