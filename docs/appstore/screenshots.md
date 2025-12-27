# prismCalc - Screenshot Requirements

## Required Device Sizes

### iPhone
| Device | Resolution | Required |
|--------|------------|----------|
| 6.9" bucket (App Store Connect) | 1320 x 2868 | Yes |
| 6.5" bucket (App Store Connect) | 1284 x 2778 | Optional |
| 5.5" (iPhone 8 Plus) | 1242 x 2208 | Optional |

### iPad
| Device | Resolution | Required |
|--------|------------|----------|
| 13"/12.9" bucket (App Store Connect) | 2064 x 2752 | Yes |
| 11" iPad Pro (4th gen) | 1668 x 2388 | Optional |

---

## Screenshot Plan (10 screenshots per device)

### 1. Hero Shot - Calculator
**Theme**: Aurora (default)
**Content**: Main calculator with a calculation displayed (e.g., "1,234.56")
**Caption**: "Beautiful Glassmorphic Design"

### 2. Tip Calculator
**Theme**: Blue-Green Harmony
**Content**: Tip calculator with bill value + 20% tip
**Caption**: "Smart Tip Calculator"

### 3. Bill Split
**Theme**: Calming Blues
**Content**: Bill split view with 4 people, showing per-person amount
**Caption**: "Split Bills Instantly"

### 4. Discount Calculator
**Theme**: Forest Earth
**Content**: Discount calculator showing savings and final price
**Caption**: "Calculate Discounts"

### 5. Unit Converter
**Theme**: Soft Tranquil
**Content**: Converting a non-zero value (e.g., meters to feet)
**Caption**: "Convert Any Unit"

### 6. Theme Selection
**Theme**: Multiple visible
**Content**: Theme picker grid with all themes visible
**Caption**: "6 Stunning Themes"

### 7. Calculation History (Pro)
**Theme**: Midnight
**Content**: History view with multiple entries (Pro unlocked)
**Caption**: "Track Your Calculations"

### 8. Widgets
**Theme**: Aurora
**Content**: In-app Widgets settings screen with previews
**Caption**: "Powerful Widgets"

### 9. App Icons
**Theme**: Aurora
**Content**: App icon selection screen
**Caption**: "Customize Your Icon"

### 10. Calculator Result
**Theme**: Aurora
**Content**: Calculator with a high-contrast result
**Caption**: "Fast, Accurate Results"

**Optional swaps**: If we capture OS-level shots later, replace #9/#10 with Siri and Control Center.

---

## Capture Instructions

### Simulator Setup
```bash
# iPhone 6.9" bucket (1320 x 2868)
xcrun simctl boot "iPhone 16 Pro Max"

# iPad 13"/12.9" bucket (2064 x 2752)
xcrun simctl boot "iPad Pro (13-inch) (M4)"
```

### Screenshot Commands
```bash
# Capture simulator screenshot
xcrun simctl io booted screenshot screenshot.png

# Or use Xcode: Debug > View Debugging > Take Screenshot
```

### Post-Processing
1. Add device frames (optional - App Store handles this)
2. Add captions using Figma/Sketch
3. Ensure text is readable
4. Export at exact required resolutions

---

## File Naming Convention

```
{device}_{number}_{feature}.png

Examples:
- iphone67_01_calculator.png
- iphone67_02_tip.png
- ipad129_01_calculator.png
```

---

## App Preview Video (Optional)

**Duration**: 15-30 seconds
**Resolution**: Same as screenshots
**Format**: H.264, 30fps

**Storyboard**:
1. App launch with mesh gradient animation (3s)
2. Calculator usage with button animations (5s)
3. Swipe to tip calculator, use arc slider (5s)
4. Theme switching showcase (5s)
5. Widget demonstration (5s)
6. End with logo/tagline (2s)
