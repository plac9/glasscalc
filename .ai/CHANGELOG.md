# PrismCalc - Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CLAUDE.md project context file
- .ai/ directory with SESSION_CONTEXT.md, ARCHITECTURE.md, CHANGELOG.md, HANDOFF.md
- Automated screenshot capture (10 PNGs on iPhone 17 simulator)
- Automated screenshot sets for iPhone 17, 17 Pro, 17 Pro Max, and 16e
- Screenshot runner arguments for simulator/output/prefix
- Mission statement audit documentation

### Changed
- Updated QA_REPORT.md with iOS-only verification notes
- Screenshot tests now accept SELECT_TAB launch argument
- History is Pro-only and paywall copy updated
- Screenshot runner now selects latest xcresult and exact simulator name matches

### Removed
- Currency conversion from Unit Converter and CurrencyService

### Fixed
- StoreKit loading state reset on completion paths
- History update path for lock/unlock entries
- Screenshot extraction/rename pipeline for consistent iphone67_*.png output

## [1.0.0] - 2025-12-07

### Added
- Complete glassmorphism design system with 6 themes
- Basic calculator with Apple-style percent behavior
- Pro features: Tip Calculator, Discount Calculator, Split Bill, Unit Converter
- Widget extension (small, medium, large, Control Center)
- Siri Shortcuts via App Intents
- TipKit feature discovery
- 100 unit tests
- Dynamic Type scaling for iOS views
- VoiceOver accessibility labels
- Screenshot UI tests
- App Store prep assets

### Changed
- Aligned percent behavior with Apple Calculator
- Scale button labels for Dynamic Type
- Scale display for Dynamic Type

### Fixed
- Error state clearing on next digit entry
- Percent behavior with pending operations

## [0.9.0] - 2025-12-01

### Added
- All 6 MeshGradient themes
- SF Symbol 6 animations
- Haptic feedback system
- History feature with SwiftData
- iCloud sync for Pro users

### Changed
- Refined glass material layering
- Improved ArcSlider responsiveness

## [0.8.0] - 2025-11-25

### Added
- Unit Converter with currency (Frankfurter API)
- Split Bill feature
- Discount Calculator

### Changed
- Pro feature gating with StoreKit 2

## [0.7.0] - 2025-11-20

### Added
- Tip Calculator with ArcSlider
- Settings view with theme selection
- Paywall UI for Pro upgrade

## [0.6.0] - 2025-11-15

### Added
- Calculator engine with full operation support
- History service
- Basic widget

## [0.5.0] - 2025-11-10

### Added
- GlassButton, GlassCard components
- ArcSlider custom control
- Aurora theme (default)

## [0.4.0] - 2025-11-05

### Added
- Project structure with SPM
- GlassTheme design system foundation
- MeshGradient configuration

## [0.1.0] - 2025-11-01

### Added
- Initial project setup
- Swift Package Manager configuration
- Basic SwiftUI app scaffold

---

**Note**: This changelog tracks significant changes. Update when making notable modifications.
