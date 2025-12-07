import SwiftUI
import SwiftData
import TipKit

/// History view showing past calculations with iOS 18 zoom transitions
public struct HistoryView: View {
    @State private var entries: [HistoryEntry] = []
    @State private var selectedType: CalculationType?
    @State private var showClearConfirm = false
    @State private var showPaywall = false

    // iOS 18 zoom transition support
    @Namespace private var historyNamespace
    @State private var selectedEntry: HistoryEntry?

    private let addWidgetTip = AddWidgetTip()
    private var storeKit: StoreKitManager { StoreKitManager.shared }

    // Free tier limit
    private let freeLimit = 10

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: GlassTheme.spacingMedium) {
                    // Header with filter and clear
                    headerSection

                    // Widget tip
                    TipView(addWidgetTip)
                        .tipBackground(Color.clear)

                    // Filter chips
                    filterSection

                    // History entries
                    if filteredEntries.isEmpty {
                        emptyState
                    } else {
                        entriesList
                    }
                }
                .padding()
            }
            .onAppear {
                loadHistory()
            }
            .confirmationDialog(
                "Clear History",
                isPresented: $showClearConfirm,
                titleVisibility: .visible
            ) {
                Button("Clear All", role: .destructive) {
                    clearHistory()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all calculation history.")
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
        var filtered: [HistoryEntry]
        if let selectedType {
            filtered = entries.filter { $0.type == selectedType }
        } else {
            filtered = entries
        }

        // Limit to 10 most recent for free users
        if !storeKit.isPro {
            return Array(filtered.prefix(freeLimit))
        }
        return filtered
    }

    private var hasMoreThanFree: Bool {
        entries.count > freeLimit && !storeKit.isPro
    }

    // MARK: - Header

    @MainActor
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                Text("History")
                    .font(GlassTheme.titleFont)
                    .foregroundStyle(GlassTheme.text)

                Text("\(entries.count) calculations")
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
                            Circle()
                                .fill(.ultraThinMaterial)
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
                .scrollTransition(.interactive) { content, phase in
                    content.opacity(phase.isIdentity ? 1 : 0.6)
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
                    .scrollTransition(.interactive) { content, phase in
                        content.opacity(phase.isIdentity ? 1 : 0.6)
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
                Capsule()
                    .fill(isSelected ? GlassTheme.primary : .clear)
                    .background(
                        Capsule()
                            .fill(.thinMaterial)
                    )
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedType)
    }

    // MARK: - Entries List

    @MainActor
    private var entriesList: some View {
        LazyVStack(spacing: GlassTheme.spacingSmall) {
            ForEach(filteredEntries) { entry in
                historyCard(entry)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.7)
                            .scaleEffect(phase.isIdentity ? 1 : 0.95)
                            .offset(y: phase.isIdentity ? 0 : phase.value * 15)
                    }
            }

            // Upgrade banner for free users with more than 10 items
            if hasMoreThanFree {
                upgradePromoBanner
            }
        }
    }

    @MainActor
    private func historyCard(_ entry: HistoryEntry) -> some View {
        GlassCard(material: .ultraThinMaterial, padding: GlassTheme.spacingSmall) {
            HStack(spacing: GlassTheme.spacingSmall) {
                // Type icon
                Image(systemName: entry.type.icon)
                    .font(.title3)
                    .foregroundStyle(GlassTheme.primary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(GlassTheme.primary.opacity(0.15))
                    )

                // Details
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.result)
                        .font(GlassTheme.headlineFont)
                        .foregroundStyle(GlassTheme.text)

                    Text(entry.details)
                        .font(GlassTheme.captionFont)
                        .foregroundStyle(GlassTheme.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                // Time
                Text(entry.relativeDate)
                    .font(.system(size: 11))
                    .foregroundStyle(GlassTheme.textTertiary)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                deleteEntry(entry)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        // iOS 18 zoom transition source
        .matchedTransitionSource(id: entry.id, in: historyNamespace)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(entry.type.rawValue): \(entry.result)")
        .accessibilityHint("Double tap to view details, swipe left to delete")
        .onTapGesture {
            selectedEntry = entry
        }
    }

    // MARK: - Upgrade Banner

    @MainActor
    private var upgradePromoBanner: some View {
        GlassCard(material: .thinMaterial) {
            VStack(spacing: GlassTheme.spacingMedium) {
                HStack {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [GlassTheme.primary, GlassTheme.secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                        Text("You have \(entries.count - freeLimit) more calculations")
                            .font(GlassTheme.headlineFont)
                            .foregroundStyle(GlassTheme.text)

                        Text("Upgrade to Pro for unlimited history")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                    }

                    Spacer()
                }

                Button {
                    showPaywall = true
                } label: {
                    Text("Upgrade to Pro")
                        .font(GlassTheme.headlineFont)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, GlassTheme.spacingSmall)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [GlassTheme.primary, GlassTheme.secondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(featureName: "Unlimited History", featureIcon: "clock.arrow.circlepath")
        }
    }

    // MARK: - Empty State

    @MainActor
    private var emptyState: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
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
        withAnimation {
            entries.removeAll { $0.id == entry.id }
        }
    }

    private func clearHistory() {
        HistoryService.shared.clearAll()
        withAnimation {
            entries.removeAll()
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
