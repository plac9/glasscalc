#!/bin/bash
#
# Automated App Store Connect Setup for PrismCalc
# Uses App Store Connect API for automation
#

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}  PrismCalc App Store Connect Setup${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Configuration
BUNDLE_ID="com.laclairtech.prismcalc"
WIDGET_BUNDLE_ID="com.laclairtech.prismcalc.widget"
APP_GROUP="group.com.laclairtech.prismcalc.shared"
IAP_PRODUCT_ID="com.laclairtech.prismcalc.pro"
APP_NAME="PrismCalc"
SKU="prismcalc-ios"

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

# Check if logged in to App Store Connect
if ! xcrun altool --list-apps -u "$APPLE_ID" -p "@keychain:AC_PASSWORD" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to App Store Connect${NC}"
    echo ""
    echo "To set up automated access:"
    echo "  1. Generate an App-Specific Password:"
    echo "     https://appleid.apple.com/account/manage → Sign-In & Security → App-Specific Passwords"
    echo ""
    echo "  2. Save to keychain:"
    echo "     security add-generic-password -a \"\$APPLE_ID\" -w \"YOUR_APP_PASSWORD\" -s \"AC_PASSWORD\""
    echo ""
    echo "  3. Set your Apple ID:"
    echo "     export APPLE_ID=\"your@email.com\""
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Logged in to App Store Connect${NC}"

# Step 1: Register Bundle IDs
echo ""
echo -e "${BLUE}Step 1: Registering Bundle IDs${NC}"
echo -e "${YELLOW}═══════════════════════════════════${NC}"

register_bundle_id() {
    local bundle_id=$1
    local name=$2
    local capabilities=$3

    echo -e "${YELLOW}📝 Checking bundle ID: $bundle_id${NC}"

    # Note: This would use App Store Connect API
    # For now, we'll create manual instructions
    echo -e "${BLUE}Manual step required:${NC}"
    echo "  1. Go to https://developer.apple.com/account/resources/identifiers"
    echo "  2. Click '+' to create new App ID"
    echo "  3. Description: $name"
    echo "  4. Bundle ID: $bundle_id"
    echo "  5. Capabilities: $capabilities"
    echo ""
}

register_bundle_id "$BUNDLE_ID" "PrismCalc" "In-App Purchase, App Groups, Siri"
register_bundle_id "$WIDGET_BUNDLE_ID" "PrismCalc Widget" "App Groups"

# Step 2: Create App Group
echo ""
echo -e "${BLUE}Step 2: Creating App Group${NC}"
echo -e "${YELLOW}═══════════════════════════════════${NC}"
echo -e "${BLUE}Manual step required:${NC}"
echo "  1. Go to https://developer.apple.com/account/resources/identifiers"
echo "  2. Click '+' → App Groups"
echo "  3. Description: PrismCalc Shared Data"
echo "  4. Identifier: $APP_GROUP"
echo ""

# Step 3: Create App Record
echo ""
echo -e "${BLUE}Step 3: Creating App Record${NC}"
echo -e "${YELLOW}═══════════════════════════════════${NC}"

cat > app-metadata.json <<EOF
{
  "name": "$APP_NAME",
  "bundleId": "$BUNDLE_ID",
  "sku": "$SKU",
  "primaryLanguage": "en-US",
  "primaryCategory": "UTILITIES",
  "secondaryCategory": "FINANCE"
}
EOF

echo -e "${GREEN}✅ App metadata prepared${NC}"
echo -e "${BLUE}Manual step required:${NC}"
echo "  1. Go to https://appstoreconnect.apple.com"
echo "  2. My Apps → '+' → New App"
echo "  3. Platform: iOS"
echo "  4. Name: PrismCalc"
echo "  5. Primary Language: English (U.S.)"
echo "  6. Bundle ID: $BUNDLE_ID"
echo "  7. SKU: $SKU"
echo ""

# Step 4: Configure In-App Purchase
echo ""
echo -e "${BLUE}Step 4: Setting Up In-App Purchase${NC}"
echo -e "${YELLOW}═══════════════════════════════════${NC}"

cat > iap-metadata.json <<EOF
{
  "productId": "$IAP_PRODUCT_ID",
  "referenceName": "PrismCalc Pro",
  "type": "Non-Consumable",
  "price": 2.99,
  "priceUSD": "2.99",
  "displayName": "PrismCalc Pro",
  "description": "Unlock all calculators, themes, and features"
}
EOF

echo -e "${GREEN}✅ IAP metadata prepared${NC}"
echo -e "${BLUE}Manual step required:${NC}"
echo "  1. In App Store Connect → Your App → In-App Purchases"
echo "  2. Click '+' or 'Create'"
echo "  3. Type: Non-Consumable"
echo "  4. Reference Name: PrismCalc Pro"
echo "  5. Product ID: $IAP_PRODUCT_ID"
echo "  6. Price: Tier 5 (\$2.99)"
echo "  7. Localization (English): Display Name: 'PrismCalc Pro'"
echo "  8. Description: 'Unlock all calculators, themes, and features'"
echo ""

# Step 5: Upload App Metadata
echo ""
echo -e "${BLUE}Step 5: App Metadata & Screenshots${NC}"
echo -e "${YELLOW}═══════════════════════════════════${NC}"

echo -e "${YELLOW}Using metadata from: docs/appstore/metadata.md${NC}"
echo -e "${YELLOW}Using screenshots from: ./screenshots/${NC}"

echo ""
echo -e "${BLUE}Manual steps required:${NC}"
echo "  1. Copy description from docs/appstore/metadata.md"
echo "  2. Upload screenshots from ./screenshots/"
echo "  3. Set app category: Utilities (primary), Finance (secondary)"
echo "  4. Privacy Policy URL: https://laclairtech.com/privacy"
echo "  5. Support URL: https://laclairtech.com/support/prismcalc"
echo ""

# Step 6: Summary
echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Setup Summary${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "✓ App metadata prepared"
echo "✓ IAP metadata prepared"
echo "✓ Configuration files created"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Complete manual steps above"
echo "  2. Build and upload via Xcode:"
echo "     • Product → Archive"
echo "     • Distribute App → App Store Connect"
echo "  3. Submit for review in App Store Connect"
echo ""
echo -e "${BLUE}Generated files:${NC}"
echo "  • app-metadata.json"
echo "  • iap-metadata.json"
echo ""

# Create checklist
cat > appstore-checklist.md <<'EOF'
# App Store Connect Setup Checklist

## Bundle IDs
- [ ] Register com.laclairtech.prismcalc
  - [ ] Enable In-App Purchase capability
  - [ ] Enable App Groups capability
  - [ ] Enable Siri capability
- [ ] Register com.laclairtech.prismcalc.widget
  - [ ] Enable App Groups capability
- [ ] Create App Group: group.com.laclairtech.prismcalc.shared

## App Record
- [ ] Create new app in App Store Connect
- [ ] Set name: PrismCalc
- [ ] Set bundle ID: com.laclairtech.prismcalc
- [ ] Set SKU: prismcalc-ios
- [ ] Set primary category: Utilities
- [ ] Set secondary category: Finance

## In-App Purchase
- [ ] Create Non-Consumable IAP
- [ ] Product ID: com.laclairtech.prismcalc.pro
- [ ] Price: $2.99 (Tier 5)
- [ ] Display Name: PrismCalc Pro
- [ ] Description: Unlock all calculators, themes, and features
- [ ] Submit IAP for review

## App Information
- [ ] Copy description from docs/appstore/metadata.md
- [ ] Set keywords: calculator,tip,split,bill,discount,converter,glass,theme,widget,siri
- [ ] Upload screenshots (all required sizes)
- [ ] Privacy Policy URL: https://laclairtech.com/privacy
- [ ] Support URL: https://laclairtech.com/support/prismcalc
- [ ] Set age rating: 4+

## Privacy
- [ ] Configure privacy details
- [ ] Select "No data collection"

## Build & Submit
- [ ] Archive build in Xcode
- [ ] Upload to App Store Connect
- [ ] Select build in version
- [ ] Fill TestFlight info
- [ ] Submit for review

## Post-Submission
- [ ] Monitor review status
- [ ] Test IAP with sandbox account
- [ ] Prepare for launch

---

**Status**: Ready for setup
**Date**: $(date +%Y-%m-%d)
EOF

echo -e "${GREEN}✅ Created setup checklist: appstore-checklist.md${NC}"
echo ""
