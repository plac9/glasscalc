import SwiftUI

/// Full-screen animated preview of a theme with iOS 18 zoom transition support
@available(iOS 18.0, *)
public struct ThemePreviewView: View {
    let theme: GlassTheme.Theme
    let onApply: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var showApplied = false
    @ScaledMetric(relativeTo: .title2) private var iconSize: CGFloat = 56
    @ScaledMetric(relativeTo: .caption2) private var proBadgeSize: CGFloat = 12

    public init(theme: GlassTheme.Theme, onApply: (() -> Void)? = nil) {
        self.theme = theme
        self.onApply = onApply
    }

    public var body: some View {
        ZStack {
            // Animated mesh gradient for this specific theme
            AnimatedMeshBackground(config: meshConfig(for: theme))
                .ignoresSafeArea()

            // Content overlay
            VStack {
                // Close button at top
                HStack {
                    Spacer()
                    GlassIconButton(
                        icon: "xmark",
                        style: .plain,
                        symbolAnimation: .bounce,
                        accessibilityLabel: "Close preview"
                    ) {
                        dismiss()
                    }
                }
                .padding()

                Spacer()

                // Theme info
                themeInfoSection

                Spacer()

                // Action buttons
                actionButtons
                    .padding(.bottom, 40)
            }
        }
        .overlay(alignment: .top) {
            if showApplied {
                appliedToast
            }
        }
    }

    // MARK: - Theme Info Section

    @MainActor
    private var themeInfoSection: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            // Theme icon
            Image(systemName: "paintpalette.fill")
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(.white)
                .symbolEffect(.breathe, options: .repeating)

            // Theme name
            Text(theme.rawValue)
                .font(GlassTheme.titleFont)
                .foregroundStyle(.white)

            // Pro badge if applicable
            if theme.isPro {
                Text("PRO")
                    .font(.system(size: proBadgeSize, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, GlassTheme.spacingSmall)
                    .padding(.vertical, GlassTheme.spacingXS)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.2))
                    )
            }
        }
    }

    // MARK: - Action Buttons

    @MainActor
    private var actionButtons: some View {
        HStack(spacing: GlassTheme.spacingMedium) {
            // Close button
            GlassPillButton(
                icon: "xmark",
                text: "Close",
                style: .secondary,
                symbolAnimation: .bounce
            ) {
                dismiss()
            }

            // Apply button (if callback provided)
            if let onApply = onApply {
                GlassPillButton(
                    icon: "checkmark",
                    text: "Apply Theme",
                    style: .primary,
                    symbolAnimation: .bounce
                ) {
                    onApply()
                    showAppliedFeedback()
                }
            }
        }
    }

    // MARK: - Applied Toast

    @MainActor
    private var appliedToast: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            Image(systemName: "checkmark.circle.fill")
            Text("Theme Applied!")
        }
        .font(GlassTheme.captionFont)
        .foregroundStyle(.white)
        .padding(.horizontal, GlassTheme.spacingMedium)
        .padding(.vertical, GlassTheme.spacingSmall)
        .background(
            Capsule()
                .fill(GlassTheme.success)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
        .padding(.top, GlassTheme.spacingLarge)
    }

    // MARK: - Helpers

    private func meshConfig(for theme: GlassTheme.Theme) -> MeshGradientConfig {
        switch theme {
        case .aurora:
            return .aurora
        case .calmingBlues:
            return .calmingBlues
        case .forestEarth:
            return .forestEarth
        case .softTranquil:
            return .softTranquil
        case .blueGreenHarmony:
            return .blueGreenHarmony
        case .midnight:
            return .midnight
        }
    }

    private func showAppliedFeedback() {
        withAnimation(GlassTheme.springAnimation) {
            showApplied = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(GlassTheme.springAnimation) {
                showApplied = false
            }
            // Dismiss after showing feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    if #available(iOS 18.0, *) {
        ThemePreviewView(theme: .aurora) {
            print("Applied aurora theme")
        }
    }
}

#Preview("Midnight Theme") {
    if #available(iOS 18.0, *) {
        ThemePreviewView(theme: .midnight)
    }
}
