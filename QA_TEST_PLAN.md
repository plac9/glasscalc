# PrismCalc - Comprehensive QA Test Plan

**Version**: 1.0.0 (Build 1)
**Test Date**: 2025-12-07
**Tester**: Automated + Manual
**Platform**: iOS 18+ (Simulator + Device)

---

## Test Categories

1. [Build & Configuration](#1-build--configuration)
2. [Core Calculator Functionality](#2-core-calculator-functionality)
3. [Freemium Model & IAP](#3-freemium-model--iap)
4. [Pro Features](#4-pro-features)
5. [History & Data Persistence](#5-history--data-persistence)
6. [Themes & Customization](#6-themes--customization)
7. [UI/UX & Navigation](#7-uiux--navigation)
8. [Widgets & Extensions](#8-widgets--extensions)
9. [iOS 18 Features](#9-ios-18-features)
10. [Edge Cases & Error Handling](#10-edge-cases--error-handling)
11. [Performance & Memory](#11-performance--memory)
12. [Accessibility](#12-accessibility)

---

## 1. Build & Configuration

### 1.1 Build Tests
- [ ] Clean build succeeds without warnings
- [ ] Archive build succeeds
- [ ] All targets build (App + Widget Extension)
- [ ] No deprecated API usage warnings
- [ ] Code signing configured correctly

### 1.2 Configuration Files
- [ ] Info.plist has correct Bundle ID
- [ ] Info.plist has correct version (1.0.0)
- [ ] Info.plist has correct build number (1)
- [ ] Entitlements files configured correctly
- [ ] App Groups enabled for both targets
- [ ] StoreKit configuration file present

### 1.3 Dependencies
- [ ] All Swift packages resolved
- [ ] No missing dependencies
- [ ] Framework linking correct

---

## 2. Core Calculator Functionality

### 2.1 Basic Operations
- [ ] Addition works correctly
- [ ] Subtraction works correctly
- [ ] Multiplication works correctly
- [ ] Division works correctly
- [ ] Division by zero handled gracefully

### 2.2 Decimal Operations
- [ ] Decimal point input works
- [ ] Multiple decimal points prevented
- [ ] Decimal calculations accurate
- [ ] Decimal display formatting correct

### 2.3 Advanced Operations
- [ ] Percentage calculations work
- [ ] Sign change (+/-) works
- [ ] Clear (C) button resets display
- [ ] All Clear (AC) resets state completely

### 2.4 Calculator State
- [ ] Equals shows correct result
- [ ] Chain calculations work
- [ ] Result becomes new operand after equals
- [ ] Display updates in real-time

### 2.5 Edge Cases
- [ ] Very large numbers handled
- [ ] Very small numbers handled
- [ ] Scientific notation displays correctly
- [ ] Overflow prevention works

---

## 3. Freemium Model & IAP

### 3.1 Free Tier Features
- [ ] Basic calculator accessible
- [ ] Aurora theme unlocked by default
- [ ] Settings accessible
- [ ] Free features work without purchase

### 3.2 Locked Features (Free Tier)
- [ ] Tip Calculator shows paywall
- [ ] Discount Calculator shows paywall
- [ ] Split Bill shows paywall
- [ ] Unit Converter shows paywall
- [ ] History shows paywall
- [ ] Additional themes locked (except Aurora)

### 3.3 Paywall UI
- [ ] Paywall displays correctly
- [ ] Price shown: $2.99
- [ ] Feature list accurate
- [ ] "Upgrade to Pro" button visible
- [ ] "Restore Purchase" button visible
- [ ] "Maybe Later" / dismiss option available

### 3.4 Purchase Flow
- [ ] Tapping "Upgrade to Pro" triggers StoreKit
- [ ] StoreKit sheet displays correctly
- [ ] Purchase completes successfully (sandbox)
- [ ] All Pro features unlock after purchase
- [ ] Purchase state persists after app restart

### 3.5 Restore Purchase
- [ ] "Restore Purchase" works
- [ ] Previously purchased Pro unlocks
- [ ] Error handling for no purchases found

---

## 4. Pro Features

### 4.1 Tip Calculator
- [ ] Bill amount input works
- [ ] Tip percentage picker works
- [ ] Tip amount calculated correctly
- [ ] Total amount calculated correctly
- [ ] Split between people works
- [ ] Per-person amount accurate
- [ ] Rounding handled correctly

### 4.2 Discount Calculator
- [ ] Original price input works
- [ ] Discount percentage input works
- [ ] Discount amount calculated correctly
- [ ] Final price calculated correctly
- [ ] Savings displayed correctly

### 4.3 Split Bill Calculator
- [ ] Bill amount input works
- [ ] Number of people input works
- [ ] Per-person amount calculated correctly
- [ ] Tip included in split calculation
- [ ] Rounding handled fairly

### 4.4 Unit Converter
- [ ] Length conversions work
- [ ] Weight conversions work
- [ ] Temperature conversions work
- [ ] Volume conversions work
- [ ] Unit picker displays all options
- [ ] Conversion accuracy verified
- [ ] Bidirectional conversion works

---

## 5. History & Data Persistence

### 5.1 History (Pro Only)
- [ ] Calculations saved to history
- [ ] History accessible after Pro purchase
- [ ] History displays calculation type
- [ ] History displays result
- [ ] History displays timestamp

### 5.2 History Actions
- [ ] Tap history item to load result
- [ ] Swipe to delete works
- [ ] Clear all history works
- [ ] Confirmation dialog for clear all

### 5.3 Data Persistence
- [ ] History persists after app restart
- [ ] Pro purchase state persists
- [ ] Theme selection persists
- [ ] User preferences persist

---

## 6. Themes & Customization

### 6.1 Free Tier Themes
- [ ] Aurora theme unlocked by default
- [ ] Aurora theme displays correctly
- [ ] Other themes show lock icon
- [ ] Tapping locked theme shows paywall

### 6.2 Pro Tier Themes
- [ ] All themes unlock after Pro purchase
- [ ] All themes display correctly
- [ ] Theme switching works smoothly
- [ ] Theme persists after restart

### 6.3 Theme List
Test each theme displays correctly:
- [ ] Aurora (Free)
- [ ] Ocean
- [ ] Sunset
- [ ] Forest
- [ ] Lavender
- [ ] Rose Gold
- [ ] Midnight
- [ ] Mint
- [ ] Coral
- [ ] Electric

### 6.4 Theme Effects
- [ ] Mesh gradient animates
- [ ] Glass blur effect works
- [ ] Colors match theme
- [ ] Tab bar tint matches theme
- [ ] Dark mode support

---

## 7. UI/UX & Navigation

### 7.1 Tab Bar (iOS 18 Floating)
- [ ] Tab bar displays correctly
- [ ] Tab bar floats above content
- [ ] Tab icons correct
- [ ] Tab labels correct
- [ ] Selected tab highlighted
- [ ] Tab switching works smoothly

### 7.2 Tab Order
- [ ] Calculator tab first
- [ ] Tip tab second
- [ ] Split tab third
- [ ] Discount tab fourth
- [ ] Convert tab fifth
- [ ] History tab sixth
- [ ] Settings tab seventh
- [ ] More menu contains overflow tabs (if >5 tabs)

### 7.3 Navigation
- [ ] All tabs accessible
- [ ] Back navigation works
- [ ] More menu navigation works (if applicable)
- [ ] No navigation glitches
- [ ] State preserved during tab switching

### 7.4 Buttons & Controls
- [ ] All buttons respond to taps
- [ ] Haptic feedback on button taps
- [ ] Button states (normal, pressed) correct
- [ ] Disabled buttons grayed out
- [ ] Loading states display correctly

### 7.5 Layout & Spacing
- [ ] Layout adapts to different screen sizes
- [ ] Safe area insets respected
- [ ] No overlapping UI elements
- [ ] Consistent spacing throughout
- [ ] Landscape orientation supported

---

## 8. Widgets & Extensions

### 8.1 Widget Extension
- [ ] Widget builds without errors
- [ ] Widget displays on home screen
- [ ] Widget shows last calculation
- [ ] Widget updates when app used
- [ ] Widget respects Pro status

### 8.2 Widget Sizes
- [ ] Small widget displays correctly
- [ ] Medium widget displays correctly
- [ ] Large widget displays correctly
- [ ] Widget data refreshes

### 8.3 Shared Data
- [ ] App Groups configured correctly
- [ ] Widget reads shared data
- [ ] Data syncs between app and widget
- [ ] No data corruption

---

## 9. iOS 18 Features

### 9.1 Floating Tab Bar
- [ ] Tab bar uses `.sidebarAdaptable` style
- [ ] Tab bar floats with blur effect
- [ ] Tab customization available
- [ ] Tab customization persists

### 9.2 Mesh Gradients
- [ ] Mesh background animates smoothly
- [ ] No performance issues with animation
- [ ] Colors blend correctly
- [ ] Gradients adapt to theme

### 9.3 Zoom Transitions
- [ ] Zoom transition on number tap
- [ ] Transition smooth and fluid
- [ ] No visual glitches
- [ ] Performance acceptable

### 9.4 Sensory Feedback
- [ ] Haptics on button taps
- [ ] Haptics on tab switch
- [ ] Haptics on purchase complete
- [ ] Feedback appropriate for actions

---

## 10. Edge Cases & Error Handling

### 10.1 Input Validation
- [ ] Invalid characters rejected
- [ ] Maximum input length enforced
- [ ] Empty input handled gracefully
- [ ] Negative numbers handled correctly

### 10.2 Network & IAP Errors
- [ ] No network error handled
- [ ] IAP fetch failure handled
- [ ] Purchase cancelled handled
- [ ] Purchase failed handled
- [ ] Error messages user-friendly

### 10.3 State Recovery
- [ ] App survives app switch
- [ ] App survives background/foreground
- [ ] App survives low memory warning
- [ ] State restored after crash
- [ ] No data loss

### 10.4 Boundary Conditions
- [ ] Zero values handled
- [ ] Negative values handled
- [ ] Maximum values handled
- [ ] Minimum values handled
- [ ] Null/nil values handled

---

## 11. Performance & Memory

### 11.1 Performance
- [ ] App launches quickly (<3 seconds)
- [ ] Tab switching instant
- [ ] Calculations instant
- [ ] No UI lag or stuttering
- [ ] Animations smooth (60fps)

### 11.2 Memory
- [ ] No memory leaks detected
- [ ] Memory usage reasonable (<50MB idle)
- [ ] Memory released on background
- [ ] No retain cycles
- [ ] Instruments profiling clean

### 11.3 Battery
- [ ] No excessive CPU usage
- [ ] No excessive battery drain
- [ ] Background activity minimal
- [ ] Location services not used

---

## 12. Accessibility

### 12.1 VoiceOver
- [ ] All buttons labeled correctly
- [ ] Calculator buttons readable
- [ ] Tab bar readable
- [ ] Proper element ordering
- [ ] Hints provided where needed

### 12.2 Dynamic Type
- [ ] Text scales with system setting
- [ ] Layout adapts to larger text
- [ ] No text truncation
- [ ] Readability maintained

### 12.3 Accessibility Identifiers
- [ ] All interactive elements have IDs
- [ ] IDs unique and descriptive
- [ ] UI tests can locate elements
- [ ] IDs follow naming convention

### 12.4 Color & Contrast
- [ ] Sufficient contrast ratios
- [ ] Colors distinguishable
- [ ] Dark mode support
- [ ] Colorblind-friendly

---

## Test Results Summary

### Critical Issues (Must Fix)
- [ ] List any critical bugs that prevent release

### Major Issues (Should Fix)
- [ ] List any major bugs that impact UX

### Minor Issues (Nice to Fix)
- [ ] List any minor bugs or improvements

### Passed Tests
- [ ] List all passed test categories

---

## Sign-Off

- [ ] All critical tests passed
- [ ] All major tests passed
- [ ] App ready for TestFlight
- [ ] App ready for App Store submission

**Tested By**: _______________
**Date**: _______________
**Approved**: [ ] Yes [ ] No
