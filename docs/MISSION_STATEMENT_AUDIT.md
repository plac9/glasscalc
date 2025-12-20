# PrismCalc Mission Statement Audit

Date: 2025-12-19
Scope: Purpose definition + alignment to current implementation

## Proposed Mission Statement (v1)

"PrismCalc is for everyday iPhone users who want a gorgeous, trustworthy calculator for money math without clutter."

## Purpose Definition

- Primary purpose: trusted daily money math (tips, discounts, splits, conversions) delivered through premium glass visuals.
- Secondary purpose: feel-good, Apple-native polish that makes routine calculations feel delightful, not utilitarian.
- Non-goals (v1): scientific, programmer, graphing, or heavy workflow features that add clutter.

## Alignment Check (Mission vs. Current State)

Strong alignment
- UI promise: glass-first design system with themed mesh gradients and glass components.
- Trust: CalculatorEngine + 100 tests provide correctness safeguards.
- Money math tools: tip, discount, split, history; currency conversion supports real-world spending.
- Delight: haptics + motion with reduce-motion respect.

Partial alignment
- Unit converter broadens scope beyond "money math"; it still supports the promise if positioned as "everyday practical conversions" and anchored by currency.
- App Store assets and messaging still needed to reflect the mission clearly.

Gap alignment
- No explicit mission statement in README or App Store metadata copy yet.
- Manual iOS checks for readability/accessibility still pending (Dynamic Type + VoiceOver).
- Performance profiling on device not yet documented for the glass visuals promise.

## Risks to Mission Clarity

- Over-broad toolset risks diluting the "money math" anchor.
- Glass visuals can compromise readability if contrast slips at larger Dynamic Type sizes.
- Performance regressions in blur/mesh could undermine "premium" feel.

## Recommendations (Mission-Forward)

1. Add the mission statement to README and App Store metadata so users see the purpose in one line.
2. Frame unit conversion as a practical money-adjacent feature (currency + common measurements).
3. Complete iOS-only accessibility/performance checks to confirm the "trustworthy" claim.
4. Keep future modes (scientific/programmer) explicitly out of v1 scope unless they reinforce the mission.
