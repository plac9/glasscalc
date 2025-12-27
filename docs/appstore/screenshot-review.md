# PrismCalc - App Store Screenshot Review

**Status:** ready for upload (setup only)
**Date:** 2025-12-26

## Latest Sets (Candidate)

### iPhone (current root set)
- Path: `screenshots/iphone67_*.png`
- Size (sample): **1320 x 2868** (`iphone67_01.png`)
- Count: **10** files
- Notes: valid for iPhone 6.9" bucket (accepted by ASC).

### iPhone (latest automated, 6.9" bucket)
- Path: `screenshots/automated/2025-12-26-iphone-16-pro-max-v3/`
- Size (sample): **1320 x 2868** (`iphone69_01.png`)
- Count: **10** files
- Notes: valid for iPhone 6.9" bucket; reviewed and ready.

### iPhone (latest automated)
- Path: `screenshots/automated/2025-12-26-iphone-17/`
- Size (sample): **1206 x 2622** (`iphone67_01.png`)
- Count: **10** files
- Notes: not a valid App Store Connect size bucket.

### iPhone (legacy appstore set)
- Path: `screenshots/appstore/`
- Size (sample): **1320 x 2868** (`01_Calculator_Free.png`)
- Count: **9** files
- Notes: valid for iPhone 6.9" bucket (accepted by ASC), but missing one shot.

### iPad (latest)
- Path: `screenshots/automated/2025-12-26-ipad-13/`
- Size (sample): **2064 x 2752** (`ipad13_01.png`)
- Count: **10** files
- Notes: valid for iPad 13"/12.9" bucket (accepted by ASC).

### iPad (latest automated, 13"/12.9" bucket)
- Path: `screenshots/automated/2025-12-26-ipad-13-m5-v3/`
- Size (sample): **2064 x 2752** (`ipad13_01.png`)
- Count: **10** files
- Notes: valid for iPad 13"/12.9" bucket; reviewed and ready.

## Confirmed Buckets (App Store Connect)

### iPhone
- **6.9" bucket** accepts: 1260×2736, 1320×2868, 1290×2796 (and landscape variants).\n  - Covers 6.5", 6.7", 6.9" devices.\n  - Recommended target: **1320×2868**.
- **6.5" bucket** accepts: 1242×2688, 1284×2778 (and landscape variants).

### iPad
- **13"/12.9" bucket** accepts: 2064×2752 or 2048×2732 (and landscape variants).\n  - Recommended target: **2064×2752**.

## Shot Mapping (10‑shot plan)

**iPhone set (candidate: 2025-12-26-iphone-16-pro-max-v3)**
1. `iphone69_01.png` - Hero Calculator
2. `iphone69_02.png` - Tip Calculator (values populated)
3. `iphone69_03.png` - Bill Split (values populated)
4. `iphone69_04.png` - Discount Calculator (values populated)
5. `iphone69_05.png` - Unit Converter (values populated)
6. `iphone69_06.png` - Theme Selection
7. `iphone69_07.png` - History (Pro)
8. `iphone69_08.png` - Widgets (settings)
9. `iphone69_09.png` - App Icon (settings)
10. `iphone69_10.png` - Calculator Result

**iPad set (candidate: 2025-12-26-ipad-13-m5-v3)**
1. `ipad13_01.png` - Hero Calculator
2. `ipad13_02.png` - Tip Calculator (values populated)
3. `ipad13_03.png` - Bill Split (values populated)
4. `ipad13_04.png` - Discount Calculator (values populated)
5. `ipad13_05.png` - Unit Converter (values populated)
6. `ipad13_06.png` - Theme Selection
7. `ipad13_07.png` - History (Pro)
8. `ipad13_08.png` - Widgets (settings)
9. `ipad13_09.png` - App Icon (settings)
10. `ipad13_10.png` - Calculator Result

## Review Results (iPhone 6.9 root set)
- `iphone67_01.png`: keep (clean hero calculator)
- `iphone67_02.png`: reject (duplicate calculator, empty state)
- `iphone67_03.png`: reject (duplicate calculator, empty state)
- `iphone67_04.png`: keep (tip calculator)
- `iphone67_05.png`: reject (duplicate calculator, empty state)
- `iphone67_06.png`: reject (duplicate of tip calculator)
- `iphone67_07.png`: keep (discount calculator)
- `iphone67_08.png`: keep (split bill)
- `iphone67_09.png`: reject (duplicate calculator, empty state)
- `iphone67_10.png`: optional alt hero (calculator with value) but still duplicate

**Result:** iPhone set is missing 6 feature shots (unit converter, theme picker, history, widgets, Siri, control center) and needs a fresh capture in 1320x2868.

## Review Results (iPad 13/12.9 set)
- `ipad13_01.png`: keep (hero calculator)
- `ipad13_02.png`: reject (busy layout with paywall overlay, More tab)
- `ipad13_03.png`: reject (tip calculator gated screen)
- `ipad13_04.png`: keep (settings/theme area)
- `ipad13_05.png`: keep (tip calculator UI; recapture with real values if possible)
- `ipad13_06.png`: keep (discount calculator UI; recapture with real values if possible)
- `ipad13_07.png`: keep (split bill UI; recapture with real values if possible)
- `ipad13_08.png`: keep (unit converter UI; recapture with real values if possible)
- `ipad13_09.png`: keep (history list)
- `ipad13_10.png`: reject (duplicate hero calculator)

**Result:** iPad set is missing widgets, Siri integration, and Control Center shots; consider recapture with non-zero data for clarity.

## Review Results (iPhone 6.9 automated v3, iPhone 16 Pro Max)
- `iphone69_01.png`: keep (hero calculator)
- `iphone69_02.png`: keep (tip with values)
- `iphone69_03.png`: keep (split with values)
- `iphone69_04.png`: keep (discount with values)
- `iphone69_05.png`: keep (converter with values)
- `iphone69_06.png`: keep (theme selection)
- `iphone69_07.png`: keep (history list)
- `iphone69_08.png`: keep (widgets settings)
- `iphone69_09.png`: keep (app icon settings)
- `iphone69_10.png`: keep (calculator result)

**Result:** iPhone v3 set is clean (no keyboard, no paywalls) and ready for upload.

## Review Results (iPad 13 automated v3, iPad Pro 13-inch M5)
- `ipad13_01.png`: keep (hero calculator)
- `ipad13_02.png`: keep (tip with values)
- `ipad13_03.png`: keep (split with values)
- `ipad13_04.png`: keep (discount with values)
- `ipad13_05.png`: keep (converter with values)
- `ipad13_06.png`: keep (theme selection)
- `ipad13_07.png`: keep (history list)
- `ipad13_08.png`: keep (widgets settings)
- `ipad13_09.png`: keep (app icon settings)
- `ipad13_10.png`: keep (calculator result)

**Result:** iPad v3 set is clean (no keyboard, no paywalls) and ready for upload.

## Next Actions
- Use iPhone v3 set (`screenshots/automated/2025-12-26-iphone-16-pro-max-v3/`) and iPad v3 set (`screenshots/automated/2025-12-26-ipad-13-m5-v3/`) as the upload sources.
- Upload to App Store Connect (setup only, no submission).
- Decide whether to archive or delete older v1/v2 directories after upload.
