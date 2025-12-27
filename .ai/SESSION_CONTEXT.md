# PrismCalc - Session Context

**Last Updated**: 2025-12-26
**Status**: Phase 4 - Launch
**Version**: 1.0.0 (Build 2)
**Brand**: LaClair Technologies

## Quick Status

- **Current Phase**: Phase 4 - Launch preparation
- **Active Work**: All TASKMASTER milestones complete (M1-M5), ready for submission
- **Blockers**: Privacy policy URL (drafted, needs deploy), M4-T4 needs physical device for Instruments
- **Next Steps**: Deploy privacy policy page, upload latest archive to App Store Connect, review macOS/watch screenshots, physical device performance profiling, finalize App Store metadata

## Project Overview

### Purpose
Spectacular glassmorphic calculator for iOS with freemium model. Core calculator free, social tools (tip/split/discount) Pro ($2.99).

### Technology Stack
- **Language**: Swift 6.0 (strict concurrency)
- **Framework**: 100% SwiftUI
- **Platforms**: iOS 18+, iPadOS 18+, macOS 15+
- **Data**: SwiftData with ModelContainer
- **Purchases**: StoreKit 2
- **Build**: Swift Package Manager + Xcode

### Repository Info
- **GitHub**: https://github.com/plac9/prismcalc
- **Path**: `~/dev/ios/prismcalc`
- **Bundle ID**: `com.laclairtech.prismcalc`

## Current State

### What's Done
- [x] All 6 themes with MeshGradient backgrounds
- [x] Basic calculator with Apple-style percent
- [x] Pro features: Tip, Discount, Split, Converter
- [x] Widget extension (small, medium, large)
- [x] Siri Shortcuts (App Intents)
- [x] TipKit feature discovery
- [x] 142 unit tests passing
- [x] Dynamic Type scaling (iOS views)
- [x] Accessibility labels for VoiceOver
- [x] Screenshot UI tests passing
- [x] Automated screenshots captured (iPhone 17, 17 Pro, 17 Pro Max, 16e)
- [x] Reduce Motion support (all 14 files)
- [x] Keyboard dismiss with Done button (4 input views)
- [x] History entry lock/unlock via swipe
- [x] History gated behind Pro paywall
- [x] Tab order reorganized (Calc → Tip → Split → Discount → Convert → History → Settings)
- [x] Theme changes trigger instant refresh

### What's Pending
- [ ] Manual iPhone Dynamic Type pass
- [ ] Manual VoiceOver verification
- [ ] Device performance profiling (Instruments)
- [ ] Screenshot review/crop for App Store (latest device sets)
- [ ] Review refreshed macOS/watch screenshots
- [ ] Privacy policy URL live (drafted at `website/public/privacy/index.html`, pending deploy)
- [ ] Upload latest archive to App Store Connect
- [ ] App Store metadata completion
- [ ] TestFlight beta submission
- [ ] Production release

### Known Issues
- AppIcon warning: "The app icon set has an unassigned child" (cosmetic only)
- Manual accessibility pass still needed despite static audit passing

### Recent Changes
- **2025-12-26**: Refreshed macOS snap and watchOS 46mm screenshot sets
- **2025-12-26**: iOS archive created at `build/archives/PrismCalc-2025-12-26.xcarchive`
- **2025-12-20**: Completed all TASKMASTER M1-M5 milestones (142 tests)
- **2025-12-20**: Tab order: Calc → Tip → Split → Discount → Convert → History → Settings
- **2025-12-20**: Removed currency conversion from Unit Converter
- **2025-12-20**: Keyboard Done button + scroll dismiss for all input views
- **2025-12-20**: History lock/unlock with swipe left/right actions
- **2025-12-20**: History is Pro-only (paywall gated)
- **2025-12-20**: Theme instant refresh via @AppStorage + .id() force rebuild
- **2025-12-20**: Screenshot runner now targets latest xcresult, exact simulator match, and customizable output/prefix
- **2025-12-20**: New screenshot sets captured (iPhone 17, 17 Pro, 17 Pro Max, 16e)
- **2025-12-20**: Reduce Motion support across 14 view files
- **2025-12-19**: Automated screenshots captured on iPhone 17 simulator
- **2025-12-19**: UI tests updated with SELECT_TAB launch arg

## Key Files & Locations

### Source Code
- **App Entry**: `Sources/PrismCalc/App/PrismCalcApp.swift`
- **Calculator Engine**: `Sources/PrismCalc/Core/Services/CalculatorEngine.swift`
- **Design System**: `Sources/PrismCalc/DesignSystem/`
- **Themes**: `Sources/PrismCalc/DesignSystem/GlassTheme.swift`

### Documentation
- **Session Context**: `.ai/SESSION_CONTEXT.md` (this file)
- **Architecture**: `.ai/ARCHITECTURE.md`
- **Changelog**: `.ai/CHANGELOG.md`
- **Handoff**: `.ai/HANDOFF.md`
- **QA Report**: `QA_REPORT.md`
- **Taskmaster**: `docs/TASKMASTER_IOS_PRISMCALC.md`

### Screenshots
- **Automated**: `screenshots/iphone-17/`, `screenshots/iphone-17-pro/`, `screenshots/iphone-17-pro-max/`, `screenshots/iphone-16e/`
- **App Store**: `docs/appstore/screenshots.md`

## Development Workflow

### Build & Test
```bash
# Build
swift build

# Run all tests
swift test

# Run specific test suite
swift test --filter CalculatorEngineTests

# Xcode build
xcodebuild -project PrismCalc.xcodeproj -scheme PrismCalc -sdk iphonesimulator clean build CODE_SIGNING_ALLOWED=NO

# Screenshot tests
xcodebuild test -only-testing:PrismCalcUITests/ScreenshotTests -destination 'platform=iOS Simulator,name=iPhone 17'
```

### Common Tasks
```bash
# Check git status
git status
git log --oneline -5

# View uncommitted changes
git diff --stat

# View specific file history
git log --oneline -10 -- Sources/PrismCalc/App/
```

## Deployment

### Environments
- **Development**: Local Xcode/simulator
- **TestFlight**: Pending submission
- **Production**: Pending App Store approval

### App Store Connect
- **Bundle ID**: com.laclairtech.prismcalc
- **SKU**: TBD
- **Category**: Utilities
- **Price**: Free (with $2.99 Pro IAP)

## Resources

### Documentation
- See `docs/README.md` for complete documentation index
- See `docs/APPSTORE_CONNECT_SETUP.md` for submission guide
- See `docs/IAP_TESTING_GUIDE.md` for StoreKit testing

### Related Projects
- **netcalc** - ADHD-friendly subnet calculator (sibling iOS app)
- Part of LaClair Technologies iOS portfolio

---

**Note**: This file provides AI session context. Update at start and end of each session.
