# prismCalc

**Spectacular glassmorphic calculator for iOS**

Part of the LaClair Tech suite - Beautiful, functional tools with stunning UI design.

![Status](https://img.shields.io/badge/status-development-yellow?style=flat-square)
![Platform](https://img.shields.io/badge/platform-iOS%2018.0%2B%20%7C%20iPadOS%2018.0%2B%20%7C%20macOS%2015.0%2B%20%7C%20watchOS%2010.0%2B-lightgrey?style=flat-square)
![Swift](https://img.shields.io/badge/swift-6.0-orange?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)

---

## Overview

prismCalc is a beautifully designed calculator app featuring full glassmorphism effects. On iOS 26+ it uses Liquid Glass (`glassEffect`); on iOS 18+ it uses layered material fallbacks while keeping the same visual language.

**Mission**: prismCalc is for everyday iPhone users who want a gorgeous, trustworthy calculator for money math without clutter.

**Design Philosophy**:
- **UI First**: Stunning glassmorphism with layered materials
- **Practical Tools**: Tips, discounts, splits, conversions
- **Modern Swift**: Swift 6.0 with strict concurrency
- **100% SwiftUI**: Native iOS interface with haptic feedback
- **Freemium Model**: Core calculator free, social tools Pro

---

## Features

### Free Tier
- Basic calculator with glass UI
- 1 theme (Aurora)
- Basic widget

### Pro Tier ($2.99)
- **Tip Calculator** - Bill + tip % with arc slider + split
- **Discount Calculator** - Original price, % off, savings shown
- **Split Bill** - Divide bills among friends
- **Unit Converter** - Length, weight, temperature
- History with lock/unlock entries
- 6 premium themes
- All widget styles
- Alternate app icons

---

## Screenshots

Screenshots live in `screenshots/` and `docs/appstore/`.

---

## Design System

### Glassmorphism Stack
```
┌─────────────────────────────────┐
│  Dynamic Gradient Background    │  LinearGradient (theme-based)
├─────────────────────────────────┤
│  .ultraThinMaterial overlay     │  Frosted base layer
├─────────────────────────────────┤
│  .regularMaterial cards         │  Floating glass elements
├─────────────────────────────────┤
│  .thinMaterial buttons          │  Interactive elements
└─────────────────────────────────┘
```

### Themes (6 Total)
1. **Aurora** (default) - Dynamic gradients, blue/purple/cyan
2. **Calming Blues** - Soft blue `#83BCD4`, peaceful
3. **Forest Earth** - Grounded green `#4E785E`, natural
4. **Soft Tranquil** - Pale blue `#C5E3F6`, maximum calm
5. **Blue-Green Harmony** - Modern teal `#00CEC8`, energized
6. **Midnight** - Dark mode optimized, deep blacks

### App Icons
- **Default**: Frosted glass calculator icon
- **Pro Variants**: Theme-colored versions (6 total)

---

## Architecture

### Technology Stack
- **Language**: Swift 6.0 (strict concurrency enabled)
- **UI Framework**: 100% SwiftUI
- **Platforms**: iOS 18.0+, iPadOS 18.0+, macOS 15.0+ (native), watchOS 10.0+
- **Bundle IDs**: iOS `com.laclairtech.prismcalc`, macOS `com.laclairtech.prismcalc.mac`, watchOS `com.laclairtech.prismcalc.watch`, widgets `com.laclairtech.prismcalc.widget`, `com.laclairtech.prismcalc.mac.widget`, `com.laclairtech.prismcalc.watch.widget`
- **App Group**: `group.com.laclairtech.prismcalc.shared`
- **Package Manager**: Swift Package Manager

### Project Structure
```
PrismCalc/
├── Sources/PrismCalc/
│   ├── App/                      # App entry, navigation
│   ├── Features/
│   │   ├── Calculator/           # Basic calculator
│   │   ├── TipCalculator/        # Tip + split (Pro)
│   │   ├── DiscountCalculator/   # Discount calc (Pro)
│   │   ├── SplitBill/            # Bill splitting (Pro)
│   │   ├── UnitConverter/        # Conversions (Pro)
│   │   ├── History/              # Calculation history
│   │   └── Settings/             # Themes, icons, Pro
│   ├── DesignSystem/             # Glass components
│   ├── Widgets/                  # Home screen widgets
│   └── Core/                     # Models, services
├── Tests/
└── docs/
```

---

## Development

### Requirements
- Xcode 16.0+
- Swift 6.0+
- iOS 18.0+ / iPadOS 18.0+ / macOS 15.0+ / watchOS 10.0+

### Building
```bash
# Clone repository
git clone https://github.com/plac9/prismcalc.git
cd prismcalc

# Build with Swift Package Manager
swift build

# Run tests
swift test

# Or open in Xcode
open Package.swift

# In Xcode, select scheme "PrismCalc" and run on iOS 18+ simulator/device
```

---

## Roadmap

### Phase 1: Core UI & Calculator ✅
- [x] Project setup with SPM
- [x] Design system (glass components)
- [x] Basic calculator engine
- [x] Calculator UI with full glassmorphism
- [x] History feature

### Phase 2: Social Tools (Pro) ✅
- [x] Tip calculator with arc slider
- [x] Discount calculator
- [x] Split bill feature
- [x] Unit converter (length, weight, temperature)

### Phase 3: Polish ✅
- [x] All 6 themes with MeshGradient backgrounds
- [x] Widgets (small, medium, large + Control Center)
- [x] SF Symbol 6 animations
- [x] Accessibility labels for VoiceOver
- [x] Input validation & overflow protection
- [x] Siri Shortcuts (App Intents)
- [x] TipKit feature discovery
- [x] 97 unit tests (8 suites)

### Phase 4: Launch
- [ ] App Store assets
- [ ] Privacy policy
- [ ] App Store submission

---

## Workflow Alignment (AuADHD)

Reference: `docs/AUADHD_IOS_WORKFLOW_PRISMCALC.md`

**Scope**: native iOS/iPadOS/macOS/watchOS parity in progress

- P0 Define Value: ✅ (glass + trust for money math)
- P1 Decide Scope: ✅ (single primary layout; Calculator tab anchor)
- P2 Design System: ✅ (GlassTheme + reusable components)
- P3 Trust Engine: ✅ (CalculatorEngine + tests)
- P4 Delight: ✅ (subtle haptics + motion)
- P5 Prove It: ⏳ (need iOS-only checks: contrast, perf, math regression run)
- P6 Launch: ⏳ (App Store assets + privacy policy + submission)

---

## License

MIT License - See LICENSE file for details

---

## About LaClair Tech

LaClair Tech builds beautiful, functional tools for iOS. Our apps prioritize stunning design without sacrificing usability.

**Website**: [laclairtech.com](https://laclairtech.com)
**GitHub**: [@plac9](https://github.com/plac9)

---

## Related Projects

- **netcalc** - ADHD-friendly subnet calculator with glassmorphism
- **LANScanPro** - Network security and device discovery

---

**Built with glass, designed to impress.**
