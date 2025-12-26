# prismCalc - App Store Connect Setup Guide

Complete step-by-step guide for setting up prismCalc in App Store Connect.

---

## Prerequisites

- ✅ Apple Developer Account (paid $99/year membership)
- ✅ App built and tested locally
- ✅ Screenshots ready (will generate after setup)
- ✅ App metadata prepared (`docs/appstore/metadata.md`)

---

## Step 1: Create App Record

### 1.1 Access App Store Connect
1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Sign in with your Apple ID
3. Click **"My Apps"**
4. Click **"+"** → **"New App"**

### 1.2 App Information
Fill out the new app form:

| Field | Value |
|-------|-------|
| **Platform** | iOS |
| **Name** | prismCalc |
| **Primary Language** | English (U.S.) |
| **Bundle ID** | `com.laclairtech.prismcalc` |
| **SKU** | `prismcalc-ios` (unique identifier) |
| **User Access** | Full Access |

⚠️ **Important**: Bundle ID must match what's in Xcode project!

---

## Step 2: Register Bundle ID (if not already done)

### 2.1 Create App ID in Developer Portal
1. Go to [developer.apple.com/account](https://developer.apple.com/account)
2. **Certificates, Identifiers & Profiles** → **Identifiers**
3. Click **"+"** to register new identifier
4. Select **"App IDs"** → Continue

### 2.2 Configure App ID
| Field | Value |
|-------|-------|
| **Description** | prismCalc - Glassmorphic Calculator |
| **Bundle ID** | Explicit: `com.laclairtech.prismcalc` |
| **Capabilities** | • In-App Purchase ✓<br>• App Groups ✓ (for widget)<br>• Siri ✓ |

### 2.3 App Group (for Widget)
1. **Identifiers** → **"+"** → **App Groups**
2. **Description**: prismCalc Shared Data
3. **Identifier**: `group.com.laclairtech.prismcalc.shared`
4. Click **Continue** → **Register**

### 2.4 Widget Extension Bundle ID
Repeat for widget extension:
- **Bundle ID**: `com.laclairtech.prismcalc.widget`
- **Capabilities**: App Groups ✓

---

## Step 3: App Information

Back in App Store Connect, fill out app details:

### 3.1 General Information
- **Subtitle**: Glassmorphic Calculator
- **Privacy Policy URL**: `https://laclairtech.com/privacy`
- **Category**:
  - Primary: **Utilities**
  - Secondary: **Finance**
- **Content Rights**: Yes (you own all rights)

### 3.2 Age Rating
Click **"Edit"** next to Age Rating:
- All questions: **No**
- **Result**: 4+

### 3.3 Pricing and Availability
- **Price**: Free
- **Availability**: All territories
- **Pre-order**: Not available (for 1.0)

---

## Step 4: In-App Purchases

### 4.1 Create IAP Product
1. In your app page, go to **"In-App Purchases"** tab
2. Click **"+"** (or "Create")
3. Select **"Non-Consumable"**

### 4.2 Reference Information
| Field | Value |
|-------|-------|
| **Reference Name** | prismCalc Pro |
| **Product ID** | `com.laclairtech.prismcalc.pro` |

⚠️ **Must match** StoreKit config and code!

### 4.3 Pricing
1. Click **"Add Pricing"**
2. **Base Country**: United States
3. **Price**: $2.99 (Tier 5)
4. Click **"Next"** → **"Create"**

### 4.4 Localization (English - U.S.)
| Field | Value |
|-------|-------|
| **Display Name** | prismCalc Pro |
| **Description** | Unlock all calculators, themes, and features |

### 4.5 Review Information
- **Screenshot**: Upload any screenshot showing Pro features
- **Review Notes**: "Test with StoreKit sandbox. All features unlock after purchase."

### 4.6 Submit for Review
Click **"Submit for Review"** on the IAP (separate from app review)

---

## Step 5: App Metadata

### 5.1 App Information
Fill from `docs/appstore/metadata.md`:

**App Name**: prismCalc

**Subtitle** (30 chars max):
```
Glassmorphic Calculator
```

**Promotional Text** (170 chars - can be updated anytime):
```
Beautiful calculator with iOS 18+ glassmorphism (Liquid Glass on iOS 26+), tip splitting, discounts, unit conversion, and 6 stunning themes. Pro tools for everyday math.
```

### 5.2 Description
Copy from `docs/appstore/metadata.md` → Full Description section

Key points to include:
- Core calculator features
- Pro features (Tip, Discount, Split, Convert)
- Design highlights (6 themes, iOS 18+ glassmorphism, Liquid Glass on iOS 26+)
- Widgets & Siri
- Accessibility

**Character count**: ~2000/4000 (leave room for updates)

### 5.3 Keywords (100 chars max)
```
calculator,tip,split,bill,discount,converter,glass,theme,widget,siri
```

### 5.4 Support URL
```
https://laclairtech.com/support/prismcalc
```

### 5.5 Marketing URL (optional)
```
https://laclairtech.com/prismcalc
```

---

## Step 6: Screenshots & Preview

### 6.1 Required Screenshot Sizes

**iPhone** (required):
- 6.9" Display (iPhone 17 Pro Max): 1320 x 2868
- 6.7" Display (iPhone 15 Pro Max): 1290 x 2796

**iPad** (optional but recommended):
- 12.9" Display (iPad Pro): 2048 x 2732

### 6.2 Upload Screenshots
1. **Prepare Screenshots**: Use automated script (see below)
2. **Upload**: Drag & drop into App Store Connect
3. **Order**: Rearrange to showcase best features first
4. **Captions**: Optional but recommended

**Recommended Order**:
1. Calculator (hero shot)
2. Tip Calculator
3. Themes
4. History
5. Widgets

---

## Step 7: App Review Information

### 7.1 Contact Information
- **First Name**: Patrick
- **Last Name**: LaClair
- **Phone**: Your phone number
- **Email**: Your email

### 7.2 Demo Account (if needed)
Not needed for prismCalc (no login required)

### 7.3 Notes for Reviewer
```
prismCalc is a calculator app with freemium model:

FREE TIER:
- Basic calculator
- Aurora theme

PRO TIER ($2.99):
- Tip calculator with bill splitting
- Discount calculator
- Unit converter
- History with lock/unlock entries
- All 6 themes

TESTING IAP:
The Pro upgrade can be tested using the sandbox environment.
All features unlock immediately after purchase.

No login required. All data stored locally on device.
```

### 7.4 Version Release
- **Automatic Release**: Recommended for 1.0
- **Manual Release**: Use if coordinating with marketing

---

## Step 8: Build Upload

### 8.1 Archive Build in Xcode
```bash
# Open project
open ~/dev/ios/prismcalc/PrismCalc.xcodeproj

# Or via command line:
xcodebuild archive \
  -scheme PrismCalc \
  -destination 'generic/platform=iOS' \
  -archivePath ~/Desktop/PrismCalc.xcarchive

xcodebuild -exportArchive \
  -archivePath ~/Desktop/PrismCalc.xcarchive \
  -exportPath ~/Desktop/PrismCalc-Export \
  -exportOptionsPlist ExportOptions.plist
```

### 8.2 Upload to App Store Connect
**Option A: Xcode Organizer** (Easier)
1. Xcode → Window → Organizer
2. Select archive → Click **"Distribute App"**
3. **App Store Connect** → Upload
4. Wait for processing (10-30 mins)

**Option B: Command Line**
```bash
xcrun altool --upload-app \
  -f PrismCalc.ipa \
  -t ios \
  -u your@email.com \
  -p app-specific-password
```

### 8.3 Select Build
1. Return to App Store Connect
2. **App Information** → **Build** section
3. Click **"+"** → Select uploaded build
4. Fill TestFlight info if prompted

---

## Step 9: App Privacy

### 9.1 Privacy Details
1. Go to **"App Privacy"** tab
2. Click **"Get Started"**

**Data Collection**: None

Click through all categories and select **"No, we do not collect data from this app"**

### 9.2 Privacy Policy
Required even with no data collection:
```
https://laclairtech.com/privacy
```

Create simple policy stating:
- No data collection
- All calculations local
- No tracking/analytics
- No user accounts

---

## Step 10: Submit for Review

### 10.1 Pre-Submission Checklist
- [ ] App metadata complete
- [ ] Screenshots uploaded (all required sizes)
- [ ] Build selected
- [ ] IAP submitted separately
- [ ] Privacy info filled
- [ ] Pricing set
- [ ] Review notes added
- [ ] Support URL working
- [ ] App tested on device

### 10.2 Submit
1. Go to version page (e.g., "1.0 Prepare for Submission")
2. Review all sections (must have green checkmarks)
3. Click **"Add for Review"**
4. Click **"Submit to App Store Review"**

### 10.3 Review Timeline
- **Typical**: 24-48 hours
- **First submission**: May take up to 5 days
- **Status updates**: Via email and App Store Connect

---

## Status Tracking

### App Review States
- **Waiting for Review**: In queue
- **In Review**: Being tested (usually 6-24 hrs)
- **Pending Developer Release**: Approved, waiting for manual release
- **Ready for Sale**: Live on App Store!
- **Rejected**: Review feedback provided, fix and resubmit

---

## Post-Approval

### Once Approved (Ready for Sale):
1. **Verify Live**: Check App Store listing
2. **Test Download**: Install from App Store
3. **Test IAP**: Purchase with sandbox account
4. **Monitor**: Check ratings/reviews daily
5. **Analytics**: Review in App Store Connect

---

## Troubleshooting

### Build Not Appearing
- Wait 30-60 minutes after upload
- Check email for processing errors
- Verify bundle ID matches App Store Connect

### IAP Not Available
- Ensure IAP is "Ready to Submit" status
- Must have valid paid agreements signed
- Banking/tax info must be complete

### Metadata Rejected
- Common issues: misleading screenshots, inappropriate keywords
- Fix and resubmit (usually fast-tracked)

---

## Quick Reference

**Bundle IDs**:
- App: `com.laclairtech.prismcalc`
- Widget: `com.laclairtech.prismcalc.widget`
- App Group: `group.com.laclairtech.prismcalc.shared`

**IAP**:
- Product ID: `com.laclairtech.prismcalc.pro`
- Price: $2.99

**URLs**:
- Privacy: `https://laclairtech.com/privacy`
- Support: `https://laclairtech.com/support/prismcalc`
- Marketing: `https://laclairtech.com/prismcalc`

---

## Integration with AI Assistants

### For ChatGPT 5 / Claude in Xcode Intelligence

You mentioned having AI assistants connected to Xcode. Here's how to work with them:

**Context to Share**:
```
Working on prismCalc iOS app submission.
Bundle ID: com.laclairtech.prismcalc
IAP Product: com.laclairtech.prismcalc.pro ($2.99)
Freemium model: Free calculator | Pro: all tools + history with lock/unlock entries
```

**Useful Prompts**:
- "Generate App Store description following Apple guidelines"
- "Review my screenshots for App Store compliance"
- "Help me respond to App Review feedback"
- "Optimize keywords for calculator app category"

Let me know if you need specific integration instructions!
