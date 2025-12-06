import SwiftUI

/// Settings view with theme selection and app info
public struct SettingsView: View {
    @State private var selectedTheme: GlassTheme.Theme = .aurora
    @State private var isPro: Bool = false // Simulated for now

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Theme Selection
                themeSection

                // Pro Features
                proSection

                // About
                aboutSection
            }
            .padding()
        }
        .onAppear {
            selectedTheme = GlassTheme.currentTheme
        }
    }

    // MARK: - Theme Section

    @MainActor
    private var themeSection: some View {
        VStack(alignment: .leading, spacing: GlassTheme.spacingMedium) {
            Text("Theme")
                .font(GlassTheme.headlineFont)
                .foregroundStyle(GlassTheme.text)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: GlassTheme.spacingSmall) {
                ForEach(GlassTheme.Theme.allCases) { theme in
                    themeCard(theme)
                }
            }
        }
    }

    @MainActor
    private func themeCard(_ theme: GlassTheme.Theme) -> some View {
        let isSelected = selectedTheme == theme
        let isLocked = theme.isPro && !isPro

        return Button {
            guard !isLocked else { return }
            withAnimation(GlassTheme.springAnimation) {
                selectedTheme = theme
                GlassTheme.currentTheme = theme
            }
        } label: {
            VStack(spacing: GlassTheme.spacingSmall) {
                // Theme Preview
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusSmall)
                    .fill(
                        LinearGradient(
                            colors: gradientColors(for: theme),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusSmall)
                            .fill(.ultraThinMaterial)
                            .padding(8)
                    )
                    .overlay(
                        Group {
                            if isLocked {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.white)
                            }
                        }
                    )

                // Theme Name
                HStack {
                    Text(theme.rawValue)
                        .font(GlassTheme.captionFont)
                        .foregroundStyle(GlassTheme.text)

                    if theme.isPro {
                        Text("PRO")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(GlassTheme.primary)
                            )
                    }
                }
            }
            .padding(GlassTheme.spacingSmall)
            .background(
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusMedium)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusMedium)
                            .stroke(
                                isSelected ? GlassTheme.primary : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .opacity(isLocked ? 0.6 : 1)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedTheme)
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
                        Text("GlassCalc Pro")
                            .font(GlassTheme.headlineFont)
                            .foregroundStyle(GlassTheme.text)

                        Text("Unlock all features")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                    }

                    Spacer()

                    if isPro {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title)
                            .foregroundStyle(GlassTheme.success)
                    }
                }

                if !isPro {
                    VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                        proFeatureRow(icon: "percent", text: "Tip Calculator")
                        proFeatureRow(icon: "tag", text: "Discount Calculator")
                        proFeatureRow(icon: "person.2", text: "Split Bill")
                        proFeatureRow(icon: "arrow.left.arrow.right", text: "Unit Converter")
                        proFeatureRow(icon: "paintpalette", text: "All 6 Themes")
                        proFeatureRow(icon: "clock.arrow.circlepath", text: "Unlimited History")
                    }

                    Button {
                        // TODO: StoreKit purchase
                        isPro = true
                    } label: {
                        Text("Upgrade for $2.99")
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
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [GlassTheme.primary, GlassTheme.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("GlassCalc")
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
