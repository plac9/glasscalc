# PrismCalc Automation Run Plan

## Scope
- App: Liquid Glass background unification, high-contrast accessibility toggle, StoreKit OSLog diagnostics.
- Website: demo section, accessibility improvements, SEO/meta updates, content depth (About/Support/Roadmap).
- Product roadmap: scientific tools, currency/tax, smart split, localization, and web/PWA exploration.

## Preconditions
- Xcode 16+, Swift 6, macOS 15.
- App Store Connect credentials or API key (if metadata updates are automated).
- GitHub token (repo + Pages if needed).
- Playwright installed (for site QA) and working browser.

## Automated Run (Straight Line)
1. Sync repo state and verify clean working tree.
2. Run the automation script (preferred): `scripts/run-prismcalc-automation.sh`.
3. Apply app updates:
   - Update DesignSystem for Liquid Glass helpers.
   - Wire high-contrast state to GlassTheme + Settings.
   - Add OSLog diagnostics for StoreKit flows.
4. Run Swift build + tests:
   - `swift build`
   - `swift test`
5. Update website content + components:
   - Copy, FAQ, About, Demo, Accessibility, Roadmap sections.
   - Accessibility: focus-visible styles, high-contrast toggle, image alt text.
   - SEO: meta tags + structured headings.
6. Run website checks:
   - `npm install` (if needed), `npm run build`.
   - Playwright smoke tests for hero, demo, and high-contrast mode.
7. Capture QA artifacts:
   - Use Playwright screenshots for hero, demo, and FAQ sections.
   - Save in `website/docs/` or `screenshots/` with timestamps.
8. Update planning + logs:
   - Append daily note entry every 15 minutes.
   - Send cadence email using `send-status-email.py`.
9. Commit and push once checks pass.

## Automation Hooks
- Runner script: `scripts/run-prismcalc-automation.sh` orchestrates steps 1-9.
- Playwright:
  - Use a scripted flow for theme + high-contrast toggles, then snapshot key sections.
- API integrations:
  - GitHub API: open PRs and attach artifacts.
  - App Store Connect API: update release notes, pricing, and metadata.
  - Vizzini: queue roadmap tasks, capture outcomes, and sync status back to docs.

## Logging Cadence
- Daily note every 15 minutes while active.
- Email status every 15 minutes:
  - `python3 ~/dev/.standards/send-status-email.py --agent Codex --focus "prismcalc" --status "in progress" --next "..." --blockers "None" --changes "..." --debt "..."`

## Roadmap Follow-Through (Automation Targets)
- Generate GitHub issues from `Roadmap` section data.
- Auto-build website previews and attach to PRs.
- Add CI checks for contrast ratios and Lighthouse accessibility audits.
