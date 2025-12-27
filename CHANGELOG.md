# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- App Store screenshot set in `screenshots/` (iphone67_01.png through iphone67_10.png).
- Preview stubs for `TipResultsSection` and `SplitResultsSection` to aid UI iteration.
- Native macOS and watchOS targets, plus platform-specific widget extensions.
- watchOS calculator UI and watch widget entry point.
- App Group entitlements for app and widget targets.
- Platform parity checklist and refreshed automated screenshots (iPhone 17, iPad Pro 13, watchOS 46mm, macOS native).
- Refreshed automated screenshot sets for iPhone 17 and iPad Pro 13-inch (M5) in `screenshots/automated/2025-12-26-*`.
- Refreshed macOS snap screenshots and watchOS 46mm set in `screenshots/automated/2025-12-26-macos-snap/` and `screenshots/automated/2025-12-26-watchos-46mm/`.
- Privacy policy page at `https://prismcalc.app/privacy` (website).
- Website platforms + widgets sections with updated platform imagery and showcase gallery assets.
- App Review “What to Test” checklist in App Store metadata docs.
- Export compliance flag set in app Info.plist files (non-exempt encryption).

### Changed
- Set iPhone + iPad targeting (`TARGETED_DEVICE_FAMILY = 1,2`) and codified team ID in `project.yml`.
- Tuned glass highlights and borders for reduce-transparency/increase-contrast accessibility settings.
- Added supported orientations in iOS build settings (generated Info.plist) to satisfy iPad multitasking requirements.
- Regenerated Xcode project/scheme from `project.yml`.
- Display name and user-facing strings aligned to `prismCalc`.
- iPad tab view uses sidebar-adaptable layout; macOS default window size set; watch UI contrast improved.
- Layered glass fallback for iOS 18 while keeping Liquid Glass (`glassEffect`) on iOS 26+.
- Calculator layout treats macOS as large-screen for consistent sizing.
- watchOS calculator uses scaled metrics for spacing, fonts, and button sizing.
- StoreKit logs now include entitlement refresh and verification failures.
- Website copy now reflects Apple Watch support and Liquid Glass availability.
- Refined glass edge rendering with softer highlight blending and lower border contrast.
- Watch button borders softened to reduce edge artifacts on small screens.
- History free tier now shows the last 10 entries with upgrade messaging; lock actions are disabled unless Pro.
- macOS window sizing snaps between calculator-only and calculator+history widths; history visibility follows resize state.
- iPad large-screen calculator buttons now cap at 140pt for layout balance.
- watchOS display supports long-press backspace on the calculator output.
- macOS min window height increased; titlebar now transparent; history panel toggle is available on edge hover even when compact.
- macOS history panel row sizing now fits 10 entries without scrolling; tab bar icon contrast increased.
- Consolidated the mesh background into a single shared layer and added performance toggles for animation and reduced frame rate.
- Website copy, FAQ, and theme showcase updated for current feature set and privacy messaging.
- App Store screenshot review doc now reflects App Store Connect upload status.

### Fixed
- UI screenshot tests can tap calculator buttons via explicit accessibility identifiers.
- Guarded watchOS button background fill to avoid incompatible material branch.
- UI tests now navigate Settings/History/Convert via the More menu when not in the tab bar.

### Removed
- Unassigned `AppIcon.png` from `App/Assets.xcassets/AppIcon.appiconset`.
