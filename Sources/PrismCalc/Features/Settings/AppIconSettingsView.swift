import SwiftUI

#if os(iOS)
import UIKit
#endif

/// App icon selection (Pro-only alternates).
public struct AppIconSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIconName: String? = nil
    @State private var errorMessage: String?

    private let storeKit = StoreKitManager.shared

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GlassTheme.spacingLarge) {
                Text("App Icon")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)
                    .textCase(.uppercase)
                    .padding(.leading, GlassTheme.spacingSmall)

                GlassCard(material: .thinMaterial, padding: 0) {
                    VStack(spacing: 0) {
                        ForEach(Self.iconOptions) { option in
                            Button {
                                applyIcon(option)
                            } label: {
                                HStack {
                                    Image(systemName: option.symbol)
                                        .foregroundStyle(option.isPrimary ? GlassTheme.primary : GlassTheme.secondary)
                                        .frame(width: 28)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.title)
                                            .font(GlassTheme.bodyFont)
                                            .foregroundStyle(GlassTheme.text)

                                        Text(option.subtitle)
                                            .font(GlassTheme.captionFont)
                                            .foregroundStyle(GlassTheme.textSecondary)
                                    }

                                    Spacer()

                                    if !storeKit.isPro && option.isProOnly {
                                        Text("PRO")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Capsule().fill(GlassTheme.primary))
                                    } else if option.iconName == selectedIconName || (option.isPrimary && selectedIconName == nil) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(GlassTheme.primary)
                                    }
                                }
                                .padding(GlassTheme.spacingMedium)
                            }
                            .buttonStyle(.plain)
                            .disabled(!storeKit.isPro && option.isProOnly)

                            if option.id != Self.iconOptions.last?.id {
                                Divider()
                                    .background(GlassTheme.text.opacity(0.1))
                            }
                        }
                    }
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(GlassTheme.captionFont)
                        .foregroundStyle(GlassTheme.error)
                        .padding(.horizontal, GlassTheme.spacingSmall)
                }
            }
            .padding()
            .prismContentMaxWidth()
        }
        .navigationTitle("App Icon")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        #endif
        .onAppear {
            selectedIconName = Self.currentIconName
        }
    }

    private func applyIcon(_ option: AppIconOption) {
        #if os(iOS)
        guard UIApplication.shared.supportsAlternateIcons else {
            errorMessage = "Alternate icons are not supported on this device."
            return
        }

        if !storeKit.isPro && option.isProOnly {
            errorMessage = "Alternate icons require prismCalc Pro."
            return
        }

        UIApplication.shared.setAlternateIconName(option.iconName) { error in
            DispatchQueue.main.async {
                if let error {
                    errorMessage = error.localizedDescription
                } else {
                    errorMessage = nil
                    selectedIconName = option.iconName
                }
            }
        }
        #else
        errorMessage = "Alternate icons are only available on iOS and iPadOS."
        #endif
    }

    static func displayName(for iconName: String?) -> String {
        iconOptions.first(where: { $0.iconName == iconName })?.title ?? "Default"
    }

    #if os(iOS)
    private static var currentIconName: String? {
        UIApplication.shared.alternateIconName
    }
    #else
    private static var currentIconName: String? {
        nil
    }
    #endif

    private static let iconOptions: [AppIconOption] = [
        AppIconOption(
            id: "primary",
            title: "Default (Dark Glass)",
            subtitle: "Classic prism with rainbow grid.",
            symbol: "app.fill",
            iconName: nil,
            isPrimary: true,
            isProOnly: false
        ),
        AppIconOption(
            id: "light",
            title: "Light Glass",
            subtitle: "Bright glass with pastel grid.",
            symbol: "sun.max.fill",
            iconName: "LightGlass",
            isPrimary: false,
            isProOnly: true
        ),
        AppIconOption(
            id: "prism",
            title: "Prism Beam",
            subtitle: "Dark prism with rainbow beam.",
            symbol: "sparkles",
            iconName: "PrismBeam",
            isPrimary: false,
            isProOnly: true
        ),
        AppIconOption(
            id: "neon",
            title: "Neon Ops",
            subtitle: "Minimal neon operators.",
            symbol: "bolt.fill",
            iconName: "NeonOps",
            isPrimary: false,
            isProOnly: true
        ),
    ]
}

private struct AppIconOption: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let iconName: String?
    let isPrimary: Bool
    let isProOnly: Bool
}

#Preview {
    NavigationStack {
        AppIconSettingsView()
    }
}
