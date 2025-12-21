import WidgetKit
import SwiftUI
import AppIntents

/// PrismCalc Widget - Shows recent calculations with interactive buttons
public struct PrismCalcWidget: Widget {
    public let kind: String = "PrismCalcWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrismCalcTimelineProvider()) { entry in
            PrismCalcWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("PrismCalc")
        .description("Quick calculations and history")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Timeline Entry

public struct PrismCalcEntry: TimelineEntry {
    public let date: Date
    public let lastResult: String
    public let lastExpression: String
    public let recentHistory: [HistoryItem]

    public struct HistoryItem: Identifiable {
        public let id = UUID()
        public let type: String
        public let result: String
        public let details: String
        public let icon: String

        public init(type: String, result: String, details: String, icon: String) {
            self.type = type
            self.result = result
            self.details = details
            self.icon = icon
        }
    }

    public init(date: Date, lastResult: String, lastExpression: String, recentHistory: [HistoryItem]) {
        self.date = date
        self.lastResult = lastResult
        self.lastExpression = lastExpression
        self.recentHistory = recentHistory
    }
}

// MARK: - Timeline Provider

public struct PrismCalcTimelineProvider: TimelineProvider {
    private let sharedData = SharedDataService.shared

    public init() {}

    public func placeholder(in context: Context) -> PrismCalcEntry {
        PrismCalcEntry(
            date: Date(),
            lastResult: "42",
            lastExpression: "6 × 7",
            recentHistory: [
                .init(type: "Calculator", result: "42", details: "6 × 7", icon: "plus.forwardslash.minus"),
                .init(type: "Tip", result: "$23.60", details: "$20 + 18%", icon: "dollarsign.circle"),
                .init(type: "Split", result: "$15.00", details: "$60 ÷ 4", icon: "person.2")
            ]
        )
    }

    public func getSnapshot(in context: Context, completion: @escaping (PrismCalcEntry) -> Void) {
        let entry = createEntry()
        completion(entry)
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<PrismCalcEntry>) -> Void) {
        let entry = createEntry()
        // Refresh every hour or when app signals update
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }

    private func createEntry() -> PrismCalcEntry {
        let lastResult = sharedData.getLastResult()
        let lastExpression = sharedData.getLastExpression()
        let recentHistory = sharedData.getRecentHistory()

        // Convert WidgetHistoryItem to PrismCalcEntry.HistoryItem
        let historyItems = recentHistory.map { item in
            PrismCalcEntry.HistoryItem(
                type: item.type,
                result: item.result,
                details: item.details,
                icon: item.icon
            )
        }

        // If no history, return default entry
        if lastResult == "0" && historyItems.isEmpty {
            return PrismCalcEntry(
                date: Date(),
                lastResult: "0",
                lastExpression: "Tap to calculate",
                recentHistory: []
            )
        }

        return PrismCalcEntry(
            date: Date(),
            lastResult: lastResult,
            lastExpression: lastExpression,
            recentHistory: historyItems
        )
    }
}

// MARK: - Widget Views

public struct PrismCalcWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: PrismCalcEntry

    public init(entry: PrismCalcEntry) {
        self.entry = entry
    }

    public var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    PrismCalcWidget()
} timeline: {
    PrismCalcEntry(
        date: Date(),
        lastResult: "42",
        lastExpression: "6 × 7",
        recentHistory: []
    )
}

#Preview(as: .systemMedium) {
    PrismCalcWidget()
} timeline: {
    PrismCalcEntry(
        date: Date(),
        lastResult: "$23.60",
        lastExpression: "$20 + 18% tip",
        recentHistory: [
            .init(type: "Calc", result: "42", details: "6 × 7", icon: "plus.forwardslash.minus"),
            .init(type: "Tip", result: "$23.60", details: "$20 + 18%", icon: "dollarsign.circle"),
            .init(type: "Split", result: "$15", details: "$60 ÷ 4", icon: "person.2")
        ]
    )
}

#Preview(as: .systemLarge) {
    PrismCalcWidget()
} timeline: {
    PrismCalcEntry(
        date: Date(),
        lastResult: "$23.60",
        lastExpression: "$20 + 18% tip",
        recentHistory: [
            .init(type: "Calc", result: "42", details: "6 × 7", icon: "plus.forwardslash.minus"),
            .init(type: "Tip", result: "$23.60", details: "$20 + 18%", icon: "dollarsign.circle"),
            .init(type: "Split", result: "$15", details: "$60 ÷ 4", icon: "person.2")
        ]
    )
}
