import SwiftUI

/// Settings view with organized sections for appearance, customization, and pro features
public struct SettingsView: View {
    @AppStorage("selectedTheme") private var selectedThemeName: String = GlassTheme.Theme.aurora.rawValue
    @State private var showPurchaseError: Bool = false
    @State private var showThemePicker: Bool = false
    @ScaledMetric(relativeTo: .caption2) private var proBadgeSize: CGFloat = 9
    @ScaledMetric(relativeTo: .title2) private var aboutIconSize: CGFloat = 48
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("zeroOnRight") private var zeroOnRight: Bool = false

    /// Current theme derived from stored name
    private var selectedTheme: GlassTheme.Theme {
        GlassTheme.Theme(rawValue: selectedThemeName) ?? .aurora
    }

    /// Binding for theme picker that syncs both storage and static property
    private var selectedThemeBinding: Binding<GlassTheme.Theme> {
        Binding(
            get: { selectedTheme },
            set: { newTheme in
                selectedThemeName = newTheme.rawValue
                GlassTheme.currentTheme = newTheme
            }
        )
    }

    // iOS 18 zoom transition support for theme preview
    @Namespace private var themeNamespace
    @State private var previewTheme: GlassTheme.Theme?

    private var storeKit: StoreKitManager { StoreKitManager.shared }

    public init() {}

    public var body: some View {
        let reduce = reduceMotion
        NavigationStack {
            ScrollView {
                VStack(spacing: GlassTheme.spacingLarge) {
                    // Appearance Section
                    appearanceSection
                        .scrollTransition { content, phase in
                            content
                                .opacity(reduce || phase.isIdentity ? 1 : 0.8)
                                .scaleEffect(reduce || phase.isIdentity ? 1 : 0.98)
                        }

                    // Customization Section (placeholders for M3)
                    customizationSection
                        .scrollTransition { content, phase in
                            content
                                .opacity(reduce || phase.isIdentity ? 1 : 0.8)
                                .scaleEffect(reduce || phase.isIdentity ? 1 : 0.98)
                        }

                    // Pro Features (near bottom)
                    if !storeKit.isPro {
                        proSection
                            .scrollTransition { content, phase in
                                content
                                    .opacity(reduce || phase.isIdentity ? 1 : 0.8)
                                    .blur(radius: reduce || phase.isIdentity ? 0 : 2)
                            }
                    }

                    // About (at bottom)
                    aboutSection
                        .scrollTransition { content, phase in
                            content
                                .opacity(reduce || phase.isIdentity ? 1 : 0.8)
                                .scaleEffect(reduce || phase.isIdentity ? 1 : 0.98)
                        }
                }
                .padding()
            }
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            #endif
        }
        .onAppear {
            // Sync stored theme on appear (in case it was changed externally)
            if selectedThemeName != GlassTheme.currentTheme.rawValue {
                selectedThemeName = GlassTheme.currentTheme.rawValue
            }
        }
        .alert("Purchase Error", isPresented: $showPurchaseError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(storeKit.errorMessage ?? "An error occurred")
        }
        #if os(iOS)
        // iOS 18 zoom transition for theme preview using dedicated view
        .fullScreenCover(item: $previewTheme) { theme in
            if #available(iOS 18.0, *) {
                ThemePreviewView(theme: theme) {
                    selectedThemeBinding.wrappedValue = theme
                }
                .navigationTransition(
                    .zoom(sourceID: theme.id, in: themeNamespace)
                )
            }
        }
        #endif
    }

    // MARK: - Appearance Section

    @MainActor
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
            Text("Appearance")
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
                .textCase(.uppercase)
                .padding(.leading, GlassTheme.spacingSmall)

            GlassCard(material: .thinMaterial, padding: 0) {
                VStack(spacing: 0) {
                    // Theme picker - drill-in navigation
                    NavigationLink {
                        ThemePickerView(selectedTheme: selectedThemeBinding)
                    } label: {
                        HStack {
                            Image(systemName: "paintpalette")
                                .foregroundStyle(GlassTheme.primary)
                                .frame(width: 28)

                            Text("Theme")
                                .font(GlassTheme.bodyFont)
                                .foregroundStyle(GlassTheme.text)

                            Spacer()

                            // Current theme preview
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: gradientColors(for: selectedTheme),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 24, height: 24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(GlassTheme.text.opacity(0.2), lineWidth: 1)
                                )

                            Text(selectedTheme.rawValue)
                                .font(GlassTheme.captionFont)
                                .foregroundStyle(GlassTheme.textSecondary)

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(GlassTheme.textTertiary)
                        }
                        .padding(GlassTheme.spacingMedium)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Theme, currently \(selectedTheme.rawValue)")
                    .accessibilityHint("Double tap to change theme")

                    Divider()
                        .background(GlassTheme.text.opacity(0.1))

                    // App Icon (placeholder for future)
                    HStack {
                        Image(systemName: "app.badge")
                            .foregroundStyle(GlassTheme.primary)
                            .frame(width: 28)

                        Text("App Icon")
                            .font(GlassTheme.bodyFont)
                            .foregroundStyle(GlassTheme.text)

                        Spacer()

                        if !storeKit.isPro {
                            Text("PRO")
                                .font(.system(size: proBadgeSize, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(GlassTheme.primary))
                        }

                        Text("Default")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(GlassTheme.textTertiary)
                    }
                    .padding(GlassTheme.spacingMedium)
                    .opacity(0.5) // Disabled for now
                    .accessibilityLabel("App Icon, coming soon")
                    .accessibilityHint("This feature is not yet available")
                }
            }
        }
    }

    // MARK: - Customization Section

    @MainActor
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
            Text("Customization")
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
                .textCase(.uppercase)
                .padding(.leading, GlassTheme.spacingSmall)

            GlassCard(material: .thinMaterial, padding: 0) {
                VStack(spacing: 0) {
                    // Keypad Layout - 0 position toggle (M3-T2)
                    HStack {
                        Image(systemName: "number.square")
                            .foregroundStyle(GlassTheme.primary)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Zero on Right")
                                .font(GlassTheme.bodyFont)
                                .foregroundStyle(GlassTheme.text)

                            Text("Swap 0 and decimal positions")
                                .font(GlassTheme.captionFont)
                                .foregroundStyle(GlassTheme.textTertiary)
                        }

                        Spacer()

                        Toggle("", isOn: $zeroOnRight)
                            .tint(GlassTheme.primary)
                            .labelsHidden()
                    }
                    .padding(GlassTheme.spacingMedium)
                    .sensoryFeedback(.selection, trigger: zeroOnRight)
                    .accessibilityLabel("Zero on right")
                    .accessibilityHint("When enabled, the zero button appears on the right side of the keypad")

                    Divider()
                        .background(GlassTheme.text.opacity(0.1))

                    // Tab Order - Reset option (M3-T1)
                    Button {
                        resetTabOrder()
                    } label: {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                                .foregroundStyle(GlassTheme.primary)
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Reset Tab Order")
                                    .font(GlassTheme.bodyFont)
                                    .foregroundStyle(GlassTheme.text)

                                Text("Long-press tabs on iPad to reorder")
                                    .font(GlassTheme.captionFont)
                                    .foregroundStyle(GlassTheme.textTertiary)
                            }

                            Spacer()

                            Image(systemName: "arrow.counterclockwise")
                                .font(.caption)
                                .foregroundStyle(GlassTheme.textSecondary)
                        }
                        .padding(GlassTheme.spacingMedium)
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.selection, trigger: false)
                    .accessibilityLabel("Reset tab order")
                    .accessibilityHint("Restores tabs to their default order")

                    Divider()
                        .background(GlassTheme.text.opacity(0.1))

                    // Widget Settings (M3-T3)
                    NavigationLink {
                        WidgetSettingsView()
                    } label: {
                        HStack {
                            Image(systemName: "widget.small")
                                .foregroundStyle(GlassTheme.primary)
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Widgets")
                                    .font(GlassTheme.bodyFont)
                                    .foregroundStyle(GlassTheme.text)

                                Text("Add widgets to Home Screen")
                                    .font(GlassTheme.captionFont)
                                    .foregroundStyle(GlassTheme.textTertiary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(GlassTheme.textTertiary)
                        }
                        .padding(GlassTheme.spacingMedium)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Widgets")
                    .accessibilityHint("View available widgets and how to add them")
                }
            }
        }
    }

    private func resetTabOrder() {
        // Clear the tab customization from UserDefaults to reset to default order
        UserDefaults.standard.removeObject(forKey: "tabCustomization")
        // Provide haptic feedback
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }

    private func gradientColors(for theme: GlassTheme.Theme) -> [Color] {
        switch theme {
        case .aurora: return GlassTheme.auroraGradient
        case .calmingBlues: return GlassTheme.calmingBluesGradient
        case .forestEarth: return GlassTheme.forestEarthGradient
        case .softTranquil: return GlassTheme.softTranquilGradient
        case .blueGreenHarmony: return GlassTheme.blueGreenGradient
        case .midnight: return GlassTheme.midnightGradient
        }
    }

    // MARK: - Pro Section

    @MainActor
    private var proSection: some View {
        GlassCard {
            VStack(spacing: GlassTheme.spacingMedium) {
                HStack {
                    VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                        Text("PrismCalc Pro")
                            .font(GlassTheme.headlineFont)
                            .foregroundStyle(GlassTheme.text)

                        Text(storeKit.isPro ? "All features unlocked" : "Unlock all features")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                    }

                    Spacer()

                    if storeKit.isPro {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title)
                            .foregroundStyle(GlassTheme.success)
                    }
                }

                if !storeKit.isPro {
                    VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                        proFeatureRow(icon: "percent", text: "Tip Calculator")
                        proFeatureRow(icon: "tag", text: "Discount Calculator")
                        proFeatureRow(icon: "person.2", text: "Split Bill")
                        proFeatureRow(icon: "arrow.left.arrow.right", text: "Unit Converter")
                        proFeatureRow(icon: "paintpalette", text: "All 6 Themes")
                        proFeatureRow(icon: "clock.arrow.circlepath", text: "Unlimited History")
                    }

                    // Purchase Button
                    Button {
                        Task {
                            do {
                                try await storeKit.purchase()
                            } catch {
                                showPurchaseError = true
                            }
                        }
                    } label: {
                        HStack {
                            if storeKit.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Upgrade for \(storeKit.proPrice)")
                            }
                        }
                        .font(GlassTheme.bodyFont)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [GlassTheme.primary, GlassTheme.secondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(storeKit.isLoading)
                    .accessibilityLabel("Upgrade to Pro for \(storeKit.proPrice)")
                    .accessibilityHint("Unlocks all Pro features including tip calculator, discount calculator, and more")

                    // Restore Purchases
                    Button {
                        Task {
                            await storeKit.restorePurchases()
                            if storeKit.errorMessage != nil && !storeKit.isPro {
                                showPurchaseError = true
                            }
                        }
                    } label: {
                        Text("Restore Purchases")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.primary)
                    }
                    .buttonStyle(.plain)
                    .disabled(storeKit.isLoading)
                    .accessibilityLabel("Restore purchases")
                    .accessibilityHint("Restores previously purchased Pro features")
                }
            }
        }
    }

    @MainActor
    private func proFeatureRow(icon: String, text: String) -> some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            Image(systemName: icon)
                .foregroundStyle(GlassTheme.primary)
                .frame(width: 24)

            Text(text)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
        }
    }

    // MARK: - About Section

    @MainActor
    private var aboutSection: some View {
        GlassCard(material: .ultraThinMaterial) {
            VStack(spacing: GlassTheme.spacingMedium) {
                Image(systemName: "equal.square.fill")
                    .font(.system(size: aboutIconSize))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [GlassTheme.primary, GlassTheme.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("PrismCalc")
                    .font(GlassTheme.titleFont)
                    .foregroundStyle(GlassTheme.text)

                Text("Version 1.0.0")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                Text("A LaClair Tech App")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: GlassTheme.auroraGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        SettingsView()
    }
}

