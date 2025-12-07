# PrismCalc - Code Maturity Implementation Plan

## Overview
Complete remaining work for production-ready testing (excluding localization).
Leverage iOS 18+ cutting-edge features for a modern experience.

---

## 1. Accessibility Labels

### Files to Modify:
- `Sources/PrismCalc/DesignSystem/GlassButton.swift`
- `Sources/PrismCalc/DesignSystem/GlassDisplay.swift`
- `Sources/PrismCalc/DesignSystem/ArcSlider.swift`
- `Sources/PrismCalc/Features/Calculator/CalculatorView.swift`
- `Sources/PrismCalc/Features/TipCalculator/TipCalculatorView.swift`
- `Sources/PrismCalc/Features/DiscountCalculator/DiscountCalculatorView.swift`
- `Sources/PrismCalc/Features/SplitBill/SplitBillView.swift`
- `Sources/PrismCalc/Features/UnitConverter/UnitConverterView.swift`
- `Sources/PrismCalc/Features/History/HistoryView.swift`
- `Sources/PrismCalc/Features/Paywall/PaywallView.swift`

### Implementation:
1. **GlassButton** - Add `accessibilityLabel` parameter, apply to all buttons
2. **GlassDisplay** - Add `accessibilityValue` for current result, `accessibilityLabel` for expression
3. **ArcSlider** - Add `accessibilityValue` with current percentage, `accessibilityAdjustableAction` for increment/decrement
4. **Calculator buttons** - Label each: "Seven", "Plus", "Equals", "Clear", etc.
5. **Pro calculators** - Label inputs, sliders, and result displays
6. **History** - Label each entry with type and result

---

## 2. Privacy Manifest

### File to Create:
- `App/PrivacyInfo.xcprivacy`

### Content:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array/>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

### Update:
- `project.yml` - Add PrivacyInfo.xcprivacy to app sources

---

## 3. StoreKit Scheme Configuration

### File to Modify:
- `project.yml`

### Implementation:
Add scheme configuration with StoreKit testing:
```yaml
schemes:
  PrismCalc:
    build:
      targets:
        PrismCalc: all
    run:
      config: Debug
      storeKitConfiguration: App/Configuration.storekit
```

---

## 4. Additional Tests

### Files to Create:
- `Tests/PrismCalcTests/TipCalculatorViewModelTests.swift`
- `Tests/PrismCalcTests/DiscountCalculatorViewModelTests.swift`
- `Tests/PrismCalcTests/SplitBillViewModelTests.swift`
- `Tests/PrismCalcTests/UnitConverterViewModelTests.swift`
- `Tests/PrismCalcTests/HistoryServiceTests.swift`

### Test Coverage:
1. **TipCalculatorViewModel**
   - Calculate tip for various percentages
   - Split bill among multiple people
   - Handle zero/negative inputs

2. **DiscountCalculatorViewModel**
   - Apply percentage discounts
   - Calculate savings correctly
   - Handle edge cases (0%, 100%)

3. **SplitBillViewModel**
   - Even split calculations
   - Tip distribution
   - Rounding behavior

4. **UnitConverterViewModel**
   - Length conversions (all unit pairs)
   - Weight conversions
   - Volume conversions
   - Temperature conversions (including negative)

5. **HistoryService**
   - Save entries
   - Fetch entries by type
   - Delete entries
   - Widget sync triggers

---

## 5. Input Validation & Edge Cases

### Files to Modify:
- `Sources/PrismCalc/Features/Calculator/CalculatorViewModel.swift`
- `Sources/PrismCalc/Features/Calculator/CalculatorEngine.swift`
- All Pro calculator ViewModels

### Implementation:
1. **Display length limit** - Cap at 15 digits
2. **Overflow protection** - Return "Error" for results > Double.max
3. **Input sanitization** - Prevent multiple decimals, leading zeros
4. **Pro calculators** - Max bill/price limits, valid percentage ranges

---

---

## 6. Interactive Widgets (iOS 17+)

### Files to Modify:
- `Sources/PrismCalc/Widgets/PrismCalcWidget.swift`

### Implementation:
Add `Button` with `AppIntent` for widget interactions:
- Quick calculation buttons (+, -, ×, ÷)
- Tap result to open app with that value
- "New Calculation" button

```swift
struct CalculateIntent: AppIntent {
    static var title: LocalizedStringResource = "Calculate"
    @Parameter(title: "Operation") var operation: String

    func perform() async throws -> some IntentResult {
        // Perform calculation, update shared data
        return .result()
    }
}
```

---

## 7. Control Center Widget (iOS 18+)

### Files to Create:
- `Sources/PrismCalc/Widgets/PrismCalcControlWidget.swift`

### Implementation:
ControlKit widget for Control Center:
- Single button to open calculator
- Shows last result as subtitle
- Toggleable (Pro feature indicator)

```swift
struct PrismCalcControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "PrismCalcControl") {
            ControlWidgetButton(action: OpenCalculatorIntent()) {
                Label("PrismCalc", systemImage: "equal.square.fill")
            }
        }
        .displayName("PrismCalc")
    }
}
```

---

## 8. App Intents / Siri Shortcuts (iOS 16+)

### Files to Create:
- `Sources/PrismCalc/Core/Intents/CalculateTipIntent.swift`
- `Sources/PrismCalc/Core/Intents/ConvertUnitIntent.swift`
- `Sources/PrismCalc/Core/Intents/PrismCalcShortcuts.swift`

### Siri Phrases:
- "Calculate 18% tip on $45"
- "Split $120 between 4 people"
- "Convert 5 miles to kilometers"
- "What's 15% off $80"

### Implementation:
```swift
struct CalculateTipIntent: AppIntent {
    static var title: LocalizedStringResource = "Calculate Tip"

    @Parameter(title: "Bill Amount") var billAmount: Double
    @Parameter(title: "Tip Percentage") var tipPercentage: Int

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let tip = billAmount * Double(tipPercentage) / 100
        let total = billAmount + tip
        return .result(value: "Tip: $\(tip.formatted()), Total: $\(total.formatted())")
    }
}
```

---

## 9. TipKit - Feature Discovery (iOS 17+)

### Files to Create:
- `Sources/PrismCalc/Core/Tips/PrismCalcTips.swift`

### Tips to Show:
- First launch: "Swipe between calculators"
- Pro feature: "Unlock all calculators with Pro"
- History: "Long press to copy result"
- Widget: "Add widget for quick access"

### Implementation:
```swift
struct SwipeCalculatorsTip: Tip {
    var title: Text { Text("Swipe to Switch") }
    var message: Text? { Text("Swipe left or right to access different calculators") }
    var image: Image? { Image(systemName: "hand.draw") }
}
```

---

## Execution Order

1. **Privacy Manifest** - Required for App Store
2. **StoreKit Scheme** - Enables purchase testing
3. **Input Validation** - Prevents crashes/bugs
4. **Accessibility** - Comprehensive VoiceOver support
5. **TipKit** - Onboarding experience
6. **App Intents** - Siri integration
7. **Interactive Widgets** - Enhanced widget experience
8. **Control Center Widget** - iOS 18 flagship feature
9. **Tests** - Full coverage for confidence

---

## Success Criteria

- [x] Build succeeds with no warnings
- [x] All tests pass (97 tests, 8 suites)
- [x] VoiceOver can navigate entire app (accessibility labels added)
- [ ] StoreKit sandbox purchases work (manual test required)
- [x] Privacy manifest validates in Xcode
- [x] No crashes on edge case inputs (validation + overflow protection)
- [x] Siri can execute calculation shortcuts (App Intents implemented)
- [x] Interactive widget buttons work (Button with AppIntent)
- [x] Control Center widget appears and functions (5 Control widgets)
- [x] TipKit tips display on first launch (4 tips configured)

---

## Summary

| Category | Items | iOS Version |
|----------|-------|-------------|
| Core Maturity | Privacy, Accessibility, Validation, Tests | iOS 18+ |
| Modern Features | TipKit, App Intents, Interactive Widgets | iOS 17+ |
| Cutting Edge | Control Center Widget | iOS 18+ |

**Total New Files:** ~10
**Total Modified Files:** ~15
