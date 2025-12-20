import SwiftUI

/// Widget management view showing available widgets with previews and add instructions
public struct WidgetSettingsView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .body) private var widgetPreviewScale: CGFloat = 1.0

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
                    icon: "square",
                    previewContent: smallWidgetPreview
                )

                // Medium widget preview
                widgetPreviewCard(
                    size: "Medium",
                    description: "Latest result with quick action grid",
                    icon: "rectangle",
                    previewContent: mediumWidgetPreview
                )

                // Large widget preview
                widgetPreviewCard(
                    size: "Large",
                    description: "Full result, actions, and history",
                    icon: "square.fill",
                    previewContent: largeWidgetPreview
                )
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

    // MARK: - Widget Preview Content

    @MainActor @ViewBuilder
    private func smallWidgetPreview() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.caption)
                    .foregroundStyle(.blue.gradient)
                Text("PrismCalc")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Text("42")
                .font(.system(size: 20, weight: .medium, design: .rounded))

            Text("6 × 7")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                Circle()
                    .fill(.blue.opacity(0.15))
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 10))
                            .foregroundStyle(.blue)
                    )
                Circle()
                    .fill(.blue.opacity(0.15))
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "person.2")
                            .font(.system(size: 10))
                            .foregroundStyle(.blue)
                    )
            }
        }
        .frame(height: 100 * widgetPreviewScale)
    }

    @MainActor @ViewBuilder
    private func mediumWidgetPreview() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Image(systemName: "equal.square.fill")
                        .font(.caption2)
                        .foregroundStyle(.blue.gradient)
                    Text("Latest")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text("$23.60")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                Text("$20 + 18% tip")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Divider()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 4) {
                ForEach(["plus.forwardslash.minus", "dollarsign.circle", "person.2", "arrow.left.arrow.right"], id: \.self) { icon in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.blue.opacity(0.1))
                        .frame(height: 28)
                        .overlay(
                            Image(systemName: icon)
                                .font(.caption2)
                                .foregroundStyle(.blue)
                        )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 80 * widgetPreviewScale)
    }

    @MainActor @ViewBuilder
    private func largeWidgetPreview() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.caption)
                    .foregroundStyle(.blue.gradient)
                Text("PrismCalc")
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
            }

            Text("$23.60")
                .font(.system(size: 18, weight: .medium, design: .rounded))
            Text("$20 + 18% tip")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                ForEach(["plus.forwardslash.minus", "dollarsign.circle", "person.2", "arrow.left.arrow.right"], id: \.self) { icon in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.blue.opacity(0.1))
                        .frame(height: 30)
                        .overlay(
                            Image(systemName: icon)
                                .font(.caption)
                                .foregroundStyle(.blue)
                        )
                }
            }

            Divider()

            Text("Recent History")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 6) {
                Circle()
                    .fill(.blue.opacity(0.1))
                    .frame(width: 16, height: 16)
                    .overlay(
                        Image(systemName: "plus.forwardslash.minus")
                            .font(.system(size: 8))
                            .foregroundStyle(.blue)
                    )
                VStack(alignment: .leading, spacing: 0) {
                    Text("42")
                        .font(.caption2)
                        .fontWeight(.medium)
                    Text("6 × 7")
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(height: 160 * widgetPreviewScale)
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
