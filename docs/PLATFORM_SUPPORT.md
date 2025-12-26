# prismCalc Platform Support

**Generated**: 2025-12-25
**Project**: prismCalc v1.0.0
**Minimum Deployment Target**: iOS 18.0 / iPadOS 18.0 / macOS 15.0 / watchOS 10.0

---

## Supported Platforms

prismCalc is currently built for **native iOS, native iPadOS, native macOS, and watchOS**. The app is optimized for modern Apple devices running iOS 18 or later, with companion coverage on Apple Watch and native widgets per platform.

### ✅ iPhone Support

**Deployment Target**: iOS 18.0+

#### Compatible Devices (iOS 18+)
- iPhone 17 series (Pro, Pro Max, Air, Standard, 16e)
- iPhone 16 series (all models)
- iPhone 15 series (all models)
- iPhone 14 series (all models)
- Any iPhone that supports iOS 18

#### Optimized For
- **Portrait orientation** (primary)
- All iPhone screen sizes from iPhone SE to iPhone Pro Max
- iOS 18 floating tab bar (`.sidebarAdaptable`)
- Liquid Glass (`glassEffect`) on iOS 26+, layered glass fallback on iOS 18+
- Dynamic Type for accessibility
- VoiceOver support

#### Tested On
✅ **iPhone 17** (iOS 26.2 Simulator) - Running
✅ **iPhone 17 Pro** (iOS 26.2 Simulator) - Running
✅ **iPhone 17 Pro Max** (iOS 26.2 Simulator) - Running

---

### ✅ iPad Support

**Deployment Target**: iOS 18.0+ (iPadOS 18.0+)

#### Compatible Devices (iPadOS 18+)
- iPad Pro (all sizes, M5 and later)
- iPad Air (all sizes, M3 and later)
- iPad mini (A17 Pro and later)
- iPad (A16 and later)
- Any iPad that supports iPadOS 18

#### Optimized For
- **All orientations** (portrait, landscape, split view)
- Multitasking (Split View, Slide Over)
- iPad-specific layouts with more screen real estate
- Keyboard shortcuts (if implemented)
- Apple Pencil support (future consideration)
- Stage Manager compatibility
- Liquid Glass (`glassEffect`) on iOS 26+, layered glass fallback on iOS 18+

#### Tested On
✅ **iPad Pro 13-inch (M5)** (iOS 26.2 Simulator) - Running
- iPad Pro 11-inch (available but not currently running)
- iPad Air 13-inch (available but not currently running)
- iPad Air 11-inch (available but not currently running)
- iPad mini A17 Pro (available but not currently running)

---

### ✅ macOS Support (Native SwiftUI)

**Deployment Target**: macOS 15.0+ (native)

#### Optimized For
- Apple Silicon Macs running macOS 15+
- Pointer input + keyboard usage
- Resizable window layouts with a compact calculator-first footprint
- Slide-in history panel (last 10 entries) when the window is expanded wide
- Same glassmorphic UI principles as iOS/iPadOS

#### Notes
- Native macOS app target with its own bundle ID
- Native macOS WidgetKit extension included
- "Designed for iPad" distribution disabled (native macOS target only)
- iOS-only behaviors (haptics, tab bar appearance) are guarded
- Default macOS window size: 320x560; history panel is opt-in via edge toggle

---

### ✅ watchOS Support (Companion App)

**Deployment Target**: watchOS 10.0+

#### Optimized For
- Quick calculations on the wrist
- Compact keypad and display
- Glass-inspired visuals tuned for small screens

#### Notes
- Focused feature set (basic operations)
- History tab with last 10 calculations (on-device)
- Tap haptics for keypad feedback
- Quick Tip/Discount/Split tools using calculator input
- Native watchOS widget extension (accessory families)
#### Tested On
✅ **Apple Watch Series 11 (46mm)** (watchOS 26.2 Simulator) - Running

---

## Unsupported Platforms

The following platforms are **NOT currently supported** by prismCalc. To add support, significant code changes and additional configuration would be required.

### ❌ tvOS (Apple TV)

**Status**: Not configured
**Why Not Supported**:
- No tvOS target in project configuration
- Calculator UI not optimized for TV/remote control
- No focus-based navigation implemented
- Limited use case for calculator on TV

**To Add Support**:
1. Create tvOS target in `project.yml`
2. Redesign UI for 10-foot interface
3. Implement focus engine navigation
4. Add Siri Remote support
5. Rethink UX for living room use

---

### ❌ visionOS (Apple Vision Pro)

**Status**: Not configured
**Why Not Supported**:
- No visionOS target in project configuration
- No spatial UI design implemented
- Calculator UI designed for 2D touch screens, not spatial interfaces
- Would benefit from 3D spatial design rethinking

**To Add Support**:
1. Create visionOS target in `project.yml`
2. Redesign UI using RealityKit/SwiftUI for spatial computing
3. Implement hand tracking and eye tracking
4. Design immersive calculator experience
5. Test in Vision Pro simulator/device

---

## Device Families

The project configuration (`project.yml`) specifies:

```yaml
TARGETED_DEVICE_FAMILY: 1,2
```

**Device Family Codes**:
- `1` = iPhone
- `2` = iPad
- `3` = Apple TV (tvOS)
- `4` = Apple Watch (watchOS)
- `6` = Mac Catalyst (macOS)
- `7` = Apple Vision (visionOS)

**Current Configuration**: iOS target uses `1,2` (iPhone + iPad). macOS and watchOS are separate native targets.

---

## Architecture Support

**Supported Architectures**:
- `arm64` (Apple Silicon, all modern iOS/iPadOS devices)
- `x86_64` (iOS Simulator on Intel Macs)

**Minimum iOS Version**: 18.0
**Swift Version**: 5.9+
**Xcode Version**: 15.0+

---

## Testing Matrix

### Automated Testing
✅ **97 Unit Tests** - All passing
✅ **UI Tests** - All passing (screenshot capture, navigation, paywalls)
✅ **Build Tests** - Zero warnings

### Manual Testing Recommended

#### iPhone Testing
- [ ] iPhone SE (smallest screen)
- [ ] iPhone 17 (standard size)
- [ ] iPhone 17 Pro Max (largest screen)
- [ ] Landscape orientation
- [ ] Dark mode vs Light mode
- [ ] Accessibility features (VoiceOver, Dynamic Type, Reduce Motion)

#### iPad Testing
- [ ] iPad mini (smallest iPad)
- [ ] iPad Air 11-inch (mid-size)
- [ ] iPad Pro 13-inch (largest)
- [ ] Split View multitasking
- [ ] Slide Over mode
- [ ] Stage Manager
- [ ] Landscape orientation
- [ ] External keyboard shortcuts (if implemented)

#### macOS Testing
- [ ] Resizable window (min/max sizes)
- [ ] Keyboard shortcuts (calculator input)
- [ ] Pointer and hover behaviors
- [ ] Menu bar + focus ring visibility
- [ ] Widget install + refresh

#### watchOS Testing
- [ ] Launch + basic calculations
- [ ] Crown/scroll behavior (if any)
- [ ] Widget accessory families
- [ ] Dark/light readability

---

## App Store Configuration

When submitting to App Store Connect:

**Supported Platforms**: iOS, iPadOS, macOS (native), watchOS (companion)
**Device Support**: iPhone, iPad, Apple Silicon Mac, Apple Watch
**Minimum OS Version**: iOS 18.0 / iPadOS 18.0 / macOS 15.0 / watchOS 10.0
**Supported Languages**: English (en-US) - more can be added
**Pricing**: Free with $2.99 Pro upgrade (IAP)
**watchOS**: Companion app ships with the iOS bundle (no separate App Store listing)
**Widgets**: Separate WidgetKit extensions for iOS/iPadOS, macOS, and watchOS

---

## Future Platform Expansion

If you want to expand to other platforms in the future, prioritize based on:

1. **visionOS** (Most Innovative) - Future-forward, differentiator
2. **tvOS** (Lowest Priority) - Limited use case

---

## How to Switch Devices in Simulator

### Command Line
```bash
# List all available devices
xcrun simctl list devices available

# Boot a specific device
xcrun simctl boot <DEVICE_ID>

# Install app
xcrun simctl install <DEVICE_ID> /path/to/PrismCalc.app

# Launch app
xcrun simctl launch <DEVICE_ID> com.laclairtech.prismcalc
```

### Xcode
1. Open `PrismCalc.xcodeproj` in Xcode
2. Click device selector (top-left, next to Play button)
3. Choose any iPhone or iPad simulator
4. Press `⌘ + R` to build and run

### Simulator.app
1. Open Simulator app
2. Go to `File > Open Simulator > [Choose Device]`
3. Each device has its own window
4. You can run multiple simulators simultaneously

---

## Currently Running

Not tracked in this doc. Verify active simulators/devices in Xcode or Simulator.

---

## Summary

**What prismCalc Supports**:
- ✅ iPhone (iOS 18+)
- ✅ iPad (iPadOS 18+)
- ✅ macOS native app (macOS 15+)
- ✅ Apple Watch companion (watchOS 10+)
- ✅ Widgets on iOS/iPadOS, macOS, and watchOS

**What prismCalc Does NOT Support** (yet):
- ❌ tvOS (Apple TV)
- ❌ visionOS (Apple Vision Pro)

To add support for other platforms, you'll need to update `project.yml`, create platform-specific targets, and adapt the UI for each platform's interaction model.

---

**Status**: 🟡 native iOS/iPadOS/macOS/watchOS support in progress
**Next Steps**: Validate iOS + watchOS builds after installing watchOS platform; run device testing before App Store submission
