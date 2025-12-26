import SwiftUI
#if os(iOS)
import UIKit
#endif

private extension View {
    @ViewBuilder
    func ifAvailableiOS17<Content: View>(_ transform: (Self) -> Content) -> some View {
        if #available(iOS 17.0, *) {
            transform(self)
        } else {
            self
        }
    }
}

/// Results display section for split bill calculator
struct SplitResultsSection: View {
    let viewModel: SplitBillViewModel

    init(viewModel: SplitBillViewModel) {
        self.viewModel = viewModel
    }
    // Fixed sizes for calculator displays
    private let heroValueSize: CGFloat = 56
    @Environment(\EnvironmentValues.accessibilityReduceMotion) private var reduceMotion
    @Environment(\EnvironmentValues.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private var isIncreasedContrast: Bool {
        if #available(iOS 17.0, *) {
            return colorSchemeContrast == .increased
        } else {
            #if os(iOS)
            return UIAccessibility.isDarkerSystemColorsEnabled
            #else
            return false
            #endif
        }
    }

    var body: some View {
        VStack(spacing: CGFloat(GlassTheme.spacingMedium)) {
            perPersonHero
            breakdownCard
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Per Person Hero

    @MainActor
    private var perPersonHero: some View {
        VStack(spacing: CGFloat(GlassTheme.spacingXS)) {
            Text("Each Person Pays")
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Text(viewModel.formattedPerPerson)
                .font(.system(size: heroValueSize, weight: .medium, design: .rounded))
                .foregroundStyle(GlassTheme.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .ifAvailableiOS17 { view in
                    view.contentTransition(reduceMotion ? .identity : .numericText())
                }
                .animation(
                    reduceMotion ? nil : .easeInOut(duration: 0.15),
                    value: viewModel.perPersonShare
                )
        }
        .frame(maxWidth: .infinity)
        .padding(CGFloat(GlassTheme.spacingLarge))
        .background(heroBackground)
        .shadow(color: GlassTheme.primary.opacity(0.2), radius: 20, y: 10)
    }

    private var heroBackground: some View {
        GlassTheme.glassCardBackground(
            cornerRadius: GlassTheme.cornerRadiusXL,
            material: .regular,
            reduceTransparency: reduceTransparency
        )
            .overlay(
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                    .stroke(
                        GlassTheme.glassBorderGradient(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: isIncreasedContrast
                        ),
                        lineWidth: GlassTheme.glassBorderLineWidth(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: isIncreasedContrast
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
            VStack(spacing: CGFloat(GlassTheme.spacingSmall)) {
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
        .frame(maxWidth: .infinity, alignment: .leading)
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
            .ifAvailableiOS17 { view in
                view.sensoryFeedback(.success, trigger: viewModel.billValue)
            }
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

#Preview {
    SplitResultsSection(viewModel: SplitBillViewModel())
}
