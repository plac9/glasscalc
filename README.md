# GlassCalc

**Spectacular glassmorphic calculator for iOS**

Part of the LaClair Tech suite - Beautiful, functional tools with stunning UI design.

![Status](https://img.shields.io/badge/status-development-yellow?style=flat-square)
![Platform](https://img.shields.io/badge/platform-iOS%2018.0%2B%20%7C%20macOS%2015.0%2B-lightgrey?style=flat-square)
![Swift](https://img.shields.io/badge/swift-6.0-orange?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)

---

## Overview

GlassCalc is a beautifully designed calculator app featuring full glassmorphism effects, leveraging iOS 18's Liquid Glass design language. Primary focus on spectacular UI while providing practical real-world calculation tools.

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
- History (last 10 calculations)
- 1 theme (Aurora)
- Basic widget

### Pro Tier ($2.99)
- **Tip Calculator** - Bill + tip % with arc slider + split
- **Discount Calculator** - Original price, % off, savings shown
- **Split Bill** - Divide bills among friends
- **Unit Converter** - Length, weight, temp, currency (live rates)
- Unlimited history with iCloud sync
- 6 premium themes
- All widget styles
- Alternate app icons

---

## Screenshots

*Coming soon - Full glassmorphism UI*

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
- **Platforms**: iOS 18.0+, iPadOS 18.0+, macOS 15.0+
- **Bundle ID**: com.laclairtech.glasscalc
- **Package Manager**: Swift Package Manager
- **Currency API**: Frankfurter (free, ECB data)

### Project Structure
```
GlassCalc/
├── Sources/GlassCalc/
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
- iOS 18.0+ / macOS 15.0+

### Building
```bash
# Clone repository
git clone https://github.com/plac9/glasscalc.git
cd glasscalc

# Build with Swift Package Manager
swift build

# Run tests
swift test

# Or open in Xcode
open Package.swift
```

---

## Roadmap

### Phase 1: Core UI & Calculator (Current)
- [ ] Project setup with SPM
- [ ] Design system (glass components)
- [ ] Basic calculator engine
- [ ] Calculator UI with full glassmorphism
- [ ] History feature

### Phase 2: Social Tools (Pro)
- [ ] Tip calculator with arc slider
- [ ] Discount calculator
- [ ] Split bill feature
- [ ] Unit converter + currency API

### Phase 3: Polish
- [ ] All 6 themes
- [ ] Widgets (small, medium, large)
- [ ] Alternate app icons
- [ ] In-App Purchase integration

### Phase 4: Launch
- [ ] App Store assets
- [ ] Privacy policy
- [ ] App Store submission

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
