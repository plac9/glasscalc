import WidgetKit
import SwiftUI
import AppIntents

#if !os(watchOS)
private enum WidgetTheme {
    static let backgroundGradient: [Color] = [
        Color(red: 0.18, green: 0.22, blue: 0.50),
        Color(red: 0.34, green: 0.26, blue: 0.64),
        Color(red: 0.20, green: 0.45, blue: 0.70)
    ]
    static let accentPrimary = Color(red: 0.48, green: 0.64, blue: 0.98)
    static let accentSecondary = Color(red: 0.36, green: 0.82, blue: 0.88)
    static let text = Color.white
    static let textSecondary = Color.white.opacity(0.72)
    static let textTertiary = Color.white.opacity(0.55)

    static func borderGradient(reduceTransparency: Bool, increaseContrast: Bool) -> LinearGradient {
        let highContrast = increaseContrast
        let startOpacity = highContrast ? 0.32 : 0.18
        let endOpacity = highContrast ? 0.16 : 0.08
        let reduceMultiplier: Double = reduceTransparency ? 0.6 : 1.0
        return LinearGradient(
            colors: [
                Color.white.opacity(startOpacity * reduceMultiplier),
                Color.white.opacity(endOpacity * reduceMultiplier)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func borderLineWidth(reduceTransparency: Bool, increaseContrast: Bool) -> CGFloat {
        if increaseContrast {
            return reduceTransparency ? 0.9 : 1.1
        }
        return reduceTransparency ? 0.6 : 0.8
    }

    static func borderBlendMode(for colorScheme: ColorScheme) -> BlendMode {
        colorScheme == .dark ? .overlay : .softLight
    }
}

/// PrismCalc Widget - Shows recent calculations with interactive buttons
public struct PrismCalcWidget: Widget {
    public let kind: String = "PrismCalcWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrismCalcTimelineProvider()) { entry in
            PrismCalcWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("prismCalc")
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
        AdaptivePrismCalcWidgetView(entry: entry)
    }
}

// A single adaptive view that renders appropriately for each family size
struct AdaptivePrismCalcWidgetView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme
    let entry: PrismCalcEntry

    private var isIncreasedContrast: Bool {
        if #available(iOS 14.0, *) {
            return colorSchemeContrast == .increased
        } else {
            return false
        }
    }

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                small
            case .systemMedium:
                medium
            case .systemLarge:
                large
            default:
                small
            }
        }
        .padding()
        .background(widgetHighlightOverlay)
        .containerBackground(widgetBackground, for: .widget)
    }

    // MARK: - Small
    private var small: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.title2)
                    .foregroundStyle(widgetAccentGradient)

                Text("prismCalc")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(WidgetTheme.textSecondary)
            }

            Spacer()

            Text(entry.lastResult)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundStyle(WidgetTheme.text)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(entry.lastExpression)
                .font(.caption)
                .foregroundStyle(WidgetTheme.textSecondary)

            HStack(spacing: 8) {
                ForEach([WidgetFeature.tipCalculator, .billSplit], id: \.rawValue) { feature in
                    Button(intent: OpenFeatureIntent(feature: feature)) {
                        Image(systemName: feature.icon)
                            .font(.caption)
                            .foregroundStyle(WidgetTheme.text)
                            .frame(width: 28, height: 28)
                            .background(widgetCircleBackground)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Medium
    private var medium: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "equal.square.fill")
                        .foregroundStyle(widgetAccentGradient)
                    Text("Latest")
                        .font(.caption)
                        .foregroundStyle(WidgetTheme.textSecondary)
                }

                Spacer()

                Text(entry.lastResult)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(WidgetTheme.text)

                Text(entry.lastExpression)
                    .font(.caption)
                    .foregroundStyle(WidgetTheme.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            VStack(spacing: 8) {
                Text("Quick Actions")
                    .font(.caption2)
                    .foregroundStyle(WidgetTheme.textSecondary)

                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 8
                ) {
                    ForEach(
                        [WidgetFeature.calculator, .tipCalculator, .billSplit, .unitConverter],
                        id: \.rawValue
                    ) { feature in
                        Button(intent: OpenFeatureIntent(feature: feature)) {
                            VStack(spacing: 4) {
                                Image(systemName: feature.icon)
                                    .font(.body)
                                    .foregroundStyle(WidgetTheme.text)

                                Text(feature.label)
                                    .font(.system(size: 9))
                                    .foregroundStyle(WidgetTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(widgetRoundedBackground(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Large
    private var large: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.title2)
                    .foregroundStyle(widgetAccentGradient)

                Text("prismCalc")
                    .font(.headline)
                    .foregroundStyle(WidgetTheme.text)

                Spacer()

                Text("Latest Result")
                    .font(.caption)
                    .foregroundStyle(WidgetTheme.textSecondary)
            }

            // Result
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.lastResult)
                    .font(.system(size: 36, weight: .medium, design: .rounded))
                    .foregroundStyle(WidgetTheme.text)

                Text(entry.lastExpression)
                    .font(.subheadline)
                    .foregroundStyle(WidgetTheme.textSecondary)
            }
            .padding(.vertical, 4)

            // Quick actions
            HStack(spacing: 8) {
                ForEach(
                    [WidgetFeature.calculator, .tipCalculator, .billSplit, .unitConverter],
                    id: \.rawValue
                ) { feature in
                    Button(intent: OpenFeatureIntent(feature: feature)) {
                        VStack(spacing: 4) {
                            Image(systemName: feature.icon)
                                .font(.body)
                                .foregroundStyle(WidgetTheme.text)

                            Text(feature.label)
                                .font(.system(size: 10))
                                .foregroundStyle(WidgetTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(widgetRoundedBackground(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()

            // History
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Recent History")
                        .font(.caption)
                        .foregroundStyle(WidgetTheme.textSecondary)

                    Spacer()
                }

                ForEach(entry.recentHistory) { item in
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .font(.body)
                            .foregroundStyle(WidgetTheme.text)
                            .frame(width: 24, height: 24)
                            .background(widgetCircleBackground)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.result)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(WidgetTheme.text)

                            Text(item.details)
                                .font(.caption)
                                .foregroundStyle(WidgetTheme.textSecondary)
                        }

                        Spacer()

                        Text(item.type)
                            .font(.caption2)
                            .foregroundStyle(WidgetTheme.textTertiary)
                    }
                }
            }

            Spacer(minLength: 0)
        }
    }

    private var widgetBackground: LinearGradient {
        LinearGradient(
            colors: WidgetTheme.backgroundGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var widgetHighlightOverlay: some View {
        Color.white
            .opacity(reduceTransparency ? 0.12 : 0.06)
            .blendMode(.softLight)
    }

    private var widgetAccentGradient: LinearGradient {
        LinearGradient(
            colors: [WidgetTheme.accentPrimary, WidgetTheme.accentSecondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var widgetCircleBackground: some View {
        Circle()
            .fill(Color.white.opacity(reduceTransparency ? 0.2 : 0.12))
            .overlay(
                Circle()
                    .strokeBorder(
                        WidgetTheme.borderGradient(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: isIncreasedContrast
                        ),
                        lineWidth: WidgetTheme.borderLineWidth(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: isIncreasedContrast
                        )
                    )
                    .blendMode(WidgetTheme.borderBlendMode(for: colorScheme))
            )
    }

    private func widgetRoundedBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white.opacity(reduceTransparency ? 0.2 : 0.12))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        WidgetTheme.borderGradient(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: isIncreasedContrast
                        ),
                        lineWidth: WidgetTheme.borderLineWidth(
                            reduceTransparency: reduceTransparency,
                            increaseContrast: isIncreasedContrast
                        )
                    )
                    .blendMode(WidgetTheme.borderBlendMode(for: colorScheme))
            )
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
#endif
