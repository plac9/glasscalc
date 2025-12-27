import SwiftUI

/// Full-screen animated preview of a theme with iOS 18 zoom transition support
@available(iOS 18.0, *)
public struct ThemePreviewView: View {
    let theme: GlassTheme.Theme
    let onApply: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(MeshAnimationSettings.animationEnabledKey) private var meshAnimationEnabled: Bool = true
    @AppStorage(MeshAnimationSettings.reducedFrameRateKey) private var meshReducedFrameRate: Bool = false
    @State private var isLowPowerMode: Bool = ProcessInfo.processInfo.isLowPowerModeEnabled
    @State private var thermalState: ProcessInfo.ThermalState = ProcessInfo.processInfo.thermalState
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
            AnimatedMeshBackground(
                config: meshConfig(for: theme),
                animated: shouldAnimateMesh,
                frameInterval: meshFrameInterval
            )
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
        #if os(iOS)
        .onReceive(NotificationCenter.default.publisher(for: .NSProcessInfoPowerStateDidChange)) { _ in
            isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        }
        #endif
        .onReceive(NotificationCenter.default.publisher(for: ProcessInfo.thermalStateDidChangeNotification)) { _ in
            thermalState = ProcessInfo.processInfo.thermalState
        }
    }

    // MARK: - Theme Info Section

    @MainActor
    private var themeInfoSection: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            // Theme icon
            themeIconView
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(.white)

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

    // MARK: - Theme Icon (Reduce Motion Support)

    @MainActor @ViewBuilder
    private var themeIconView: some View {
        if reduceMotion {
            Image(systemName: "paintpalette.fill")
        } else {
            Image(systemName: "paintpalette.fill")
                .symbolEffect(.breathe, options: .repeating)
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
        if reduceMotion {
            showApplied = true
        } else {
            withAnimation(GlassTheme.springAnimation) {
                showApplied = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if reduceMotion {
                showApplied = false
            } else {
                withAnimation(GlassTheme.springAnimation) {
                    showApplied = false
                }
            }
            // Dismiss after showing feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        }
    }

    private var shouldAnimateMesh: Bool {
        guard meshAnimationEnabled else { return false }
        guard !reduceMotion else { return false }
        guard scenePhase == .active else { return false }
        if isLowPowerMode { return false }
        switch thermalState {
        case .serious, .critical:
            return false
        default:
            return true
        }
    }

    private var meshFrameInterval: Double {
        let useReducedRate = meshReducedFrameRate || thermalState == .fair
        return useReducedRate ? (1.0 / 15.0) : (1.0 / 30.0)
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
