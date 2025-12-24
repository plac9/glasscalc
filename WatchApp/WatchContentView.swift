import SwiftUI

struct WatchContentView: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 4)

    @State private var display = "0"
    @State private var storedValue: Double?
    @State private var pendingOperation: WatchCalculatorEngine.Operation?
    @State private var isNewInput = true
    var body: some View {
        ZStack {
            LinearGradient(
                colors: WatchTheme.backgroundGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 8) {
                displayView
                buttonGrid
            }
            .padding(8)
        }
    }

    private var displayView: some View {
        HStack {
            Spacer()
            Text(display)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(WatchTheme.text)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, 6)
    }

    private var buttonGrid: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            WatchGlassButton(title: "C", isAccent: true) { clear() }
            WatchGlassButton(title: "/", isAccent: true) { applyOperation(.divide) }
            WatchGlassButton(title: "x", isAccent: true) { applyOperation(.multiply) }
            WatchGlassButton(title: "-", isAccent: true) { applyOperation(.subtract) }

            ForEach(["7", "8", "9", "+", "4", "5", "6", "=", "1", "2", "3", ".", "0"], id: \.self) { label in
                switch label {
                case "+":
                    WatchGlassButton(title: label, isAccent: true) { applyOperation(.add) }
                case "=":
                    WatchGlassButton(title: label, isAccent: true) { calculateResult() }
                case ".":
                    WatchGlassButton(title: label, isAccent: false) { inputDigit(label) }
                default:
                    WatchGlassButton(title: label, isAccent: false) { inputDigit(label) }
                }
            }
        }
    }

    private func inputDigit(_ digit: String) {
        if isNewInput {
            display = digit == "." ? "0." : digit
            isNewInput = false
            return
        }

        if digit == "." && display.contains(".") {
            return
        }

        if display == "0" && digit != "." {
            display = digit
        } else {
            display += digit
        }
    }

    private func applyOperation(_ operation: WatchCalculatorEngine.Operation) {
        let currentValue = WatchCalculatorEngine.parseDisplay(display)

        if let stored = storedValue, let pending = pendingOperation {
            let result = WatchCalculatorEngine.calculate(stored, pending, currentValue)
            display = WatchCalculatorEngine.formatDisplay(result)
            storedValue = result
        } else {
            storedValue = currentValue
        }

        pendingOperation = operation
        isNewInput = true
    }

    private func calculateResult() {
        guard let stored = storedValue, let pending = pendingOperation else { return }
        let currentValue = WatchCalculatorEngine.parseDisplay(display)
        let result = WatchCalculatorEngine.calculate(stored, pending, currentValue)
        display = WatchCalculatorEngine.formatDisplay(result)
        pendingOperation = nil
        storedValue = nil
        isNewInput = true
    }

    private func clear() {
        display = "0"
        storedValue = nil
        pendingOperation = nil
        isNewInput = true
    }
}

private struct WatchGlassButton: View {
    let title: String
    let isAccent: Bool
    let accessibilityLabel: String
    let action: () -> Void
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    init(title: String, isAccent: Bool, accessibilityLabel: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.isAccent = isAccent
        self.accessibilityLabel = accessibilityLabel ?? Self.defaultAccessibilityLabel(for: title)
        self.action = action
    }

    private var isHighContrast: Bool {
        colorSchemeContrast == .increased
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, minHeight: 30)
        }
        .buttonStyle(.plain)
        .foregroundStyle(isAccent ? Color.white : WatchTheme.text)
        .background(backgroundStyle)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(isHighContrast ? 0.35 : 0.2), lineWidth: isHighContrast ? 1.0 : 0.6)
        )
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private var backgroundStyle: some View {
        if isAccent {
            RoundedRectangle(cornerRadius: 8)
                .fill(WatchTheme.accent.opacity(isHighContrast ? 1.0 : 0.85))
        } else {
            if isHighContrast {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(reduceTransparency ? 0.25 : 0.15))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
            }
        }
    }

    private static func defaultAccessibilityLabel(for title: String) -> String {
        switch title {
        case "0": return "Zero"
        case "1": return "One"
        case "2": return "Two"
        case "3": return "Three"
        case "4": return "Four"
        case "5": return "Five"
        case "6": return "Six"
        case "7": return "Seven"
        case "8": return "Eight"
        case "9": return "Nine"
        case ".": return "Decimal point"
        case "+": return "Plus"
        case "-": return "Minus"
        case "x": return "Multiply"
        case "/": return "Divide"
        case "=": return "Equals"
        case "C": return "Clear"
        default: return title
        }
    }
}

#Preview {
    WatchContentView()
}
