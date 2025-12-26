import SwiftUI

/// Main calculator view with full glassmorphism UI
public struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @AppStorage("zeroOnRight") private var zeroOnRight: Bool = false

    public init() {}

    public var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            #if os(macOS)
            let isLargeScreen = size.width > 900 || size.height > 780
            let contentWidth = size.width
            #else
            let isLargeScreen = horizontalSizeClass == .regular && size.width > 600
            let contentWidth = size.width
            #endif

            let layoutSize = CGSize(width: contentWidth, height: size.height)
            let layoutMetrics = calculateLayout(for: layoutSize, isLargeScreen: isLargeScreen)
            let spacing = layoutMetrics.spacing

            VStack(spacing: 0) {
                // Display - proportionally sized for iPad
                GlassDisplay(
                    value: viewModel.display,
                    expression: viewModel.expression,
                    isLargeScreen: isLargeScreen
                )
                .frame(width: layoutMetrics.gridWidth, height: layoutMetrics.displayHeight)
                .padding(.top, layoutMetrics.topPadding)
                .padding(.bottom, layoutMetrics.displayBottomPadding)

                // Button grid - sized to always fit
                VStack(spacing: spacing) {
                        // Row 1: ⌫, AC, %, /
                        HStack(spacing: spacing) {
                            deleteButton(layoutMetrics: layoutMetrics)

                            calculatorButton(
                                "AC",
                                style: .special,
                                id: "calculator-button-AC",
                                layoutMetrics: layoutMetrics,
                                shortcut: .escape
                            ) {
                                viewModel.clear()
                            }

                            calculatorButton(
                                "%",
                                style: .special,
                                id: "calculator-button-percent",
                                layoutMetrics: layoutMetrics,
                                shortcut: "%"
                            ) {
                                viewModel.percentage()
                            }

                            calculatorButton(
                                "/",
                                style: .operation,
                                id: "calculator-button-divide",
                                layoutMetrics: layoutMetrics,
                                shortcut: "/"
                            ) {
                                viewModel.inputOperation(.divide)
                            }
                        }

                        // Row 2: 7, 8, 9, x
                        HStack(spacing: spacing) {
                            calculatorButton("7", id: "calculator-button-7", layoutMetrics: layoutMetrics, shortcut: "7") {
                                viewModel.inputDigit("7")
                            }

                            calculatorButton("8", id: "calculator-button-8", layoutMetrics: layoutMetrics, shortcut: "8") {
                                viewModel.inputDigit("8")
                            }

                            calculatorButton("9", id: "calculator-button-9", layoutMetrics: layoutMetrics, shortcut: "9") {
                                viewModel.inputDigit("9")
                            }

                            calculatorButton(
                                "x",
                                style: .operation,
                                id: "calculator-button-multiply",
                                layoutMetrics: layoutMetrics,
                                shortcut: "x"
                            ) {
                                viewModel.inputOperation(.multiply)
                            }
                        }

                        // Row 3: 4, 5, 6, -
                        HStack(spacing: spacing) {
                            calculatorButton("4", id: "calculator-button-4", layoutMetrics: layoutMetrics, shortcut: "4") {
                                viewModel.inputDigit("4")
                            }

                            calculatorButton("5", id: "calculator-button-5", layoutMetrics: layoutMetrics, shortcut: "5") {
                                viewModel.inputDigit("5")
                            }

                            calculatorButton("6", id: "calculator-button-6", layoutMetrics: layoutMetrics, shortcut: "6") {
                                viewModel.inputDigit("6")
                            }

                            calculatorButton(
                                "-",
                                style: .operation,
                                id: "calculator-button-subtract",
                                layoutMetrics: layoutMetrics,
                                shortcut: "-"
                            ) {
                                viewModel.inputOperation(.subtract)
                            }
                        }

                        // Row 4: 1, 2, 3, +
                        HStack(spacing: spacing) {
                            calculatorButton("1", id: "calculator-button-1", layoutMetrics: layoutMetrics, shortcut: "1") {
                                viewModel.inputDigit("1")
                            }

                            calculatorButton("2", id: "calculator-button-2", layoutMetrics: layoutMetrics, shortcut: "2") {
                                viewModel.inputDigit("2")
                            }

                            calculatorButton("3", id: "calculator-button-3", layoutMetrics: layoutMetrics, shortcut: "3") {
                                viewModel.inputDigit("3")
                            }

                            calculatorButton(
                                "+",
                                style: .operation,
                                id: "calculator-button-add",
                                layoutMetrics: layoutMetrics,
                                shortcut: "+"
                            ) {
                                viewModel.inputOperation(.add)
                            }
                        }

                        // Row 5: +/-, 0, ., = — respects zeroOnRight preference
                        HStack(spacing: spacing) {
                            calculatorButton(
                                "+/-",
                                style: .special,
                                id: "calculator-button-sign",
                                layoutMetrics: layoutMetrics
                            ) {
                                viewModel.toggleSign()
                            }

                            if zeroOnRight {
                                // Alternative layout: +/-, ., 0, =
                                calculatorButton(".", id: "calculator-button-decimal", layoutMetrics: layoutMetrics, shortcut: ".") {
                                    viewModel.inputDigit(".")
                                }

                                calculatorButton("0", id: "calculator-button-0", layoutMetrics: layoutMetrics, shortcut: "0") {
                                    viewModel.inputDigit("0")
                                }
                            } else {
                                // Standard layout: +/-, 0, ., =
                                calculatorButton("0", id: "calculator-button-0", layoutMetrics: layoutMetrics, shortcut: "0") {
                                    viewModel.inputDigit("0")
                                }

                                calculatorButton(".", id: "calculator-button-decimal", layoutMetrics: layoutMetrics, shortcut: ".") {
                                    viewModel.inputDigit(".")
                                }
                            }

                            calculatorButton(
                                "=",
                                style: .equals,
                                id: "calculator-button-equals",
                                layoutMetrics: layoutMetrics,
                                shortcut: "="
                            ) {
                                viewModel.calculate()
                            }
                        }
                }
                .frame(width: layoutMetrics.gridWidth)
                .padding(.bottom, layoutMetrics.bottomPadding)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, layoutMetrics.horizontalPadding)
            .frame(width: layoutMetrics.contentWidth)
        }
    }

    @ViewBuilder
    private func calculatorButton(
        _ title: String,
        style: GlassButton.Style = .number,
        id: String,
        layoutMetrics: LayoutMetrics,
        shortcut: KeyEquivalent? = nil,
        modifiers: EventModifiers = [],
        action: @escaping () -> Void
    ) -> some View {
        let button = GlassButton(
            title,
            style: style,
            size: layoutMetrics.buttonSize,
            accessibilityIdentifier: id,
            action: action
        )
        if let shortcut {
            button.keyboardShortcut(shortcut, modifiers: modifiers)
        } else {
            button
        }
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
        .keyboardShortcut(.delete)
    }

    private func calculateLayout(for size: CGSize, isLargeScreen: Bool) -> LayoutMetrics {
        // Spacing and padding values
        #if os(macOS)
        let _ = isLargeScreen
        let spacing: CGFloat = 6
        let horizontalPadding: CGFloat = 6
        let bottomPadding: CGFloat = 6
        let topPadding: CGFloat = 6
        let displayBottomPadding: CGFloat = 8
        let minDisplayHeight: CGFloat = 96
        let maxDisplayHeight: CGFloat = size.height * 0.3
        let maxButtonSize: CGFloat = 96

        let availableWidth = size.width - (horizontalPadding * 2) - (spacing * 3)
        let calculatedButtonSize = availableWidth / 4

        let reservedPadding = topPadding + bottomPadding + displayBottomPadding
        let maxButtonSizeByHeight = max(0, (size.height - reservedPadding - minDisplayHeight - (spacing * 4)) / 5)
        let buttonSize = max(0, min(calculatedButtonSize, maxButtonSizeByHeight, maxButtonSize))

        let buttonGridHeight = (buttonSize * 5) + (spacing * 4)
        let totalReserved = reservedPadding + buttonGridHeight
        let rawDisplayHeight = size.height - totalReserved
        let displayHeight = min(max(rawDisplayHeight, minDisplayHeight), maxDisplayHeight)
        let unusedSpace = rawDisplayHeight - displayHeight
        let adjustedTopPadding = topPadding + (unusedSpace > 0 ? unusedSpace * 0.4 : 0)
        #else
        let spacing: CGFloat = isLargeScreen ? GlassTheme.spacingMedium : GlassTheme.spacingSmall
        let horizontalPadding: CGFloat = isLargeScreen ? GlassTheme.spacingXL * 2 : GlassTheme.spacingMedium
        let bottomPadding: CGFloat = isLargeScreen ? GlassTheme.spacingXL : GlassTheme.spacingLarge
        let topPadding: CGFloat = isLargeScreen ? GlassTheme.spacingMedium : GlassTheme.spacingSmall

        let minDisplayHeight: CGFloat = isLargeScreen ? 200 : 120
        let maxDisplayHeight: CGFloat = isLargeScreen ? size.height * 0.40 : size.height * 0.38
        let baseMaxButtonSize: CGFloat = isLargeScreen ? 140 : GlassTheme.buttonSizeLarge
        #endif

        #if !os(macOS)
        // Calculate button size based on width
        let availableWidth = size.width - (horizontalPadding * 2) - (spacing * 3) // 3 gaps between 4 buttons
        let calculatedButtonSize = availableWidth / 4

        // Cap button size based on available height so the grid always fits
        let reservedPadding = topPadding + bottomPadding + GlassTheme.spacingMedium
        let maxButtonSizeByHeight = max(0, (size.height - reservedPadding - minDisplayHeight - (spacing * 4)) / 5)
        let maxButtonSize = min(baseMaxButtonSize, maxButtonSizeByHeight)
        let buttonSize = max(0, min(calculatedButtonSize, maxButtonSize))

        // Calculate total button grid height (5 rows + 4 gaps)
        let buttonGridHeight = (buttonSize * 5) + (spacing * 4)

        // Calculate available height for display with sensible constraints
        let totalReserved = reservedPadding + buttonGridHeight
        let rawDisplayHeight = size.height - totalReserved

        // Constrain display height: min for readability, allow generous max for large results
        // Larger display reduces black space and shows calculations prominently
        let displayHeight = min(max(rawDisplayHeight, minDisplayHeight), maxDisplayHeight)

        // Recalculate top padding to center content when display is constrained
        let unusedSpace = rawDisplayHeight - displayHeight
        let adjustedTopPadding = topPadding + (unusedSpace > 0 ? unusedSpace * 0.4 : 0)
        let displayBottomPadding = isLargeScreen ? GlassTheme.spacingMedium : GlassTheme.spacingSmall
        #endif

        let gridWidth = (buttonSize * 4) + (spacing * 3)
        #if os(macOS)
        let finalDisplayHeight = displayHeight
        let finalTopPadding = adjustedTopPadding
        let finalBottomPadding = bottomPadding
        let finalDisplayBottomPadding = displayBottomPadding
        #else
        let finalDisplayHeight = displayHeight
        let finalTopPadding = adjustedTopPadding
        let finalBottomPadding = bottomPadding
        let finalDisplayBottomPadding = displayBottomPadding
        #endif
        #if os(macOS)
        let contentWidth = gridWidth + (horizontalPadding * 2)
        #else
        let contentWidth = min(size.width, gridWidth + (horizontalPadding * 2))
        #endif

        return LayoutMetrics(
            displayHeight: finalDisplayHeight,
            buttonSize: buttonSize,
            topPadding: finalTopPadding,
            displayBottomPadding: finalDisplayBottomPadding,
            spacing: spacing,
            horizontalPadding: horizontalPadding,
            bottomPadding: finalBottomPadding,
            gridWidth: gridWidth,
            contentWidth: contentWidth
        )
    }
}

// MARK: - Layout Metrics

private struct LayoutMetrics {
    let displayHeight: CGFloat
    let buttonSize: CGFloat
    let topPadding: CGFloat
    let displayBottomPadding: CGFloat
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    let bottomPadding: CGFloat
    let gridWidth: CGFloat
    let contentWidth: CGFloat
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
