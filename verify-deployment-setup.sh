#!/bin/bash

# Deployment Setup Verification Script
# This script checks if all deployment configurations are in place

echo "🔍 Verifying Deployment Setup..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
checks_passed=0
checks_failed=0

# Function to check file existence
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅${NC} $1 exists"
        ((checks_passed++))
        return 0
    else
        echo -e "${RED}❌${NC} $1 missing"
        ((checks_failed++))
        return 1
    fi
}

# Function to check directory existence
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅${NC} $1 exists"
        ((checks_passed++))
        return 0
    else
        echo -e "${RED}❌${NC} $1 missing"
        ((checks_failed++))
        return 1
    fi
}

echo "📋 Checking Configuration Files..."
check_file "netlify.toml"
check_file "vercel.json"
check_file "pubspec.yaml"
check_file ".github/workflows/ci.yml"
check_file ".github/workflows/deploy-web.yml"

echo ""
echo "📄 Checking Documentation..."
check_file "DEPLOYMENT_GUIDE.md"
check_file "WEB_DEPLOYMENT.md"
check_file "DEPLOYMENT_SETUP_SUMMARY.md"
check_file "README.md"

echo ""
echo "📁 Checking Project Structure..."
check_dir "web"
check_file "web/index.html"
check_file "web/manifest.json"
check_dir "android"
check_dir "lib"

echo ""
echo "🔧 Checking Flutter Installation..."
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}✅${NC} Flutter is installed"
    flutter --version | head -n 1
    ((checks_passed++))
else
    echo -e "${YELLOW}⚠️${NC} Flutter not found in PATH"
    echo "   Install Flutter from: https://flutter.dev/docs/get-started/install"
    ((checks_failed++))
fi

echo ""
echo "📊 Results:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Checks Passed: ${GREEN}$checks_passed${NC}"
echo -e "Checks Failed: ${RED}$checks_failed${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $checks_failed -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All checks passed! Your project is ready for deployment.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Build locally: flutter build web --release"
    echo "2. Deploy to Netlify: See WEB_DEPLOYMENT.md"
    echo "3. Or push to GitHub and setup CI/CD"
    echo ""
    exit 0
else
    echo ""
    echo -e "${RED}⚠️ Some checks failed. Please review the missing items above.${NC}"
    echo ""
    exit 1
fi
