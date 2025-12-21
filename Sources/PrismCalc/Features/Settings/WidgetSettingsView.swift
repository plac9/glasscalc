import SwiftUI
import WidgetKit

/// Widget management view showing available widgets with previews and add instructions
public struct WidgetSettingsView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init() {}

    public var body: some View {
        let reduce = reduceMotion

        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Instructions section
                instructionsSection
                    .scrollTransition { content, phase in
                        content.opacity(reduce || phase.isIdentity ? 1 : 0.85)
                    }

                // Widget previews
                widgetPreviewsSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.85)
                            .scaleEffect(reduce || phase.isIdentity ? 1 : 0.98)
                    }

                // Tips section
                tipsSection
                    .scrollTransition { content, phase in
                        content.opacity(reduce || phase.isIdentity ? 1 : 0.85)
                    }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Widgets")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        #endif
    }

    // MARK: - Instructions Section

    @MainActor
    private var instructionsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GlassTheme.spacingMedium) {
                HStack {
                    Image(systemName: "plus.app")
                        .font(.title2)
                        .foregroundStyle(GlassTheme.primary)

                    Text("Add Widgets to Home Screen")
                        .font(GlassTheme.headlineFont)
                        .foregroundStyle(GlassTheme.text)
                }

                VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                    instructionStep(number: 1, text: "Long-press on your Home Screen")
                    instructionStep(number: 2, text: "Tap the + button in the top corner")
                    instructionStep(number: 3, text: "Search for \"PrismCalc\"")
                    instructionStep(number: 4, text: "Choose a widget size and tap \"Add Widget\"")
                }
            }
        }
    }

    @MainActor
    private func instructionStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: GlassTheme.spacingSmall) {
            Text("\(number)")
                .font(GlassTheme.captionFont)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(Circle().fill(GlassTheme.primary))

            Text(text)
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.text)
        }
    }

    // MARK: - Widget Previews Section

    @MainActor
    private var widgetPreviewsSection: some View {
        VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
            Text("Available Widgets")
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
                .textCase(.uppercase)
                .padding(.leading, GlassTheme.spacingSmall)

            VStack(spacing: GlassTheme.spacingMedium) {
                // Small widget preview
                widgetPreviewCard(
                    size: "Small",
                    description: "Quick result and feature shortcuts",
                    icon: "square"
                ) {
                    AdaptiveWidgetPreview(family: .systemSmall)
                }

                // Medium widget preview
                widgetPreviewCard(
                    size: "Medium",
                    description: "Latest result with quick action grid",
                    icon: "rectangle"
                ) {
                    AdaptiveWidgetPreview(family: .systemMedium)
                }

                // Large widget preview
                widgetPreviewCard(
                    size: "Large",
                    description: "Full result, actions, and history",
                    icon: "square.fill"
                ) {
                    AdaptiveWidgetPreview(family: .systemLarge)
                }
            }
        }
    }

    @MainActor
    private func widgetPreviewCard<Content: View>(
        size: String,
        description: String,
        icon: String,
        @ViewBuilder previewContent: @escaping () -> Content
    ) -> some View {
        GlassCard(material: .thinMaterial) {
            VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(GlassTheme.primary)

                    Text(size)
                        .font(GlassTheme.bodyFont)
                        .fontWeight(.medium)
                        .foregroundStyle(GlassTheme.text)

                    Spacer()

                    Text("Widget")
                        .font(GlassTheme.captionFont)
                        .foregroundStyle(GlassTheme.textTertiary)
                }

                Text(description)
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                // Preview container
                previewContent()
                    .frame(maxWidth: .infinity)
                    .padding(GlassTheme.spacingSmall)
                    .background(
                        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusMedium)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
    }

    // MARK: - Tips Section

    @MainActor
    private var tipsSection: some View {
        GlassCard(material: .ultraThinMaterial) {
            VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundStyle(GlassTheme.warning)

                    Text("Tips")
                        .font(GlassTheme.bodyFont)
                        .fontWeight(.medium)
                        .foregroundStyle(GlassTheme.text)
                }

                Text("• Widgets update automatically with your latest calculations")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                Text("• Tap any widget to open PrismCalc instantly")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                Text("• Use quick action buttons to jump directly to features")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)
            }
        }
    }
}

private struct AdaptiveWidgetPreview: View {
    let family: WidgetFamily

    var body: some View {
        AdaptivePrismCalcWidgetView(entry: sampleEntry)
            .frame(maxWidth: .infinity)
            .frame(height: heightForFamily(family))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.thinMaterial)
            )
    }

    private var sampleEntry: PrismCalcEntry {
        PrismCalcEntry(
            date: Date(),
            lastResult: "42",
            lastExpression: "6 × 7",
            recentHistory: [
                .init(type: "Calc", result: "42", details: "6 × 7", icon: "plus.forwardslash.minus"),
                .init(type: "Tip", result: "$23.60", details: "$20 + 18%", icon: "dollarsign.circle"),
                .init(type: "Split", result: "$15", details: "$60 ÷ 4", icon: "person.2")
            ]
        )
    }

    private func heightForFamily(_ family: WidgetFamily) -> CGFloat {
        switch family {
        case .systemSmall: return 150
        case .systemMedium: return 150
        case .systemLarge: return 300
        default: return 150
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ZStack {
            LinearGradient(
                colors: GlassTheme.auroraGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            WidgetSettingsView()
        }
    }
}
