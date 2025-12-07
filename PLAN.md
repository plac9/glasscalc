# PrismCalc iOS 18 Visual Overhaul - Implementation Plan

## Executive Summary

Transform PrismCalc's UI from iOS 17-style LinearGradient backgrounds and standard TabView into a cutting-edge iOS 18 experience using **MeshGradient**, **SF Symbol 6 animations**, **Zoom Navigation Transitions**, **Floating Tab Bar with Sidebar**, and **Scroll Effects**.

**Goal**: Deliver an EASY but AMAZING UI experience by intelligently applying iOS 18 features where they enhance usability without overwhelming users.

---

## Phase 1: MeshGradient Theming Architecture

### Current State
- `GlassTheme.swift` uses `[Color]` arrays for 6 themes
- `ContentView.swift` renders `LinearGradient` with animated start/end points
- Theme colors: Aurora, Calming Blues, Forest Earth, Soft Tranquil, Blue-Green, Midnight

### Target Architecture

#### 1.1 New MeshGradient Configuration Type
Create a new `MeshGradientConfig` struct that encapsulates all MeshGradient parameters:

```swift
// Sources/PrismCalc/DesignSystem/MeshGradientConfig.swift
public struct MeshGradientConfig: Sendable {
    let width: Int = 3   // 3x3 grid = 9 control points
    let height: Int = 3
    let points: [SIMD2<Float>]
    let colors: [Color]

    // Animation keyframes for point positions
    let animatedPoints: [[SIMD2<Float>]]
}
```

#### 1.2 Theme-Specific MeshGradient Definitions
Each theme gets a unique 3x3 mesh configuration:

| Theme | Grid | Colors | Animation Style |
|-------|------|--------|-----------------|
| Aurora | 3x3 | Blue→Purple→Cyan flow | Slow oscillating drift |
| Calming Blues | 3x3 | Cool blues centered | Gentle wave motion |
| Forest Earth | 3x3 | Greens to earth tones | Organic breathing |
| Soft Tranquil | 3x3 | Light pastels | Subtle shimmer |
| Blue-Green | 3x3 | Turquoise gradation | Fluid rotation |
| Midnight | 3x3 | Deep indigos | Slow pulse glow |

#### 1.3 Animated MeshGradient Background Component
Replace `backgroundGradient` in ContentView with new animated mesh:

```swift
// Sources/PrismCalc/DesignSystem/AnimatedMeshBackground.swift
struct AnimatedMeshBackground: View {
    @State private var phase: CGFloat = 0
    let config: MeshGradientConfig

    var body: some View {
        TimelineView(.animation) { timeline in
            MeshGradient(
                width: 3,
                height: 3,
                points: animatedPoints(for: timeline.date),
                colors: config.colors
            )
        }
    }

    private func animatedPoints(for date: Date) -> [SIMD2<Float>] {
        // Use sine/cosine waves to oscillate interior points
        // Edge points stay fixed, center 4 points drift
    }
}
```

#### 1.4 GlassTheme Updates
Extend `GlassTheme.swift`:

```swift
// Add to GlassTheme
@MainActor
public static var meshConfig: MeshGradientConfig {
    switch currentTheme {
    case .aurora: return auroraMeshConfig
    case .calmingBlues: return calmingBluesMeshConfig
    // ... other themes
    }
}

private static let auroraMeshConfig = MeshGradientConfig(
    points: [
        // 3x3 grid positions
        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
        [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
    ],
    colors: [
        .blue, .purple, .cyan,
        .purple.opacity(0.8), Color(hex: "7B68EE"), .cyan.opacity(0.8),
        .blue.opacity(0.6), .purple.opacity(0.6), .cyan.opacity(0.6)
    ]
)
```

### Files to Modify
- **NEW**: `Sources/PrismCalc/DesignSystem/MeshGradientConfig.swift`
- **NEW**: `Sources/PrismCalc/DesignSystem/AnimatedMeshBackground.swift`
- **MODIFY**: `Sources/PrismCalc/DesignSystem/GlassTheme.swift`
- **MODIFY**: `Sources/PrismCalc/App/ContentView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/Settings/SettingsView.swift` (theme previews)

---

## Phase 2: SF Symbol 6 Animation Integration

### Target Animations by Context

#### 2.1 Calculator Buttons - Operation Feedback
| Action | Symbol | Effect |
|--------|--------|--------|
| Equals pressed | `equal` | `.bounce` on result |
| Operation selected | `plus`/`minus`/etc | `.pulse` highlight |
| Clear | `xmark.circle` | `.wiggle` confirmation |
| Backspace | `delete.left` | `.breathe` subtle |

#### 2.2 Tab Bar Icons - Selection & State
| Tab | Symbol | Effect on Select |
|-----|--------|------------------|
| Calculator | `plus.forwardslash.minus` | `.bounce.down` |
| Tip | `dollarsign.circle` | `.wiggle` |
| History | `clock.arrow.circlepath` | `.rotate` |
| Settings | `gearshape` | `.rotate` partial |

#### 2.3 Feature-Specific Animations
| Feature | Symbol | Trigger | Effect |
|---------|--------|---------|--------|
| Tip Calculator | `percent` | Tip calculated | `.bounce` |
| Unit Converter | `arrow.left.arrow.right` | Swap units | `.rotate.byLayer` |
| Split Bill | `person.2` | Add person | `.wiggle.forward` |
| Discount | `tag` | Discount applied | `.bounce.up` |

#### 2.4 Implementation Pattern

```swift
// GlassButton enhancement
struct GlassButton: View {
    @State private var triggerEffect = false
    let symbolEffect: SymbolEffect?

    var body: some View {
        Button { ... } label: {
            Image(systemName: icon)
                .symbolEffect(symbolEffect, value: triggerEffect)
        }
    }
}
```

### Files to Modify
- **MODIFY**: `Sources/PrismCalc/DesignSystem/GlassButton.swift`
- **MODIFY**: `Sources/PrismCalc/App/ContentView.swift` (tab icons)
- **MODIFY**: `Sources/PrismCalc/Features/Calculator/CalculatorView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/TipCalculator/TipCalculatorView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/UnitConverter/UnitConverterView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/SplitBill/SplitBillView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/DiscountCalculator/DiscountCalculatorView.swift`

---

## Phase 3: Floating Tab Bar with Sidebar

### Current State
- Standard `TabView` with 7 tabs
- UITabBarAppearance customization for glass effect
- Bottom tab bar on all devices

### Target Architecture

#### 3.1 Tab Structure with Sections

```swift
// ContentView.swift restructure
TabView {
    // Primary calculators (always visible in tab bar)
    Tab("Calculator", systemImage: "plus.forwardslash.minus") {
        CalculatorView()
    }

    Tab("History", systemImage: "clock.arrow.circlepath") {
        HistoryView()
    }

    // Pro features in collapsible section (sidebar only)
    TabSection("Pro Features") {
        Tab("Tip", systemImage: "dollarsign.circle") {
            ProGatedView { TipCalculatorView() }
        }
        Tab("Discount", systemImage: "tag") {
            ProGatedView { DiscountCalculatorView() }
        }
        Tab("Split", systemImage: "person.2") {
            ProGatedView { SplitBillView() }
        }
        Tab("Convert", systemImage: "arrow.left.arrow.right") {
            ProGatedView { UnitConverterView() }
        }
    }

    // Settings with search role
    Tab("Settings", systemImage: "gearshape", role: .search) {
        SettingsView()
    }
}
.tabViewStyle(.sidebarAdaptable)
.tabViewCustomization($tabCustomization)
```

#### 3.2 Size Class Handling
- **iPhone (Compact)**: Floating tab bar at bottom with 4 primary tabs
- **iPad (Regular)**: Sidebar with full tab sections, collapsible

#### 3.3 Tab Customization Persistence

```swift
@AppStorage("tabCustomization")
private var tabCustomization = TabViewCustomization()
```

### Files to Modify
- **MODIFY**: `Sources/PrismCalc/App/ContentView.swift` (major restructure)
- **MODIFY**: `Sources/PrismCalc/App/PrismCalcApp.swift` (AppStorage)

---

## Phase 4: Zoom Navigation Transitions

### Target Interactions

#### 4.1 History Entry → Detail View (NEW)
When tapping a history entry, zoom into a detail view:

```swift
// HistoryView.swift
@Namespace private var historyNamespace

// In historyCard()
GlassCard { ... }
    .matchedTransitionSource(id: entry.id, in: historyNamespace)
    .onTapGesture {
        selectedEntry = entry
    }

// Detail sheet/navigation
.navigationDestination(item: $selectedEntry) { entry in
    HistoryDetailView(entry: entry)
        .navigationTransition(.zoom(sourceID: entry.id, in: historyNamespace))
}
```

#### 4.2 Theme Preview → Theme Detail (NEW)
In SettingsView, zoom into full-screen theme preview:

```swift
// SettingsView.swift
@Namespace private var themeNamespace

// Theme card
themeCard(theme)
    .matchedTransitionSource(id: theme.id, in: themeNamespace)

// Full preview
.fullScreenCover(item: $previewTheme) { theme in
    ThemePreviewView(theme: theme)
        .navigationTransition(.zoom(sourceID: theme.id, in: themeNamespace))
}
```

#### 4.3 Calculator Display → Expanded View (Optional)
Zoom the display area when tapping for copy/edit:

```swift
// GlassDisplay enhancement
.matchedTransitionSource(id: "display", in: calculatorNamespace)
```

### New Files
- **NEW**: `Sources/PrismCalc/Features/History/HistoryDetailView.swift`
- **NEW**: `Sources/PrismCalc/Features/Settings/ThemePreviewView.swift`

### Files to Modify
- **MODIFY**: `Sources/PrismCalc/Features/History/HistoryView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/Settings/SettingsView.swift`

---

## Phase 5: Scroll Effects System

### Target Effects

#### 5.1 History List - Parallax Cards

```swift
// HistoryView.swift
LazyVStack {
    ForEach(filteredEntries) { entry in
        historyCard(entry)
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0.7)
                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                    .offset(y: phase.isIdentity ? 0 : phase.value * 20)
            }
    }
}
```

#### 5.2 Settings Sections - Fade on Scroll

```swift
// SettingsView.swift
ScrollView {
    VStack {
        ForEach(sections) { section in
            sectionView(section)
                .scrollTransition(.animated) { content, phase in
                    content
                        .opacity(phase.isIdentity ? 1 : 0.5)
                        .blur(radius: phase.isIdentity ? 0 : 2)
                }
        }
    }
}
```

#### 5.3 Calculator - Stretchy Header Effect
Show expanded display that compresses on scroll (if we add scrollable features):

```swift
.onScrollGeometryChange(for: CGFloat.self) { proxy in
    proxy.contentOffset.y
} action: { oldValue, newValue in
    displayScale = max(0.8, 1 - (newValue / 200))
}
```

#### 5.4 Filter Chips - Horizontal Scroll Fade

```swift
// HistoryView.swift filterSection
ScrollView(.horizontal) {
    HStack {
        ForEach(types) { type in
            filterChip(type)
                .scrollTransition(.interactive) { content, phase in
                    content.opacity(phase.isIdentity ? 1 : 0.5)
                }
        }
    }
}
```

### Files to Modify
- **MODIFY**: `Sources/PrismCalc/Features/History/HistoryView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/Settings/SettingsView.swift`
- **MODIFY**: `Sources/PrismCalc/Features/Calculator/CalculatorView.swift` (optional)

---

## Implementation Order

### Stage 1: Foundation (MeshGradient + Tab Bar)
1. Create `MeshGradientConfig.swift`
2. Create `AnimatedMeshBackground.swift`
3. Update `GlassTheme.swift` with mesh configs
4. Restructure `ContentView.swift` with new TabView + MeshGradient

**Validation**: App builds, displays animated mesh background, floating tab bar works

### Stage 2: Micro-Interactions (SF Symbols)
5. Enhance `GlassButton.swift` with symbolEffect support
6. Add tab icon animations in `ContentView.swift`
7. Add feature-specific animations in each feature view

**Validation**: Buttons animate, tab icons respond to selection

### Stage 3: Navigation Polish (Zoom Transitions)
8. Create `HistoryDetailView.swift`
9. Add zoom transition to `HistoryView.swift`
10. Create `ThemePreviewView.swift`
11. Add zoom transition to `SettingsView.swift`

**Validation**: Tapping history entries zooms to detail, theme cards zoom to preview

### Stage 4: Scroll Refinement
12. Add `scrollTransition` to history cards
13. Add scroll effects to settings sections
14. Add horizontal scroll fade to filter chips

**Validation**: Scrolling feels polished with subtle parallax/fade effects

### Stage 5: Testing & Refinement
15. Update unit tests for new components
16. Accessibility audit (VoiceOver, Reduce Motion)
17. Performance profiling (MeshGradient animation battery impact)
18. iPad layout testing with sidebar

---

## Risk Mitigation

### Performance Concerns
- **MeshGradient Animation**: Use `TimelineView(.animation)` with 30fps cap
- **Scroll Effects**: Throttle `onScrollGeometryChange` updates
- **Symbol Effects**: Only active on interaction, not continuous

### Accessibility
- Respect `accessibilityReduceMotion` preference
- Provide static fallbacks for all animations
- Maintain sufficient color contrast in mesh gradients

### Backward Compatibility
- All features require iOS 18+ (already set in project.yml)
- No fallback needed for iOS 17

---

## Success Metrics

1. **Visual Impact**: Background feels organic and alive, not flat
2. **Interaction Delight**: Button presses feel responsive with symbol feedback
3. **Navigation Clarity**: Zoom transitions maintain spatial context
4. **Scroll Fluidity**: Lists feel premium with parallax effects
5. **Performance**: Maintain 60fps, no battery drain concerns

---

## Documentation Updates Required

After implementation, update:
- `/Users/patricklaclair/obsidian-vault/.vault/projects/prismcalc/INDEX.md`
- `/Users/patricklaclair/obsidian-vault/.vault/projects/prismcalc/changelog.md`
- Daily note at `/Users/patricklaclair/obsidian-vault/01-Daily/`

---

*Plan created: 2025-12-06 20:45*
*Ready for implementation approval*
