# PrismCalc - Architecture

**Last Updated**: 2025-12-19

## Overview

PrismCalc is a glassmorphic calculator app built with 100% SwiftUI, targeting iOS 18+. The architecture emphasizes:
- **UI First**: Stunning glassmorphism with layered materials
- **Trust**: Correct math with comprehensive tests
- **Modern Swift**: Swift 6.0 with strict concurrency
- **Freemium**: Core free, social tools Pro

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PrismCalcApp                          │
│                  (App Entry Point)                       │
└─────────────────────────┬───────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│                    ContentView                           │
│               (Tab-based Navigation)                     │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │Calculator│ │  Tools   │ │ History  │ │ Settings │   │
│  │  (Free)  │ │  (Pro)   │ │(Free/Pro)│ │ (All)    │   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│                  Design System Layer                     │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐             │
│  │GlassTheme │ │GlassButton│ │ GlassCard │             │
│  │(6 themes) │ │           │ │           │             │
│  └───────────┘ └───────────┘ └───────────┘             │
│  ┌───────────┐ ┌───────────┐                           │
│  │ ArcSlider │ │MeshGradient│                          │
│  │           │ │  Config   │                           │
│  └───────────┘ └───────────┘                           │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│                    Core Services                         │
│  ┌────────────────┐ ┌────────────────┐                 │
│  │CalculatorEngine│ │ HistoryService │                 │
│  │ (Math Logic)   │ │ (SwiftData)    │                 │
│  └────────────────┘ └────────────────┘                 │
│  ┌────────────────┐ ┌────────────────┐                 │
│  │ StoreKitService│ │CurrencyService │                 │
│  │ (IAP/Pro)      │ │ (Frankfurter)  │                 │
│  └────────────────┘ └────────────────┘                 │
└─────────────────────────────────────────────────────────┘
```

## Key Design Decisions

### 1. Glassmorphism Implementation

**Decision**: Use SwiftUI's native `.material` modifiers with `MeshGradient` backgrounds.

**Rationale**:
- Native performance (no custom blur shaders)
- Automatic adaptation to reduce-motion preference
- Consistent with iOS design language

**Implementation**:
```swift
// Layered glass stack
ZStack {
    MeshGradient(...)  // Animated background
    .ultraThinMaterial // Frosted base
    .regularMaterial   // Glass cards
    .thinMaterial      // Buttons
}
```

### 2. Calculator Engine (Apple-Style Percent)

**Decision**: Implement Apple Calculator's percent behavior with pending operations.

**Rationale**:
- Users expect Apple-style behavior
- Trust is critical for money math
- Comprehensive test coverage ensures correctness

**Behavior**:
- `100 + 10%` = 110 (10% of 100 added)
- `100 - 10%` = 90 (10% of 100 subtracted)
- `10%` standalone = 0.1 (conversion only)

### 3. Theme System

**Decision**: 6 hardcoded themes with `MeshGradient` configurations.

**Rationale**:
- Pro feature with clear value proposition
- `MeshGradient` enables unique animated backgrounds
- Themes share color palette research with netcalc

**Themes**:
| Theme | Colors | Mood |
|-------|--------|------|
| Aurora | Blue/Purple/Cyan | Dynamic, energetic |
| Calming Blues | #83BCD4 | Peaceful |
| Forest Earth | #4E785E | Grounded |
| Soft Tranquil | #C5E3F6 | Maximum calm |
| Blue-Green | #00CEC8 | Modern, fresh |
| Midnight | Deep blacks | Dark mode |

### 4. Freemium Model (StoreKit 2)

**Decision**: Core calculator free, social tools behind $2.99 one-time purchase.

**Rationale**:
- Low barrier to entry
- Social tools (tip/split) have clear Pro value
- One-time purchase avoids subscription fatigue

**Gating**:
```swift
// Free
- Basic calculator
- History (10 items)
- Aurora theme
- Basic widget

// Pro ($2.99)
- Tip Calculator
- Discount Calculator
- Split Bill
- Unit Converter
- Unlimited history
- All 6 themes
- All widgets
- Alternate icons
```

### 5. SwiftData for History

**Decision**: Use SwiftData with `ModelContainer` for calculation history.

**Rationale**:
- Native iOS 17+ persistence
- Automatic iCloud sync for Pro users
- Simple model definition

**Model**:
```swift
@Model
class CalculationEntry {
    var expression: String
    var result: String
    var timestamp: Date
}
```

### 6. Widget Architecture

**Decision**: Shared App Group for widget data access.

**Rationale**:
- Widget extension cannot access app's SwiftData directly
- App Group enables shared UserDefaults
- Lightweight sync for widget display

**App Group**: `group.com.laclairtech.prismcalc`

## Concurrency Strategy

### Swift 6.0 Strict Concurrency

**Approach**:
- All UI updates on `@MainActor`
- Services marked with appropriate isolation
- No data races (compiler-verified)

**Key Annotations**:
```swift
@MainActor
final class CalculatorViewModel: ObservableObject { ... }

@MainActor
public enum GlassTheme: Sendable { ... }
```

## Testing Strategy

### Test Pyramid

```
        ┌───────────┐
        │  UI Tests │  ← Screenshot tests for App Store
        │    (10)   │
        └───────────┘
       ┌─────────────┐
       │Integration  │  ← Service integration
       │   Tests     │
       └─────────────┘
      ┌───────────────┐
      │   Unit Tests  │  ← Calculator engine, models
      │     (90+)     │
      └───────────────┘
```

### Critical Test Coverage

- **CalculatorEngine**: All operations, edge cases
- **Percent Behavior**: Apple-style verification
- **Error Clearing**: UX flow tests
- **Theme System**: Color/gradient verification

## Performance Considerations

### Potential Bottlenecks

1. **MeshGradient animation**: Heavy on older devices
   - Mitigation: Reduce animation complexity, respect reduce-motion

2. **Material blur**: GPU-intensive
   - Mitigation: Use system materials (hardware-optimized)

3. **Currency API calls**: Network latency
   - Mitigation: Cache rates, background refresh

### Monitoring

- Instruments Time Profiler for UI thread
- Memory usage during theme transitions
- Battery impact of animations

## Security Considerations

- No sensitive data stored (calculator history only)
- StoreKit 2 handles payment security
- Currency API uses HTTPS only
- No user accounts or authentication

## Future Considerations

### Potential Enhancements
- Watch app (simple calculator)
- Mac Catalyst optimization
- Additional themes (seasonal?)
- History export/share

### Technical Debt
- AppIcon warning (cosmetic)
- iPad layout optimization (post-iOS launch)
- macOS polish (post-iOS launch)

---

**Note**: This document captures architectural decisions. Update when making significant changes.
