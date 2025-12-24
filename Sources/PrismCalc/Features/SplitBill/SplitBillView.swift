import SwiftUI

/// Split Bill Calculator - divide bills among friends with optional tip
public struct SplitBillView: View {
    @State private var viewModel = SplitBillViewModel()
    @State private var decrementTrigger = false
    @State private var incrementTrigger = false
    // Fixed sizes for calculator displays - should not scale with Dynamic Type
    private let currencySymbolSize: CGFloat = 32
    private let inputValueSize: CGFloat = 48
    private let peopleCountSize: CGFloat = 56
    private let peopleControlSize: CGFloat = 56
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @FocusState private var isInputFocused: Bool

    public init() {}

    public var body: some View {
        let reduce = reduceMotion
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Total Bill Input
                billInputSection
                    .scrollTransition { content, phase in
                        content.opacity(reduce || phase.isIdentity ? 1 : 0.85)
                    }

                // Number of People
                peopleSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.85)
                            .scaleEffect(reduce || phase.isIdentity ? 1 : 0.97)
                    }

                // Tip Toggle and Slider
                tipSection

                // Results
                SplitResultsSection(viewModel: viewModel)
                    .scrollTransition { content, phase in
                        content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.9)
                            .offset(y: reduce || phase.isIdentity ? 0 : phase.value * 8)
                    }
            }
            .padding()
            .prismContentMaxWidth()
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
                Text("Total Bill")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                HStack {
                    Text("$")
                        .font(.system(size: currencySymbolSize, weight: .light, design: .rounded))
                        .foregroundStyle(GlassTheme.textSecondary)

                    TextField("0.00", text: $viewModel.totalBill)
                        .font(.system(size: inputValueSize, weight: .light, design: .rounded))
                        .decimalKeyboard()
                        .foregroundStyle(GlassTheme.text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .multilineTextAlignment(.trailing)
                        .focused($isInputFocused)
                        .accessibilityLabel("Total bill")
                }
            }
        }
    }

    // MARK: - People Section

    @MainActor
    private var peopleSection: some View {
        GlassCard {
            VStack(spacing: GlassTheme.spacingMedium) {
                Text("Split Between")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                HStack(spacing: GlassTheme.spacingXL) {
                    // Decrement
                    Button {
                        decrementTrigger.toggle()
                        viewModel.decrementPeople()
                    } label: {
                        decrementButtonIcon
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(
                                viewModel.numberOfPeople > 1
                                    ? GlassTheme.text
                                    : GlassTheme.textTertiary
                            )
                            .frame(width: peopleControlSize, height: peopleControlSize)
                            .background(
                                GlassTheme.glassCircleBackground(
                                    material: .thin,
                                    reduceTransparency: reduceTransparency
                                )
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.numberOfPeople <= 1)
                    .accessibilityLabel("Decrease people")
                    .accessibilityHint("Decreases the number of people to split between")

                    // People Count with Icons
                    VStack(spacing: GlassTheme.spacingXS) {
                        HStack(spacing: 4) {
                            ForEach(0..<min(viewModel.numberOfPeople, 5), id: \.self) { _ in
                                Image(systemName: "person.fill")
                                    .foregroundStyle(GlassTheme.primary)
                            }
                            if viewModel.numberOfPeople > 5 {
                                Text("+\(viewModel.numberOfPeople - 5)")
                                    .font(GlassTheme.captionFont)
                                    .foregroundStyle(GlassTheme.primary)
                            }
                        }

                        Text("\(viewModel.numberOfPeople)")
                            .font(.system(size: peopleCountSize, weight: .light, design: .rounded))
                            .foregroundStyle(GlassTheme.text)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .contentTransition(reduceMotion ? .identity : .numericText())
                            .animation(reduceMotion ? nil : .easeInOut(duration: 0.15), value: viewModel.numberOfPeople)

                        Text(viewModel.numberOfPeople == 1 ? "person" : "people")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                    }

                    // Increment
                    Button {
                        incrementTrigger.toggle()
                        viewModel.incrementPeople()
                    } label: {
                        incrementButtonIcon
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(GlassTheme.text)
                            .frame(width: peopleControlSize, height: peopleControlSize)
                            .background(
                                GlassTheme.glassCircleBackground(
                                    material: .thin,
                                    reduceTransparency: reduceTransparency
                                )
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Increase people")
                    .accessibilityHint("Increases the number of people to split between")
                }
                .sensoryFeedback(.selection, trigger: viewModel.numberOfPeople)
            }
        }
    }

    // MARK: - Tip Section

    @MainActor
    private var tipSection: some View {
        GlassCard(material: .ultraThinMaterial) {
            VStack(spacing: GlassTheme.spacingMedium) {
                // Toggle
                HStack {
                    Text("Include Tip")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.text)

                    Spacer()

                    Toggle("", isOn: $viewModel.includeTip)
                        .tint(GlassTheme.primary)
                        .labelsHidden()
                        .accessibilityLabel("Include tip")
                }

                // Tip Slider (when enabled)
                if viewModel.includeTip {
                    VStack(spacing: GlassTheme.spacingSmall) {
                        HStack {
                            Text("Tip: \(Int(viewModel.tipPercentage))%")
                                .font(GlassTheme.captionFont)
                                .foregroundStyle(GlassTheme.textSecondary)

                            Spacer()

                            Text(viewModel.formattedTip)
                                .font(GlassTheme.bodyFont)
                                .foregroundStyle(GlassTheme.primary)
                        }

                        Slider(
                            value: $viewModel.tipPercentage,
                            in: 0...30,
                            step: 1
                        )
                        .tint(GlassTheme.primary)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(reduceMotion ? nil : GlassTheme.springAnimation, value: viewModel.includeTip)
        }
    }

    // MARK: - Button Icons (Reduce Motion Support)

    @MainActor @ViewBuilder
    private var decrementButtonIcon: some View {
        if reduceMotion {
            Image(systemName: "minus")
        } else {
            Image(systemName: "minus")
                .symbolEffect(.bounce.down, value: decrementTrigger)
        }
    }

    @MainActor @ViewBuilder
    private var incrementButtonIcon: some View {
        if reduceMotion {
            Image(systemName: "plus")
        } else {
            Image(systemName: "plus")
                .symbolEffect(.bounce.up, value: incrementTrigger)
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

        SplitBillView()
    }
}
