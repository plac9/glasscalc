import SwiftUI
import WidgetKit

#if os(watchOS)
private struct PrismCalcWatchEntry: TimelineEntry {
    let date: Date
    let lastResult: String
    let lastExpression: String
}

private struct PrismCalcWatchProvider: TimelineProvider {
    func placeholder(in context: Context) -> PrismCalcWatchEntry {
        PrismCalcWatchEntry(date: Date(), lastResult: "0", lastExpression: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (PrismCalcWatchEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrismCalcWatchEntry>) -> Void) {
        let entry = makeEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func makeEntry() -> PrismCalcWatchEntry {
        PrismCalcWatchEntry(
            date: Date(),
            lastResult: SharedDataService.shared.getLastResult(),
            lastExpression: SharedDataService.shared.getLastExpression()
        )
    }
}

struct PrismCalcWatchWidget: Widget {
    let kind: String = "PrismCalcWatchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrismCalcWatchProvider()) { entry in
            PrismCalcWatchWidgetView(entry: entry)
        }
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
        .configurationDisplayName("prismCalc")
        .description("Quick access to your last calculation.")
    }
}

private struct PrismCalcWatchWidgetView: View {
    let entry: PrismCalcWatchEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            Text(entry.lastResult)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .containerBackground(.fill.tertiary, for: .widget)
        case .accessoryInline:
            Text("Calc \(entry.lastResult)")
                .font(.system(.caption, design: .rounded))
                .containerBackground(.clear, for: .widget)
        default:
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.lastResult)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                if !entry.lastExpression.isEmpty {
                    Text(entry.lastExpression)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            }
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
#endif
