import SwiftUI

/// Tip Calculator with arc slider and split functionality
public struct TipCalculatorView: View {
    @State private var viewModel = TipCalculatorViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Bill Amount Input
                billInputSection

                // Tip Percentage Arc Slider
                tipSliderSection

                // Quick Tip Buttons
                quickTipSection

                // Split Between People
                splitSection

                // Results
                resultsSection
            }
            .padding()
        }
    }

    // MARK: - Bill Input

    @MainActor
    private var billInputSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                Text("Bill Amount")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                HStack {
                    Text("$")
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundStyle(GlassTheme.textSecondary)

                    TextField("0.00", text: $viewModel.billAmount)
                        .font(.system(size: 48, weight: .light, design: .rounded))
                        .decimalKeyboard()
                        .foregroundStyle(GlassTheme.text)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    // MARK: - Tip Slider

    private var tipSliderSection: some View {
        GlassCard(material: .ultraThinMaterial) {
            VStack(spacing: GlassTheme.spacingSmall) {
                ArcSlider(
                    value: $viewModel.tipPercentage,
                    range: 0...30,
                    step: 1,
                    label: "TIP"
                )
            }
            .padding(.vertical, GlassTheme.spacingSmall)
        }
    }

    // MARK: - Quick Tips

    @MainActor
    private var quickTipSection: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            ForEach(viewModel.quickTips, id: \.self) { tip in
                Button {
                    withAnimation(GlassTheme.springAnimation) {
                        viewModel.selectQuickTip(tip)
                    }
                } label: {
                    Text("\(Int(tip))%")
                        .font(GlassTheme.bodyFont)
                        .fontWeight(.medium)
                        .foregroundStyle(
                            viewModel.tipPercentage == tip
                                ? .white
                                : GlassTheme.text
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, GlassTheme.spacingSmall)
                        .background(
                            Capsule()
                                .fill(
                                    viewModel.tipPercentage == tip
                                        ? GlassTheme.primary
                                        : .clear
                                )
                                .background(
                                    Capsule()
                                        .fill(.thinMaterial)
                                )
                        )
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: viewModel.tipPercentage)
            }
        }
    }

    // MARK: - Split Section

    @MainActor
    private var splitSection: some View {
        GlassCard {
            HStack {
                Text("Split Between")
                    .font(GlassTheme.bodyFont)
                    .foregroundStyle(GlassTheme.text)

                Spacer()

                HStack(spacing: GlassTheme.spacingMedium) {
                    Button {
                        viewModel.decrementPeople()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(
                                viewModel.numberOfPeople > 1
                                    ? GlassTheme.primary
                                    : GlassTheme.textTertiary
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.numberOfPeople <= 1)

                    Text("\(viewModel.numberOfPeople)")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .foregroundStyle(GlassTheme.text)
                        .frame(minWidth: 40)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.15), value: viewModel.numberOfPeople)

                    Button {
                        viewModel.incrementPeople()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(GlassTheme.primary)
                    }
                    .buttonStyle(.plain)
                }
                .sensoryFeedback(.selection, trigger: viewModel.numberOfPeople)
            }
        }
    }

    // MARK: - Results

    @MainActor
    private var resultsSection: some View {
        VStack(spacing: GlassTheme.spacingSmall) {
            // Tip Amount
            resultRow(label: "Tip", value: viewModel.formattedTip)

            // Total
            resultRow(
                label: "Total",
                value: viewModel.formattedTotal,
                isHighlighted: true
            )

            // Per Person (if splitting)
            if viewModel.numberOfPeople > 1 {
                Divider()
                    .background(GlassTheme.textTertiary)

                resultRow(
                    label: "Per Person",
                    value: viewModel.formattedPerPerson,
                    isHighlighted: true
                )

                resultRow(
                    label: "Tip Per Person",
                    value: viewModel.formattedTipPerPerson
                )
            }
        }
        .padding(GlassTheme.spacingMedium)
        .background(
            RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusLarge)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusLarge)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 15, y: 8)
    }

    @MainActor
    private func resultRow(label: String, value: String, isHighlighted: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Spacer()

            Text(value)
                .font(isHighlighted ? GlassTheme.titleFont : GlassTheme.headlineFont)
                .foregroundStyle(isHighlighted ? GlassTheme.primary : GlassTheme.text)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.15), value: value)
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

        TipCalculatorView()
    }
}
