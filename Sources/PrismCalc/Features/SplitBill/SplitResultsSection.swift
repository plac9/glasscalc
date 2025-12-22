import SwiftUI

/// Results display section for split bill calculator
struct SplitResultsSection: View {
    let viewModel: SplitBillViewModel
    // Fixed sizes for calculator displays
    private let heroValueSize: CGFloat = 56
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityIncreaseContrast) private var increaseContrast

    var body: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            perPersonHero
            breakdownCard
        }
    }

    // MARK: - Per Person Hero

    @MainActor
    private var perPersonHero: some View {
        VStack(spacing: GlassTheme.spacingXS) {
            Text("Each Person Pays")
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Text(viewModel.formattedPerPerson)
                .font(.system(size: heroValueSize, weight: .medium, design: .rounded))
                .foregroundStyle(GlassTheme.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .contentTransition(reduceMotion ? .identity : .numericText())
                .animation(
                    reduceMotion ? nil : .easeInOut(duration: 0.15),
                    value: viewModel.perPersonShare
                )
        }
        .frame(maxWidth: .infinity)
        .padding(GlassTheme.spacingLarge)
        .background(heroBackground)
        .shadow(color: GlassTheme.primary.opacity(0.2), radius: 20, y: 10)
    }

    private var heroBackground: some View {
        GlassTheme.glassCardBackground(
            cornerRadius: GlassTheme.cornerRadiusXL,
            material: .regularMaterial,
            reduceTransparency: reduceTransparency
        )
            .overlay(
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                    .stroke(
                        GlassTheme.glassBorderGradient(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: increaseContrast
                        ),
                        lineWidth: GlassTheme.glassBorderLineWidth(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: increaseContrast
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                    .stroke(GlassTheme.primary.opacity(0.3), lineWidth: 2)
            )
    }

    // MARK: - Breakdown Card

    @MainActor
    private var breakdownCard: some View {
        GlassCard {
            VStack(spacing: GlassTheme.spacingSmall) {
                breakdownRow(label: "Bill", value: viewModel.formattedBill)

                if viewModel.includeTip {
                    breakdownRow(
                        label: "Tip (\(Int(viewModel.tipPercentage))%)",
                        value: viewModel.formattedTip
                    )
                }

                Divider()
                    .background(GlassTheme.textTertiary)

                breakdownRow(
                    label: "Grand Total",
                    value: viewModel.formattedGrandTotal,
                    isHighlighted: true
                )

                if viewModel.billValue > 0 {
                    saveButton
                }
            }
        }
    }

    @MainActor
    private var saveButton: some View {
        Group {
            Divider()
                .background(GlassTheme.textTertiary)

            Button {
                viewModel.saveToHistory()
            } label: {
                Label("Save to History", systemImage: "clock.arrow.circlepath")
                    .font(GlassTheme.bodyFont)
                    .foregroundStyle(GlassTheme.primary)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.success, trigger: viewModel.billValue)
            .accessibilityLabel("Save to history")
            .accessibilityHint("Saves this split bill calculation to your history")
        }
    }

    // MARK: - Breakdown Row

    @MainActor
    private func breakdownRow(
        label: String,
        value: String,
        isHighlighted: Bool = false
    ) -> some View {
        HStack {
            Text(label)
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Spacer()

            Text(value)
                .font(isHighlighted ? GlassTheme.headlineFont : GlassTheme.bodyFont)
                .foregroundStyle(isHighlighted ? GlassTheme.text : GlassTheme.textSecondary)
        }
    }
}
