# PrismCalc - Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Marketing website** at prismcalc.app (Vite 7 + React 19 + TypeScript)
  - Glassmorphism UI matching iOS app design
  - Animated mesh gradients, dark mode support
  - Full SEO optimization with Open Graph meta tags
  - Smart App Banner for iOS users
- Deployed to Cloudflare Pages with custom domain and SSL
- WidgetPreviewTypes shared model for screenshot automation
- 9 App Store screenshots with clean naming format
- **Custom MoreView** with themed mesh gradient navigation (2025-12-21)
- **Website dark mode toggle** with system preference + manual override
- New Blue-Green theme screenshots for website (Calculator, Tip, Split, Discount, More)
- Floating pill navigation header for website

### Changed
- SwiftLint refactoring: extracted 8 components, eliminated ALL source warnings
- Consolidated widget fixes, reorganized tests
- Screenshot naming now uses clean format without UUIDs
- **Tab structure reduced from 7 to 5** (Calculator, Tip, Split, Discount, More)
- Arc slider backgrounds removed for seamless integration with mesh gradient
- Website hero text now white with shadow for better contrast on teal
- Screenshot gallery breaks out of container for full-width horizontal scroll

### Removed
- Currency conversion from Unit Converter and CurrencyService
- Old UUID-based screenshot files
- iPad/Mac/iCloud references from website (iPhone only for v1.0)

### Fixed
- StoreKit loading state reset on completion paths
- History update path for lock/unlock entries
- ArcSlider percentage clamping to prevent bottom-half overflow
- **More screen themed background** (was plain black from system TabView overflow)
- Sub-pages (Settings, History, Convert) now properly themed via ThemedContent wrapper
- Website text contrast issues on teal background

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
