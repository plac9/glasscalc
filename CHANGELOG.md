# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- App Store screenshot set in `screenshots/` (iphone67_01.png through iphone67_10.png).
- Preview stubs for `TipResultsSection` and `SplitResultsSection` to aid UI iteration.

### Changed
- Set iPhone-only targeting (`TARGETED_DEVICE_FAMILY = 1`) and codified team ID in `project.yml`.
- Tuned glass highlights and borders for reduce-transparency/increase-contrast accessibility settings.
- Locked orientation to portrait in `App/Info.plist`.
- Regenerated Xcode project/scheme from `project.yml`.

### Fixed
- UI screenshot tests can tap calculator buttons via explicit accessibility identifiers.

### Removed
- Unassigned `AppIcon.png` from `App/Assets.xcassets/AppIcon.appiconset`.
