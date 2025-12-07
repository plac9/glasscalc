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
            smallWidget
        case .systemMedium:
            mediumWidget
        case .systemLarge:
            largeWidget
        default:
            smallWidget
        }
    }

    // MARK: - Small Widget

    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.title2)
                    .foregroundStyle(.blue.gradient)

                Text("PrismCalc")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(entry.lastResult)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(entry.lastExpression)
                .font(.caption)
                .foregroundStyle(.secondary)

            // Quick action buttons
            HStack(spacing: 8) {
                ForEach([WidgetFeature.tipCalculator, .billSplit], id: \.rawValue) { feature in
                    Button(intent: OpenFeatureIntent(feature: feature)) {
                        Image(systemName: feature.icon)
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .frame(width: 28, height: 28)
                            .background(.blue.opacity(0.15))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
    }

    // MARK: - Medium Widget

    private var mediumWidget: some View {
        HStack(spacing: 12) {
            // Last result section
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "equal.square.fill")
                        .foregroundStyle(.blue.gradient)
                    Text("Latest")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(entry.lastResult)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(entry.lastExpression)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // Quick actions grid
            VStack(spacing: 8) {
                Text("Quick Actions")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach([WidgetFeature.calculator, .tipCalculator, .billSplit, .unitConverter], id: \.rawValue) { feature in
                        Button(intent: OpenFeatureIntent(feature: feature)) {
                            VStack(spacing: 4) {
                                Image(systemName: feature.icon)
                                    .font(.body)
                                    .foregroundStyle(.blue)

                                Text(feature.label)
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }

    // MARK: - Large Widget

    private var largeWidget: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.title2)
                    .foregroundStyle(.blue.gradient)

                Text("PrismCalc")
                    .font(.headline)

                Spacer()

                Text("Latest Result")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Last result hero
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.lastResult)
                    .font(.system(size: 36, weight: .medium, design: .rounded))

                Text(entry.lastExpression)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)

            // Quick action buttons row
            HStack(spacing: 8) {
                ForEach([WidgetFeature.calculator, .tipCalculator, .billSplit, .unitConverter], id: \.rawValue) { feature in
                    Button(intent: OpenFeatureIntent(feature: feature)) {
                        VStack(spacing: 4) {
                            Image(systemName: feature.icon)
                                .font(.body)
                                .foregroundStyle(.blue)

                            Text(feature.label)
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()

            // History list
            HStack {
                Text("Recent History")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if !entry.recentHistory.isEmpty {
                    Button(intent: ClearWidgetHistoryIntent()) {
                        Label("Clear", systemImage: "trash")
                            .font(.caption2)
                            .foregroundStyle(.red.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                }
            }

            ForEach(entry.recentHistory) { item in
                HStack(spacing: 12) {
                    Image(systemName: item.icon)
                        .font(.body)
                        .foregroundStyle(.blue)
                        .frame(width: 24, height: 24)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.result)
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Text(item.details)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(item.type)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()
        }
        .padding()
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
