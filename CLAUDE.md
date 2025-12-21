# CLAUDE.md - AI Assistant Guide for PrismCalc

This file provides context and conventions for AI assistants working on this codebase.

## Project Overview

**PrismCalc** is a glassmorphic calculator app for iOS featuring:
- Full glassmorphism effects using iOS 18's Liquid Glass design language
- Swift 6.0 with strict concurrency
- 100% SwiftUI with haptic feedback
- Freemium model with in-app purchases

**Key URLs:**
- Bundle ID: `com.laclairtech.prismcalc`
- Widget Bundle ID: `com.laclairtech.prismcalc.widget`
- App Group: `group.com.laclairtech.prismcalc`

## Technology Stack

| Technology | Version | Notes |
|------------|---------|-------|
| Swift | 6.0 | Strict concurrency enabled |
| iOS | 18.0+ | Required for MeshGradient |
| macOS | 15.0+ | For development |
| Xcode | 16.0+ | Required |
| SwiftUI | Latest | 100% SwiftUI |
| SwiftData | Latest | For history persistence |
| StoreKit 2 | Latest | For in-app purchases |

## Project Structure

```
PrismCalc/
├── App/                          # App entry point and configuration
│   ├── Main.swift               # @main entry point
│   ├── Info.plist               # App configuration
│   ├── Configuration.storekit   # StoreKit testing configuration
│   └── Assets.xcassets/         # App icons and colors
│
├── Sources/PrismCalc/
│   ├── App/                     # App scene and navigation
│   │   ├── PrismCalcApp.swift   # Main app configuration
│   │   └── ContentView.swift    # Root navigation view
│   │
│   ├── Features/                # Feature modules (MVVM)
│   │   ├── Calculator/          # Basic calculator
│   │   ├── TipCalculator/       # Tip + split (Pro)
│   │   ├── DiscountCalculator/  # Discount calc (Pro)
│   │   ├── SplitBill/           # Bill splitting (Pro)
│   │   ├── UnitConverter/       # Conversions (Pro)
│   │   ├── History/             # Calculation history
│   │   ├── Settings/            # App settings
│   │   └── Paywall/             # Pro upgrade UI
│   │
│   ├── DesignSystem/            # Shared UI components
│   │   ├── GlassTheme.swift     # Colors, spacing, typography
│   │   ├── GlassButton.swift    # Glassmorphic buttons
│   │   ├── GlassCard.swift      # Glass card container
│   │   ├── GlassDisplay.swift   # Calculator display
│   │   ├── ArcSlider.swift      # Circular slider
│   │   └── MeshGradientConfig.swift  # Theme gradients
│   │
│   ├── Core/                    # Shared business logic
│   │   ├── Models/              # Data models
│   │   ├── Services/            # Singleton services
│   │   ├── Extensions/          # Swift extensions
│   │   ├── Intents/             # App Intents (Siri)
│   │   └── Tips/                # TipKit configuration
│   │
│   └── Widgets/                 # Widget implementations
│
├── WidgetExtension/             # Widget extension target
├── Tests/
│   ├── PrismCalcTests/          # Unit tests
│   └── PrismCalcUITests/        # UI tests & screenshots
├── scripts/                     # Build and automation scripts
└── docs/                        # Additional documentation
```

## Architecture Patterns

### MVVM with @Observable

Each feature follows MVVM pattern:

```swift
// ViewModel pattern
@Observable
@MainActor
public final class FeatureViewModel {
    // Private backing with validation
    private var _value: String = ""
    public var value: String {
        get { _value }
        set {
            // Input validation
            _value = sanitize(newValue)
        }
    }

    // Computed results
    public var computedResult: Double {
        // Calculate from state
    }

    // Actions
    public func clear() { }
    public func save() { }
}
```

### Services (Singleton Pattern)

Services use shared singleton instances:

```swift
@MainActor
public final class SomeService {
    public static let shared = SomeService()
    private init() { }

    public func doSomething() { }
}
```

Key services:
- `HistoryService.shared` - Calculation history (SwiftData)
- `StoreKitManager.shared` - In-app purchases
- `SharedDataService.shared` - Widget data sharing

### Design System Components

All UI components use the `GlassTheme` design system:

```swift
// Colors (theme-aware)
GlassTheme.primary          // Current theme's primary color
GlassTheme.secondary        // Current theme's secondary color
GlassTheme.backgroundGradient  // Array of gradient colors

// Typography
GlassTheme.displayFont      // Large numbers
GlassTheme.titleFont        // Section titles
GlassTheme.bodyFont         // Body text
GlassTheme.monoFont         // Calculator display

// Spacing
GlassTheme.spacingSmall     // 8pt
GlassTheme.spacingMedium    // 16pt
GlassTheme.spacingLarge     // 24pt

// Corner radius
GlassTheme.cornerRadiusMedium   // 16pt
GlassTheme.cornerRadiusLarge    // 24pt

// Animation
GlassTheme.springAnimation
GlassTheme.buttonSpring
```

## Code Conventions

### Swift 6 Concurrency

All view models and services are `@MainActor`:

```swift
@Observable
@MainActor
public final class ViewModel { }
```

Mark types as `Sendable` where applicable:

```swift
public enum SomeType: String, CaseIterable, Sendable { }
```

### Input Validation

All user input should be validated in property setters:

```swift
private var _amount: String = ""
public var amount: String {
    get { _amount }
    set {
        // Filter invalid characters
        let filtered = newValue.filter { $0.isNumber || $0 == "." }
        // Limit length
        let limited = String(filtered.prefix(10))
        // Prevent multiple decimals
        _amount = preventMultipleDecimals(limited)
    }
}
```

### Computed Values with Guards

Protect against division by zero and overflow:

```swift
public var perPersonAmount: Double {
    guard numberOfPeople > 0 else { return totalAmount }
    let share = totalAmount / Double(numberOfPeople)
    return share.isFinite ? share : 0
}
```

### Accessibility

All interactive elements need accessibility labels:

```swift
Button(action: action) {
    Text(label)
}
.accessibilityLabel(accessibilityText)
.accessibilityAddTraits(.isButton)
.accessibilityIdentifier("unique-id")  // For UI tests
```

### Documentation Comments

Use triple-slash doc comments for public APIs:

```swift
/// Calculates the tip amount based on bill and percentage
///
/// - Parameters:
///   - bill: The bill amount in dollars
///   - percentage: The tip percentage (0-100)
/// - Returns: The calculated tip amount
public func calculateTip(bill: Double, percentage: Double) -> Double
```

## Testing

### Test Framework

Uses Swift Testing (not XCTest) for unit tests:

```swift
import Testing
@testable import PrismCalc

@Suite("Feature Name")
struct FeatureTests {

    @Test("Description of test")
    @MainActor
    func testSomething() {
        let viewModel = FeatureViewModel()
        viewModel.someProperty = "value"

        #expect(viewModel.result == expectedValue)
    }
}
```

### Running Tests

```bash
# Via Swift Package Manager
swift test

# Via Xcode
xcodebuild test -scheme PrismCalc -destination 'platform=iOS Simulator,name=iPhone 16'
```

### UI Testing Launch Arguments

The app supports testing launch arguments:

- `SCREENSHOT_MODE` - Disables animations for screenshots
- `SIMULATE_PRO` - Simulates Pro purchase
- `RESET_PURCHASES` - Resets to free tier
- `PRESET_THEME:ThemeName` - Sets specific theme
- `POPULATE_DATA` - Adds sample history data

## Building

### With Swift Package Manager

```bash
swift build
swift test
```

### With Xcode

```bash
# Open project
open PrismCalc.xcodeproj

# Or generate with xcodegen (if project.yml changes)
xcodegen generate
```

### Build Configuration

- Debug: Uses StoreKit testing configuration
- Release: Uses production StoreKit

## Themes

Six themes available (Aurora is free, others Pro):

| Theme | Primary Color | Style |
|-------|--------------|-------|
| Aurora | `#7B68EE` | Dynamic blue/purple/cyan |
| Calming Blues | `#83BCD4` | Soft peaceful blue |
| Forest Earth | `#4E785E` | Grounded green |
| Soft Tranquil | `#C5E3F6` | Pale calm blue |
| Blue-Green | `#00CEC8` | Modern teal |
| Midnight | `#6366F1` | Dark mode optimized |

## Pro Features

Features gated behind Pro purchase (`com.laclairtech.prismcalc.pro`):

- Tip Calculator
- Discount Calculator
- Split Bill
- Unit Converter
- History with lock/unlock entries (Pro only)
- Premium themes (5)
- All widget styles
- Alternate app icons

Check Pro status: `StoreKitManager.shared.isPro`

## Common Tasks

### Adding a New Feature

1. Create folder in `Sources/PrismCalc/Features/NewFeature/`
2. Add `NewFeatureViewModel.swift` (use @Observable, @MainActor)
3. Add `NewFeatureView.swift`
4. Add unit tests in `Tests/PrismCalcTests/`
5. Add navigation entry in `ContentView.swift`

### Adding a New Theme

1. Add color constants in `GlassTheme.swift`
2. Add gradient in `GlassTheme.swift`
3. Add case to `Theme` enum
4. Add mesh config in `MeshGradientConfig.swift`
5. Update semantic color switches

### Adding History Support

```swift
// Save to history
HistoryService.shared.saveCalculation(
    expression: "100 + 50",
    result: "150"
)

// Or for specialized calculations
HistoryService.shared.saveTip(
    bill: "$100.00",
    tipPercent: 20,
    total: "$120.00",
    perPerson: "$60.00",
    people: 2
)
```

## Scripts

Located in `scripts/`:

- `capture-screenshots.sh` - Automated App Store screenshots
- `generate-icons.sh` - Generate app icons from source
- `run-screenshot-tests.sh` - Run UI screenshot tests
- `setup-appstore-connect.sh` - App Store Connect setup

## Important Files

- `Package.swift` - Swift Package Manager configuration
- `project.yml` - XcodeGen project definition
- `App/Configuration.storekit` - StoreKit testing products
- `App/PrismCalc.entitlements` - App capabilities
- `WidgetExtension/PrismCalcWidget.entitlements` - Widget capabilities

## Known Patterns

### Haptic Feedback

Use shared generator to avoid reallocation:

```swift
#if os(iOS)
private static let hapticGenerator: UIImpactFeedbackGenerator = {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.prepare()
    return generator
}()
#endif

// Usage
Self.hapticGenerator.impactOccurred()
Self.hapticGenerator.prepare()
```

### Preview Providers

Always wrap previews with theme background:

```swift
#Preview {
    ZStack {
        LinearGradient(
            colors: GlassTheme.auroraGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        FeatureView()
    }
}
```

### Color from Hex

```swift
Color(hex: "7B68EE")  // Returns Color from hex string
Color(light: lightColor, dark: darkColor)  // Adaptive color
```

## Don't Do

- Don't use XCTest - use Swift Testing framework
- Don't create UIKit views - use 100% SwiftUI
- Don't access main actor from background - mark async appropriately
- Don't store sensitive data in UserDefaults - use Keychain for secrets
- Don't hardcode currency symbols - use NumberFormatter
- Don't skip input validation - always sanitize user input
