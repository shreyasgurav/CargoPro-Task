# Firebase Setup Guide

This guide will help you set up Firebase Authentication for both Android and Web platforms.

## Prerequisites

- Flutter SDK installed
- Firebase CLI installed: `npm install -g firebase-tools`
- A Google account

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "CargoPro" (or your preferred name)
4. Disable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Phone Authentication

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Click on **Phone** provider
3. Enable it
4. Save

## Step 3: Set Up Android App

### 3.1 Add Android App to Firebase

1. In Firebase Console, click the **Android** icon
2. Enter Android package name: `com.cargopro.cargo_pro_app`
3. Enter app nickname: "CargoPro Android" (optional)
4. Leave SHA-1 empty for development (required for production)
5. Click "Register app"

### 3.2 Download google-services.json

1. Download the `google-services.json` file
2. Place it in: `android/app/google-services.json`

### 3.3 Update Android Configuration

The project is already configured with the necessary Firebase dependencies.

**Verify these files exist:**
- `android/build.gradle` - includes Google Services plugin
- `android/app/build.gradle` - includes Firebase dependencies

## Step 4: Set Up Web App

### 4.1 Add Web App to Firebase

1. In Firebase Console, click the **Web** icon (</>)
2. Enter app nickname: "CargoPro Web"
3. Enable Firebase Hosting (optional, needed for deployment)
4. Click "Register app"

### 4.2 Copy Firebase Configuration

You'll see a configuration object like:

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "cargopro-xxxxx.firebaseapp.com",
  projectId: "cargopro-xxxxx",
  storageBucket: "cargopro-xxxxx.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef"
};
```

### 4.3 Update Web Configuration

Update `web/index.html` and add Firebase scripts before the closing `</head>` tag:

```html
<!-- Firebase App (the core Firebase SDK) -->
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-auth-compat.js"></script>

<script>
  // Your web app's Firebase configuration
  const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
  };
  
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
</script>
```

### 4.4 Add Authorized Domains (Web)

1. Go to **Authentication** → **Settings** → **Authorized domains**
2. Add your deployment domain (e.g., `cargopro-xxxxx.web.app`)
3. For local testing, `localhost` is already authorized

## Step 5: Generate firebase_options.dart

### Using FlutterFire CLI (Recommended)

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configure Firebase for your project:
```bash
flutterfire configure
```

This will:
- Create `lib/firebase_options.dart`
- Register apps if not already registered
- Download configuration files

### Manual Setup (Alternative)

If you prefer manual setup, create `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS is not supported');
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}
```

## Step 6: Update main.dart

Uncomment the Firebase initialization code in `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await initServices();
  runApp(const MyApp());
}
```

## Step 7: Update AuthService

In `lib/services/auth_service.dart`, uncomment all Firebase-related code.

## Step 8: Test the Setup

### For Android:
```bash
flutter run -d android
```

### For Web:
```bash
flutter run -d chrome
```

### Test Phone Authentication:

1. Run the app
2. Enter a test phone number
3. Check Firebase Console for verification code (in development)
4. Or use a test phone number in Firebase Console:
   - Go to Authentication → Settings → Phone
   - Add test phone numbers with predefined codes

## Step 9: Add Test Phone Numbers (Optional)

For development without SMS:

1. Firebase Console → Authentication → Settings
2. Scroll to "Phone numbers for testing"
3. Add numbers like: `+1 555-555-5555` with code `123456`

## Troubleshooting

### Android Issues:

**SHA-1 Certificate Error:**
```bash
# Get debug SHA-1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```
Add this to Firebase Console → Project Settings → Your app

**MultiDex Error:**
Already configured in `android/app/build.gradle`

### Web Issues:

**CORS Errors:**
Make sure your domain is added to authorized domains in Firebase Console

**reCAPTCHA Issues:**
Firebase will show a reCAPTCHA for phone auth on web. This is normal behavior.

**localhost Testing:**
Use `http://localhost:<port>` not `127.0.0.1`

## Production Checklist

- [ ] Add SHA-1 certificate to Firebase Console (Android)
- [ ] Enable app verification in Firebase Auth settings
- [ ] Add production domain to authorized domains
- [ ] Set up abuse prevention
- [ ] Configure reCAPTCHA settings for web
- [ ] Test on real devices with real phone numbers
- [ ] Remove test phone numbers before production release

## Useful Commands

```bash
# Check Firebase projects
firebase projects:list

# Login to Firebase
firebase login

# Initialize Firebase Hosting
firebase init hosting

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## Additional Resources

- [Firebase Phone Auth Documentation](https://firebase.google.com/docs/auth/flutter/phone-auth)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
