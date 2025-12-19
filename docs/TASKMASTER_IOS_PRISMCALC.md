# PrismCalc iOS Taskmaster

Scope: iOS-first only. iPadOS/macOS polish happens after iOS ships.

## Objectives
- Ship a trustworthy glass-first calculator on iOS with correct math.
- Ensure readability, accessibility, and performance on iPhone devices.
- Finish iOS App Store packaging.

## Execution Order (Logical)

### 1) Trust and Correctness (math engine + UX)
- [x] Implement Apple-style percent behavior with pending operations.
- [x] Clear error state on next digit entry.
- [x] Add unit tests for percent behavior and error clearing.

### 2) Accessibility and Readability (iOS)
- [ ] Run iPhone Dynamic Type pass (all themes).
- [ ] Verify VoiceOver labels for calculator keys and display on iPhone.
- [ ] Adjust glass contrast and text colors if any theme fails readability.
  - Note: Added Dynamic Type scaling and accessibility labels in iOS views; simulator checklist pending due to `simctl list devices` timeouts.

### 3) Performance (iOS)
- [ ] Profile on iPhone: mesh gradient + blur performance (Instruments).
- [ ] Add reduce-motion fallback or static mesh if needed.

### 4) Verification (iOS)
- [x] Run `swift test` and record results.
- [ ] Run iPhone screenshot UI tests.
- [ ] Update QA report with iOS-only verification notes.

### 5) Launch (iOS)
- [ ] Capture final iPhone screenshots (3 hero shots minimum).
- [ ] Confirm privacy policy URL is live.
- [ ] Update App Store metadata and submit.

## Notes
- iOS behavior target: immediate-execution calculator, Apple-style percent.
- App Store assets and privacy policy remain the only launch blockers.
