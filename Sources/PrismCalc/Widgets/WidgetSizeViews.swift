import SwiftUI
import WidgetKit

// MARK: - Small Widget View

struct SmallWidgetView: View {
    let entry: PrismCalcEntry

    var body: some View {
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
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    let entry: PrismCalcEntry

    var body: some View {
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
}

// MARK: - Large Widget View

struct LargeWidgetView: View {
    let entry: PrismCalcEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            headerSection

            // Last result hero
            resultSection

            // Quick action buttons row
            quickActionsRow

            Divider()

            // History list
            historySection

            Spacer()
        }
        .padding()
    }

    private var headerSection: some View {
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
    }

    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.lastResult)
                .font(.system(size: 36, weight: .medium, design: .rounded))

            Text(entry.lastExpression)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var quickActionsRow: some View {
        HStack(spacing: 8) {
            ForEach(
                [WidgetFeature.calculator, .tipCalculator, .billSplit, .unitConverter],
                id: \.rawValue
            ) { feature in
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
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            historyHeader

            ForEach(entry.recentHistory) { item in
                historyRow(item)
            }
        }
    }

    private var historyHeader: some View {
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
    }

    private func historyRow(_ item: PrismCalcEntry.HistoryItem) -> some View {
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
}
