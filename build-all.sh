#!/bin/bash

# Build Script for Habit Tracker
# Builds Android APK and Web in one command

echo "🏗️ Building Habit Tracker for Android and Web..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found!${NC}"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo -e "${BLUE}📦 Step 1/5: Installing dependencies...${NC}"
flutter pub get
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

echo -e "${BLUE}🔧 Step 2/5: Generating code files...${NC}"
dart run build_runner build --delete-conflicting-outputs
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Code generation failed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Code files generated${NC}"
echo ""

echo -e "${BLUE}🤖 Step 3/5: Building Android APK...${NC}"
flutter build apk --release
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Android build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Android APK built successfully${NC}"
echo "   Location: build/app/outputs/flutter-apk/app-release.apk"
echo ""

echo -e "${BLUE}🌐 Step 4/5: Building Web...${NC}"
flutter build web --release --web-renderer canvaskit
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Web build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Web built successfully${NC}"
echo "   Location: build/web/"
echo ""

echo -e "${BLUE}📊 Step 5/5: Generating build summary...${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}🎉 Build Complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Android APK:"
echo "   Path: build/app/outputs/flutter-apk/app-release.apk"
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    size=$(du -h "build/app/outputs/flutter-apk/app-release.apk" | cut -f1)
    echo "   Size: $size"
fi
echo ""
echo "🌐 Web Build:"
echo "   Path: build/web/"
if [ -d "build/web" ]; then
    size=$(du -sh "build/web" | cut -f1)
    echo "   Size: $size"
fi
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📤 Next Steps:"
echo ""
echo "For Android:"
echo "  • Install APK on device manually"
echo "  • Or upload to Google Play Store"
echo ""
echo "For Web:"
echo "  • Deploy to Netlify: drag build/web folder to app.netlify.com"
echo "  • Deploy to Vercel: vercel --prod"
echo "  • Deploy to Firebase: firebase deploy --only hosting"
echo ""
echo "See DEPLOYMENT_GUIDE.md for detailed instructions!"
echo ""
