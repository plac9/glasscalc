import SwiftUI
import SwiftData
import TipKit

/// History view showing past calculations with iOS 18 zoom transitions
public struct HistoryView: View {
    @State private var entries: [HistoryEntry] = []
    @State private var selectedType: CalculationType?
    @State private var showClearConfirm = false
    @ScaledMetric(relativeTo: .title2) private var emptyIconSize: CGFloat = 48
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // iOS 18 zoom transition support
    @Namespace private var historyNamespace
    @State private var selectedEntry: HistoryEntry?

    private let addWidgetTip = AddWidgetTip()
    private var storeKit: StoreKitManager { StoreKitManager.shared }
    private let freeHistoryLimit = 10

    public init() {}

    public var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let isTwoColumn = horizontalSizeClass == .regular && proxy.size.width >= 820
                let columnSpacing = isTwoColumn ? GlassTheme.spacingMedium : GlassTheme.spacingLarge
                let sectionSpacing = isTwoColumn ? GlassTheme.spacingSmall : GlassTheme.spacingMedium
                let contentPadding = isTwoColumn ? GlassTheme.spacingLarge : GlassTheme.spacingMedium
                let listSpacing = isTwoColumn ? GlassTheme.spacingXS : GlassTheme.spacingSmall
                ScrollView {
                    AdaptiveColumns(isSplit: isTwoColumn, spacing: columnSpacing) {
                        VStack(spacing: sectionSpacing) {
                            // Header with filter and clear
                            headerSection

                            if !isPro {
                                freeTierNotice
                            }

                            // Widget tip with action handler
                            TipView(addWidgetTip) { action in
                                if action.id == "dismiss" {
                                    addWidgetTip.invalidate(reason: .actionPerformed)
                                }
                            }
                            .tipBackground(Color.clear)

                            // Filter chips
                            filterSection
                        }
                    } right: {
                        VStack(spacing: sectionSpacing) {
                            // History entries
                            if filteredEntries.isEmpty {
                                emptyState
                            } else {
                                entriesList(spacing: listSpacing)
                            }

                            if !isPro {
                                ProUpgradeSection()
                            }
                        }
                    }
                    .padding(contentPadding)
                    .prismContentMaxWidth()
                }
            }
            .onAppear {
                loadHistory()
            }
            .confirmationDialog(
                "Clear History",
                isPresented: $showClearConfirm,
                titleVisibility: .visible
            ) {
                Button("Clear Unlocked", role: .destructive) {
                    clearHistory()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                let lockedCount = entries.filter { $0.isLocked }.count
                if lockedCount > 0 {
                    Text("""
                        This will delete all unlocked history. \
                        \(lockedCount) locked \(lockedCount == 1 ? "entry" : "entries") will be preserved.
                        """)
                } else {
                    Text("This will permanently delete all calculation history.")
                }
            }
            // iOS 18 zoom navigation destination
            .navigationDestination(item: $selectedEntry) { entry in
                if #available(iOS 18.0, *) {
                    #if os(iOS)
                    HistoryDetailView(entry: entry)
                        .navigationTransition(.zoom(sourceID: entry.id, in: historyNamespace))
                    #else
                    HistoryDetailView(entry: entry)
                    #endif
                } else {
                    // Fallback for iOS 17 (shouldn't be needed as app requires iOS 18+)
                    Text("Detail view requires iOS 18+")
                }
            }
        }
    }

    // MARK: - Filtered Entries

    private var filteredEntries: [HistoryEntry] {
        let scopedEntries = visibleEntries
        var filtered: [HistoryEntry]
        if let selectedType {
            filtered = scopedEntries.filter { $0.type == selectedType }
        } else {
            filtered = scopedEntries
        }
        return filtered
    }

    // MARK: - Header

    @MainActor
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                Text("History")
                    .font(GlassTheme.titleFont)
                    .foregroundStyle(GlassTheme.text)

                Text(historyCountText)
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)
            }

            Spacer()

            if !entries.isEmpty {
                Button {
                    showClearConfirm = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(GlassTheme.error)
                        .frame(width: 44, height: 44)
                        .background(
                            GlassTheme.glassCircleBackground(
                                material: .ultraThin,
                                reduceTransparency: reduceTransparency
                            )
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear all history")
                .accessibilityHint("Permanently deletes all calculation history")
            }
        }
    }

    // MARK: - Filter

    @MainActor
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: GlassTheme.spacingSmall) {
                // All filter
                filterChip(label: "All", icon: "list.bullet", isSelected: selectedType == nil) {
                    selectedType = nil
                }
                .scrollTransition(.interactive) { [reduceMotionNow = reduceMotion] content, phase in
                    content.opacity(reduceMotionNow || phase.isIdentity ? 1 : 0.6)
                }

                // Type filters
                ForEach(CalculationType.allCases, id: \.rawValue) { type in
                    filterChip(
                        label: type.rawValue,
                        icon: type.icon,
                        isSelected: selectedType == type
                    ) {
                        selectedType = type
                    }
                    .scrollTransition(.interactive) { [reduceMotionNow = reduceMotion] content, phase in
                        content.opacity(reduceMotionNow || phase.isIdentity ? 1 : 0.6)
                    }
                }
            }
        }
    }

    @MainActor
    private func filterChip(
        label: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: GlassTheme.spacingXS) {
                Image(systemName: icon)
                    .font(.caption)

                Text(label)
                    .font(GlassTheme.captionFont)
            }
            .foregroundStyle(isSelected ? .white : GlassTheme.text)
            .padding(.horizontal, GlassTheme.spacingSmall)
            .padding(.vertical, GlassTheme.spacingXS)
            .background(
                GlassTheme.glassCapsuleBackground(
                    material: .thin,
                    reduceTransparency: reduceTransparency
                )
                .overlay(
                    Capsule()
                        .fill(GlassTheme.primary)
                        .opacity(isSelected ? 0.9 : 0)
                )
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedType)
    }

    // MARK: - Entries List

    @MainActor
    private func entriesList(spacing: CGFloat) -> some View {
        LazyVStack(spacing: spacing) {
            ForEach(filteredEntries) { entry in
                HistoryCardView(
                    entry: entry,
                    namespace: historyNamespace,
                    onDelete: deleteEntry,
                    onToggleLock: toggleLock,
                    onSelect: { selectedEntry = $0 },
                    allowsLocking: isPro
                )
                .scrollTransition { [reduceMotionNow = reduceMotion] content, phase in
                    content
                        .opacity(reduceMotionNow || phase.isIdentity ? 1 : 0.7)
                        .scaleEffect(reduceMotionNow || phase.isIdentity ? 1 : 0.95)
                        .offset(y: reduceMotionNow || phase.isIdentity ? 0 : phase.value * 15)
                }
            }
        }
    }

    @MainActor
    private var freeTierNotice: some View {
        GlassCard(material: .ultraThinMaterial) {
            VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                Text("Free History")
                    .font(GlassTheme.headlineFont)
                    .foregroundStyle(GlassTheme.text)
                Text("Showing the last \(freeHistoryLimit) entries. Upgrade for unlimited history and lock controls.")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var isPro: Bool {
        storeKit.isPro
    }

    private var visibleEntries: [HistoryEntry] {
        if isPro {
            return entries
        }
        return Array(entries.prefix(freeHistoryLimit))
    }

    private var historyCountText: String {
        if isPro {
            return "\(entries.count) calculations"
        }
        let count = min(entries.count, freeHistoryLimit)
        return "Last \(count) of \(freeHistoryLimit)"
    }

    // MARK: - Empty State

    @MainActor
    private var emptyState: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: emptyIconSize))
                .foregroundStyle(GlassTheme.textTertiary)

            Text("No History Yet")
                .font(GlassTheme.headlineFont)
                .foregroundStyle(GlassTheme.text)

            Text("Your calculations will appear here")
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, GlassTheme.spacingXL * 2)
    }

    // MARK: - Actions

    private func loadHistory() {
        entries = HistoryService.shared.fetchAll()
    }

    private func deleteEntry(_ entry: HistoryEntry) {
        HistoryService.shared.delete(entry)
        let reduceMotionSnapshot = reduceMotion
        if reduceMotionSnapshot {
            entries.removeAll { $0.id == entry.id }
        } else {
            withAnimation {
                entries.removeAll { $0.id == entry.id }
            }
        }
    }

    private func clearHistory() {
        // Only clear unlocked entries
        let unlockedEntries = entries.filter { !$0.isLocked }
        for entry in unlockedEntries {
            HistoryService.shared.delete(entry)
        }
        let reduceMotionSnapshot = reduceMotion
        if reduceMotionSnapshot {
            entries.removeAll { !$0.isLocked }
        } else {
            withAnimation {
                entries.removeAll { !$0.isLocked }
            }
        }
    }

    private func toggleLock(_ entry: HistoryEntry) {
        guard isPro else { return }
        entry.isLocked.toggle()
        HistoryService.shared.update(entry)
        let reduceMotionSnapshot = reduceMotion
        if reduceMotionSnapshot {
            // Force refresh to update UI
            loadHistory()
        } else {
            withAnimation {
                loadHistory()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: GlassTheme.auroraGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        HistoryView()
    }
}
