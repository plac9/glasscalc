# prismCalc Implementation Plan v2

**Mission Statement (v1)**: "prismCalc is for everyday iPhone users who want a gorgeous, trustworthy calculator for money math without clutter."

**Date**: 2025-12-19
**Author**: Claude Code iOS Engineering Agent
**Scope**: native iOS/iPadOS/macOS/watchOS parity in progress.

---

## 0) Mission Alignment Summary

This plan protects prismCalc's core identity: **money math + gorgeous + trustworthy + no clutter**.

Every task is evaluated against mission guardrails. We fix broken UI that damages trust (Quick Access Widget no-op, ArcSlider drift), reduce visual clutter (display spacing, Settings restructure), and add mission-critical usability (delete button, breadcrumb clarity) without scope creep. Customization features (keypad layout, menu order) are minimal v1 implementations that respect Apple conventions. We explicitly reject scientific/programmer modes and complex workflows that dilute the "money math without clutter" promise.

The glass aesthetic remains paramount, but readability at high Dynamic Type takes precedence - we'll adjust blur/opacity before sacrificing legibility.

---

## 1) Milestones

| Milestone | Title | Dependencies | Estimate | Risk Level |
|-----------|-------|--------------|----------|------------|
| **M1** | Fix Broken/Buggy UI | None | Medium | Low |
| **M2** | Mission-Critical Usability | M1 | Medium | Low |
| **M3** | Customization Features | M2 | Large | Medium |
| **M4** | Apple-Native Polish + Accessibility | M1 | Medium | Low |
| **M5** | Tests and Hardening | M1-M4 | Medium | Low |

### Milestone Dependencies Graph

```
M1 (Bugs) ──┬──▶ M2 (Usability) ──▶ M3 (Customization)
            │
            └──▶ M4 (Polish/A11y)
                        │
M2 + M4 ────────────────┴──▶ M5 (Tests)
```

---

## 2) Task Breakdown

### M1: Fix Broken/Buggy UI (Priority: CRITICAL)

Dead UI damages trust. Fix these first.

---

#### M1-T1: Fix Quick Access Widget No-Op

**Category**: Mission-critical (damages trust when UI element does nothing)

**What Changes**:
- Audit `AddWidgetTip` in HistoryView.swift - currently shows TipKit tip but tapping does nothing
- Implement actual widget addition guidance using `WidgetKit.WidgetCenter.shared.reloadAllTimelines()`
- Consider using `IntentConfiguration` to deep-link to home screen widget add flow
- If iOS doesn't support programmatic widget add, change tip text to instructional ("Add from Home Screen: hold, tap +, search prismCalc")

**Acceptance Criteria**:
- [ ] Widget tip either adds widget OR clearly instructs user how to add
- [ ] No dead/confusing UI elements
- [ ] Widget tip dismisses appropriately after action

**Implementation Notes**:
- Check iOS 18 WidgetKit API for any new programmatic options
- TipKit `invalidationReason` should be `.actionPerformed` when done

**Tests to Add**:
- UI test: tap widget tip, verify expected behavior
- Unit test: tip invalidation logic

---

#### M1-T2: Fix ArcSlider Alignment Drift (Tip/Discount Screens)

**Category**: Mission-critical (broken gesture UX)

**What Changes**:
- The drag gesture in `ArcSlider.swift` uses relative coordinates that drift when parent scrolls
- Fix: Use `coordinateSpace` modifier to anchor gesture to slider's local space
- Ensure drag detection stays centered on arc regardless of scroll position

**Acceptance Criteria**:
- [ ] ArcSlider rotation gesture works correctly at any scroll position
- [ ] No drift when scrolling Tip/Discount screens
- [ ] Thumb follows finger accurately

**Implementation Notes**:
```swift
// Current problem: gesture.location is in parent coordinate space
// Fix: Use named coordinate space
.coordinateSpace(name: "arcSlider")
.gesture(DragGesture(coordinateSpace: .named("arcSlider"))...)
```

**Tests to Add**:
- UI test: scroll to bottom, drag ArcSlider, verify value changes correctly

---

#### M1-T3: Fix Theme Propagation in Tip/Discount Graphics

**Category**: Mission-supporting (visual consistency)

**What Changes**:
- Audit TipCalculatorView and DiscountCalculatorView for hardcoded colors
- Ensure all graphics use `GlassTheme.primary`, `GlassTheme.secondary`, etc.
- Verify ArcSlider fill gradient respects theme

**Acceptance Criteria**:
- [ ] All 6 themes display correctly in Tip Calculator
- [ ] All 6 themes display correctly in Discount Calculator
- [ ] ArcSlider gradient matches current theme

**Tests to Add**:
- Screenshot test per theme for Tip view
- Screenshot test per theme for Discount view

---

#### M1-T4: Reduce Calculator Display Black Space

**Category**: Mission-supporting (visual polish)

**What Changes**:
- Current `calculateLayout` in CalculatorView.swift allocates excessive display height
- Reduce `displayBottomPadding` and `topPadding` values
- Ensure display height is proportional, not just "remaining space"
- Keep enough room for expanded breadcrumb (M2-T3)

**Acceptance Criteria**:
- [ ] Display area is balanced (no excessive black space above/below)
- [ ] Buttons grid properly sized
- [ ] Works on iPhone SE through iPhone 16 Pro Max

**Implementation Notes**:
- Constrain `availableDisplayHeight` to sensible max (e.g., 35% of screen)
- Leave room for future breadcrumb expansion

**Tests to Add**:
- Screenshot tests on multiple device sizes

---

### M2: Mission-Critical Usability

---

#### M2-T1: Add Single-Digit Delete Button (Backspace)

**Category**: Mission-critical (standard calculator UX)

**What Changes**:
- Add backspace button to calculator keypad
- Position: Replace one function button OR add as swipe gesture on display
- Recommend: Long-press on AC to switch to "C" (clear entry) mode is Apple pattern
- Alternative: Add dedicated backspace button (⌫) in Row 1

**Acceptance Criteria**:
- [ ] User can delete last entered digit
- [ ] Works correctly with operations pending
- [ ] Clear haptic feedback on delete
- [ ] VoiceOver announces "delete" action

**Implementation Notes**:
- Apple Calculator uses AC/C toggle pattern
- Consider swipe-left on display as additional gesture
- CalculatorViewModel needs `deleteLastDigit()` method

**Tests to Add**:
- Unit test: deleteLastDigit() removes single character
- UI test: tap delete, verify display updates

---

#### M2-T2: Expand Breadcrumb/Expression Display

**Category**: Mission-critical (trust - users need to see operations)

**What Changes**:
- Current `expression` in GlassDisplay shows minimal context
- Expand to show full operation chain: `100 + 10% =`
- Ensure expression is scrollable if very long
- Position near output display, clearly secondary to result

**Acceptance Criteria**:
- [ ] Full expression visible (e.g., "100 + 10% =")
- [ ] Expression scrolls horizontally if needed
- [ ] Clear visual hierarchy: result prominent, expression secondary
- [ ] Dynamic Type support for expression text

**Implementation Notes**:
- Update CalculatorViewModel to build full expression string
- Consider using `ScrollView(.horizontal)` for long expressions

**Tests to Add**:
- Unit test: expression building for complex operations
- UI test: verify expression displays correctly

---

#### M2-T3: Restructure Settings Screen

**Category**: Mission-supporting (reduce clutter)

**What Changes**:
1. Move Theme selection into drill-in menu item ("Themes >")
2. Move "prismCalc" branding into "About" section
3. Move Pro unlock to bottom (visible but not obnoxious)
4. Add placeholders for: Keypad Layout, Menu Order, Widget Management

**Acceptance Criteria**:
- [ ] Settings has clean top-level structure
- [ ] Themes accessible via single tap + drill-in
- [ ] About section contains branding + version
- [ ] Pro unlock visible near bottom
- [ ] Customization entries ready (can be stubs for M3)

**Implementation Notes**:
- Use `NavigationLink` for Themes
- Extract ThemeSettingsView as separate view
- Add `List` grouping for logical sections

**Tests to Add**:
- UI test: navigate to Themes, verify all 6 visible
- UI test: verify About section contains version

---

#### M2-T4: Add History Note Option (Tip/Discount/Split)

**Category**: Mission-supporting (money math context)

**What Changes**:
- When saving Tip/Discount/Split to history, prompt for optional note
- Note examples: "Dinner at Mario's", "Split with Sarah and Mike"
- Store note in HistoryEntry model
- Display note in History list and detail view

**Acceptance Criteria**:
- [ ] "Add Note" option appears before save
- [ ] Note is optional (can skip)
- [ ] Note displays in history list
- [ ] Note editable in detail view

**Implementation Notes**:
- Add `note: String?` to HistoryEntry
- Use `.sheet` or inline text field for note input

**Tests to Add**:
- Unit test: HistoryEntry with note persists correctly
- UI test: add note, verify displays in history

---

### M3: Customization Features

---

#### M3-T1: Customizable Bottom Menu Order

**Category**: Mission-supporting (personalization without clutter)

**What Changes**:
- Allow reordering tabs in bottom menu
- Calculator locked at position 1 (non-movable)
- Default order: Calculator, Convert, Tip, Split, Discount, History, Settings
- Use iOS `TabViewCustomization` API (already partially implemented)
- Persist order via `@AppStorage`

**Acceptance Criteria**:
- [ ] Long-press on tab bar enters edit mode
- [ ] Drag to reorder (except Calculator)
- [ ] Order persists across launches
- [ ] Reset to default option in Settings

**Implementation Notes**:
- iOS 18 TabView with `.tabViewCustomization()` already scaffolded
- Need to implement proper binding to persisted storage
- Add Settings entry for manual edit access

**Tests to Add**:
- UI test: reorder tabs, verify persistence
- Unit test: tab order storage/retrieval

---

#### M3-T2: Customizable Keypad Layout (Minimal v1)

**Category**: Mission-risk (complexity) - propose minimal version

**What Changes**:
**Minimal v1 Scope**:
- Allow moving 0 position (bottom-left vs bottom-middle)
- Enter customization: 5-second press-and-hold on keypad (with Settings toggle)
- Visual: Buttons wiggle (like iOS home screen)
- Save/Cancel/Reset buttons appear
- Persist layout via `@AppStorage`

**NOT in v1**:
- Full button rearrangement (too complex, too many edge cases)
- Custom button sizes
- Adding/removing buttons

**Acceptance Criteria**:
- [ ] 5-second hold enters edit mode (wiggle animation)
- [ ] Can swap 0 position
- [ ] Save persists, Cancel reverts
- [ ] Reset to default works
- [ ] Settings has toggle to disable hold-to-edit

**Implementation Notes**:
- Use `@GestureState` for press duration tracking
- Wiggle animation: `rotationEffect` with `Animation.easeInOut.repeatForever()`
- Consider using `enum KeypadLayout { case standard, zeroLeft }` for v1

**Tests to Add**:
- UI test: enter edit mode, swap 0, save, verify persistence
- Unit test: layout storage/retrieval

---

#### M3-T3: Widget Management in Settings

**Category**: Mission-supporting (discoverability)

**What Changes**:
- Add "Widgets" entry in Settings
- Show available widget types with previews
- Link to iOS widget gallery or instructions
- If widget not added, show "Add Widget" guidance

**Acceptance Criteria**:
- [ ] Settings > Widgets shows available types
- [ ] Widget previews visible
- [ ] Clear instructions for adding widgets

**Implementation Notes**:
- Use `WidgetCenter.shared.getCurrentConfigurations()` to detect installed widgets
- Show different state for "installed" vs "not installed"

**Tests to Add**:
- UI test: navigate to widget settings

---

### M4: Apple-Native Polish + Accessibility + Performance

---

#### M4-T1: Dynamic Type Full Pass

**Category**: Mission-critical (accessibility)

**What Changes**:
- Audit every screen with Accessibility XXXL enabled
- Ensure all text uses `@ScaledMetric` or system fonts
- Verify no text truncation or overlap
- Adjust glass effects if they harm readability at large sizes

**Acceptance Criteria**:
- [ ] All screens readable at XXXL
- [ ] No text truncation
- [ ] Interactive targets remain 44pt minimum
- [ ] Glass blur reduced if needed for contrast

**Implementation Notes**:
- Use Accessibility Inspector to verify
- Consider `.minimumScaleFactor()` for tight spaces
- May need to reduce material opacity at high Dynamic Type

**Apple References**:
- Human Interface Guidelines > Accessibility > Dynamic Type
- WWDC 2023 "Build accessible apps with SwiftUI"

**Tests to Add**:
- Screenshot tests at XXXL across all screens

---

#### M4-T2: VoiceOver Full Pass

**Category**: Mission-critical (accessibility)

**What Changes**:
- Verify all interactive elements have accessibility labels
- Ensure logical navigation order
- Add accessibility hints where helpful
- Test with VoiceOver enabled on real device

**Acceptance Criteria**:
- [ ] Every button/control has label
- [ ] Tab navigation order is logical
- [ ] ArcSlider adjustable via VoiceOver
- [ ] Calculator operations announced correctly

**Apple References**:
- Human Interface Guidelines > Accessibility > VoiceOver
- WWDC 2024 "Catch up on accessibility in SwiftUI"

**Tests to Add**:
- Accessibility audit using Xcode Accessibility Inspector
- Manual VoiceOver walkthrough documented

---

#### M4-T3: Reduce Motion Support

**Category**: Mission-supporting (accessibility)

**What Changes**:
- Audit all animations for `accessibilityReduceMotion` support
- MeshGradient animation should be static when reduced motion on
- ArcSlider should use crossfade instead of movement
- Scroll transitions should be disabled

**Acceptance Criteria**:
- [ ] `@Environment(\.accessibilityReduceMotion)` checked
- [ ] Static fallbacks for all animations
- [ ] App remains visually appealing without motion

**Apple References**:
- Human Interface Guidelines > Accessibility > Motion

**Tests to Add**:
- Screenshot tests with Reduce Motion enabled

---

#### M4-T4: Performance Profiling (Instruments)

**Category**: Mission-critical (trust - app must be responsive)

**What Changes**:
- Run Time Profiler on physical device
- Check MeshGradient CPU/GPU usage
- Check material blur performance
- Target: 60fps scroll, no frame drops during animation

**Acceptance Criteria**:
- [ ] 60fps maintained during normal use
- [ ] No frame drops > 3ms during animations
- [ ] GPU usage reasonable for blur effects
- [ ] Battery impact acceptable

**Implementation Notes**:
- Use Instruments > Time Profiler
- Use Instruments > Core Animation
- Test on oldest supported device (iPhone 12?)

**Tests to Add**:
- Performance baseline documented
- Automated XCTest performance tests for scroll

---

#### M4-T5: Validate Haptics Best Practice

**Category**: Mission-supporting (delight)

**What Changes**:
- Audit current haptic usage against Apple HIG
- Ensure haptics match feedback types (selection, impact, notification)
- Verify haptics don't fire too frequently
- Current haptics are "excellent" per testing - preserve and document

**Acceptance Criteria**:
- [ ] Haptics match Apple recommendations
- [ ] No haptic spam (debounced appropriately)
- [ ] Haptics enhance, don't distract

**Apple References**:
- Human Interface Guidelines > Inputs > Haptics
- WWDC 2021 "Design with haptics"

**Tests to Add**:
- Document haptic usage per interaction type

---

#### M4-T6: Glass Number Animation Audit

**Category**: Mission-supporting (polish)

**What Changes**:
- Audit "glass number sliding effect" in display
- Verify animation uses modern SwiftUI patterns
- Check `.contentTransition(.numericText())` usage
- Ensure animation respects Reduce Motion

**Acceptance Criteria**:
- [ ] Number transitions are smooth
- [ ] Uses `.contentTransition(.numericText())` where appropriate
- [ ] Respects Reduce Motion preference
- [ ] Performance acceptable (no jank)

**Tests to Add**:
- Visual regression test for number transitions

---

#### M4-T7: Split Screen Visual Polish

**Category**: Mission-supporting (polish)

**What Changes**:
- Per testing: "Functionality ok; needs visual cleanup/polish"
- Audit SplitBillView for consistency with other screens
- Ensure glass materials and spacing match Tip/Discount
- Add subtle animations for person count changes

**Acceptance Criteria**:
- [ ] Visual consistency with Tip/Discount screens
- [ ] Proper glass layering
- [ ] Pleasant animations for interactions

**Tests to Add**:
- Screenshot test for Split view

---

### M5: Tests and Hardening

---

#### M5-T1: Calculation Engine Correctness Tests

**Category**: Mission-critical (trust)

**What Changes**:
- Expand existing CalculatorEngine tests
- Add edge cases: division by zero, overflow, very large numbers
- Add percent behavior tests for all operation combinations
- Add decimal precision tests

**Acceptance Criteria**:
- [ ] 100% coverage of CalculatorEngine
- [ ] Edge cases documented and tested
- [ ] Percent behavior matches Apple Calculator exactly

**Tests to Add**:
- Edge case suite in CalculatorEngineTests

---

#### M5-T2: Persistence Tests

**Category**: Mission-critical (trust)

**What Changes**:
- Test all `@AppStorage` values persist correctly
- Test History entries survive app restart
- Test tab order customization persistence
- Test keypad layout persistence

**Acceptance Criteria**:
- [ ] All persisted values round-trip correctly
- [ ] No data loss on app update
- [ ] iCloud sync works for Pro history

**Tests to Add**:
- Persistence test suite

---

#### M5-T3: Theme Propagation Tests

**Category**: Mission-supporting (visual consistency)

**What Changes**:
- Create test that cycles through all 6 themes
- Screenshot each major screen per theme
- Verify no hardcoded colors visible

**Acceptance Criteria**:
- [ ] All 6 themes render correctly
- [ ] No visual artifacts per theme
- [ ] Screenshot baseline established

**Tests to Add**:
- ThemePropagationTests with screenshots

---

#### M5-T4: Accessibility Automated Tests

**Category**: Mission-critical (accessibility)

**What Changes**:
- Add XCUITest accessibility checks
- Verify all buttons have accessibility identifiers
- Check minimum touch target sizes
- Verify accessibility value updates for ArcSlider

**Acceptance Criteria**:
- [ ] Automated accessibility audit passes
- [ ] No unlabeled interactive elements
- [ ] Touch targets >= 44pt

**Tests to Add**:
- AccessibilityTests suite

---

#### M5-T5: UI Flow Tests for Customization

**Category**: Mission-supporting (feature coverage)

**What Changes**:
- Test customization mode entry/exit
- Test tab reorder flow
- Test keypad edit mode
- Test save/cancel/reset behaviors

**Acceptance Criteria**:
- [ ] Entry into edit modes works
- [ ] Reorder gestures work
- [ ] Save persists, cancel reverts, reset defaults

**Tests to Add**:
- CustomizationFlowTests

---

## 3) Research Notes (Apple References)

### Haptics
- **HIG: Haptics** - Use system feedback types (`UIImpactFeedbackGenerator`, `UISelectionFeedbackGenerator`)
- **WWDC 2021: Design with haptics** - Pair haptics with visual/audio feedback; don't overuse
- **Current implementation**: Uses `.sensoryFeedback()` modifier (iOS 17+) - approved pattern

### Animations + Reduce Motion
- **HIG: Motion** - Respect `accessibilityReduceMotion`; provide meaningful fallbacks
- **WWDC 2023: Build accessible apps** - Use `.animation(nil)` or `.transaction { $0.animation = nil }` for disable
- **SwiftUI**: `@Environment(\.accessibilityReduceMotion)` property wrapper

### SwiftUI Layout + Dynamic Type
- **HIG: Typography** - Use system fonts; avoid fixed sizes
- **HIG: Dynamic Type** - Test at all sizes; prioritize legibility over aesthetics
- **SwiftUI**: `@ScaledMetric`, `.font(.system(...))`, `.minimumScaleFactor()`
- **WWDC 2024: Catch up on accessibility** - New SwiftUI accessibility APIs

### Widgets
- **WidgetKit Documentation** - `WidgetCenter.shared.reloadAllTimelines()`
- **HIG: Widgets** - Clear, glanceable content; respect system appearance
- **iOS 18**: Interactive widgets, Control Center widgets
- **Note**: No programmatic "add widget" API - must guide user

### Accessibility
- **HIG: Accessibility** - VoiceOver, Dynamic Type, Reduce Motion, color contrast
- **WCAG 2.1 AA**: 4.5:1 contrast ratio for normal text
- **SwiftUI**: `.accessibilityLabel()`, `.accessibilityValue()`, `.accessibilityAdjustableAction()`

### Performance (Blur/Material/Mesh)
- **WWDC 2023: Build for spatial computing** - Material performance considerations
- **WWDC 2024: What's new in SwiftUI** - MeshGradient performance tips
- **Instruments**: Time Profiler, Core Animation, GPU Driver
- **Guidelines**: Avoid stacking > 3 materials; use `.ultraThinMaterial` for overlays

---

## 4) Test Plan

### Unit Tests

| Area | Test Type | Coverage Target | Priority |
|------|-----------|-----------------|----------|
| CalculatorEngine | Correctness | 100% | Critical |
| HistoryService | Persistence | 90% | High |
| TabOrderStorage | Persistence | 100% | Medium |
| KeypadLayoutStorage | Persistence | 100% | Medium |
| ThemeManager | State | 80% | Medium |

### UI Tests

| Flow | Test Type | Devices | Priority |
|------|-----------|---------|----------|
| Calculator operations | Functional | All sizes | Critical |
| ArcSlider interaction | Functional | iPhone 17 | Critical |
| Tab reorder | Functional | iPhone 17 | Medium |
| Keypad edit mode | Functional | iPhone 17 | Medium |
| Theme switching | Screenshot | iPhone 17 | High |

### Accessibility Tests

| Check | Method | Pass Criteria |
|-------|--------|---------------|
| VoiceOver labels | Automated + Manual | All controls labeled |
| Touch targets | Automated | >= 44pt |
| Contrast ratios | Accessibility Inspector | >= 4.5:1 |
| Dynamic Type | Manual | Readable at XXXL |
| Reduce Motion | Manual | Static fallbacks work |

### Performance Tests

| Metric | Threshold | Test Method |
|--------|-----------|-------------|
| Scroll FPS | >= 60 | XCTest + Instruments |
| Animation jank | < 3ms drops | Time Profiler |
| Cold launch | < 1s | XCTest |
| Memory usage | < 100MB | Instruments |

### Test Execution Checklist

- [ ] Run `swift test` - all pass
- [ ] Run UI tests on iPhone SE (3rd gen) - smallest screen
- [ ] Run UI tests on iPhone 17 Pro Max - largest screen
- [ ] Run with Dynamic Type XXXL
- [ ] Run with VoiceOver enabled
- [ ] Run with Reduce Motion enabled
- [ ] Profile on physical device with Instruments

---

## 5) Risks & Decisions

### Risk 1: Customizable Tab Bar vs Apple Conventions

**Risk Level**: Medium

**Description**: iOS 18's `TabViewCustomization` allows reordering but has limitations. Custom tab bars risk breaking accessibility and platform consistency.

**Decision**: Use native `TabViewCustomization` API. Lock Calculator at position 1. Accept iOS's constraints rather than building custom tab bar.

**Mitigation**: If native API insufficient, document limitations and defer full customization to v2.

---

### Risk 2: Keypad Layout Editor Complexity

**Risk Level**: Medium-High

**Description**: Full drag-and-drop keypad editor is complex (many layouts, edge cases, persistence). Risks scope creep.

**Decision**: v1 = Minimal version (0 position swap only). Visual feedback with wiggle animation. If users want more, add in v2.

**Justification**: "Simple and premium over featureful and busy" - mission guardrail.

---

### Risk 3: Glass Visuals at High Dynamic Type

**Risk Level**: Medium

**Description**: Material blur can reduce contrast at high Dynamic Type sizes, making text unreadable.

**Decision**: Test at XXXL first. If contrast fails:
1. Reduce material opacity
2. Add subtle text shadows
3. Use `.regularMaterial` instead of `.ultraThinMaterial` for text backgrounds

**Fallback**: Readability > Aesthetics. Reduce glass effect before making text unreadable.

---

### Risk 4: Quick Access Widget API Limitations

**Risk Level**: Low

**Description**: iOS doesn't provide programmatic "add widget to home screen" API.

**Decision**: Widget tip should provide clear instructions rather than dead button. Change text to: "Add from Home Screen: Long-press, tap +, search prismCalc"

---

### Risk 5: ArcSlider Coordinate Space Fix

**Risk Level**: Low

**Description**: Changing coordinate space might affect gesture sensitivity.

**Decision**: Use named coordinate space. Test thoroughly on multiple devices. Maintain current haptic feedback behavior.

---

## v1 Non-Goals (Explicitly Not Building)

Per mission guardrails, these are **out of scope**:

1. **Scientific calculator mode** - Adds clutter, dilutes mission
2. **Programmer calculator mode** - Not everyday money math
3. **Graphing features** - Out of scope
4. **Heavy workflow features** - Keep it simple
5. **Full keypad rearrangement** - Too complex for v1
6. **Custom button sizes** - Unnecessary complexity
7. **tvOS support** - Post v1
8. **visionOS support** - Post v1

---

## Execution Order

**Phase 1** (M1 - Bugs): Fix trust-damaging issues first
1. M1-T1: Quick Access Widget fix (dead UI = trust damage)
2. M1-T2: ArcSlider drift fix
3. M1-T3: Theme propagation
4. M1-T4: Display spacing

**Phase 2** (M2 - Usability): Core UX improvements
1. M2-T1: Delete button
2. M2-T2: Breadcrumb expansion
3. M2-T3: Settings restructure
4. M2-T4: History notes

**Phase 3** (M4 - Polish): Run in parallel where possible
1. M4-T1: Dynamic Type pass
2. M4-T2: VoiceOver pass
3. M4-T3: Reduce Motion
4. M4-T4: Performance profiling
5. M4-T5: Haptics validation
6. M4-T6: Animation audit
7. M4-T7: Split polish

**Phase 4** (M3 - Customization): Lower priority
1. M3-T1: Menu order
2. M3-T2: Keypad layout (minimal)
3. M3-T3: Widget settings

**Phase 5** (M5 - Tests): Final hardening
1. M5-T1 through M5-T5

---

## Session Logging Protocol

Per `~/dev/.standards/AGENT-STANDARDS.md`:

- **15-minute cadence**: Update `~/obsidian-vault/01-Daily/YYYY-MM-DD.md`
- **Entry format**: `HH:MM - Claude-Code - prismCalc - {Task/Outcome}`
- **Standard AuADHD block** with colored labels
- **Email blast** via `send-status-email.py` at session end or major milestones

---

**Ready for execution. Begin with M1-T1 (Quick Access Widget fix).**
