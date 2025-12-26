# Platform Parity Checklist

Track platform parity against the iOS baseline using a consistent 4-column checklist.

Legend: `[x]` done, `[~]` in progress, `[ ]` not started

## iOS (baseline)

| Checklist Item | Status | Evidence/Notes | Next Action |
| --- | --- | --- | --- |
| Calculator layout + glass display | [x] | Baseline UI reference | Maintain as baseline |
| Tab navigation (5 tabs + More) | [x] | TabView configuration | Keep aligned |
| Pro gating + StoreKit 2 | [~] | Present in code; build OK | Verify purchase flow |
| History (last 10 free + Pro unlock) | [x] | Free tier now shows last 10 with upgrade CTA | Validate limits + sync |
| Themes + high-contrast toggle | [~] | Theme system exists | Validate contrast toggle |
| Widgets (iOS) | [~] | Widget visuals updated with glass styling | Capture updated widget screenshots |
| Screenshot automation (iPhone) | [x] | `screenshots/automated/2025-12-26-iphone-17/` | Review for quality |

## iPadOS (needs parity polish)

| Checklist Item | Status | Evidence/Notes | Next Action |
| --- | --- | --- | --- |
| Adaptive layout (spacing + scale) | [~] | Updated two-column threshold + spacing tuning | Review layout + typography |
| Two-column layout for Pro tools | [~] | AdaptiveColumns spacing tightened | Validate spacing on iPad |
| Sidebar/Tab behavior | [x] | `.sidebarAdaptable` in ContentView | Confirm iPad UX |
| Pro feature screens (Tip/Split/Discount) | [~] | Spacing tightened | Refit card sizes if needed |
| History presentation | [~] | Two-column layout applied | Validate list density |
| History density + filter placement | [~] | List spacing tightened for iPad | Verify readability |
| Glass effects consistency | [~] | Mostly aligned | Fix edge artifacts |
| Widgets (iPad) | [~] | Shared iOS widgets | Validate sizes |
| Screenshot automation (iPad) | [x] | `screenshots/automated/2025-12-26-ipad-13/` | Review for quality |

## macOS (native)

| Checklist Item | Status | Evidence/Notes | Next Action |
| --- | --- | --- | --- |
| Compact window sizing | [x] | Snap width 320 | Validate minimum UX |
| Expanded history panel | [~] | Snap width 644 | Confirm no dead space after snap enforcement |
| History panel toggle | [x] | Edge toggle + hover | Verify discoverability |
| "Designed for iPad" distribution disabled | [x] | iOS target `SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = NO` | Keep native-only listing |
| Bottom glass tab bar (auto-hide) | [~] | Readability tuned (contrast + sizing) | Validate in app |
| macOS-specific UI polish | [~] | Spacing tightened | Refine typography/spacing |
| Widgets (macOS) | [~] | Native widget target | Validate visuals |
| Snap sizing screenshots | [x] | `screenshots/automated/2025-12-26-macos-snap/` | Review for quality |

## watchOS (companion)

| Checklist Item | Status | Evidence/Notes | Next Action |
| --- | --- | --- | --- |
| Basic calculator UI | [x] | WatchContentView implemented | Verify tap feel |
| Glass button styling | [~] | Depth/contrast tuning applied | Validate on device |
| Feature parity scope (Tip/Split/Discount) | [~] | Watch tool pages use calculator input | Refine layout/flow |
| History (last 10 or summary) | [x] | Tab view with persisted last-10 entries | Tune density/typography |
| Watch-specific interaction cues | [~] | Tap haptics + long-press backspace | Evaluate for gestures + errors |
| Widgets (watchOS) | [~] | Watch widget gradient styling updated | Validate families |
| Accessibility (contrast/size) | [~] | Scaled metrics used | Audit with settings |
| Screenshot capture (watch) | [x] | `screenshots/automated/2025-12-26-watchos-46mm/` | Review for quality |
