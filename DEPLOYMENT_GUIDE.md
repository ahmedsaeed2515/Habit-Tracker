# 🚀 Deployment Guide - Habit Tracker

This guide provides step-by-step instructions for deploying the Habit Tracker app to various platforms.

## 📱 Android APK

### Build APK Locally

```bash
# Release APK
flutter build apk --release

# Split APKs by ABI (smaller file sizes)
flutter build apk --split-per-abi --release

# Output location
# build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (for Google Play Store)

```bash
flutter build appbundle --release

# Output location
# build/app/outputs/bundle/release/app-release.aab
```

### CI/CD (Automated)

The GitHub Actions workflow automatically builds Android APK on every push to main/master/develop branches:

- **Workflow**: `.github/workflows/ci.yml`
- **Job**: `build_android`
- **Artifacts**: APK is uploaded as GitHub Actions artifact named `app-release.apk`

To download:
1. Go to Actions tab in GitHub
2. Select the latest workflow run
3. Download the `app-release.apk` artifact

---

## 🌐 Web Deployment

### Build Web Locally

```bash
# Generate code files first
dart run build_runner build --delete-conflicting-outputs

# Build for web
flutter build web --release --web-renderer canvaskit

# Output location
# build/web/
```

### Deploy to Netlify

#### Option 1: Netlify CLI

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Build the project
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release --web-renderer canvaskit

# Deploy
netlify deploy --prod --dir=build/web
```

#### Option 2: Netlify UI (Drag and Drop)

1. Build the project locally (see commands above)
2. Go to [Netlify](https://app.netlify.com)
3. Drag and drop the `build/web` folder
4. Your site is live!

#### Option 3: Netlify Git Integration (Recommended)

1. Push your code to GitHub
2. Go to [Netlify](https://app.netlify.com)
3. Click "New site from Git"
4. Connect your repository
5. Netlify will automatically use the `netlify.toml` configuration
6. Deploy!

**Configuration**: `netlify.toml` is already configured in the root directory.

### Deploy to Vercel

#### Option 1: Vercel CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Build the project
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release --web-renderer canvaskit

# Deploy
vercel --prod
```

#### Option 2: Vercel Git Integration (Recommended)

1. Push your code to GitHub
2. Go to [Vercel](https://vercel.com)
3. Click "New Project"
4. Import your repository
5. Vercel will automatically use the `vercel.json` configuration
6. Deploy!

**Configuration**: `vercel.json` is already configured in the root directory.

**Important Notes for Vercel**:
- Vercel will automatically install Flutter during the build process
- The first deployment may take longer as it downloads Flutter SDK
- Subsequent deployments will be faster due to caching

### Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase (only first time)
firebase init hosting

# Select:
# - What do you want to use as your public directory? build/web
# - Configure as a single-page app? Yes
# - Set up automatic builds with GitHub? (Optional) Yes

# Build the project
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release --web-renderer canvaskit

# Deploy
firebase deploy --only hosting
```

---

## 🔄 CI/CD Pipeline

### Current Setup

The project includes a GitHub Actions workflow that automatically:

1. **Tests** the code on every push/PR
2. **Builds Android APK** after tests pass
3. **Builds Web** after tests pass
4. **Uploads artifacts** for download

### Workflow Jobs

- **test**: Runs tests, formatting, and analysis
- **build_android**: Builds APK and App Bundle
- **build_ios**: Builds iOS app (requires macOS)
- **build_web**: Builds web app

### Accessing Build Artifacts

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Select a workflow run
4. Scroll down to "Artifacts" section
5. Download:
   - `app-release.apk` - Android APK
   - `web-build` - Web build files

---

## 📋 Pre-Deployment Checklist

### For All Platforms

- [ ] Update version in `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Test the app thoroughly
- [ ] Update CHANGELOG.md

### For Android

- [ ] Update version code in `android/app/build.gradle`
- [ ] Check app permissions in `android/app/src/main/AndroidManifest.xml`
- [ ] Update app icons if needed
- [ ] Test on multiple Android versions

### For Web

- [ ] Test on multiple browsers (Chrome, Firefox, Safari, Edge)
- [ ] Check responsive design
- [ ] Verify all assets load correctly
- [ ] Test PWA functionality
- [ ] Update meta tags in `web/index.html` if needed

---

## 🔧 Troubleshooting

### Build Fails on CI/CD

**Problem**: Build fails with "Target of URI hasn't been generated"

**Solution**: 
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Web App Doesn't Load

**Problem**: White screen on web deployment

**Solution**:
1. Check browser console for errors
2. Ensure all assets are included in `pubspec.yaml`
3. Try different web renderer: `--web-renderer html` or `--web-renderer canvaskit`

### APK Won't Install

**Problem**: "App not installed" error

**Solution**:
1. Enable "Unknown Sources" in Android settings
2. Uninstall previous version if exists
3. Check if APK is corrupted (re-download/rebuild)

### Netlify Build Fails

**Problem**: Build command fails

**Solution**:
1. Check build logs in Netlify dashboard
2. Ensure `netlify.toml` is in root directory
3. Verify Flutter version matches your local version

### Vercel Build Fails

**Problem**: Flutter not found during build

**Solution**:
1. The `vercel.json` includes Flutter installation
2. Check build logs for specific errors
3. Ensure `vercel.json` is in root directory

---

## 📊 Deployment Comparison

| Platform | Difficulty | Speed | Cost | CI/CD | Custom Domain |
|----------|-----------|-------|------|-------|---------------|
| **Netlify** | Easy | Fast | Free tier | ✅ | ✅ |
| **Vercel** | Easy | Fast | Free tier | ✅ | ✅ |
| **Firebase** | Medium | Fast | Free tier | ✅ | ✅ |
| **GitHub Pages** | Easy | Medium | Free | ✅ | ✅ |

---

## 🎯 Recommended Approach

### For Quick Demo
1. Build locally: `flutter build web`
2. Deploy to Netlify via drag-and-drop

### For Production
1. Set up Git integration with Netlify or Vercel
2. Enable automatic deployments from main branch
3. Use preview deployments for testing

### For Android Distribution
1. Use GitHub Actions to build APK automatically
2. Download from Actions artifacts
3. Distribute via:
   - Direct APK download
   - Google Play Store (requires developer account)
   - App stores alternatives (F-Droid, APKPure, etc.)

---

## 🔗 Useful Links

- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [Netlify Documentation](https://docs.netlify.com/)
- [Vercel Documentation](https://vercel.com/docs)
- [Firebase Hosting Documentation](https://firebase.google.com/docs/hosting)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Made with ❤️ for Habit Tracker**
