import SwiftUI

/// Theme picker view for drill-in navigation from Settings
public struct ThemePickerView: View {
    @Binding var selectedTheme: GlassTheme.Theme
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric(relativeTo: .caption2) private var proBadgeSize: CGFloat = 9
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    // iOS 18 zoom transition support for theme preview
    @Namespace private var themeNamespace
    @State private var previewTheme: GlassTheme.Theme?

    private var storeKit: StoreKitManager { StoreKitManager.shared }

    public init(selectedTheme: Binding<GlassTheme.Theme>) {
        self._selectedTheme = selectedTheme
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: GlassTheme.spacingSmall) {
                ForEach(GlassTheme.Theme.allCases) { theme in
                    themeCard(theme)
                }
            }
            .padding()
            .prismContentMaxWidth()
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Theme")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
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
                themePreview(for: theme, isSelected: isSelected, isLocked: isLocked)
                themeNameLabel(theme)
            }
            .padding(GlassTheme.spacingSmall)
            .background(cardBackground(isSelected: isSelected))
            .opacity(isLocked ? 0.6 : 1)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedTheme)
        .matchedTransitionSource(id: theme.id, in: themeNamespace)
        .onLongPressGesture(minimumDuration: 0.5) {
            previewTheme = theme
        }
        .accessibilityLabel(themeAccessibilityLabel(theme, isSelected: isSelected, isLocked: isLocked))
        .accessibilityHint(isLocked ? "Upgrade to Pro to use this theme" : "Double tap to select")
    }

    // MARK: - Theme Card Subviews

    @MainActor @ViewBuilder
    private func themePreview(
        for theme: GlassTheme.Theme,
        isSelected: Bool,
        isLocked: Bool
    ) -> some View {
        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusSmall)
            .fill(
                LinearGradient(
                    colors: gradientColors(for: theme),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 80)
            .overlay(
                GlassTheme.glassCardBackground(
                    cornerRadius: GlassTheme.cornerRadiusSmall,
                    material: .ultraThin,
                    reduceTransparency: reduceTransparency
                )
                .padding(12)
            )
            .overlay(themeStatusIcon(isSelected: isSelected, isLocked: isLocked))
    }

    @ViewBuilder
    private func themeStatusIcon(isSelected: Bool, isLocked: Bool) -> some View {
        if isLocked {
            Image(systemName: "lock.fill")
                .font(.title3)
                .foregroundStyle(.white)
        } else if isSelected {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
        }
    }

    @MainActor
    private func themeNameLabel(_ theme: GlassTheme.Theme) -> some View {
        HStack {
            Text(theme.rawValue)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.text)

            if theme.isPro && !storeKit.isPro {
                Text("PRO")
                    .font(.system(size: proBadgeSize, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(GlassTheme.primary))
            }
        }
    }

    private func cardBackground(isSelected: Bool) -> some View {
        GlassTheme.glassCardBackground(
            cornerRadius: GlassTheme.cornerRadiusMedium,
            material: .thin,
            reduceTransparency: reduceTransparency
        )
        .overlay(
            RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusMedium)
                .stroke(isSelected ? GlassTheme.primary : Color.clear, lineWidth: 2)
        )
    }

    private func themeAccessibilityLabel(
        _ theme: GlassTheme.Theme,
        isSelected: Bool,
        isLocked: Bool
    ) -> String {
        "\(theme.rawValue) theme" +
        "\(isSelected ? ", selected" : "")" +
        "\(isLocked ? ", locked, requires Pro" : "")"
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
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ThemePickerView(selectedTheme: .constant(.aurora))
    }
}
