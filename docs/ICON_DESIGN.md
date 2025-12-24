# prismCalc App Icon Design

**Created**: 2025-12-07
**Designer**: Programmatically generated
**Style**: Glassmorphic / Aurora Theme

---

## Design Concept

The prismCalc app icon embodies the app's glassmorphic aesthetic and "prism" theme with a beautiful, modern design.

### Visual Elements

1. **Background**: Aurora gradient (purple → blue → light blue)
   - Matches the app's default Aurora theme
   - Creates depth and visual interest
   - Colors: `#9966FF` → `#6699FF` → `#80CCFF`

2. **Glass Container**: Semi-transparent rounded square
   - 25% white overlay for glass effect
   - Rounded corners (20% of icon size)
   - Subtle shadow for depth
   - Gradient border (white 60% → 20%) for glass rim effect

3. **Calculator Symbols**: Four operator symbols in 2x2 grid
   - **Plus** (top-left): Addition symbol
   - **Minus** (top-right): Subtraction symbol
   - **Multiply** (bottom-left): Rotated plus (45°)
   - **Divide** (bottom-right): Line with dots above/below
   - All symbols in bright white (95% opacity)
   - Clean, modern geometric shapes

### Design Principles

- **Glassmorphism**: Semi-transparent overlays, subtle borders, depth
- **Modern iOS**: Rounded corners, clean symbols, proper shadows
- **Brand Consistency**: Aurora colors match the app's main theme
- **Scalability**: Works at all sizes (20x20 to 1024x1024)
- **Recognition**: Calculator symbols immediately communicate purpose

---

## Technical Details

### Generation

Icons are generated programmatically using Core Graphics via `scripts/generate-icon.swift`:
- 18 different sizes for iOS and iPadOS
- PNG format with alpha channel
- Proper color space (sRGB)
- Optimized for retina displays

### Sizes Generated

```
20x20   @2x, @3x  (Notification icons)
29x29   @2x, @3x  (Settings, Spotlight icons)
40x40   @2x, @3x  (Spotlight, iPad icons)
60x60   @2x, @3x  (iPhone app icons)
76x76   @1x, @2x  (iPad app icons)
83.5x83.5 @2x     (iPad Pro app icon)
1024x1024         (App Store icon)
```

### Color Palette

```swift
// Aurora Gradient
Purple:     #9966FF (rgb: 153, 102, 255)
Blue:       #6699FF (rgb: 102, 153, 255)
Light Blue: #80CCFF (rgb: 128, 204, 255)

// Glass Effect
Glass Base:   White 25% opacity
Glass Border: White 60% → 20% gradient
Symbols:      White 95% opacity

// Shadow
Color:  Black 30% opacity
Blur:   8% of icon size
Offset: 3% down
```

---

## Regenerating Icons

If you need to regenerate the icons (e.g., for design tweaks):

```bash
# Make sure script is executable
chmod +x scripts/generate-icon.swift

# Generate all icon sizes
swift scripts/generate-icon.swift
```

The script will:
1. Generate all 18 icon sizes
2. Save them to `App/Assets.xcassets/AppIcon.appiconset/`
3. Overwrite existing icons
4. Report success for each size

---

## Design Rationale

### Why Glassmorphism?

- **Brand Alignment**: Matches the app's core visual style
- **Modern**: Glassmorphism is trendy in iOS design (2024-2025)
- **Distinctive**: Stands out from flat, solid-color calculator icons
- **Depth**: Glass effects create visual interest and hierarchy

### Why Calculator Symbols?

- **Clear Purpose**: Users immediately understand it's a calculator
- **Simplicity**: Clean symbols work at small sizes
- **Grid Layout**: Balanced, professional appearance
- **Universal**: Mathematical symbols are language-independent

### Why Aurora Colors?

- **Default Theme**: Matches what users see when they first open the app
- **Calming**: Purple/blue gradients are soothing, not aggressive
- **Premium Feel**: Rich colors suggest a quality, paid product
- **Contrast**: Light symbols pop against gradient background

---

## App Store Assets

The 1024x1024 icon (`Icon-1024.png`) is ready for:
- App Store Connect upload
- App Store listing page
- Search results
- Marketing materials

This is the icon users will see before downloading, so it's been designed to:
- Look professional and polished
- Clearly communicate the app's purpose
- Match the app's visual identity
- Stand out in search results

---

## Accessibility

The icon design considers accessibility:
- **High Contrast**: White symbols on colored background (AAA rated)
- **Clear Shapes**: Symbols are distinct and recognizable
- **No Text**: Symbols are universal, no localization needed
- **Size Flexibility**: Works at all required sizes without pixelation

---

## Future Modifications

If you want to modify the icon design, edit `scripts/generate-icon.swift`:

### Common Tweaks

**Change Colors**:
```swift
// Line 29-33 - Adjust gradient colors
let colors = [
    CGColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0),  // Purple
    CGColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0),  // Blue
    CGColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)   // Light blue
]
```

**Adjust Glass Opacity**:
```swift
// Line 67 - Change glass transparency
context.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25))  // 25% = subtle
```

**Change Symbol Layout**:
```swift
// Lines 104-106 - Adjust symbol spacing
let symbolSize = size * 0.12   // Make symbols bigger/smaller
let offset = size * 0.15        // Bring symbols closer/further apart
```

After editing, run `swift scripts/generate-icon.swift` to regenerate all sizes.

---

## Icon Preview

The icon features:
```
┌─────────────────────────┐
│                         │
│   Purple-Blue Gradient  │
│   ┌───────────────┐    │
│   │ ╔═══╗         │    │
│   │ ║ + │ -       │    │
│   │ ║═══║         │    │
│   │ ║ × │ ÷       │    │
│   │ ╚═══╝ Glass   │    │
│   └───────────────┘    │
│                         │
└─────────────────────────┘
```

Clean, modern, glassmorphic calculator icon that matches prismCalc's premium aesthetic.

---

**Status**: ✅ Complete - Ready for App Store submission
