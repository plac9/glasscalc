import SwiftUI

/// Preview content for small widget in settings
struct SmallWidgetPreviewContent: View {
    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            header
            resultText
            expressionText
            quickActions
        }
        .frame(height: 100 * scale)
    }

    private var header: some View {
        HStack {
            Image(systemName: "equal.square.fill")
                .font(.caption)
                .foregroundStyle(.blue.gradient)
            Text("PrismCalc")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var resultText: some View {
        Text("42")
            .font(.system(size: 20, weight: .medium, design: .rounded))
    }

    private var expressionText: some View {
        Text("6 × 7")
            .font(.caption2)
            .foregroundStyle(.secondary)
    }

    private var quickActions: some View {
        HStack(spacing: 4) {
            actionCircle(icon: "dollarsign.circle")
            actionCircle(icon: "person.2")
        }
    }

    private func actionCircle(icon: String) -> some View {
        Circle()
            .fill(.blue.opacity(0.15))
            .frame(width: 18, height: 18)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundStyle(.blue)
            )
    }
}

/// Preview content for medium widget in settings
struct MediumWidgetPreviewContent: View {
    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1.0

    var body: some View {
        HStack {
            resultSection

            Divider()

            actionsGrid
        }
        .frame(height: 80 * scale)
    }

    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Image(systemName: "equal.square.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue.gradient)
                Text("Latest")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text("$23.60")
                .font(.system(size: 16, weight: .medium, design: .rounded))
            Text("$20 + 18% tip")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var actionsGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 4
        ) {
            ForEach(
                ["plus.forwardslash.minus", "dollarsign.circle", "person.2", "arrow.left.arrow.right"],
                id: \.self
            ) { icon in
                actionButton(icon: icon)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func actionButton(icon: String) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(.blue.opacity(0.1))
            .frame(height: 28)
            .overlay(
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(.blue)
            )
    }
}

/// Preview content for large widget in settings
struct LargeWidgetPreviewContent: View {
    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            header
            resultSection
            actionsRow
            Divider()
            historySection
        }
        .frame(height: 160 * scale)
    }

    private var header: some View {
        HStack {
            Image(systemName: "equal.square.fill")
                .font(.caption)
                .foregroundStyle(.blue.gradient)
            Text("PrismCalc")
                .font(.caption)
                .fontWeight(.medium)
            Spacer()
        }
    }

    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("$23.60")
                .font(.system(size: 18, weight: .medium, design: .rounded))
            Text("$20 + 18% tip")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var actionsRow: some View {
        HStack(spacing: 4) {
            ForEach(
                ["plus.forwardslash.minus", "dollarsign.circle", "person.2", "arrow.left.arrow.right"],
                id: \.self
            ) { icon in
                RoundedRectangle(cornerRadius: 6)
                    .fill(.blue.opacity(0.1))
                    .frame(height: 30)
                    .overlay(
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundStyle(.blue)
                    )
            }
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Recent History")
                .font(.caption2)
                .foregroundStyle(.secondary)

            historyRow
        }
    }

    private var historyRow: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(.blue.opacity(0.1))
                .frame(width: 16, height: 16)
                .overlay(
                    Image(systemName: "plus.forwardslash.minus")
                        .font(.system(size: 8))
                        .foregroundStyle(.blue)
                )
            VStack(alignment: .leading, spacing: 0) {
                Text("42")
                    .font(.caption2)
                    .fontWeight(.medium)
                Text("6 × 7")
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
