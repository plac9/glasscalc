import SwiftUI

/// Settings view with theme selection and app info
public struct SettingsView: View {
    @State private var selectedTheme: GlassTheme.Theme = .aurora
    @State private var showPurchaseError: Bool = false

    // iOS 18 zoom transition support for theme preview
    @Namespace private var themeNamespace
    @State private var previewTheme: GlassTheme.Theme?

    private var storeKit: StoreKitManager { StoreKitManager.shared }

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Theme Selection
                themeSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.8)
                            .scaleEffect(phase.isIdentity ? 1 : 0.98)
                    }

                // Pro Features
                proSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.8)
                            .blur(radius: phase.isIdentity ? 0 : 2)
                    }

                // About
                aboutSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.8)
                            .scaleEffect(phase.isIdentity ? 1 : 0.98)
                    }
            }
            .padding()
        }
        .onAppear {
            selectedTheme = GlassTheme.currentTheme
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
                    selectedTheme = theme
                    GlassTheme.currentTheme = theme
                }
                .navigationTransition(
                    .zoom(sourceID: theme.id, in: themeNamespace)
                )
            }
        }
        #endif
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
        let isLocked = theme.isPro && !storeKit.isPro

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
        // iOS 18 zoom transition source - long press for preview
        .matchedTransitionSource(id: theme.id, in: themeNamespace)
        .onLongPressGesture(minimumDuration: 0.5) {
            previewTheme = theme
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

