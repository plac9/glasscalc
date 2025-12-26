# PrismCalc App Store Preparation - Execution Checklist

**Purpose**: Prepare PrismCalc for App Store submission WITHOUT submitting for review
**Status**: Ready to execute
**Date**: 2025-12-07

---

## ✅ Pre-Execution Verification

- [x] Project builds successfully
- [x] App Groups entitlements configured
- [x] 10 App Store screenshots captured
- [x] Metadata documentation complete
- [x] StoreKit configuration in place
- [x] UI tests automated for screenshots

---

## Phase 1: Apple Developer Portal Setup

### Step 1.1: Register Main App Bundle ID
**Time estimate**: 3-5 minutes
**URL**: https://developer.apple.com/account/resources/identifiers

**Instructions**:
1. [ ] Sign in to Apple Developer Portal
2. [ ] Click "Identifiers" in left sidebar
3. [ ] Click "+" button (top left)
4. [ ] Select "App IDs" → Continue
5. [ ] Select "App" → Continue
6. [ ] Fill in details:
   - **Description**: `PrismCalc`
   - **Bundle ID**: Select "Explicit"
   - **Bundle ID**: `com.laclairtech.prismcalc`
7. [ ] Enable capabilities:
   - ✅ In-App Purchase
   - ✅ App Groups
   - ✅ Siri
8. [ ] Click Continue → Register

**Verification**: Bundle ID `com.laclairtech.prismcalc` appears in Identifiers list

---

### Step 1.2: Register Widget Bundle ID
**Time estimate**: 2-3 minutes
**URL**: https://developer.apple.com/account/resources/identifiers

**Instructions**:
1. [ ] Click "+" button (top left)
2. [ ] Select "App IDs" → Continue
3. [ ] Select "App" → Continue
4. [ ] Fill in details:
   - **Description**: `PrismCalc Widget`
   - **Bundle ID**: Select "Explicit"
   - **Bundle ID**: `com.laclairtech.prismcalc.widget`
5. [ ] Enable capabilities:
   - ✅ App Groups
6. [ ] Click Continue → Register

**Verification**: Bundle ID `com.laclairtech.prismcalc.widget` appears in Identifiers list

---

### Step 1.3: Create App Group
**Time estimate**: 2-3 minutes
**URL**: https://developer.apple.com/account/resources/identifiers

**Instructions**:
1. [ ] Click "+" button (top left)
2. [ ] Select "App Groups" → Continue
3. [ ] Fill in details:
   - **Description**: `PrismCalc Shared Data`
   - **Identifier**: `group.com.laclairtech.prismcalc.shared`
4. [ ] Click Continue → Register

**Verification**: App Group `group.com.laclairtech.prismcalc.shared` appears in Identifiers list

---

### Step 1.4: Link App Group to Main App Bundle ID
**Time estimate**: 2 minutes
**URL**: https://developer.apple.com/account/resources/identifiers

**Instructions**:
1. [ ] Click on `com.laclairtech.prismcalc` in Identifiers list
2. [ ] Click "Edit" (top right)
3. [ ] Find "App Groups" in capabilities list
4. [ ] Click "Configure"
5. [ ] Check ✅ `group.com.laclairtech.prismcalc.shared`
6. [ ] Click Continue → Save

**Verification**: `com.laclairtech.prismcalc` shows App Groups enabled with 1 group

---

### Step 1.5: Link App Group to Widget Bundle ID
**Time estimate**: 2 minutes
**URL**: https://developer.apple.com/account/resources/identifiers

**Instructions**:
1. [ ] Click on `com.laclairtech.prismcalc.widget` in Identifiers list
2. [ ] Click "Edit" (top right)
3. [ ] Find "App Groups" in capabilities list
4. [ ] Click "Configure"
5. [ ] Check ✅ `group.com.laclairtech.prismcalc.shared`
6. [ ] Click Continue → Save

**Verification**: `com.laclairtech.prismcalc.widget` shows App Groups enabled with 1 group

---

## Phase 2: App Store Connect Setup

### Step 2.1: Create App Record
**Time estimate**: 5 minutes
**URL**: https://appstoreconnect.apple.com

**Instructions**:
1. [ ] Sign in to App Store Connect
2. [ ] Click "My Apps"
3. [ ] Click "+" button → "New App"
4. [ ] Fill in details:
   - **Platform**: iOS
   - **Name**: `PrismCalc`
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select `com.laclairtech.prismcalc`
   - **SKU**: `prismcalc-ios`
   - **User Access**: Full Access
5. [ ] Click "Create"

**Verification**: PrismCalc app appears in "My Apps" list

---

### Step 2.2: Configure App Information
**Time estimate**: 5-7 minutes
**URL**: https://appstoreconnect.apple.com → Your App → App Information

**Instructions**:

**Category**:
1. [ ] Click on app in "My Apps"
2. [ ] Click "App Information" in left sidebar
3. [ ] Scroll to "Category" section
4. [ ] Set:
   - **Primary Category**: Utilities
   - **Secondary Category**: Finance
5. [ ] Click "Save"

**Age Rating**:
1. [ ] Scroll to "Age Rating" section
2. [ ] Click "Edit"
3. [ ] Answer all questions (should result in 4+):
   - No to all content questions
4. [ ] Click "Done"

**App Privacy**:
1. [ ] Scroll to "Privacy Policy URL"
2. [ ] Set **Privacy Policy URL**: `https://laclairtech.com/privacy`
3. [ ] Set **Support URL**: `https://laclairtech.com/support/prismcalc`
4. [ ] Leave **Marketing URL** blank
5. [ ] Click "Save"

**Verification**: Category shows "Utilities/Finance", Age Rating shows "4+", URLs saved

---

## Phase 3: In-App Purchase Setup

### Step 3.1: Create IAP Product
**Time estimate**: 8-10 minutes
**URL**: https://appstoreconnect.apple.com → Your App → In-App Purchases

**Instructions**:
1. [ ] In your app, click "In-App Purchases" in left sidebar
2. [ ] Click "+" or "Manage"
3. [ ] Select **Type**: Non-Consumable
4. [ ] Click "Create"
5. [ ] Fill in **Reference Name**: `PrismCalc Pro`
6. [ ] Fill in **Product ID**: `com.laclairtech.prismcalc.pro`

**Pricing**:
1. [ ] Click "Add Pricing"
2. [ ] Select **Price**: Tier 5 ($2.99 USD)
3. [ ] Select **Availability**: All territories
4. [ ] Click "Next" → "Add"

**Localization**:
1. [ ] Click "Add Localization"
2. [ ] Select **Language**: English (U.S.)
3. [ ] Fill in:
   - **Display Name**: `PrismCalc Pro`
   - **Description**: `Unlock all calculators, themes, and features`
4. [ ] Click "Save"

**Review Information**:
1. [ ] Scroll to "Review Information"
2. [ ] Click "Choose File" for screenshot
3. [ ] Upload: `screenshots/iphone67_05.png` (Tip Calculator Pro screenshot)
4. [ ] Fill in **Review Notes**: `Pro tier unlocks all calculator types (tip, discount, split bill, unit converter), all theme options, and history with lock/unlock entries`
5. [ ] Click "Save" (at top)

**Status**: Leave as "Ready to Submit" but DON'T submit yet

**Verification**: IAP product shows "Ready to Submit" status with $2.99 price

---

## Phase 4: Archive & Upload Build

### Step 4.1: Archive in Xcode
**Time estimate**: 3-5 minutes (plus build time ~2-3 minutes)
**Location**: Xcode on your Mac

**Instructions**:
1. [ ] Open `PrismCalc.xcodeproj` in Xcode
2. [ ] Select scheme: "PrismCalc" (top toolbar)
3. [ ] Select destination: "Any iOS Device (arm64)" (top toolbar)
4. [ ] Menu: Product → Archive
5. [ ] Wait for archive to complete (~2-3 minutes)
6. [ ] Organizer window should open automatically

**Verification**: Organizer shows new archive with version 1.0.0 (build 1)

---

### Step 4.2: Upload to App Store Connect
**Time estimate**: 8-12 minutes (upload + processing time)
**Location**: Xcode Organizer

**Instructions**:
1. [ ] In Organizer window, select your archive
2. [ ] Click "Distribute App" (right side)
3. [ ] Select "App Store Connect" → Next
4. [ ] Select "Upload" → Next
5. [ ] Distribution options:
   - ⬜ Include bitcode for iOS content: NO (not needed for iOS 16+)
   - ✅ Upload your app's symbols to receive crash reports: YES
   - ✅ Manage Version and Build Number: Automatically manage
6. [ ] Click Next
7. [ ] Review signing info → Next
8. [ ] Click "Upload"
9. [ ] Wait for upload (~5-10 minutes depending on connection)

**Verification**: Success message appears in Organizer

---

### Step 4.3: Verify Build in App Store Connect
**Time estimate**: 15-20 minutes wait time
**URL**: https://appstoreconnect.apple.com → Your App → TestFlight

**Instructions**:
1. [ ] Go to App Store Connect
2. [ ] Click on your app
3. [ ] Click "TestFlight" in top tabs
4. [ ] Wait for build to appear (~10-15 minutes after upload)
5. [ ] Build status will show:
   - First: "Processing" (~10 minutes)
   - Then: "Ready to Submit"

**Verification**: Build 1.0.0 (1) shows "Ready to Submit" status

---

## Phase 5: App Store Metadata

### Step 5.1: Upload Screenshots
**Time estimate**: 5-7 minutes
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Click "App Store" in top tabs
2. [ ] Click "+ VERSION OR PLATFORM" → "iOS"
3. [ ] Enter version: `1.0.0`
4. [ ] Scroll to "App Previews and Screenshots"
5. [ ] Select "iPhone 6.7" Display" tab
6. [ ] Drag and drop all 10 screenshots in this order:
   - `screenshots/iphone67_01.png` (Calculator Free)
   - `screenshots/iphone67_02.png` (History Free)
   - `screenshots/iphone67_03.png` (Paywall Tip)
   - `screenshots/iphone67_04.png` (Themes Free)
   - `screenshots/iphone67_05.png` (Tip Pro)
   - `screenshots/iphone67_06.png` (Discount Pro)
   - `screenshots/iphone67_07.png` (Split Bill Pro)
   - `screenshots/iphone67_08.png` (Unit Converter Pro)
   - `screenshots/iphone67_09.png` (History Pro)
   - `screenshots/iphone67_10.png` (Calculator Result Pro)
7. [ ] Wait for all to upload and process

**Verification**: All 10 screenshots appear in correct order

---

### Step 5.2: Add App Description
**Time estimate**: 3-5 minutes
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "Description" field
2. [ ] Copy from `docs/appstore/metadata.md` or paste:

```
PrismCalc brings a spectacular glassmorphic design to your everyday calculations. More than just a calculator – it's a beautiful, functional tool you'll love using.

✨ FREE FEATURES
• Stunning glassmorphic design
• Aurora theme included
• iOS 18+ optimized with smooth animations
• Liquid Glass on iOS 26+ with layered material fallback on iOS 18

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
• Apple Watch companion app + complications

DESIGNED FOR iOS 18+ (Liquid Glass on iOS 26+)
• Native floating tab bar
• Smooth zoom transitions
• Haptic feedback
• Dark mode optimized

Privacy focused: No data collection, no tracking, no accounts required.

Perfect for students, professionals, and anyone who appreciates beautiful design.
```

3. [ ] Click outside field to save

**Verification**: Description text saved (auto-saves on blur)

---

### Step 5.3: Add Keywords
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "Keywords" field
2. [ ] Paste (exactly 100 characters):
```
calculator,tip,split,bill,discount,converter,glass,theme,widget,siri,watch
```
3. [ ] Click outside field to save

**Verification**: Keywords show 100/100 characters used

---

### Step 5.4: Add Support & Marketing URLs
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "Support URL"
2. [ ] Enter: `https://laclairtech.com/support/prismcalc`
3. [ ] Leave "Marketing URL" blank
4. [ ] Click outside fields to save

**Verification**: Support URL saved

---

### Step 5.5: Set Promotional Text (Optional)
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "Promotional Text" (can be updated without review)
2. [ ] Paste:
```
Experience the most beautiful calculator on iOS. Stunning glassmorphic design meets powerful functionality.
```
3. [ ] Click outside field to save

**Verification**: Promotional text saved

---

### Step 5.6: Set Version Information
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "Version" field
2. [ ] Confirm: `1.0.0`
3. [ ] Scroll to "Copyright" field
4. [ ] Enter: `2025 LaClair Tech`
5. [ ] Click outside field to save

**Verification**: Version 1.0.0, Copyright 2025 LaClair Tech

---

### Step 5.7: Add App Review Information
**Time estimate**: 3-5 minutes
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "App Review Information" section
2. [ ] Fill in **Contact Information**:
   - **First Name**: [Your first name]
   - **Last Name**: [Your last name]
   - **Phone**: [Your phone with country code]
   - **Email**: [Your email]
3. [ ] Fill in **Notes**:
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
4. [ ] Leave "Demo Account" section blank (not needed)
5. [ ] Click outside fields to save

**Verification**: Contact info and notes saved

---

### Step 5.8: Set Version Release Option
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "Version Release" section
2. [ ] Select: ⚫ **Manually release this version**
3. [ ] This lets YOU control when the app goes live after approval

**Verification**: "Manually release this version" selected

---

### Step 5.9: Select Build
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to "Build" section
2. [ ] Click "Select a build before you submit your app"
3. [ ] Select build: `1.0.0 (1)`
4. [ ] Click "Done"

**Verification**: Build 1.0.0 (1) selected and shows in Build section

---

### Step 5.10: Save All Changes
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store → iOS App

**Instructions**:
1. [ ] Scroll to top of page
2. [ ] Click "Save" button (top right)
3. [ ] Wait for save confirmation

**Verification**: "Saved" message appears, no validation errors

---

## Phase 6: TestFlight Setup

### Step 6.1: Enable Internal Testing
**Time estimate**: 3-5 minutes
**URL**: https://appstoreconnect.apple.com → Your App → TestFlight

**Instructions**:
1. [ ] Click "TestFlight" tab
2. [ ] Under "Internal Testing", click on "App Store Connect Users"
3. [ ] Click "+" to add testers
4. [ ] Select your Apple ID email
5. [ ] Click "Add"
6. [ ] Check email for TestFlight invitation

**Verification**: You appear in Internal Testers list

---

### Step 6.2: Install TestFlight on iPhone
**Time estimate**: 2-3 minutes
**Location**: iPhone App Store

**Instructions**:
1. [ ] Open App Store on iPhone
2. [ ] Search for "TestFlight"
3. [ ] Install TestFlight app (by Apple)
4. [ ] Open TestFlight app
5. [ ] Sign in with same Apple ID

**Verification**: TestFlight app installed and signed in

---

### Step 6.3: Accept TestFlight Invite
**Time estimate**: 2 minutes
**Location**: Email → TestFlight app on iPhone

**Instructions**:
1. [ ] Check email for TestFlight invitation
2. [ ] Click "View in TestFlight" in email
3. [ ] Or: Open TestFlight app, tap "Redeem"
4. [ ] PrismCalc should appear
5. [ ] Tap "Install"
6. [ ] Wait for installation

**Verification**: PrismCalc installed via TestFlight

---

### Step 6.4: Test Basic Features
**Time estimate**: 5-10 minutes
**Location**: iPhone - PrismCalc app

**Instructions**:
1. [ ] Open PrismCalc from TestFlight
2. [ ] Test Calculator: Enter some calculations
3. [ ] Test History: Verify paywall appears for free tier
4. [ ] Test Theme: Go to Settings, verify Aurora theme unlocked
5. [ ] Test Paywall: Tap "Tip" tab, verify paywall shows
6. [ ] Test Widget: Add widget to home screen
7. [ ] Check for crashes or obvious bugs

**Verification**: All basic features work, paywall appears for Pro features

---

### Step 6.5: Test IAP Purchase (Sandbox)
**Time estimate**: 5-7 minutes
**Location**: iPhone Settings → App Store

**Prerequisites**: Create sandbox tester account first:
- Go to https://appstoreconnect.apple.com → Users and Access → Sandbox Testers
- Click "+" to create sandbox tester
- Use a fake email (e.g., test@example.com) with your password

**Instructions**:
1. [ ] On iPhone: Settings → App Store
2. [ ] Scroll down to "Sandbox Account"
3. [ ] Sign in with sandbox tester account
4. [ ] Open PrismCalc
5. [ ] Tap "Tip" tab → "Upgrade to Pro"
6. [ ] Purchase should show $2.99
7. [ ] Complete purchase (won't charge real money)
8. [ ] Verify all Pro features unlock:
   - [ ] Tip Calculator accessible
   - [ ] Discount Calculator accessible
   - [ ] Split Bill accessible
   - [ ] Unit Converter accessible
   - [ ] All themes unlocked in Settings
  - [ ] History accessible with lock/unlock entries

**Verification**: Purchase completes successfully, all Pro features work

---

## 🛑 STOP HERE - DO NOT SUBMIT FOR REVIEW YET

**What you've completed**:
- ✅ All Bundle IDs and App Groups registered
- ✅ App Store Connect app record created
- ✅ IAP product configured and ready
- ✅ Build uploaded and processed
- ✅ All metadata and screenshots uploaded
- ✅ TestFlight testing complete
- ✅ IAP purchase flow verified

**What's NOT done** (intentionally):
- ❌ App submission for review
- ❌ IAP submission for review

**Next steps when you're ready**:
1. Review everything one more time
2. Test thoroughly in TestFlight
3. When completely confident, proceed to Phase 7

---

## Phase 7: Final Submission (DO THIS WHEN READY)

### ⚠️ WARNING: This submits for Apple review ⚠️

**Only proceed when you are 100% confident and ready!**

### Step 7.1: Submit IAP for Review
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → In-App Purchases

**Instructions**:
1. [ ] Click on IAP product `PrismCalc Pro`
2. [ ] Review all information one final time
3. [ ] Click "Submit for Review" button
4. [ ] Confirm submission

**Verification**: IAP status changes to "Waiting for Review"

---

### Step 7.2: Submit App for Review
**Time estimate**: 1 minute
**URL**: https://appstoreconnect.apple.com → Your App → App Store

**Instructions**:
1. [ ] Go to App Store tab
2. [ ] Click on version 1.0.0
3. [ ] Review all information one final time
4. [ ] Click "Add for Review" (if shown)
5. [ ] Click "Submit for Review" button
6. [ ] Confirm submission

**Verification**: App status changes to "Waiting for Review"

---

### Step 7.3: Monitor Review Status
**Time estimate**: 1-3 days typical review time
**URL**: https://appstoreconnect.apple.com

**What to expect**:
- Email notifications for status changes
- Typical statuses:
  1. "Waiting for Review" (can take 1-2 days)
  2. "In Review" (usually 1-12 hours)
  3. "Pending Developer Release" (approved, waiting for you to publish)
  4. OR "Rejected" (with feedback to address)

**If approved**:
1. [ ] You'll get email: "Ready for Sale" or "Pending Developer Release"
2. [ ] If "Pending Developer Release": Click "Release This Version" when ready
3. [ ] App goes live on App Store within 1-2 hours

**If rejected**:
1. [ ] Read rejection feedback carefully
2. [ ] Address issues in code/metadata
3. [ ] Upload new build or update metadata
4. [ ] Resubmit

---

## Summary

**Total time to complete Phases 1-6**: ~2-3 hours (spread across multiple days due to build processing)

**Phase 7 (when ready)**: 5 minutes to submit + 1-3 days Apple review time

**You are in control**: Everything is prepared, but YOU decide when to submit for review!

**Files ready for reference**:
- This checklist: `EXECUTION_CHECKLIST.md`
- Setup guide: `APPSTORE_SETUP_GUIDE.md`
- Screenshots: `screenshots/iphone67_*.png`
- Metadata: `docs/appstore/metadata.md`
- IAP testing: `docs/IAP_TESTING_GUIDE.md`
