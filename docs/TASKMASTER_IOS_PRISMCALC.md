# prismCalc iOS Taskmaster

**Last Updated**: 2025-12-20
**Implementation Plan**: `docs/IMPLEMENTATION_PLAN_V2.md`
**Scope**: iOS-first only. iPadOS/macOS polish happens after iOS ships.

---

## Mission Statement (v1)

> "prismCalc is for everyday iPhone users who want a gorgeous, trustworthy calculator for money math without clutter."

**Primary purpose**: Trusted daily money math (tips, discounts, splits, conversions) delivered through premium glass visuals.
**Secondary purpose**: Apple-native polish that makes routine calculations feel delightful, not utilitarian.
**Non-goals (v1)**: Scientific/programmer/graphing/heavy workflow features that add clutter.

---

## Must Not Fail

- Math correctness (trust is everything)
- Readability (glass cannot mean low contrast)
- Performance (blur effects can be heavy)
- Accessibility (VoiceOver labels, Dynamic Type)

---

## Milestone Status

| Milestone | Title | Status | Progress |
|-----------|-------|--------|----------|
| **M1** | Fix Broken/Buggy UI | ✅ Complete | 4/4 |
| **M2** | Mission-Critical Usability | ✅ Complete | 4/4 |
| **M3** | Customization Features | ✅ Complete | 3/3 |
| **M4** | Apple-Native Polish + A11y | 🟡 In Progress | 6/7 (T4 needs device) |
| **M5** | Tests and Hardening | ✅ Complete | 5/5 |

---

## M1: Fix Broken/Buggy UI (CRITICAL)

Dead UI damages trust. Fix these first.

### M1-T1: Fix Quick Access Widget No-Op
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **File**: `Sources/PrismCalc/Features/History/HistoryView.swift`
- **Issue**: TipKit tip shows but tapping does nothing
- **Acceptance**:
  - [x] Widget tip either adds widget OR clearly instructs user
  - [x] No dead/confusing UI elements
  - [x] Widget tip dismisses appropriately

### M1-T2: Fix ArcSlider Alignment Drift
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **File**: `Sources/PrismCalc/DesignSystem/ArcSlider.swift`
- **Issue**: Drag gesture drifts when parent scrolls
- **Acceptance**:
  - [x] ArcSlider works correctly at any scroll position
  - [x] No drift when scrolling Tip/Discount screens
  - [x] Thumb follows finger accurately

### M1-T3: Fix Theme Propagation (Tip/Discount)
- **Category**: Mission-supporting
- **Status**: ✅ Complete (Already Working)
- **Files**: `TipCalculatorView.swift`, `DiscountCalculatorView.swift`
- **Issue**: Graphics/colors may not change with themes
- **Note**: Audited - theme propagation already correctly implemented via GlassTheme.primary/secondary computed properties
- **Acceptance**:
  - [x] All 6 themes display correctly in Tip Calculator
  - [x] All 6 themes display correctly in Discount Calculator
  - [x] ArcSlider gradient matches current theme

### M1-T4: Reduce Calculator Display Black Space
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **File**: `Sources/PrismCalc/Features/Calculator/CalculatorView.swift`
- **Issue**: Excessive black space above/below display
- **Acceptance**:
  - [x] Display area is balanced (max 28% screen / 180pt cap)
  - [x] Works on all iPhone sizes
  - [x] Room left for breadcrumb expansion (40% top padding redistribution)

---

## M2: Mission-Critical Usability

### M2-T1: Add Single-Digit Delete Button
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **Files**: `CalculatorView.swift`, `CalculatorViewModel.swift`
- **Acceptance**:
  - [x] User can delete last entered digit (backspace button in display area)
  - [x] Works with operations pending (uses existing backspace() method)
  - [x] Clear haptic feedback (light impact)
  - [x] VoiceOver announces "delete" (label + hint)

### M2-T2: Expand Breadcrumb/Expression Display
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **Files**: `GlassDisplay.swift`, `CalculatorViewModel.swift`
- **Acceptance**:
  - [x] Full expression visible (e.g., "100 + 10% =")
  - [x] Expression scrolls if needed (horizontal ScrollView with .defaultScrollAnchor(.trailing))
  - [x] Clear visual hierarchy (textSecondary, medium weight)
  - [x] Dynamic Type support (@ScaledMetric for expressionFontSize)

### M2-T3: Restructure Settings Screen
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Files**: `SettingsView.swift`, `ThemePickerView.swift` (new)
- **Acceptance**:
  - [x] Themes as drill-in menu (NavigationLink to ThemePickerView)
  - [x] Branding moved to About (at bottom)
  - [x] Pro unlock visible near bottom (only shows when not Pro)
  - [x] Customization entries ready (Tab Order, Widgets placeholders)

### M2-T4: Add History Note Option
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Files**: `TipCalculatorView.swift`, `HistoryEntry.swift`, `HistoryService.swift`, `HistoryView.swift`
- **Acceptance**:
  - [x] "Add Note" option before save (text field with note.text icon)
  - [x] Note is optional (empty string → nil)
  - [x] Note displays in history (with icon, theme-colored)

---

## M3: Customization Features

### M3-T1: Customizable Bottom Menu Order
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Files**: `ContentView.swift`, `SettingsView.swift`
- **Implementation Notes** (2025-12-19):
  - iOS 18 TabViewCustomization with sidebarAdaptable provides native reordering
  - Calculator tab locked with `.customizationBehavior(.disabled, for: .sidebar, .tabBar)`
  - Reset button in Settings clears UserDefaults key "tabCustomization"
  - Platform-guarded (#if os(iOS)) for macOS compatibility
- **Acceptance**:
  - [x] Long-press enters edit mode (iOS 18 built-in on iPad sidebar)
  - [x] Calculator locked at position 1
  - [x] Order persists (@AppStorage)
  - [x] Reset option in Settings

### M3-T2: Customizable Keypad Layout (Minimal v1)
- **Category**: Mission-risk (minimal scope)
- **Status**: ✅ Complete
- **Files**: `CalculatorView.swift`, `SettingsView.swift`
- **Scope**: 0 position swap only (not full rearrangement)
- **Implementation Notes** (2025-12-19):
  - Simplified to Settings toggle approach (aligned with "minimal scope")
  - @AppStorage("zeroOnRight") persists preference
  - CalculatorView conditionally renders bottom row based on setting
  - Skip complex 5-second hold mode for v1 - can add later if users request
- **Acceptance**:
  - [x] Settings toggle for 0 position (replaced 5-second hold for minimal scope)
  - [x] Layout updates instantly on toggle
  - [x] Setting persists (@AppStorage)
  - [x] Accessible with VoiceOver labels

### M3-T3: Widget Management in Settings
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Files**: `SettingsView.swift`, `WidgetSettingsView.swift` (new)
- **Implementation Notes** (2025-12-19):
  - New WidgetSettingsView with step-by-step add instructions
  - Visual previews of small, medium, and large widget layouts
  - Tips section with widget usage guidance
  - NavigationLink from Settings Customization section
- **Acceptance**:
  - [x] Settings > Widgets entry
  - [x] Widget previews (all 3 sizes with mockup content)
  - [x] Add instructions (4-step numbered guide)

---

## M4: Apple-Native Polish + Accessibility

### M4-T1: Dynamic Type Full Pass
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **Acceptance**:
  - [x] All screens readable at XXXL (semantic font styles + @ScaledMetric)
  - [x] No text truncation (minimumScaleFactor used appropriately)
  - [x] Touch targets >= 44pt (verified in all interactive elements)

### M4-T2: VoiceOver Full Pass
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **Acceptance**:
  - [x] Every control has label
  - [x] Logical navigation order
  - [x] ArcSlider adjustable via VoiceOver

### M4-T3: Reduce Motion Support
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Acceptance**:
  - [x] `accessibilityReduceMotion` checked
  - [x] Static fallbacks for animations
- **Implementation Notes**:
  - All 14 files updated with `@Environment(\.accessibilityReduceMotion)`
  - ScrollTransitions use conditional values: `reduceMotion || phase.isIdentity ? 1 : 0.85`
  - Symbol effects use `@ViewBuilder` to conditionally apply (no `.none` for Discrete/IndefiniteSymbolEffect)
  - ContentTransitions use `.identity` when reduce motion enabled
  - All `withAnimation` blocks wrapped in conditionals

### M4-T4: Performance Profiling (Instruments)
- **Category**: Mission-critical
- **Status**: 🟡 Code Audit Complete (Instruments Pending)
- **Code Audit Findings** (2025-12-19):
  - ✅ AnimatedMeshBackground uses 30fps TimelineView (efficient)
  - ✅ LazyVStack for History entries (virtualization)
  - ✅ All ForEach use proper id: for stable identity
  - ✅ Materials (43 uses) are GPU-accelerated
  - ✅ Reduce motion disables animations entirely
  - ⏳ Full Instruments profiling requires physical device
- **Acceptance**:
  - [ ] 60fps during normal use (needs device testing)
  - [ ] No frame drops > 3ms (needs device testing)
  - [ ] Reasonable GPU usage (needs device testing)

### M4-T5: Validate Haptics Best Practice
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Note**: Current haptics are "excellent" - preserve and document
- **Audit Findings** (2025-12-19):
  - **Selection haptics** (`.selection`): Tab switching, category changes, filter chips, theme picks - ✅ HIG compliant
  - **Success haptics** (`.success`): Purchase success, value celebrations on calculations - ✅ Provides responsiveness
  - **Error haptics** (`.error`): Purchase failures - ✅ HIG compliant
  - **Impact haptics** (`.impact(flexibility: .soft)`): Button presses - ✅ Subtle, appropriate
  - **Light impact** (`UIImpactFeedbackGenerator(.light)`): ArcSlider steps, calculator backspace - ✅ Subtle feedback
  - **Pre-warmed generators**: GlassButton uses static pre-warmed generator - ✅ Performance best practice
  - **No spam detected**: Value-change triggers fire appropriately for immediate feedback
- **Acceptance**:
  - [x] Haptics match Apple HIG
  - [x] No haptic spam

### M4-T6: Glass Number Animation Audit
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Audit Findings** (2025-12-19):
  - 8 number animation locations found
  - All use `.contentTransition(.numericText())`
  - All respect reduce motion: `reduceMotion ? .identity : .numericText()`
  - All have paired `.animation(reduceMotion ? nil : ...)` modifiers
  - Files: GlassDisplay, ArcSlider, TipCalculatorView, SplitBillView, DiscountCalculatorView, UnitConverterView
- **Acceptance**:
  - [x] Uses `.contentTransition(.numericText())`
  - [x] Respects Reduce Motion
  - [x] Performance acceptable (TimelineView-based, not continuous)

### M4-T7: Split Screen Visual Polish
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **File**: `SplitBillView.swift`
- **Audit Findings** (2025-12-19):
  - ✅ Glass layering consistent: GlassCard (inputs), ultraThinMaterial (sliders), thinMaterial (buttons), regularMaterial (results)
  - ✅ Hero "Each Person Pays" uses intentional primary-colored stroke to emphasize key answer
  - ✅ Breakdown section uses standard GlassCard matching other views
  - ✅ scrollTransition, contentTransition, reduce motion all implemented
  - Note: Primary stroke on hero is deliberate UX - answers "how much do I pay?" prominently
- **Acceptance**:
  - [x] Visual consistency with Tip/Discount
  - [x] Proper glass layering

---

## M5: Tests and Hardening

### M5-T1: Calculation Engine Correctness Tests
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **Target**: 100% coverage of CalculatorEngine
- **Implementation Notes** (2025-12-19):
  - Added 10 new edge case tests (110 total)
  - Covers: zero handling, negatives, decimal precision, scientific notation boundaries
  - All code paths in CalculatorEngine now tested

### M5-T2: Persistence Tests
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **Target**: All @AppStorage values round-trip correctly
- **Implementation Notes** (2025-12-19):
  - 8 new tests in PersistenceTests.swift (118 total)
  - Covers: zeroOnRight, tabCustomization, SharedDataService
  - Tests saveLastCalculation, saveRecentHistory, clearHistory round-trips

### M5-T3: Theme Propagation Tests
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Target**: Screenshot baseline for all 6 themes
- **Implementation Notes** (2025-12-19):
  - ThemeTests.swift with 12 unit tests (130 total)
  - Tests cover: theme enumeration, unique IDs, pro status, gradients, spacing, corner radius, button sizes
  - ScreenshotTests.swift updated with testCaptureAllThemes() for UI baseline

### M5-T4: Accessibility Automated Tests
- **Category**: Mission-critical
- **Status**: ✅ Complete
- **Target**: No unlabeled interactive elements
- **Implementation Notes** (2025-12-19):
  - AccessibilityTests.swift with 12 tests (142 total)
  - Tests cover: GlassButton labels for digits/operators/special buttons
  - VoiceOver-friendly display formatting verified
  - Touch target minimums (44pt) verified
  - Theme color definitions verified
  - Widget/History entry structure verified

### M5-T5: UI Flow Tests for Customization
- **Category**: Mission-supporting
- **Status**: ✅ Complete
- **Target**: Entry/exit/save/cancel flows work
- **Implementation Notes** (2025-12-20):
  - CustomizationFlowTests.swift with 7 UI flow tests
  - Tests cover: Settings navigation, Theme selection, Keypad layout toggle
  - Widget settings navigation, Reset tab order, Calculator tab locking
  - Pro features accessibility verified
  - **xcodebuild verified**: All 9 UI tests passing on iPhone 17 Pro simulator
  - Total test suite: 142 unit tests + 9 UI tests = **151 tests**

---

## Execution Order

```
Phase 1 (M1 - Bugs): Fix trust-damaging issues
├── M1-T1: Quick Access Widget ← START HERE
├── M1-T2: ArcSlider drift
├── M1-T3: Theme propagation
└── M1-T4: Display spacing

Phase 2 (M2 - Usability): Core UX
├── M2-T1: Delete button
├── M2-T2: Breadcrumb expansion
├── M2-T3: Settings restructure
└── M2-T4: History notes

Phase 3 (M4 - Polish): Parallel where possible
├── M4-T1: Dynamic Type pass
├── M4-T2: VoiceOver pass
├── M4-T3: Reduce Motion
├── M4-T4: Performance profiling
├── M4-T5: Haptics validation
├── M4-T6: Animation audit
└── M4-T7: Split polish

Phase 4 (M3 - Customization): Lower priority
├── M3-T1: Menu order
├── M3-T2: Keypad layout (minimal)
└── M3-T3: Widget settings

Phase 5 (M5 - Tests): Final hardening
└── M5-T1 through M5-T5
```

---

## Session Logging Protocol

Per `~/dev/.standards/AGENT-STANDARDS.md`:

**15-minute cadence**: Update daily note with AuADHD-friendly block:
```markdown
HH:MM - Claude-Code - prismCalc - {Task/Outcome}
- <span style="color:#9C7CE5;font-weight:600">Agent:</span> Claude-Code — prismCalc
- <span style="color:#42A5F5;font-weight:600">Now:</span> {current task}
- <span style="color:#66BB6A;font-weight:600">Status:</span> {in progress | blocked | complete}
- <span style="color:#FFB74D;font-weight:600">Next:</span> {single next action}
- <span style="color:#BA68C8;font-weight:600">Changes:</span> {files/commits}
- <span style="color:#EF5350;font-weight:600">Current Blockers:</span> {list or "None"}
- <span style="color:#78909C;font-weight:600">Debt:</span> {follow-ups or "None"}
```

**Email updates** at major milestones via:
```bash
python3 ~/dev/.standards/send-status-email.py \
  --agent Claude-Code \
  --focus "prismCalc M1" \
  --status "in progress" \
  --next "M1-T1 Quick Access Widget" \
  --blockers "None" \
  --changes "files touched" \
  --debt "None"
```

---

## Notes

- iOS behavior target: immediate-execution calculator, Apple-style percent
- Haptics are excellent - preserve current implementation
- Glass visuals must remain readable at high Dynamic Type
- Converter framed as money-adjacent (currency anchored) to stay on mission
- v1 non-goals: scientific, programmer, graphing, full keypad rearrangement
