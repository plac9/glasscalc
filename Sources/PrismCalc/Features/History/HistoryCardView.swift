import SwiftUI

/// Individual history entry card with swipe actions and zoom transition support
public struct HistoryCardView: View {
    let entry: HistoryEntry
    let namespace: Namespace.ID
    let onDelete: (HistoryEntry) -> Void
    let onToggleLock: (HistoryEntry) -> Void
    let onSelect: (HistoryEntry) -> Void

    @ScaledMetric(relativeTo: .caption2) private var timeFontSize: CGFloat = 11
    @ScaledMetric(relativeTo: .caption2) private var noteIconSize: CGFloat = 10

    public init(
        entry: HistoryEntry,
        namespace: Namespace.ID,
        onDelete: @escaping (HistoryEntry) -> Void,
        onToggleLock: @escaping (HistoryEntry) -> Void,
        onSelect: @escaping (HistoryEntry) -> Void
    ) {
        self.entry = entry
        self.namespace = namespace
        self.onDelete = onDelete
        self.onToggleLock = onToggleLock
        self.onSelect = onSelect
    }

    public var body: some View {
        GlassCard(material: .ultraThinMaterial, padding: GlassTheme.spacingSmall) {
            HStack(spacing: GlassTheme.spacingSmall) {
                typeIcon
                entryDetails
                Spacer()
                timeAndLock
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: !entry.isLocked) {
            if !entry.isLocked {
                Button(role: .destructive) {
                    onDelete(entry)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                onToggleLock(entry)
            } label: {
                Label(
                    entry.isLocked ? "Unlock" : "Lock",
                    systemImage: entry.isLocked ? "lock.open.fill" : "lock.fill"
                )
            }
            .tint(entry.isLocked ? GlassTheme.warning : GlassTheme.primary)
        }
        .matchedTransitionSource(id: entry.id, in: namespace)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityHint(accessibilityHintText)
        .onTapGesture {
            onSelect(entry)
        }
    }

    // MARK: - Subviews

    @MainActor
    private var typeIcon: some View {
        Image(systemName: entry.type.icon)
            .font(.title3)
            .foregroundStyle(GlassTheme.primary)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(GlassTheme.primary.opacity(0.15))
            )
    }

    @MainActor
    private var entryDetails: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.result)
                .font(GlassTheme.headlineFont)
                .foregroundStyle(GlassTheme.text)

            Text(entry.details)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
                .lineLimit(1)

            if let note = entry.note, !note.isEmpty {
                noteRow(note)
            }
        }
    }

    @MainActor
    private func noteRow(_ note: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "note.text")
                .font(.system(size: noteIconSize))
            Text(note)
                .lineLimit(1)
        }
        .font(.system(size: timeFontSize))
        .foregroundStyle(GlassTheme.primary.opacity(0.8))
    }

    @MainActor
    private var timeAndLock: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(entry.relativeDate)
                .font(.system(size: timeFontSize))
                .foregroundStyle(GlassTheme.textTertiary)

            if entry.isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: noteIconSize))
                    .foregroundStyle(GlassTheme.primary)
            }
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabelText: String {
        "\(entry.type.rawValue): \(entry.result)" +
        "\(entry.isLocked ? ", locked" : "")" +
        "\(entry.note.map { ", note: \($0)" } ?? "")"
    }

    private var accessibilityHintText: String {
        "Double tap to view details, swipe left to delete" +
        "\(entry.isLocked ? " (locked)" : ""), swipe right to " +
        "\(entry.isLocked ? "unlock" : "lock")"
    }
}
