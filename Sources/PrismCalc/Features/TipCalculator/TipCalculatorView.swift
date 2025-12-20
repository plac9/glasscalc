import SwiftUI

/// Tip Calculator with arc slider and split functionality
public struct TipCalculatorView: View {
    @State private var viewModel = TipCalculatorViewModel()
    @State private var decrementTrigger = false
    @State private var incrementTrigger = false
    @State private var noteText: String = ""
    @ScaledMetric(relativeTo: .title2) private var currencySymbolSize: CGFloat = 32
    @ScaledMetric(relativeTo: .largeTitle) private var inputValueSize: CGFloat = 48
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var isInputFocused: Bool

    public init() {}

    public var body: some View {
        let reduce = reduceMotion

        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Bill Amount Input
                billInputSection
                    .scrollTransition { content, phase in
                        content.opacity(reduce || phase.isIdentity ? 1 : 0.85)
                    }

                // Tip Percentage Arc Slider
                tipSliderSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.85)
                            .scaleEffect(reduce || phase.isIdentity ? 1 : 0.97)
                    }

                // Quick Tip Buttons
                quickTipSection

                // Split Between People
                splitSection

                // Results
                resultsSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.9)
                            .offset(y: reduce || phase.isIdentity ? 0 : phase.value * 8)
                    }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputFocused = false
                }
                .foregroundStyle(GlassTheme.primary)
            }
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
                        .font(.system(size: currencySymbolSize, weight: .light, design: .rounded))
                        .foregroundStyle(GlassTheme.textSecondary)

                    TextField("0.00", text: $viewModel.billAmount)
                        .font(.system(size: inputValueSize, weight: .light, design: .rounded))
                        .decimalKeyboard()
                        .foregroundStyle(GlassTheme.text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .multilineTextAlignment(.trailing)
                        .focused($isInputFocused)
                        .accessibilityLabel("Bill amount")
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
            let reduceMotionSnapshot = reduceMotion
            ForEach(viewModel.quickTips, id: \.self) { tip in
                Button {
                    if reduceMotionSnapshot {
                        viewModel.selectQuickTip(tip)
                    } else {
                        withAnimation(GlassTheme.springAnimation) {
                            viewModel.selectQuickTip(tip)
                        }
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
                .accessibilityLabel("\(Int(tip)) percent tip")
                .accessibilityHint(viewModel.tipPercentage == tip ? "Currently selected" : "Double tap to select")
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
                    let reduceMotionSnapshot = reduceMotion

                    Button {
                        decrementTrigger.toggle()
                        viewModel.decrementPeople()
                    } label: {
                        decrementButtonIcon
                            .font(.title2)
                            .foregroundStyle(
                                viewModel.numberOfPeople > 1
                                    ? GlassTheme.primary
                                    : GlassTheme.textTertiary
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.numberOfPeople <= 1)
                    .accessibilityLabel("Decrease people")
                    .accessibilityHint("Decreases the number of people to split between")

                    Text("\(viewModel.numberOfPeople)")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .foregroundStyle(GlassTheme.text)
                        .frame(minWidth: 40)
                        .contentTransition(reduceMotionSnapshot ? .identity : .numericText())
                        .animation(reduceMotionSnapshot ? nil : .easeInOut(duration: 0.15), value: viewModel.numberOfPeople)

                    Button {
                        incrementTrigger.toggle()
                        viewModel.incrementPeople()
                    } label: {
                        incrementButtonIcon
                            .font(.title2)
                            .foregroundStyle(GlassTheme.primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Increase people")
                    .accessibilityHint("Increases the number of people to split between")
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

            // Save Button
            if viewModel.billValue > 0 {
                Divider()
                    .background(GlassTheme.textTertiary)

                // Optional note input
                HStack(spacing: GlassTheme.spacingSmall) {
                    Image(systemName: "note.text")
                        .foregroundStyle(GlassTheme.textTertiary)

                    TextField("Add a note (optional)", text: $noteText)
                        .font(GlassTheme.captionFont)
                        .foregroundStyle(GlassTheme.text)
                        .textFieldStyle(.plain)
                        .accessibilityLabel("Note")
                        .accessibilityHint("Optional note to save with this calculation")
                }
                .padding(.vertical, GlassTheme.spacingXS)

                Button {
                    viewModel.saveToHistory(note: noteText.isEmpty ? nil : noteText)
                    noteText = "" // Clear after save
                } label: {
                    Label("Save to History", systemImage: "clock.arrow.circlepath")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.primary)
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.success, trigger: viewModel.billValue)
                .accessibilityLabel("Save to history")
                .accessibilityHint("Saves this tip calculation to your history")
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

    // MARK: - Button Icons (Reduce Motion Support)

    @MainActor @ViewBuilder
    private var decrementButtonIcon: some View {
        if reduceMotion {
            Image(systemName: "minus.circle.fill")
        } else {
            Image(systemName: "minus.circle.fill")
                .symbolEffect(.bounce.down, value: decrementTrigger)
        }
    }

    @MainActor @ViewBuilder
    private var incrementButtonIcon: some View {
        if reduceMotion {
            Image(systemName: "plus.circle.fill")
        } else {
            Image(systemName: "plus.circle.fill")
                .symbolEffect(.bounce.up, value: incrementTrigger)
        }
    }

    @MainActor @ViewBuilder
    private func resultRow(label: String, value: String, isHighlighted: Bool = false) -> some View {
        let reduceMotionSnapshot = reduceMotion

        HStack {
            Text(label)
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Spacer()

            Text(value)
                .font(isHighlighted ? GlassTheme.titleFont : GlassTheme.headlineFont)
                .foregroundStyle(isHighlighted ? GlassTheme.primary : GlassTheme.text)
                .contentTransition(reduceMotionSnapshot ? .identity : .numericText())
                .animation(reduceMotionSnapshot ? nil : .easeInOut(duration: 0.15), value: value)
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

