import SwiftUI

/// Custom "More" view that provides themed navigation to overflow features
/// Replaces the system-generated "More" screen from sidebarAdaptable tab style
public struct MoreView: View {
    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 24
    @ScaledMetric(relativeTo: .caption2) private var proBadgeSize: CGFloat = 9

    private var storeKit: StoreKitManager { StoreKitManager.shared }

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                // Themed mesh gradient background - embedded directly
                ThemedMeshBackground()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: GlassTheme.spacingMedium) {
                        // Unit Converter
                        moreItem(
                            title: "Convert",
                            icon: "arrow.left.arrow.right",
                            isPro: true
                        ) {
                            ProGatedView(featureName: "Unit Converter", featureIcon: "arrow.left.arrow.right") {
                                UnitConverterView()
                            }
                        }

                        // History
                        moreItem(
                            title: "History",
                            icon: "clock.arrow.circlepath",
                            isPro: true
                        ) {
                            ProGatedView(featureName: "History", featureIcon: "clock.arrow.circlepath") {
                                HistoryView()
                            }
                        }

                        // Settings
                        moreItem(
                            title: "Settings",
                            icon: "gearshape",
                            isPro: false
                        ) {
                            SettingsView()
                        }
                    }
                    .padding()
                    .prismContentMaxWidth()
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("More")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            #endif
        }
    }

    @ViewBuilder
    private func moreItem<Destination: View>(
        title: String,
        icon: String,
        isPro: Bool,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        NavigationLink {
            ThemedContent {
                destination()
            }
        } label: {
            GlassCard(material: .thinMaterial) {
                HStack(spacing: GlassTheme.spacingMedium) {
                    // Icon with gradient background
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [GlassTheme.primary, GlassTheme.secondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)

                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    Text(title)
                        .font(GlassTheme.titleFont)
                        .foregroundStyle(GlassTheme.text)

                    Spacer()

                    if isPro && !storeKit.isPro {
                        Text("PRO")
                            .font(.system(size: proBadgeSize, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(GlassTheme.primary))
                    }

                    Image(systemName: "chevron.right")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(GlassTheme.textTertiary)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(isPro && !storeKit.isPro ? "Pro feature" : "")
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: GlassTheme.blueGreenGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        MoreView()
    }
}
