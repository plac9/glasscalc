import SwiftUI

/// Settings view with organized sections for appearance, customization, and pro features
public struct SettingsView: View {
    @AppStorage("selectedTheme") private var selectedThemeName: String = GlassTheme.Theme.aurora.rawValue
    @State private var showThemePicker: Bool = false
    @ScaledMetric(relativeTo: .caption2) private var proBadgeSize: CGFloat = 9
    @ScaledMetric(relativeTo: .title2) private var aboutIconSize: CGFloat = 48
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

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

                    // Customization Section
                    CustomizationSection()
                        .scrollTransition { content, phase in
                            content
                                .opacity(reduce || phase.isIdentity ? 1 : 0.8)
                                .scaleEffect(reduce || phase.isIdentity ? 1 : 0.98)
                        }

                    // Pro Features (near bottom)
                    if !storeKit.isPro {
                        ProUpgradeSection()
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
            .scrollContentBackground(.hidden)
            .background(.clear)
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            #endif
        }
        .background(.clear)
        .onAppear {
            // Sync stored theme on appear (in case it was changed externally)
            if selectedThemeName != GlassTheme.currentTheme.rawValue {
                selectedThemeName = GlassTheme.currentTheme.rawValue
            }
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
