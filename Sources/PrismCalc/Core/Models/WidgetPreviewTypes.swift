import SwiftUI

/// Shared types for widget previews in WidgetSettingsView
/// These mirror the actual widget types but without WidgetKit dependencies

public struct WidgetPreviewEntry {
    public let date: Date
    public let lastResult: String
    public let lastExpression: String
    public let recentHistory: [HistoryItem]

    public struct HistoryItem {
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

    public static var sample: WidgetPreviewEntry {
        WidgetPreviewEntry(
            date: Date(),
            lastResult: "42",
            lastExpression: "6 × 7",
            recentHistory: [
                .init(type: "Calc", result: "42", details: "6 × 7", icon: "plus.forwardslash.minus"),
                .init(type: "Tip", result: "$23.60", details: "$20 + 18%", icon: "dollarsign.circle"),
                .init(type: "Split", result: "$15", details: "$60 ÷ 4", icon: "person.2")
            ]
        )
    }
}

/// Preview widget view for WidgetSettingsView (without WidgetKit dependency)
public struct WidgetPreviewView: View {
    public let entry: WidgetPreviewEntry
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public init(entry: WidgetPreviewEntry) {
        self.entry = entry
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.title2)
                    .foregroundStyle(GlassTheme.primary)

                Text("prismCalc")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(GlassTheme.textSecondary)
            }

            Spacer()

            Text(entry.lastResult)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundStyle(GlassTheme.text)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(entry.lastExpression)
                .font(.caption)
                .foregroundStyle(GlassTheme.textSecondary)

            if !entry.recentHistory.isEmpty {
                Divider()

                ForEach(Array(entry.recentHistory.prefix(3).enumerated()), id: \.offset) { _, item in
                    HStack(spacing: 8) {
                        Image(systemName: item.icon)
                            .font(.caption)
                            .foregroundStyle(GlassTheme.primary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.result)
                                .font(.caption)
                                .fontWeight(.medium)

                            Text(item.details)
                                .font(.caption2)
                                .foregroundStyle(GlassTheme.textSecondary)
                        }

                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            GlassTheme.glassCardBackground(
                cornerRadius: 16,
                material: .ultraThin,
                reduceTransparency: reduceTransparency
            )
        )
    }
}
