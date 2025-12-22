import SwiftUI

/// Main calculator view with full glassmorphism UI
public struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @AppStorage("zeroOnRight") private var zeroOnRight: Bool = false

    public init() {}

    public var body: some View {
        GeometryReader { geometry in
            let isIPad = horizontalSizeClass == .regular && geometry.size.width > 600
            let layoutMetrics = calculateLayout(for: geometry.size, isIPad: isIPad)
            let spacing = isIPad ? GlassTheme.spacingMedium : GlassTheme.spacingSmall
            let horizontalPadding = isIPad ? GlassTheme.spacingXL * 2 : GlassTheme.spacingMedium

            VStack(spacing: 0) {
                // Display - proportionally sized for iPad
                GlassDisplay(
                    value: viewModel.display,
                    expression: viewModel.expression
                )
                .frame(height: layoutMetrics.displayHeight)
                .padding(.horizontal, horizontalPadding)
                .padding(.top, layoutMetrics.topPadding)
                .padding(.bottom, layoutMetrics.displayBottomPadding)

                // Button grid - sized to always fit
                VStack(spacing: spacing) {
                    // Row 1: AC, +/-, %, /
                    HStack(spacing: spacing) {
                        calculatorButton(
                            "AC",
                            style: .special,
                            id: "calculator-button-AC",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.clear()
                        }

                        calculatorButton(
                            "+/-",
                            style: .special,
                            id: "calculator-button-sign",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.toggleSign()
                        }

                        calculatorButton(
                            "%",
                            style: .special,
                            id: "calculator-button-percent",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.percentage()
                        }

                        calculatorButton(
                            "/",
                            style: .operation,
                            id: "calculator-button-divide",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.inputOperation(.divide)
                        }
                    }

                    // Row 2: 7, 8, 9, x
                    HStack(spacing: spacing) {
                        calculatorButton("7", id: "calculator-button-7", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("7")
                        }

                        calculatorButton("8", id: "calculator-button-8", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("8")
                        }

                        calculatorButton("9", id: "calculator-button-9", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("9")
                        }

                        calculatorButton(
                            "x",
                            style: .operation,
                            id: "calculator-button-multiply",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.inputOperation(.multiply)
                        }
                    }

                    // Row 3: 4, 5, 6, -
                    HStack(spacing: spacing) {
                        calculatorButton("4", id: "calculator-button-4", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("4")
                        }

                        calculatorButton("5", id: "calculator-button-5", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("5")
                        }

                        calculatorButton("6", id: "calculator-button-6", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("6")
                        }

                        calculatorButton(
                            "-",
                            style: .operation,
                            id: "calculator-button-subtract",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.inputOperation(.subtract)
                        }
                    }

                    // Row 4: 1, 2, 3, +
                    HStack(spacing: spacing) {
                        calculatorButton("1", id: "calculator-button-1", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("1")
                        }

                        calculatorButton("2", id: "calculator-button-2", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("2")
                        }

                        calculatorButton("3", id: "calculator-button-3", layoutMetrics: layoutMetrics) {
                            viewModel.inputDigit("3")
                        }

                        calculatorButton(
                            "+",
                            style: .operation,
                            id: "calculator-button-add",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.inputOperation(.add)
                        }
                    }

                    // Row 5: 0, ., ⌫, = — respects zeroOnRight preference
                    HStack(spacing: spacing) {
                        if zeroOnRight {
                            // Alternative layout: ., 0, ⌫, =
                            calculatorButton(".", id: "calculator-button-decimal", layoutMetrics: layoutMetrics) {
                                viewModel.inputDigit(".")
                            }

                            calculatorButton("0", id: "calculator-button-0", layoutMetrics: layoutMetrics) {
                                viewModel.inputDigit("0")
                            }
                        } else {
                            // Standard layout: 0, ., ⌫, =
                            calculatorButton("0", id: "calculator-button-0", layoutMetrics: layoutMetrics) {
                                viewModel.inputDigit("0")
                            }

                            calculatorButton(".", id: "calculator-button-decimal", layoutMetrics: layoutMetrics) {
                                viewModel.inputDigit(".")
                            }
                        }

                        // Delete/backspace button
                        deleteButton(layoutMetrics: layoutMetrics)

                        calculatorButton(
                            "=",
                            style: .equals,
                            id: "calculator-button-equals",
                            layoutMetrics: layoutMetrics
                        ) {
                            viewModel.calculate()
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, isIPad ? GlassTheme.spacingXL : GlassTheme.spacingLarge)
            }
        }
    }

    @ViewBuilder
    private func calculatorButton(
        _ title: String,
        style: GlassButton.Style = .number,
        id: String,
        layoutMetrics: LayoutMetrics,
        action: @escaping () -> Void
    ) -> some View {
        GlassButton(
            title,
            style: style,
            size: layoutMetrics.buttonSize,
            accessibilityIdentifier: id,
            action: action
        )
    }

    @ViewBuilder
    private func deleteButton(layoutMetrics: LayoutMetrics) -> some View {
        GlassSymbolButton(
            systemName: "delete.backward",
            style: .special,
            size: layoutMetrics.buttonSize,
            accessibilityLabel: "Delete",
            accessibilityIdentifier: "calculator-button-delete"
        ) {
            viewModel.backspace()
        }
        .accessibilityHint("Removes the last digit")
    }

    private func calculateLayout(for size: CGSize, isIPad: Bool) -> LayoutMetrics {
        // Spacing and padding values
        let spacing: CGFloat = isIPad ? GlassTheme.spacingMedium : GlassTheme.spacingSmall
        let horizontalPadding: CGFloat = isIPad ? (GlassTheme.spacingXL * 4) : (GlassTheme.spacingMedium * 2)
        let bottomPadding: CGFloat = isIPad ? GlassTheme.spacingXL : GlassTheme.spacingLarge
        let topPadding: CGFloat = isIPad ? GlassTheme.spacingMedium : GlassTheme.spacingSmall

        // Calculate button size based on width
        let availableWidth = size.width - horizontalPadding - (spacing * 3) // 3 gaps between 4 buttons
        let calculatedButtonSize = availableWidth / 4
        let maxButtonSize: CGFloat = isIPad ? 200 : GlassTheme.buttonSizeLarge
        let buttonSize = min(calculatedButtonSize, maxButtonSize)

        // Calculate total button grid height (5 rows + 4 gaps)
        let buttonGridHeight = (buttonSize * 5) + (spacing * 4)

        // Calculate available height for display with sensible constraints
        let totalReserved = topPadding + bottomPadding + buttonGridHeight + GlassTheme.spacingMedium
        let rawDisplayHeight = size.height - totalReserved

        // Constrain display height: min for readability, allow generous max for large results
        // Larger display reduces black space and shows calculations prominently
        let minDisplayHeight: CGFloat = isIPad ? 200 : 120
        let maxDisplayHeight: CGFloat = isIPad ? size.height * 0.40 : size.height * 0.38
        let displayHeight = min(max(rawDisplayHeight, minDisplayHeight), maxDisplayHeight)

        // Recalculate top padding to center content when display is constrained
        let unusedSpace = rawDisplayHeight - displayHeight
        let adjustedTopPadding = topPadding + (unusedSpace > 0 ? unusedSpace * 0.4 : 0)

        return LayoutMetrics(
            displayHeight: displayHeight,
            buttonSize: buttonSize,
            topPadding: adjustedTopPadding,
            displayBottomPadding: GlassTheme.spacingMedium
        )
    }
}

// MARK: - Layout Metrics

private struct LayoutMetrics {
    let displayHeight: CGFloat
    let buttonSize: CGFloat
    let topPadding: CGFloat
    let displayBottomPadding: CGFloat
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

        CalculatorView()
    }
}
