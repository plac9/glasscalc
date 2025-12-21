# Automated Screenshot Capture - Implementation Plan

## 🎯 Goal
Automatically capture all 10 App Store screenshots without manual intervention using XCTest UI automation.

---

## 📋 Architecture Overview

```
┌─────────────────────────────────────────────┐
│  XCTest UI Test Suite                       │
│  └─ ScreenshotTests.swift                   │
│     ├─ Navigate to each screen              │
│     ├─ Set up state (themes, data)          │
│     ├─ Capture screenshot                   │
│     └─ Export to ./screenshots/             │
└─────────────────────────────────────────────┘
              ↓ uses ↓
┌─────────────────────────────────────────────┐
│  App Launch Arguments                       │
│  ├─ SCREENSHOT_MODE: Disables animations    │
│  ├─ SIMULATE_PRO: Unlocks Pro features      │
│  ├─ PRESET_THEME: Sets specific theme       │
│  ├─ POPULATE_DATA: Adds sample history      │
│  └─ SELECT_TAB: Opens a tab on launch        │
└─────────────────────────────────────────────┘
              ↓ controls ↓
┌─────────────────────────────────────────────┐
│  PrismCalc App with Accessibility IDs       │
│  └─ All interactive elements tagged         │
│     ├─ Buttons: "calculator-button-1"       │
│     ├─ Tabs: "tab-calculator", "tab-tip"    │
│     └─ Cards: "theme-card-aurora"           │
└─────────────────────────────────────────────┘
```

---

## 🏗️ Implementation Steps

### Phase 1: Project Setup ✅ (Current)
- [x] Create UI test target structure
- [x] Add basic ScreenshotTests.swift
- [ ] Configure Xcode project scheme
- [ ] Add UI test target to build

### Phase 2: App Modifications
- [ ] Add accessibility identifiers to all UI elements
- [x] Implement launch argument handling
- [x] Create test data population system
- [x] Add screenshot mode optimizations

### Phase 3: Test Implementation
- [ ] Write navigation helpers
- [ ] Implement state setup for each screenshot
- [ ] Add screenshot capture and export
- [ ] Handle theme switching

### Phase 4: Execution
- [x] Run tests for iPhone 17 simulator (iOS 26.2)
- [ ] Run tests for iPad 12.9"
- [x] Post-process and rename screenshots (exported from xcresult)
- [x] Verify all 10 screenshots captured (see `screenshots/automated/2025-12-19-iphone-17/`)

---

## 📱 Screenshot Specifications

### Required Screenshots (10 total per device)

| # | Screen | Theme | State | Description |
|---|--------|-------|-------|-------------|
| 1 | Calculator | Aurora | Free | Hero shot with calculation |
| 2 | History | Aurora | Free | History paywall (Pro-only) |
| 3 | Paywall | Aurora | Free | Tip calculator gated |
| 4 | Settings | Aurora | Free | Themes (Aurora unlocked, others locked) |
| 5 | Tip | Blue-Green | Pro | Tip calculator with 20% on $50 |
| 6 | Discount | Forest Earth | Pro | 25% off $100 |
| 7 | Split | Calming Blues | Pro | $100 split 4 ways |
| 8 | Convert | Soft Tranquil | Pro | 10 miles → 16.09 km |
| 9 | History | Midnight | Pro | History with lock/unlock entries |
| 10 | Calculator | Aurora | Pro | Final calculation shown |

---

## 🔧 Technical Implementation

### 1. Accessibility Identifiers

**Naming Convention**: `{component}-{element}-{identifier}`

```swift
// Calculator buttons
.accessibilityIdentifier("calculator-button-1")
.accessibilityIdentifier("calculator-button-plus")

// Tab bar
.accessibilityIdentifier("tab-calculator")
.accessibilityIdentifier("tab-tip")

// Theme cards
.accessibilityIdentifier("theme-card-aurora")
.accessibilityIdentifier("theme-card-midnight")

// Action buttons
.accessibilityIdentifier("paywall-upgrade-button")
```

### 2. Launch Arguments

```swift
// In PrismCalcApp.swift
if ProcessInfo.processInfo.arguments.contains("SCREENSHOT_MODE") {
    // Disable animations
    UIView.setAnimationsEnabled(false)
}

if ProcessInfo.processInfo.arguments.contains("SIMULATE_PRO") {
    // Mock Pro purchase
    UserDefaults.standard.set(true, forKey: "debug_simulatePro")
}

if let themeArg = ProcessInfo.processInfo.arguments.first(where: { $0.hasPrefix("PRESET_THEME:") }) {
    let theme = themeArg.replacingOccurrences(of: "PRESET_THEME:", with: "")
    GlassTheme.currentTheme = GlassTheme.Theme(rawValue: theme) ?? .aurora
}

if ProcessInfo.processInfo.arguments.contains("POPULATE_DATA") {
    // Add sample history entries
    populateSampleData()
}

if let tabArg = ProcessInfo.processInfo.arguments.first(where: { $0.hasPrefix("SELECT_TAB:") }) {
    let tabName = tabArg.replacingOccurrences(of: "SELECT_TAB:", with: "")
    UserDefaults.standard.set(tabName, forKey: "debug_selectedTab")
}
```

### 3. UI Test Structure

```swift
final class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!

    // Screenshot 1: Calculator (Free)
    func testScreenshot01_Calculator() {
        setupApp(pro: false, theme: "Aurora")

        // Perform calculation
        tapCalculatorButton("1")
        tapCalculatorButton("2")
        tapCalculatorButton("3")
        tapCalculatorButton("4")

        sleep(1)
        captureScreenshot("01_Calculator")
    }

    // Screenshot 5: Tip Calculator (Pro)
    func testScreenshot05_TipCalculator() {
        setupApp(pro: true, theme: "Blue-Green Harmony")

        tapTab("Tip")

        // Set bill amount
        enterAmount("50")

        // Set tip percentage to 20%
        adjustTipSlider(to: 20)

        sleep(1)
        captureScreenshot("05_Tip_Calculator_Pro")
    }

    // Helper methods
    private func setupApp(pro: Bool, theme: String, populateData: Bool = false) {
        app = XCUIApplication()
        app.launchArguments = ["SCREENSHOT_MODE"]

        if pro {
            app.launchArguments.append("SIMULATE_PRO")
        }

        app.launchArguments.append("PRESET_THEME:\(theme)")

        if populateData {
            app.launchArguments.append("POPULATE_DATA")
        }

        app.launch()
        sleep(2)
    }

    private func captureScreenshot(_ name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
```

### 4. Running Tests

```bash
# iPhone 6.7" (iPhone 17 Pro Max)
xcodebuild test \
  -scheme PrismCalc \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  -testPlan ScreenshotTests \
  -resultBundlePath ./TestResults

# Extract screenshots
xcparse screenshots ./TestResults.xcresult ./screenshots/iphone
```

---

## 🎨 Screenshot Post-Processing

### Automated Renaming
```bash
#!/bin/bash
# Rename screenshots from test results to App Store format

mv 01_Calculator.png "screenshots/iphone67_01_calculator.png"
mv 02_History_Free.png "screenshots/iphone67_02_history.png"
# ... etc
```

### Optional: Add Device Frames
```bash
# Using fastlane frameit (optional)
fastlane frameit silver screenshots/
```

---

## 🚀 Execution Plan

### Step-by-Step Execution

**Step 1: Add Accessibility IDs** (15 mins)
- Tag all calculator buttons
- Tag all tab bar items
- Tag all theme cards
- Tag all action buttons

**Step 2: Add Launch Arguments** (10 mins)
- Implement SCREENSHOT_MODE
- Implement SIMULATE_PRO
- Implement PRESET_THEME
- Implement POPULATE_DATA

**Step 3: Write UI Tests** (30 mins)
- Create test for each screenshot
- Add navigation helpers
- Add state setup methods
- Add screenshot capture

**Step 4: Run Tests** (5 mins)
- Execute on iPhone simulator
- Execute on iPad simulator (optional)
- Verify all screenshots captured

**Step 5: Post-Process** (5 mins)
- Rename files to App Store format
- Verify dimensions
- Check quality

**Total Time**: ~65 minutes

---

## 📊 Success Criteria

- ✅ All 10 screenshots captured automatically
- ✅ Correct themes applied
- ✅ Correct Pro/Free states
- ✅ No manual intervention required
- ✅ Reproducible (can re-run anytime)
- ✅ Screenshots export to `./screenshots/`
- ✅ Proper naming convention

---

## 🔄 Alternative: Fastlane Snapshot

**If XCTest approach has issues**, consider Fastlane:

```ruby
# Fastfile
lane :screenshots do
  capture_screenshots(
    devices: [
      "iPhone 17 Pro Max",
      "iPad Pro (12.9-inch) (6th generation)"
    ],
    languages: ["en-US"],
    output_directory: "./screenshots",
    clear_previous_screenshots: true
  )
end
```

But XCTest is preferred for full control.

---

## 🎯 Next Actions

1. **[NOW]** Add accessibility identifiers to UI
2. **[NOW]** Implement launch argument handling
3. **[NOW]** Write UI test cases
4. **[NOW]** Run automated tests
5. **[THEN]** Post-process screenshots

Let's execute! 🚀
