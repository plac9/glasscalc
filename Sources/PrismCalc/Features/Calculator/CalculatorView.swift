import SwiftUI

/// Main calculator view with full glassmorphism UI
public struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()

    public init() {}

    public var body: some View {
        GeometryReader { geometry in
            let buttonSize = calculateButtonSize(for: geometry.size)
            let spacing = GlassTheme.spacingSmall

            VStack(spacing: spacing) {
                Spacer()

                // Display
                GlassDisplay(
                    value: viewModel.display,
                    expression: viewModel.expression
                )
                .padding(.horizontal)

                Spacer()

                // Button grid
                VStack(spacing: spacing) {
                    // Row 1: AC, +/-, %, /
                    HStack(spacing: spacing) {
                        GlassButton("AC", style: .special, size: buttonSize) {
                            viewModel.clear()
                        }
                        GlassButton("+/-", style: .special, size: buttonSize) {
                            viewModel.toggleSign()
                        }
                        GlassButton("%", style: .special, size: buttonSize) {
                            viewModel.percentage()
                        }
                        GlassButton("/", style: .operation, size: buttonSize) {
                            viewModel.inputOperation(.divide)
                        }
                    }

                    // Row 2: 7, 8, 9, x
                    HStack(spacing: spacing) {
                        GlassButton("7", size: buttonSize) {
                            viewModel.inputDigit("7")
                        }
                        GlassButton("8", size: buttonSize) {
                            viewModel.inputDigit("8")
                        }
                        GlassButton("9", size: buttonSize) {
                            viewModel.inputDigit("9")
                        }
                        GlassButton("x", style: .operation, size: buttonSize) {
                            viewModel.inputOperation(.multiply)
                        }
                    }

                    // Row 3: 4, 5, 6, -
                    HStack(spacing: spacing) {
                        GlassButton("4", size: buttonSize) {
                            viewModel.inputDigit("4")
                        }
                        GlassButton("5", size: buttonSize) {
                            viewModel.inputDigit("5")
                        }
                        GlassButton("6", size: buttonSize) {
                            viewModel.inputDigit("6")
                        }
                        GlassButton("-", style: .operation, size: buttonSize) {
                            viewModel.inputOperation(.subtract)
                        }
                    }

                    // Row 4: 1, 2, 3, +
                    HStack(spacing: spacing) {
                        GlassButton("1", size: buttonSize) {
                            viewModel.inputDigit("1")
                        }
                        GlassButton("2", size: buttonSize) {
                            viewModel.inputDigit("2")
                        }
                        GlassButton("3", size: buttonSize) {
                            viewModel.inputDigit("3")
                        }
                        GlassButton("+", style: .operation, size: buttonSize) {
                            viewModel.inputOperation(.add)
                        }
                    }

                    // Row 5: 0 (wide), ., =
                    HStack(spacing: spacing) {
                        // Wide zero button
                        Button(action: {
                            viewModel.inputDigit("0")
                        }) {
                            Text("0")
                                .font(.system(size: buttonSize * 0.4, weight: .medium, design: .rounded))
                                .foregroundStyle(GlassTheme.text)
                                .frame(width: buttonSize * 2 + spacing, height: buttonSize)
                                .background(
                                    Capsule()
                                        .fill(.thinMaterial)
                                        .overlay(
                                            Capsule()
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
                                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
                        }
                        .buttonStyle(.plain)

                        GlassButton(".", size: buttonSize) {
                            viewModel.inputDigit(".")
                        }
                        GlassButton("=", style: .equals, size: buttonSize) {
                            viewModel.calculate()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, GlassTheme.spacingLarge)
            }
        }
    }

    private func calculateButtonSize(for size: CGSize) -> CGFloat {
        let horizontalPadding: CGFloat = GlassTheme.spacingMedium * 2
        let spacing: CGFloat = GlassTheme.spacingSmall * 3 // 3 gaps between 4 buttons
        let availableWidth = size.width - horizontalPadding - spacing
        let buttonSize = availableWidth / 4

        // Cap the size for large screens
        return min(buttonSize, GlassTheme.buttonSizeLarge)
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

        CalculatorView()
    }
}
