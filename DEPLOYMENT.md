# Deployment Guide

This guide covers deploying your CargoPro app to Firebase Hosting (Web) and creating an Android APK.

## Prerequisites

- Flutter SDK installed and configured
- Firebase CLI installed: `npm install -g firebase-tools`
- Firebase project set up (see FIREBASE_SETUP.md)

## Web Deployment to Firebase Hosting

### 1. Build the Web App

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build for web (production)
flutter build web --release
```

This creates a production build in `build/web/`

### 2. Test the Build Locally

```bash
# Serve the build locally
cd build/web
python3 -m http.server 8000

# Or use Firebase hosting locally
firebase serve
```

Open `http://localhost:8000` to test

### 3. Initialize Firebase Hosting (First Time Only)

```bash
# Login to Firebase
firebase login

# Initialize hosting
firebase init hosting
```

When prompted:
- **What do you want to use as your public directory?** `build/web`
- **Configure as a single-page app?** Yes
- **Set up automatic builds with GitHub?** No (optional)
- **Overwrite index.html?** No

### 4. Deploy to Firebase Hosting

```bash
# Deploy
firebase deploy --only hosting

# Or with a custom message
firebase deploy --only hosting -m "Initial deployment"
```

### 5. Access Your Deployed App

After deployment, you'll see output like:
```
✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/your-project/overview
Hosting URL: https://your-project.web.app
```

Visit the Hosting URL to see your live app!

### Continuous Deployment

For subsequent deployments:

```bash
# 1. Make your changes
# 2. Build
flutter build web --release

# 3. Deploy
firebase deploy --only hosting
```

### Custom Domain (Optional)

1. Go to Firebase Console → Hosting
2. Click "Add custom domain"
3. Follow the instructions to verify and connect your domain

## Android APK Deployment

### 1. Build APK (Debug)

For testing:

```bash
flutter build apk --debug
```

APK location: `build/app/outputs/flutter-apk/app-debug.apk`

### 2. Build APK (Release)

For production:

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

### 3. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

Bundle location: `build/app/outputs/bundle/release/app-release.aab`

### 4. Sign the APK (Production)

For production release, you need to sign the APK.

#### Create a Keystore

```bash
keytool -genkey -v -keystore ~/cargopro-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias cargopro
```

#### Configure Signing

Create `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=cargopro
storeFile=/Users/yourusername/cargopro-key.jks
```

Update `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

Then build:

```bash
flutter build apk --release
```

### 5. Test the APK

#### On Physical Device:

```bash
# Install APK
flutter install build/app/outputs/flutter-apk/app-release.apk

# Or use adb
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### Share via Drive:

1. Upload APK to Google Drive
2. Set sharing to "Anyone with the link"
3. Share the link

```bash
# Example: Copy APK to a shared location
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/CargoPro-v1.0.0.apk
```

### 6. Upload to Google Play Store (Optional)

1. Go to [Google Play Console](https://play.google.com/console)
2. Create a new app
3. Upload the AAB file
4. Fill in store listing details
5. Submit for review

## Build Sizes and Optimization

### Check Build Size

```bash
flutter build apk --analyze-size
```

### Reduce Build Size

```bash
# Split APK by ABI
flutter build apk --split-per-abi --release

# This creates multiple APKs:
# - app-armeabi-v7a-release.apk
# - app-arm64-v8a-release.apk
# - app-x86_64-release.apk
```

## CI/CD with GitHub Actions (Optional)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build web
      run: flutter build web --release
    
    - name: Deploy to Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
        channelId: live
        projectId: your-project-id
```

## Version Management

Update version in `pubspec.yaml`:

```yaml
version: 1.0.0+1
# Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
```

Before each release:
1. Increment version number
2. Update CHANGELOG.md
3. Tag the release in git:

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## Post-Deployment Checklist

### Web:
- [ ] Test all features on deployed URL
- [ ] Test on different browsers (Chrome, Firefox, Safari)
- [ ] Test responsive design on mobile browsers
- [ ] Verify Firebase Auth works
- [ ] Check API calls work
- [ ] Test phone OTP flow
- [ ] Verify SSL certificate

### Android:
- [ ] Test APK on real device
- [ ] Test phone OTP flow
- [ ] Test all CRUD operations
- [ ] Check app permissions
- [ ] Test offline behavior
- [ ] Verify app icon and name
- [ ] Test on different Android versions

## Rollback

### Web:
```bash
# View deployment history
firebase hosting:list

# Rollback to previous version
firebase hosting:rollback
```

### Android:
Keep previous APK versions for quick rollback if needed.

## Monitoring

### Firebase Console:
- Monitor Authentication usage
- Check Hosting metrics
- Review error reports

### Analytics (Optional):
```bash
# Add Firebase Analytics
flutter pub add firebase_analytics
```

## Troubleshooting

### Web Deployment Issues:

**Build fails:**
```bash
flutter clean
flutter pub get
flutter build web --release
```

**403 Forbidden:**
Check Firebase Hosting rules and authentication

**Files not updating:**
Clear browser cache or use incognito mode

### Android Build Issues:

**Gradle build fails:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Signing errors:**
Verify `key.properties` and keystore file path

**APK too large:**
Use `--split-per-abi` flag

## Resources

- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android)
- [Firebase Hosting Guide](https://firebase.google.com/docs/hosting)
- [Google Play Console](https://play.google.com/console)
