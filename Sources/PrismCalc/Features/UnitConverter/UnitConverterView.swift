import SwiftUI

/// Unit Converter with length, weight, and temperature
public struct UnitConverterView: View {
    @State private var viewModel = UnitConverterViewModel()
    @State private var swapTrigger = false
    // Fixed sizes for calculator displays - should not scale with Dynamic Type
    private let inputValueSize: CGFloat = 48
    private let resultValueSize: CGFloat = 48
    private let swapButtonSize: CGFloat = 44
    @Environment(\EnvironmentValues.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @FocusState private var isInputFocused: Bool

    public init() {}

    public var body: some View {
        let reduce = reduceMotion
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Category Selector
                categorySelector
                    .scrollTransition { content, phase in
                        content.opacity(reduce || phase.isIdentity ? 1 : 0.85)
                    }

                // Input
                inputSection
                    .scrollTransition { content, phase in
                        content.opacity(reduce || phase.isIdentity ? 1 : 0.85)
                    }

                // Unit Selectors with Swap
                unitSelectors
                    .scrollTransition { content, phase in
                        content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.85)
                            .scaleEffect(reduce || phase.isIdentity ? 1 : 0.97)
                    }

                // Result
                resultSection
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

    // MARK: - Category Selector

    @MainActor
    private var categorySelector: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            let reduceMotionSnapshot = reduceMotion
            ForEach(UnitConverterViewModel.Category.allCases) { category in
                Button {
                    if reduceMotionSnapshot {
                        viewModel.selectCategory(category)
                    } else {
                        withAnimation(GlassTheme.springAnimation) {
                            viewModel.selectCategory(category)
                        }
                    }
                } label: {
                    VStack(spacing: GlassTheme.spacingXS) {
                        Image(systemName: category.icon)
                            .font(.title2)

                        Text(category.rawValue)
                            .font(GlassTheme.captionFont)
                    }
                    .foregroundStyle(
                        viewModel.selectedCategory == category
                            ? .white
                            : GlassTheme.text
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, GlassTheme.spacingSmall)
                    .background(
                        GlassTheme.glassCardBackground(
                            cornerRadius: GlassTheme.cornerRadiusSmall,
                            material: .thin,
                            reduceTransparency: reduceTransparency
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusSmall)
                                .fill(GlassTheme.primary)
                                .opacity(viewModel.selectedCategory == category ? 0.9 : 0)
                        )
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(category.rawValue) converter")
                .accessibilityHint(
                    viewModel.selectedCategory == category ? "Currently selected" : "Double tap to select"
                )
            }
        }
        .sensoryFeedback(.selection, trigger: viewModel.selectedCategory)
    }

    // MARK: - Input

    @MainActor
    private var inputSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                Text("Value")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                TextField("0", text: $viewModel.inputValue)
                    .font(.system(size: inputValueSize, weight: .light, design: .rounded))
                    .decimalKeyboard()
                    .foregroundStyle(GlassTheme.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .multilineTextAlignment(.trailing)
                    .focused($isInputFocused)
                    .accessibilityLabel("Input value")
            }
        }
    }

    // MARK: - Unit Selectors

    @MainActor
    private var unitSelectors: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            // From Unit
            unitPicker(
                label: "From",
                selection: $viewModel.fromUnit,
                units: viewModel.availableUnits
            )

            let reduceMotionSnapshot = reduceMotion
            // Swap Button with SF Symbol 6 rotation animation
            Button {
                swapTrigger.toggle()
                if reduceMotionSnapshot {
                    viewModel.swapUnits()
                } else {
                    withAnimation(GlassTheme.springAnimation) {
                        viewModel.swapUnits()
                    }
                }
            } label: {
                swapButtonIcon
                    .font(.title3)
                    .foregroundStyle(GlassTheme.primary)
                    .frame(width: swapButtonSize, height: swapButtonSize)
                    .background(
                        GlassTheme.glassCircleBackground(
                            material: .regular,
                            reduceTransparency: reduceTransparency
                        )
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Swap units")
            .accessibilityHint("Swaps the from and to units")

            // To Unit
            unitPicker(
                label: "To",
                selection: $viewModel.toUnit,
                units: viewModel.availableUnits
            )
        }
    }

    @MainActor
    private func unitPicker(label: String, selection: Binding<String>, units: [String]) -> some View {
        GlassCard {
            VStack(spacing: GlassTheme.spacingXS) {
                Text(label)
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                Picker(label, selection: selection) {
                    ForEach(units, id: \.self) { unit in
                        Text(formatUnitName(unit))
                            .tag(unit)
                    }
                }
                .pickerStyle(.menu)
                .tint(GlassTheme.primary)
            }
        }
    }

    // MARK: - Swap Button Icon

    @MainActor @ViewBuilder
    private var swapButtonIcon: some View {
        if reduceMotion {
            Image(systemName: "arrow.left.arrow.right")
        } else {
            Image(systemName: "arrow.left.arrow.right")
                .symbolEffect(.rotate.byLayer, value: swapTrigger)
        }
    }

    // MARK: - Result

    @MainActor
    private var resultSection: some View {
        VStack(spacing: GlassTheme.spacingSmall) {
            let reduceMotionSnapshot = reduceMotion
            Text(displayResult)
                .font(.system(size: resultValueSize, weight: .medium, design: .rounded))
                .foregroundStyle(GlassTheme.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .contentTransition(reduceMotionSnapshot ? .identity : .numericText())
                .animation(reduceMotionSnapshot ? nil : .easeInOut(duration: 0.15), value: displayResult)

            Text(formatUnitName(viewModel.toUnit))
                .font(GlassTheme.headlineFont)
                .foregroundStyle(GlassTheme.textSecondary)

            // Save Button
            if viewModel.inputDouble > 0 {
                Button {
                    viewModel.saveToHistory(result: displayResult)
                } label: {
                    Label("Save to History", systemImage: "clock.arrow.circlepath")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.primary)
                }
                .buttonStyle(.plain)
                .padding(.top, GlassTheme.spacingSmall)
                .sensoryFeedback(.success, trigger: viewModel.inputDouble)
                .accessibilityLabel("Save to history")
                .accessibilityHint("Saves this conversion to your history")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(GlassTheme.spacingXL)
        .background(
            GlassTheme.glassCardBackground(
                cornerRadius: GlassTheme.cornerRadiusXL,
                material: .regular,
                reduceTransparency: reduceTransparency
            )
            .overlay(
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                    .stroke(GlassTheme.primary.opacity(0.3), lineWidth: 2)
            )
        )
        .shadow(color: GlassTheme.primary.opacity(0.2), radius: 20, y: 10)
    }

    private var displayResult: String {
        return viewModel.formattedResult
    }

    // MARK: - Helpers

    private func formatUnitName(_ unit: String) -> String {
        return unit.capitalized
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

        UnitConverterView()
    }
}
