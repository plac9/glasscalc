#!/bin/bash
#
# Run automated screenshot tests and extract images
#

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}  PrismCalc Automated Screenshot Capture${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Configuration
SCHEME="PrismCalc"
SIMULATOR="iPhone 17 Pro Max"
OUTPUT_DIR="./screenshots"
TEST_CLASS="ScreenshotTests"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_DIR"

# Clean previous results
echo -e "${YELLOW}🧹 Cleaning previous results...${NC}"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Find simulator ID
echo -e "${YELLOW}📱 Finding simulator: $SIMULATOR${NC}"
SIMULATOR_ID=$(xcrun simctl list devices | grep "$SIMULATOR" | grep -v "unavailable" | head -1 | grep -o '[A-F0-9-]\{36\}')

if [ -z "$SIMULATOR_ID" ]; then
    echo -e "${RED}❌ Simulator not found: $SIMULATOR${NC}"
    echo -e "${YELLOW}Available simulators:${NC}"
    xcrun simctl list devices | grep iPhone
    exit 1
fi

echo -e "${GREEN}✅ Using simulator ID: $SIMULATOR_ID${NC}"

# Boot simulator
echo -e "${YELLOW}🚀 Booting simulator...${NC}"
xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || true
sleep 2

# Build for testing
echo -e "${YELLOW}🔨 Building for testing...${NC}"
xcodebuild \
    -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
    -derivedDataPath ./DerivedData \
    build-for-testing \
    | grep -E '(error|warning|Compiling|Linking|Build succeeded)' || true

# Run UI tests
echo -e "${YELLOW}🧪 Running screenshot tests...${NC}"
echo -e "${BLUE}This will take about 2-3 minutes...${NC}"
echo ""

xcodebuild \
    -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
    -derivedDataPath ./DerivedData \
    -only-testing:"${SCHEME}UITests/$TEST_CLASS" \
    test \
    2>&1 | tee test-output.log

# Check if tests passed
if grep -q "Test Suite.*failed" test-output.log; then
    echo -e "${RED}❌ Screenshot tests failed${NC}"
    echo -e "${YELLOW}Check test-output.log for details${NC}"
    exit 1
fi

# Find test results
echo -e "${YELLOW}📁 Finding test results...${NC}"
XCRESULT=$(find ./DerivedData -name "*.xcresult" -type d | head -1)

if [ -z "$XCRESULT" ]; then
    echo -e "${RED}❌ Could not find test results${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found results: $XCRESULT${NC}"

# Extract screenshots using xcparse
echo -e "${YELLOW}📸 Extracting screenshots...${NC}"

# Check if xcparse is installed
if ! command -v xcparse &> /dev/null; then
    echo -e "${YELLOW}Installing xcparse...${NC}"
    brew install chargepoint/xcparse/xcparse
fi

# Extract screenshots
xcparse screenshots "$XCRESULT" "$OUTPUT_DIR" --test

# Rename screenshots to App Store format
echo -e "${YELLOW}📝 Renaming screenshots...${NC}"

cd "$OUTPUT_DIR"

# Find the test attachments directory
ATTACHMENTS_DIR=$(find . -name "Attachments" -type d | head -1)

if [ -d "$ATTACHMENTS_DIR" ]; then
    cd "$ATTACHMENTS_DIR"

    # Find and rename screenshot files
    for file in *.png; do
        if [ -f "$file" ]; then
            # Extract screenshot number from filename
            if [[ $file =~ ([0-9]{2})_ ]]; then
                number="${BASH_REMATCH[1]}"
                newname="iphone67_${number}_screenshot.png"
                mv "$file" "../../$newname"
                echo -e "${GREEN}✅ Renamed: $file → $newname${NC}"
            fi
        fi
    done

    cd ../..
    rm -rf "$(dirname "$ATTACHMENTS_DIR")"
fi

# List captured screenshots
echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}  Screenshots Captured${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

SCREENSHOT_COUNT=0
for file in *.png; do
    if [ -f "$file" ]; then
        size=$(ls -lh "$file" | awk '{print $5}')
        echo -e "${GREEN}✓${NC} $file ($size)"
        ((SCREENSHOT_COUNT++))
    fi
done

echo ""
if [ $SCREENSHOT_COUNT -eq 10 ]; then
    echo -e "${GREEN}🎉 Success! All 10 screenshots captured!${NC}"
elif [ $SCREENSHOT_COUNT -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Captured $SCREENSHOT_COUNT/10 screenshots${NC}"
else
    echo -e "${RED}❌ No screenshots found${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}📁 Screenshots saved to: $OUTPUT_DIR${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "  1. Review screenshots in: $OUTPUT_DIR"
echo "  2. Upload to App Store Connect"
echo ""

# Cleanup
cd "$PROJECT_DIR"
rm -f test-output.log
