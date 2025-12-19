# AuADHD iOS Dev Workflow + PrismCalc

Visual, chunked, Apple-native. Search: /. Expand all: A.

## PrismCalc pipeline (glass-first)

Same structure, tuned for "latest glass visuals" + calculator trustworthiness.

SwiftUI-first
Visual polish = feature
Math must be correct

DEFINE VALUE -> MVP MODES -> UI SYSTEM -> CALC ENGINE -> GLASS COMPONENTS -> HAPTICS/ANIM -> TEST (MATH+UI) -> TESTFLIGHT -> RELEASE

## PrismCalc "must not fail" list

Landmines
- Math correctness (trust is everything)
- Readability (glass cannot mean low contrast)
- Performance (blur effects can be heavy)
- Accessibility (VoiceOver labels, Dynamic Type)

## PrismCalc phase cards

### P0 - Define it

Do
- Choose the hook: Beauty + Trust (premium glass that feels reliable)
- Pick a user: everyday iPhone users who frequently do money math (students, parents, bartenders)

Output
- Promise: "PrismCalc is for everyday iPhone users who want a gorgeous, trustworthy calculator for money math without clutter."
- Supporting features (v1):
  - Glass-first UI with one-tap clarity
  - Tip / discount / split tools (Pro)
  - History tape (last 10 free, unlimited Pro)

Checkpoint
- "PrismCalc is for everyday iPhone users who want a gorgeous, trustworthy calculator for money math without clutter."

Real world
- "Everyone" is not a target audience; pick a real scenario and optimize for it.

### P1 - Decide scope

Candidate modes (pick v1 + later)
- Basic (v1 default)
- History tape (v1, free + Pro upgrade)
- Tip / discount / split / convert (v1 Pro)
- Scientific (later)
- Programmer (later)
- Graphing / equation solver (later)

Output
- v1 mode decision: single primary layout with a floating tab bar; Calculator is the default tab.
- "Later" list: scientific, programmer, graphing, RPN.

Apple tips
- Fewer controls, more clarity. Tabs should feel like destinations, not clutter.

Checkpoint
- v1 has a single primary layout (Calculator tab as the anchor).

Real world
- Scientific mode doubles UI complexity; add only if it supports the promise.

### P2 - Design system

Glass UI Component Kit

Do
- Define button styles (digit, operator, utility) with normal/pressed/disabled states.
- Define display styles (entry, result, error).
- Define theme tokens (material, gradients, text color, accent).

Output
- Reusable SwiftUI components:
  - GlassButton
  - GlassCard
  - GlassDisplay
  - ArcSlider (tip/discount)
- Contrast rules: minimum 4.5:1 for body text; use system materials for accessibility.

Apple tips
- Prefer system materials so Light/Dark and accessibility adapt automatically.

Checkpoint
- Themes swap without screen rewrites.

Real world
- Glass looks cool until text is unreadable. Contrast is your religion now.

### P3 - Trust

Calculator Engine (logic before UI)

Do
- Behavior: immediate-execution (Apple-style) for core calculator.
- Error states: divide by zero -> "Error"; NaN/Infinity -> "Error".
- Formatting: avoid scientific notation for reasonable numbers; cap decimals.

Output
- Pure logic module: CalculatorEngine (format/parse/calculate)
- Unit tests for sequences and edge cases (percent, negation, large values, divide by zero)

Checkpoint
- 50+ unit tests pass before UI polish.

Real world
- Beautiful UI with wrong answers is instant uninstall energy.

### P4 - Delight

Haptics + Animations (tasteful)

Do
- One tap haptic style for keys (light selection).
- Pressed-state animation: fast, subtle scale (0.96-0.98, 80-120ms).

Output
- Consistent tactile feel
- Motion that reads as premium, not noisy

Checkpoint
- Feels premium, not arcade.

Real world
- Too much motion reads as "toy," not "tool."

### P5 - Prove it

Test Plan (math + glass)

Do
- Math regression suite for common sequences and edge cases.
- Contrast checks (Light/Dark + Large Text).
- Performance spot checks on device (blur cost, list scrolling).

Output
- Release checklist
- Known-issues log

Checkpoint
- No crashes, no unreadable states, no wrong answers.

Real world
- Blur is often the biggest performance culprit. Verify on device, not just simulator.

### P6 - Launch

App Store Packaging

Do
- 3 hero screenshots:
  - Main calculator (glass clarity + readability)
  - Tip/split (real-world utility)
  - Themes or history (premium depth)
- Privacy: likely "No data collected" (confirm before submission).

Output
- App Store Connect entry
- Release build

Checkpoint
- Store page explains the app without paragraphs.

Real world
- Reviewers hate confusion more than they hate bugs. Make it obvious.
