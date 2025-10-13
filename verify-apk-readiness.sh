#!/bin/bash

# Verify APK Readiness Script
# التحقق من جاهزية المشروع لبناء APK

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 التحقق من جاهزية بناء APK"
echo "🔍 Verifying APK Build Readiness"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ERRORS=0
WARNINGS=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check 1: Android directory exists
echo -n "1. Android directory... "
if [ -d "android" ]; then
    echo -e "${GREEN}✓ موجود${NC}"
else
    echo -e "${RED}✗ غير موجود${NC}"
    ERRORS=$((ERRORS+1))
fi

# Check 2: AndroidManifest.xml exists and has permissions
echo -n "2. AndroidManifest.xml... "
if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    PERMS=$(grep -c "uses-permission" android/app/src/main/AndroidManifest.xml)
    if [ $PERMS -gt 0 ]; then
        echo -e "${GREEN}✓ موجود ($PERMS صلاحية)${NC}"
    else
        echo -e "${YELLOW}⚠ موجود لكن بدون صلاحيات${NC}"
        WARNINGS=$((WARNINGS+1))
    fi
else
    echo -e "${RED}✗ غير موجود${NC}"
    ERRORS=$((ERRORS+1))
fi

# Check 3: build.gradle.kts exists
echo -n "3. build.gradle.kts... "
if [ -f "android/app/build.gradle.kts" ]; then
    # Check applicationId
    APP_ID=$(grep "applicationId" android/app/build.gradle.kts | grep -v "example" | wc -l)
    if [ $APP_ID -gt 0 ]; then
        echo -e "${GREEN}✓ موجود${NC}"
    else
        echo -e "${YELLOW}⚠ موجود لكن لا يزال يستخدم com.example${NC}"
        WARNINGS=$((WARNINGS+1))
    fi
else
    echo -e "${RED}✗ غير موجود${NC}"
    ERRORS=$((ERRORS+1))
fi

# Check 4: Application ID
echo -n "4. Application ID... "
if [ -f "android/app/build.gradle.kts" ]; then
    APP_ID=$(grep "applicationId" android/app/build.gradle.kts | head -1)
    if echo "$APP_ID" | grep -q "com.ahmedsaeed"; then
        echo -e "${GREEN}✓ معدّ بشكل صحيح${NC}"
    elif echo "$APP_ID" | grep -q "com.example"; then
        echo -e "${YELLOW}⚠ لا يزال يستخدم com.example${NC}"
        WARNINGS=$((WARNINGS+1))
    else
        echo -e "${YELLOW}⚠ معرّف مخصص${NC}"
    fi
fi

# Check 5: Signing configuration
echo -n "5. Signing config... "
if [ -f "android/app/build.gradle.kts" ]; then
    if grep -q "signingConfigs" android/app/build.gradle.kts; then
        echo -e "${GREEN}✓ موجود${NC}"
    else
        echo -e "${YELLOW}⚠ غير موجود${NC}"
        WARNINGS=$((WARNINGS+1))
    fi
else
    echo -e "${RED}✗ الملف غير موجود${NC}"
    ERRORS=$((ERRORS+1))
fi

# Check 6: key.properties example
echo -n "6. key.properties.example... "
if [ -f "android/key.properties.example" ]; then
    echo -e "${GREEN}✓ موجود${NC}"
else
    echo -e "${YELLOW}⚠ غير موجود${NC}"
    WARNINGS=$((WARNINGS+1))
fi

# Check 7: .gitignore protection
echo -n "7. .gitignore (key protection)... "
if [ -f ".gitignore" ]; then
    if grep -q "key.properties" .gitignore; then
        echo -e "${GREEN}✓ محمي${NC}"
    else
        echo -e "${YELLOW}⚠ غير محمي${NC}"
        WARNINGS=$((WARNINGS+1))
    fi
else
    echo -e "${RED}✗ .gitignore غير موجود${NC}"
    ERRORS=$((ERRORS+1))
fi

# Check 8: CI/CD workflow
echo -n "8. CI/CD workflow... "
if [ -f ".github/workflows/ci.yml" ]; then
    if grep -q "build apk" .github/workflows/ci.yml; then
        echo -e "${GREEN}✓ موجود${NC}"
    else
        echo -e "${YELLOW}⚠ موجود لكن بدون APK build${NC}"
        WARNINGS=$((WARNINGS+1))
    fi
else
    echo -e "${YELLOW}⚠ غير موجود${NC}"
    WARNINGS=$((WARNINGS+1))
fi

# Check 9: Build script
echo -n "9. build-all.sh... "
if [ -f "build-all.sh" ]; then
    if [ -x "build-all.sh" ]; then
        echo -e "${GREEN}✓ موجود وقابل للتنفيذ${NC}"
    else
        echo -e "${YELLOW}⚠ موجود لكن غير قابل للتنفيذ${NC}"
        WARNINGS=$((WARNINGS+1))
    fi
else
    echo -e "${YELLOW}⚠ غير موجود${NC}"
    WARNINGS=$((WARNINGS+1))
fi

# Check 10: Documentation
echo -n "10. Documentation... "
DOCS=0
[ -f "APK_BUILD_GUIDE_AR.md" ] && DOCS=$((DOCS+1))
[ -f "APK_READY_AR.md" ] && DOCS=$((DOCS+1))
[ -f "DEPLOYMENT_GUIDE.md" ] && DOCS=$((DOCS+1))

if [ $DOCS -ge 2 ]; then
    echo -e "${GREEN}✓ موجود ($DOCS ملف)${NC}"
elif [ $DOCS -eq 1 ]; then
    echo -e "${YELLOW}⚠ بعض الوثائق موجودة${NC}"
    WARNINGS=$((WARNINGS+1))
else
    echo -e "${YELLOW}⚠ غير موجود${NC}"
    WARNINGS=$((WARNINGS+1))
fi

# Check 11: pubspec.yaml
echo -n "11. pubspec.yaml... "
if [ -f "pubspec.yaml" ]; then
    echo -e "${GREEN}✓ موجود${NC}"
else
    echo -e "${RED}✗ غير موجود${NC}"
    ERRORS=$((ERRORS+1))
fi

# Check 12: Minimum SDK
echo -n "12. Minimum SDK... "
if [ -f "android/app/build.gradle.kts" ]; then
    if grep -q "minSdk = 21" android/app/build.gradle.kts; then
        echo -e "${GREEN}✓ مضبوط (21)${NC}"
    elif grep -q "minSdk" android/app/build.gradle.kts; then
        MIN_SDK=$(grep "minSdk" android/app/build.gradle.kts | head -1)
        echo -e "${YELLOW}⚠ $MIN_SDK${NC}"
    else
        echo -e "${YELLOW}⚠ يستخدم القيمة الافتراضية${NC}"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 النتائج - Results"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ ممتاز! المشروع جاهز 100% لبناء APK${NC}"
    echo -e "${GREEN}✅ Excellent! Project is 100% ready for APK build${NC}"
    echo ""
    echo "يمكنك الآن:"
    echo "You can now:"
    echo "  1. flutter build apk --release"
    echo "  2. ./build-all.sh"
    echo "  3. git push (for CI/CD build)"
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ جيد! المشروع جاهز لكن مع بعض التحذيرات${NC}"
    echo -e "${YELLOW}⚠ Good! Project is ready but with some warnings${NC}"
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
    EXIT_CODE=0
else
    echo -e "${RED}✗ يوجد مشاكل يجب حلها${NC}"
    echo -e "${RED}✗ There are issues that need to be fixed${NC}"
    echo -e "${RED}Errors: $ERRORS, Warnings: $WARNINGS${NC}"
    EXIT_CODE=1
fi

echo ""
echo "للمزيد من المعلومات، إقرأ:"
echo "For more information, read:"
echo "  - APK_BUILD_GUIDE_AR.md (Arabic guide)"
echo "  - DEPLOYMENT_GUIDE.md (English guide)"
echo ""

exit $EXIT_CODE
