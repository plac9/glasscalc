# PrismCalc App Store Setup Guide

**Status**: Ready for setup (screenshots captured, code complete)
**Goal**: Prepare for App Store submission WITHOUT submitting for review yet

---

## Phase 1: Apple Developer Account Setup

### 1.1 Register Bundle IDs
Go to: https://developer.apple.com/account/resources/identifiers

**Main App Bundle ID:**
- Click '+' to create new App ID
- Description: `PrismCalc`
- Bundle ID: `com.laclairtech.prismcalc`
- Capabilities to enable:
  - ✅ In-App Purchase
  - ✅ App Groups
  - ✅ Siri
- Click Continue → Register

**Widget Bundle ID:**
- Click '+' to create new App ID
- Description: `PrismCalc Widget`
- Bundle ID: `com.laclairtech.prismcalc.widget`
- Capabilities to enable:
  - ✅ App Groups
- Click Continue → Register

### 1.2 Create App Group
Go to: https://developer.apple.com/account/resources/identifiers

- Click '+' → Select "App Groups"
- Description: `PrismCalc Shared Data`
- Identifier: `group.com.laclairtech.prismcalc`
- Click Continue → Register

**Then link to Bundle IDs:**
- Select `com.laclairtech.prismcalc` → Edit
- Enable "App Groups" → Configure
- Select `group.com.laclairtech.prismcalc`
- Repeat for `com.laclairtech.prismcalc.widget`

---

## Phase 2: App Store Connect Setup

### 2.1 Create App Record
Go to: https://appstoreconnect.apple.com

- Click "My Apps" → '+' → "New App"
- **Platform**: iOS
- **Name**: PrismCalc
- **Primary Language**: English (U.S.)
- **Bundle ID**: Select `com.laclairtech.prismcalc`
- **SKU**: `prismcalc-ios`
- **User Access**: Full Access
- Click "Create"

### 2.2 App Information
In the app you just created:

**Category:**
- Primary Category: Utilities
- Secondary Category: Finance

**Age Rating:**
- Click "Edit" next to Age Rating
- Answer all questions (should result in 4+)
- Save

**App Privacy:**
- Click "Edit" next to Privacy Policy URL
- Privacy Policy URL: `https://laclairtech.com/privacy`
- Support URL: `https://laclairtech.com/support/prismcalc`
- Marketing URL: (optional)
- Save

---

## Phase 3: In-App Purchase Setup

### 3.1 Create IAP Product
In App Store Connect → Your App → In-App Purchases:

- Click "+" or "Manage"
- **Type**: Non-Consumable
- Click "Create"

**Reference Name**: `PrismCalc Pro`
**Product ID**: `com.laclairtech.prismcalc.pro`

**Price**:
- Click "Add Pricing"
- Select "Tier 5" ($2.99 USD)
- All territories
- Save

**Localization**:
- Add localization for English (U.S.)
- **Display Name**: `PrismCalc Pro`
- **Description**: `Unlock all calculators, themes, and features`
- Save

**Review Information**:
- Upload a screenshot (use any of the 10 we generated)
- Review notes: "Pro tier unlocks all calculator types (tip, discount, split bill, unit converter), all theme options, and history with lock/unlock entries"
- Save

**Status**: Save but don't submit for review yet

---

## Phase 4: Build & Upload (Do this when ready to test)

### 4.1 Archive the Build
In Xcode:
1. Select "Any iOS Device" as the build destination
2. Product → Archive
3. Wait for archive to complete (~2-3 minutes)

### 4.2 Upload to App Store Connect
1. When archive completes, Organizer window opens
2. Select your archive
3. Click "Distribute App"
4. Select "App Store Connect" → Next
5. Select "Upload" → Next
6. Select distribution options:
   - ✅ Include bitcode for iOS content: NO (not needed for iOS 16+)
   - ✅ Upload your app's symbols: YES
   - ✅ Manage Version and Build Number: Automatically manage
7. Click Next → Upload
8. Wait for upload (~5-10 minutes)

### 4.3 Verify Upload
- Go to App Store Connect → Your App → TestFlight
- Wait 10-15 minutes for processing
- Build should appear with status "Processing" then "Ready to Submit"

---

## Phase 5: App Store Metadata (Do before submission)

### 5.1 Version Information
In App Store Connect → Your App → App Store → iOS App:

**App Previews and Screenshots:**
- Upload all 10 screenshots from `./screenshots/`:
  - iphone67_01.png through iphone67_10.png
- iPhone 6.7" Display (required)

**Promotional Text** (optional, can be updated without review):
```
Experience the most beautiful calculator on iOS. Stunning glassmorphic design meets powerful functionality.
```

**Description** (copy from `docs/appstore/metadata.md`):
```
PrismCalc brings a spectacular glassmorphic design to your everyday calculations. More than just a calculator – it's a beautiful, functional tool you'll love using.

✨ FREE FEATURES
• Stunning glassmorphic design
• Aurora theme included
• iOS 18 optimized with smooth animations

🎯 PRISMCALC PRO ($2.99)
Unlock the complete experience:

CALCULATORS
• Tip Calculator with bill splitting
• Discount Calculator with savings display
• Split Bill Calculator for groups
• Unit Converter (length, weight, temperature)
• History with lock/unlock entries

THEMES
• 10+ beautiful glassmorphic themes
• Each with unique color gradients
• Dynamic mesh backgrounds

FEATURES
• History with lock/unlock entries
• Siri Shortcuts support
• Home Screen widgets
• Control Center widget
• Live Activities support

DESIGNED FOR iOS 18
• Native floating tab bar
• Smooth zoom transitions
• Haptic feedback
• Dark mode optimized

Privacy focused: No data collection, no tracking, no accounts required.

Perfect for students, professionals, and anyone who appreciates beautiful design.
```

**Keywords** (100 characters max):
```
calculator,tip,split,bill,discount,converter,glass,theme,widget,siri
```

**Support URL**: `https://laclairtech.com/support/prismcalc`
**Marketing URL**: (optional)

**Version**: `1.0.0`
**Copyright**: `2025 LaClair Tech`

### 5.2 App Review Information

**Contact Information:**
- First Name: [Your first name]
- Last Name: [Your last name]
- Phone: [Your phone]
- Email: [Your email]

**Notes:**
```
PrismCalc is a premium calculator app with a freemium model:

FREE TIER:
- Basic calculator
- Aurora theme

PRO TIER ($2.99 one-time purchase):
- All calculator types (tip, discount, split, converter)
- All themes
- History with lock/unlock entries

To test Pro features without purchase:
1. The IAP product "PrismCalc Pro" should be approved alongside the app
2. Pro features can be tested via TestFlight sandbox accounts

No special configuration needed. The app works immediately after installation.
```

**Demo Account**: Not needed (app works without login)

### 5.3 Version Release
- **Manually release this version**: YES (so you control when it goes live)
- This means after approval, YOU choose when to publish

---

## Phase 6: Final Review Before Submission

### Checklist Before Submitting:

App Store Connect:
- [ ] App record created
- [ ] Bundle IDs registered
- [ ] App Groups configured
- [ ] IAP product created (but not submitted yet)
- [ ] All 10 screenshots uploaded
- [ ] Description and metadata complete
- [ ] Build uploaded and processed
- [ ] Build selected for version 1.0.0

TestFlight:
- [ ] Build available in TestFlight
- [ ] Tested on real device
- [ ] All features working correctly
- [ ] IAP purchase flow tested (sandbox)

**STOP HERE - Don't submit for review yet!**

---

## Phase 7: When Ready to Submit

**Only do this when you're completely ready:**

1. In App Store Connect → Your App → iOS App
2. Click "Add for Review" on the IAP product
3. Click "Submit for Review" on the app version
4. Review will typically take 1-3 days
5. You'll get email notifications for status updates

---

## Testing in TestFlight (Recommended Before Submission)

### Internal Testing:
1. In App Store Connect → TestFlight → Internal Testing
2. Add your Apple ID as internal tester
3. Install TestFlight app on iPhone
4. Install PrismCalc from TestFlight
5. Test all features thoroughly

### Sandbox IAP Testing:
1. Settings → App Store → Sandbox Account
2. Create test account at appstoreconnect.apple.com
3. Sign in with sandbox account
4. Test IAP purchase flow
5. Verify all Pro features unlock

---

## Current Status

✅ **Complete:**
- Code implementation
- All 10 App Store screenshots
- Metadata documentation
- IAP configuration
- StoreKit testing configuration

📋 **Next Steps** (do at your pace):
1. Phase 1: Register Bundle IDs and App Groups
2. Phase 2: Create App Store Connect record
3. Phase 3: Set up IAP product
4. Phase 4: Archive and upload build
5. Phase 5: Add metadata and screenshots
6. Phase 6: Test in TestFlight
7. Phase 7: Submit when ready

---

## Files Reference

- **Screenshots**: `./screenshots/iphone67_*.png` (10 files)
- **Metadata**: `docs/appstore/metadata.md`
- **IAP Testing**: `docs/IAP_TESTING_GUIDE.md`
- **StoreKit Config**: `App/Configuration.storekit`
- **This Guide**: `APPSTORE_SETUP_GUIDE.md`

---

**Remember**: You're in complete control. Take your time with each phase, test thoroughly in TestFlight, and only submit for review when you're 100% confident everything is perfect!
