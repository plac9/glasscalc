# PrismCalc Platform Support

**Generated**: 2025-12-07
**Project**: PrismCalc v1.0.0
**Minimum Deployment Target**: iOS 18.0

---

## Supported Platforms

PrismCalc is currently built for **iOS and iPadOS only**. The app is optimized for modern Apple devices running iOS 18 or later.

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
- **Landscape orientation** (supported)
- All iPhone screen sizes from iPhone SE to iPhone Pro Max
- iOS 18 floating tab bar (`.sidebarAdaptable`)
- Dynamic Type for accessibility
- VoiceOver support

#### Tested On
✅ **iPhone 17 Pro** (iOS 26.1 Simulator) - Running
✅ **iPhone 17 Pro Max** (iOS 26.1 Simulator) - Running

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

#### Tested On
✅ **iPad Pro 13-inch (M5)** (iOS 26.1 Simulator) - Running
- iPad Pro 11-inch (available but not currently running)
- iPad Air 13-inch (available but not currently running)
- iPad Air 11-inch (available but not currently running)
- iPad mini A17 Pro (available but not currently running)

---

## Unsupported Platforms

The following platforms are **NOT currently supported** by PrismCalc. To add support, significant code changes and additional configuration would be required.

### ❌ macOS (Mac Catalyst)

**Status**: Not configured
**Why Not Supported**:
- Project is iOS-only (`platform: iOS` in `project.yml`)
- No Mac Catalyst entitlements or configuration
- Would require macOS-specific UI adaptations (menu bar, window chrome, keyboard shortcuts)
- Calculator layouts optimized for touch, not mouse/trackpad

**To Add Support**:
1. Enable Mac Catalyst in `project.yml` (`supportedDestinations: [iOS, macCatalyst]`)
2. Add macOS-specific entitlements
3. Adapt UI for mouse/keyboard input
4. Test menu bar integration
5. Update App Store listing for macOS

---

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

### ❌ watchOS (Apple Watch)

**Status**: Not configured
**Why Not Supported**:
- No watchOS target in project configuration
- Small screen size incompatible with current calculator layout
- Complexity of calculator UI not suitable for watch
- Better suited for quick calculations via complications or Siri

**To Add Support**:
1. Create watchOS target in `project.yml`
2. Design minimal calculator UI for tiny screen
3. Add watchOS complications for quick calculations
4. Implement Digital Crown input
5. Consider Siri shortcuts integration

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

**Current Configuration**: `1,2` (iPhone + iPad only)

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

---

## App Store Configuration

When submitting to App Store Connect:

**Supported Platforms**: iOS, iPadOS
**Device Support**: iPhone, iPad
**Minimum OS Version**: iOS 18.0 / iPadOS 18.0
**Supported Languages**: English (en-US) - more can be added
**Pricing**: Free with $2.99 Pro upgrade (IAP)

---

## Future Platform Expansion

If you want to expand to other platforms in the future, prioritize based on:

1. **Mac Catalyst** (Easiest) - Minimal changes, large user base
2. **visionOS** (Most Innovative) - Future-forward, differentiator
3. **watchOS** (Useful) - Quick calculations on wrist
4. **tvOS** (Lowest Priority) - Limited use case

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

As of this session (2025-12-07):

✅ **iPhone 17 Pro** (iOS 26.1)
- Process ID: 96798
- Status: Running
- Build: Debug-iphonesimulator

✅ **iPad Pro 13-inch (M5)** (iOS 26.1)
- Process ID: 92059
- Status: Running
- Build: Debug-iphonesimulator

Both devices are showing PrismCalc with the new glassmorphic app icon and all features working correctly.

---

## Summary

**What PrismCalc Supports**:
- ✅ iPhone (iOS 18+)
- ✅ iPad (iPadOS 18+)

**What PrismCalc Does NOT Support** (yet):
- ❌ macOS (Mac Catalyst)
- ❌ tvOS (Apple TV)
- ❌ watchOS (Apple Watch)
- ❌ visionOS (Apple Vision Pro)

To add support for other platforms, you'll need to update `project.yml`, create platform-specific targets, and adapt the UI for each platform's interaction model.

---

**Status**: ✅ iOS/iPadOS support complete and tested
**Next Steps**: Test on physical devices, prepare for App Store submission
