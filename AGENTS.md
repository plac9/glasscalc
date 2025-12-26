# AGENTS.md
**Universal baseline:** Follow `~/dev/.standards/AGENT-STANDARDS.md` for session logging and protocols.
**See also:** `../CLAUDE.md` (iOS portfolio overview) for shared design principles.
**Parent context:** `~/dev/ios/AGENTS.md` (iOS workspace index).

## Purpose
Glassmorphic calculator app (Swift 6, SwiftUI, SwiftData, StoreKit 2) targeting iOS/iPadOS/macOS with strict concurrency and Pro feature set.

## Key Files
- `Package.swift` — SPM manifest
- `Sources/PrismCalc/` — app code (App, Features, DesignSystem, Core, Widgets)
- `Tests/` — unit tests
- `.swiftlint.yml`, `project.yml` (if present) — lint/build config
- `.ai/` (if present) — session context/handoffs

## Commands
- `swift build`
- `swift test` or `swift test --enable-code-coverage`
- `xcodebuild test -scheme PrismCalc -destination 'platform=iOS Simulator,name=iPhone 16'` — UI tests when needed

## Notes
- `glassEffect` (Liquid Glass) is iOS 26+ in the current SDK; keep availability guards and use Material fallbacks for iOS 18.

## Cross-References
- iOS overview: `../CLAUDE.md`
- Workspace hub: `~/dev/AGENTS.md`
- Baseline standards: `~/dev/.standards/AGENT-STANDARDS.md`, `~/dev/.standards/INSTRUCTION-SYSTEM.md`
