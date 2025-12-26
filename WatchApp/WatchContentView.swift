import SwiftUI
import WatchKit

private struct WatchHistoryEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let expression: String
    let result: String

    init(expression: String, result: String) {
        self.id = UUID()
        self.timestamp = Date()
        self.expression = expression
        self.result = result
    }
}

struct WatchContentView: View {
    @ScaledMetric private var gridSpacing: CGFloat = 5
    @ScaledMetric private var verticalSpacing: CGFloat = 7
    @ScaledMetric private var outerPadding: CGFloat = 6
    @ScaledMetric private var displayFontSize: CGFloat = 22
    @ScaledMetric private var displayHorizontalPadding: CGFloat = 4
    @ScaledMetric private var historyRowSpacing: CGFloat = 4
    @ScaledMetric private var sectionSpacing: CGFloat = 8

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: 4)
    }

    @State private var display = "0"
    @State private var storedValue: Double?
    @State private var pendingOperation: WatchCalculatorEngine.Operation?
    @State private var isNewInput = true
    @State private var historyEntries: [WatchHistoryEntry] = []
    @AppStorage("watchHistoryData") private var historyData: Data = Data()
    @State private var selectedTab: WatchTab = .calculator
    @State private var tipPercent: Double = 18
    @State private var discountPercent: Double = 20
    @State private var splitPeople: Int = 2
    @State private var didApplyLaunchOverrides = false
    private let maxHistoryEntries = 10

    private enum WatchTab: Int {
        case calculator
        case tip
        case discount
        case split
        case history
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: WatchTheme.backgroundGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                calculatorView
                    .tag(WatchTab.calculator)

                tipView
                    .tag(WatchTab.tip)

                discountView
                    .tag(WatchTab.discount)

                splitView
                    .tag(WatchTab.split)

                historyView
                    .tag(WatchTab.history)
            }
            .tabViewStyle(.page)
            .onAppear {
                loadHistory()
                applyLaunchOverrides()
            }
        }
    }

    private var calculatorView: some View {
        VStack(spacing: verticalSpacing) {
            displayView
            buttonGrid
        }
        .padding(outerPadding)
    }

    private var currentValue: Double {
        WatchCalculatorEngine.parseDisplay(display)
    }

    private var displayView: some View {
        HStack {
            Spacer()
            Text(display)
                .font(.system(size: displayFontSize, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(WatchTheme.text)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, displayHorizontalPadding)
        .onLongPressGesture(minimumDuration: 0.4) {
            backspace()
        }
        .accessibilityHint("Long press to delete the last digit")
    }

    private var buttonGrid: some View {
        LazyVGrid(columns: columns, spacing: gridSpacing) {
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

    private var tipView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                WatchSectionHeader(title: "Tip", subtitle: "Use calculator to enter bill")

                WatchGlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bill")
                            .font(.caption2)
                            .foregroundStyle(WatchTheme.textSecondary)
                        Text(formatCurrency(currentValue))
                            .font(.headline)
                            .foregroundStyle(WatchTheme.text)
                            .lineLimit(1)
                    }
                }

                WatchGlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Tip")
                                .font(.caption2)
                                .foregroundStyle(WatchTheme.textSecondary)
                            Spacer()
                            Text("\(Int(tipPercent))%")
                                .font(.caption2)
                                .foregroundStyle(WatchTheme.text)
                        }
                        Slider(value: $tipPercent, in: 0...30, step: 1)
                            .tint(WatchTheme.accent)
                    }
                }

                WatchGlassCard {
                    let tipAmount = currentValue * tipPercent / 100
                    let total = currentValue + tipAmount
                    VStack(alignment: .leading, spacing: 4) {
                        WatchResultRow(label: "Tip", value: formatCurrency(tipAmount))
                        WatchResultRow(label: "Total", value: formatCurrency(total), isEmphasized: true)
                    }
                }
            }
            .padding(outerPadding)
        }
    }

    private var discountView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                WatchSectionHeader(title: "Discount", subtitle: "Use calculator to enter price")

                WatchGlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Original")
                            .font(.caption2)
                            .foregroundStyle(WatchTheme.textSecondary)
                        Text(formatCurrency(currentValue))
                            .font(.headline)
                            .foregroundStyle(WatchTheme.text)
                            .lineLimit(1)
                    }
                }

                WatchGlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Discount")
                                .font(.caption2)
                                .foregroundStyle(WatchTheme.textSecondary)
                            Spacer()
                            Text("\(Int(discountPercent))%")
                                .font(.caption2)
                                .foregroundStyle(WatchTheme.text)
                        }
                        Slider(value: $discountPercent, in: 0...80, step: 5)
                            .tint(WatchTheme.accent)
                    }
                }

                WatchGlassCard {
                    let discount = currentValue * discountPercent / 100
                    let final = max(0, currentValue - discount)
                    VStack(alignment: .leading, spacing: 4) {
                        WatchResultRow(label: "Save", value: formatCurrency(discount))
                        WatchResultRow(label: "Final", value: formatCurrency(final), isEmphasized: true)
                    }
                }
            }
            .padding(outerPadding)
        }
    }

    private var splitView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                WatchSectionHeader(title: "Split", subtitle: "Use calculator to enter bill")

                WatchGlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bill")
                            .font(.caption2)
                            .foregroundStyle(WatchTheme.textSecondary)
                        Text(formatCurrency(currentValue))
                            .font(.headline)
                            .foregroundStyle(WatchTheme.text)
                            .lineLimit(1)
                    }
                }

                WatchGlassCard {
                    Stepper(value: $splitPeople, in: 1...12) {
                        HStack {
                            Text("People")
                                .font(.caption2)
                                .foregroundStyle(WatchTheme.textSecondary)
                            Spacer()
                            Text("\(splitPeople)")
                                .font(.caption2)
                                .foregroundStyle(WatchTheme.text)
                        }
                    }
                    .tint(WatchTheme.accent)
                }

                WatchGlassCard {
                    let perPerson = splitPeople > 0 ? currentValue / Double(splitPeople) : 0
                    WatchResultRow(label: "Each", value: formatCurrency(perPerson), isEmphasized: true)
                }
            }
            .padding(outerPadding)
        }
    }

    private var historyView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: historyRowSpacing) {
                HStack {
                    Text("History")
                        .font(.headline)
                        .foregroundStyle(WatchTheme.text)

                    Spacer()

                    Text("Last \(maxHistoryEntries)")
                        .font(.caption2)
                        .foregroundStyle(WatchTheme.textSecondary)
                }

                if historyEntries.isEmpty {
                    VStack(spacing: 4) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title3)
                            .foregroundStyle(WatchTheme.textSecondary)
                        Text("No history yet")
                            .font(.caption2)
                            .foregroundStyle(WatchTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                } else {
                    ForEach(historyEntries) { entry in
                        WatchHistoryRow(entry: entry)
                    }
                }
            }
            .padding(outerPadding)
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
        let expression = "\(WatchCalculatorEngine.formatDisplay(stored)) \(pending.rawValue) \(WatchCalculatorEngine.formatDisplay(currentValue))"
        recordHistory(expression: expression, result: display)
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

    private func backspace() {
        guard !isNewInput else { return }
        if display.count <= 1 || (display.count == 2 && display.hasPrefix("-")) {
            display = "0"
            isNewInput = true
            return
        }
        display.removeLast()
    }

    private func loadHistory() {
        guard !historyData.isEmpty else { return }
        do {
            historyEntries = try JSONDecoder().decode([WatchHistoryEntry].self, from: historyData)
        } catch {
            historyEntries = []
        }
    }

    private func applyLaunchOverrides() {
        guard !didApplyLaunchOverrides else { return }
        didApplyLaunchOverrides = true

        let args = ProcessInfo.processInfo.arguments
        if args.contains("WATCH_SEED_HISTORY") {
            seedHistoryIfNeeded()
        }

        if let tabArg = args.first(where: { $0.hasPrefix("WATCH_TAB:") }) {
            let rawValue = tabArg.replacingOccurrences(of: "WATCH_TAB:", with: "").lowercased()
            switch rawValue {
            case "calculator":
                selectedTab = .calculator
            case "tip":
                selectedTab = .tip
            case "discount":
                selectedTab = .discount
            case "split":
                selectedTab = .split
            case "history":
                selectedTab = .history
            default:
                break
            }
        }

        if let valueArg = args.first(where: { $0.hasPrefix("WATCH_VALUE:") }) {
            let rawValue = valueArg.replacingOccurrences(of: "WATCH_VALUE:", with: "")
            display = rawValue
            isNewInput = false
        }

        if let tipArg = args.first(where: { $0.hasPrefix("WATCH_TIP:") }) {
            let rawValue = tipArg.replacingOccurrences(of: "WATCH_TIP:", with: "")
            tipPercent = Double(rawValue) ?? tipPercent
        }

        if let discountArg = args.first(where: { $0.hasPrefix("WATCH_DISCOUNT:") }) {
            let rawValue = discountArg.replacingOccurrences(of: "WATCH_DISCOUNT:", with: "")
            discountPercent = Double(rawValue) ?? discountPercent
        }

        if let splitArg = args.first(where: { $0.hasPrefix("WATCH_SPLIT:") }) {
            let rawValue = splitArg.replacingOccurrences(of: "WATCH_SPLIT:", with: "")
            splitPeople = max(1, Int(rawValue) ?? splitPeople)
        }
    }

    private func seedHistoryIfNeeded() {
        guard historyEntries.isEmpty else { return }

        historyEntries = [
            WatchHistoryEntry(expression: "78 + 22", result: "100"),
            WatchHistoryEntry(expression: "200 x 0.2", result: "40"),
            WatchHistoryEntry(expression: "150 / 3", result: "50"),
            WatchHistoryEntry(expression: "19.99 + 5", result: "24.99"),
            WatchHistoryEntry(expression: "90 - 18", result: "72"),
            WatchHistoryEntry(expression: "12 x 8", result: "96"),
            WatchHistoryEntry(expression: "64 / 8", result: "8"),
            WatchHistoryEntry(expression: "45 + 55", result: "100"),
            WatchHistoryEntry(expression: "120 - 35", result: "85"),
            WatchHistoryEntry(expression: "7 x 9", result: "63")
        ]
        saveHistory()
    }

    private func recordHistory(expression: String, result: String) {
        historyEntries.insert(WatchHistoryEntry(expression: expression, result: result), at: 0)
        if historyEntries.count > maxHistoryEntries {
            historyEntries = Array(historyEntries.prefix(maxHistoryEntries))
        }
        saveHistory()
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(historyEntries) {
            historyData = data
        }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

private struct WatchGlassButton: View {
    let title: String
    let isAccent: Bool
    let accessibilityLabel: String
    let action: () -> Void
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @ScaledMetric private var buttonFontSize: CGFloat = 16
    @ScaledMetric private var buttonHeight: CGFloat = 30
    @ScaledMetric private var cornerRadius: CGFloat = 8

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
        Button {
            playTapHaptic()
            action()
        } label: {
            Text(title)
                .font(.system(size: buttonFontSize, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, minHeight: buttonHeight)
        }
        .buttonStyle(.plain)
        .foregroundStyle(isAccent ? Color.white : WatchTheme.text)
        .background(backgroundStyle)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(highlightOverlay)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    Color.white.opacity(isHighContrast ? 0.34 : 0.18),
                    lineWidth: isHighContrast ? 1.0 : 0.6
                )
                .blendMode(.overlay)
        )
        .shadow(color: Color.black.opacity(isAccent ? 0.35 : 0.25), radius: 1.5, y: 1)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private var backgroundStyle: some View {
        if isAccent {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            WatchTheme.accent.opacity(isHighContrast ? 1.0 : 0.95),
                            WatchTheme.accent.opacity(isHighContrast ? 0.9 : 0.65)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        } else {
            if isHighContrast {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(reduceTransparency ? 0.28 : 0.18))
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(reduceTransparency ? 0.22 : 0.14))
            }
        }
    }

    private var highlightOverlay: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(reduceTransparency ? 0.18 : 0.12),
                        Color.white.opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .blendMode(.softLight)
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

    private func playTapHaptic() {
        WKInterfaceDevice.current().play(.click)
    }
}

private struct WatchHistoryRow: View {
    let entry: WatchHistoryEntry
    @ScaledMetric private var rowPadding: CGFloat = 6
    @ScaledMetric private var rowSpacing: CGFloat = 2

    var body: some View {
        VStack(alignment: .leading, spacing: rowSpacing) {
            Text(entry.result)
                .font(.headline)
                .foregroundStyle(WatchTheme.text)
                .lineLimit(1)

            Text(entry.expression)
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
                .lineLimit(1)
        }
        .padding(rowPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 0.6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.12), Color.white.opacity(0.02)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.softLight)
                )
        )
    }
}

private struct WatchSectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline)
                .foregroundStyle(WatchTheme.text)
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
        }
    }
}

private struct WatchResultRow: View {
    let label: String
    let value: String
    var isEmphasized: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
            Spacer()
            Text(value)
                .font(isEmphasized ? .headline : .caption)
                .foregroundStyle(isEmphasized ? WatchTheme.accent : WatchTheme.text)
        }
    }
}

private struct WatchGlassCard<Content: View>: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(reduceTransparency ? 0.2 : 0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.white.opacity(0.18), lineWidth: 0.6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.16), Color.white.opacity(0.02)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blendMode(.softLight)
                    )
            )
    }
}

#Preview {
    WatchContentView()
}
