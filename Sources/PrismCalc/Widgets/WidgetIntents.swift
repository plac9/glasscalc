import AppIntents
import WidgetKit

// MARK: - Widget Quick Action Intents

/// Intent to open the app and navigate to a specific feature
struct OpenFeatureIntent: AppIntent {
    static let title: LocalizedStringResource = "Open Feature"
    static let description = IntentDescription("Open PrismCalc to a specific feature")

    static let openAppWhenRun: Bool = true

    @Parameter(title: "Feature")
    var feature: WidgetFeature

    init() {
        self.feature = .calculator
    }

    init(feature: WidgetFeature) {
        self.feature = feature
    }

    func perform() async throws -> some IntentResult {
        // The app will receive this via onOpenURL or environment
        // For now, just open the app - navigation can be handled by the app
        return .result()
    }
}

/// Features available from widget
enum WidgetFeature: String, AppEnum {
    case calculator
    case tipCalculator
    case discountCalculator
    case billSplit
    case unitConverter

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Feature"

    static let caseDisplayRepresentations: [WidgetFeature: DisplayRepresentation] = [
        .calculator: DisplayRepresentation(title: "Calculator", image: .init(systemName: "plus.forwardslash.minus")),
        .tipCalculator: DisplayRepresentation(title: "Tip Calculator", image: .init(systemName: "dollarsign.circle")),
        .discountCalculator: DisplayRepresentation(title: "Discount Calculator", image: .init(systemName: "tag")),
        .billSplit: DisplayRepresentation(title: "Bill Split", image: .init(systemName: "person.2")),
        .unitConverter: DisplayRepresentation(title: "Unit Converter", image: .init(systemName: "arrow.left.arrow.right"))
    ]

    var icon: String {
        switch self {
        case .calculator: return "plus.forwardslash.minus"
        case .tipCalculator: return "dollarsign.circle"
        case .discountCalculator: return "tag"
        case .billSplit: return "person.2"
        case .unitConverter: return "arrow.left.arrow.right"
        }
    }

    var label: String {
        switch self {
        case .calculator: return "Calc"
        case .tipCalculator: return "Tip"
        case .discountCalculator: return "Discount"
        case .billSplit: return "Split"
        case .unitConverter: return "Convert"
        }
    }
}

/// Intent to clear history (for widget button)
struct ClearWidgetHistoryIntent: AppIntent {
    static let title: LocalizedStringResource = "Clear History"
    static let description = IntentDescription("Clear calculation history")

    func perform() async throws -> some IntentResult {
        // Clear shared data
        SharedDataService.shared.clearHistory()
        // Trigger widget refresh
        WidgetCenter.shared.reloadTimelines(ofKind: "PrismCalcWidget")
        return .result()
    }
}
