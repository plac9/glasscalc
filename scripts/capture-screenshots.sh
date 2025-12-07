#!/bin/bash
#
# PrismCalc Screenshot Capture Script
# Captures App Store screenshots for iPhone and iPad
#

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SIMULATOR_IPHONE="iPhone 17 Pro Max"
SIMULATOR_IPAD="iPad Pro 13-inch (M5)"
OUTPUT_DIR="./screenshots"
BUNDLE_ID="com.laclairtech.prismcalc"

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}  PrismCalc Screenshot Capture Tool${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR/iphone"
mkdir -p "$OUTPUT_DIR/ipad"

# Function to capture screenshot
capture_screenshot() {
    local device_name=$1
    local output_file=$2
    local description=$3

    echo -e "${YELLOW}📸 Capturing: ${description}${NC}"
    xcrun simctl io "$device_name" screenshot "$output_file"
    echo -e "${GREEN}✅ Saved: $output_file${NC}"
    echo ""
}

# Function to boot simulator if needed
boot_simulator() {
    local device_name=$1
    echo -e "${BLUE}🚀 Booting simulator: $device_name${NC}"

    # Get device ID
    local device_id=$(xcrun simctl list devices | grep "$device_name" | grep -v "unavailable" | head -1 | grep -o '[A-Z0-9-]\{36\}')

    if [ -z "$device_id" ]; then
        echo -e "${YELLOW}⚠️  Could not find device: $device_name${NC}"
        return 1
    fi

    # Boot if not already booted
    xcrun simctl boot "$device_id" 2>/dev/null || true
    sleep 3

    # Install and launch app
    echo -e "${BLUE}📱 Installing PrismCalc...${NC}"
    local app_path=$(find ~/Library/Developer/Xcode/DerivedData -name "PrismCalc.app" -path "*/Debug-iphonesimulator/*" | head -1)

    if [ -z "$app_path" ]; then
        echo -e "${YELLOW}⚠️  App not built. Run: xcodebuild -scheme PrismCalc build${NC}"
        return 1
    fi

    xcrun simctl install "$device_id" "$app_path"
    xcrun simctl launch "$device_id" "$BUNDLE_ID"
    sleep 2

    echo "$device_id"
}

# ═══════════════════════════════════════
# IPHONE SCREENSHOTS
# ═══════════════════════════════════════

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  iPhone Screenshots (6.9\")${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

IPHONE_ID=$(boot_simulator "$SIMULATOR_IPHONE")

if [ -n "$IPHONE_ID" ]; then
    echo -e "${GREEN}Ready to capture iPhone screenshots!${NC}"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════${NC}"
    echo -e "${YELLOW}  MANUAL STEPS REQUIRED${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════${NC}"
    echo ""
    echo "Please navigate to each screen in the simulator, then press ENTER to capture:"
    echo ""

    # Screenshot 1: Calculator
    echo "1️⃣  Main Calculator (Aurora theme)"
    echo "   - Show calculation: 1,234.56"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/01_calculator.png" "Main Calculator"

    # Screenshot 2: Tip Calculator
    echo "2️⃣  Tip Calculator (Blue-Green Harmony theme)"
    echo "   - Navigate to Tip Calculator"
    echo "   - Set tip to 20%"
    echo "   - Bill amount: \$50.00"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/02_tip.png" "Tip Calculator"

    # Screenshot 3: Bill Split
    echo "3️⃣  Bill Split (Calming Blues theme)"
    echo "   - Navigate to Split Bill"
    echo "   - 4 people"
    echo "   - Total: \$100.00"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/03_split.png" "Bill Split"

    # Screenshot 4: Discount Calculator
    echo "4️⃣  Discount Calculator (Forest Earth theme)"
    echo "   - Navigate to Discount Calculator"
    echo "   - Original: \$100.00"
    echo "   - Discount: 25%"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/04_discount.png" "Discount Calculator"

    # Screenshot 5: Unit Converter
    echo "5️⃣  Unit Converter (Soft Tranquil theme)"
    echo "   - Navigate to Unit Converter"
    echo "   - Convert 10 miles to km"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/05_converter.png" "Unit Converter"

    # Screenshot 6: Settings - Themes
    echo "6️⃣  Theme Selection"
    echo "   - Navigate to Settings"
    echo "   - Scroll to show all 6 themes"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/06_themes.png" "Theme Selection"

    # Screenshot 7: History
    echo "7️⃣  Calculation History (Midnight theme)"
    echo "   - Navigate to History"
    echo "   - Show multiple entries"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/07_history.png" "Calculation History"

    # Screenshot 8: Widget Home Screen
    echo "8️⃣  Widgets on Home Screen"
    echo "   - Go to Home Screen (Cmd+Shift+H)"
    echo "   - Show PrismCalc widgets"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/08_widgets.png" "Widgets"

    # Screenshot 9: Siri
    echo "9️⃣  Siri Integration"
    echo "   - Activate Siri"
    echo "   - Ask: 'Calculate 18% tip on \$50'"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/09_siri.png" "Siri Integration"

    # Screenshot 10: Control Center
    echo "🔟 Control Center (iOS 18)"
    echo "   - Open Control Center"
    echo "   - Show PrismCalc buttons"
    read -p "   Press ENTER when ready..."
    capture_screenshot "$IPHONE_ID" "$OUTPUT_DIR/iphone/10_control_center.png" "Control Center"

    echo ""
    echo -e "${GREEN}✅ iPhone screenshots complete!${NC}"
fi

# ═══════════════════════════════════════
# IPAD SCREENSHOTS (Optional)
# ═══════════════════════════════════════

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  iPad Screenshots (Optional)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "Capture iPad screenshots? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    IPAD_ID=$(boot_simulator "$SIMULATOR_IPAD")

    if [ -n "$IPAD_ID" ]; then
        echo -e "${GREEN}Ready to capture iPad screenshots!${NC}"
        echo ""

        echo "1️⃣  Main Calculator (iPad layout)"
        read -p "   Press ENTER when ready..."
        capture_screenshot "$IPAD_ID" "$OUTPUT_DIR/ipad/01_calculator.png" "iPad Calculator"

        echo "2️⃣  Tip Calculator (iPad split view)"
        read -p "   Press ENTER when ready..."
        capture_screenshot "$IPAD_ID" "$OUTPUT_DIR/ipad/02_tip.png" "iPad Tip Calculator"

        # Add more iPad screenshots as needed...

        echo ""
        echo -e "${GREEN}✅ iPad screenshots complete!${NC}"
    fi
fi

# ═══════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════

echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}  Screenshot Capture Complete!${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""
echo -e "📁 Screenshots saved to: ${GREEN}$OUTPUT_DIR${NC}"
echo ""
echo "Next steps:"
echo "  1. Review screenshots for quality"
echo "  2. Add captions/overlays if needed"
echo "  3. Upload to App Store Connect"
echo ""
