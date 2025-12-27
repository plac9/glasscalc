import SwiftUI
#if os(iOS)
import UIKit
#endif

#if os(macOS)
private struct MacBottomBarInsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var macBottomBarInset: CGFloat {
        get { self[MacBottomBarInsetKey.self] }
        set { self[MacBottomBarInsetKey.self] = newValue }
    }
}
#endif

#if os(macOS)
private enum MacLayout {
    static let contentSpacing: CGFloat = 6
    static let compactHorizontalPadding: CGFloat = 6
    static let expandedHorizontalPadding: CGFloat = 6
    static let compactWindowWidth: CGFloat = 320
    static let expandedWindowWidth: CGFloat = {
        let compactPaneWidth = compactWindowWidth - (compactHorizontalPadding * 2)
        return (compactPaneWidth * 2) + contentSpacing + (expandedHorizontalPadding * 2)
    }()
    static let wideThreshold: CGFloat = expandedWindowWidth - 1
    static let barInsetCompact: CGFloat = 52
    static let barInsetExpanded: CGFloat = 64
    static let minWindowHeight: CGFloat = 620
}

enum MacTabBarMode: String, CaseIterable, Identifiable {
    case always
    case autoHide

    var id: String { rawValue }

    var title: String {
        switch self {
        case .always:
            return "Always"
        case .autoHide:
            return "Auto-hide"
        }
    }

    var subtitle: String {
        switch self {
        case .always:
            return "Bottom bar always visible"
        case .autoHide:
            return "Hide after a short pause"
        }
    }
}
#endif

/// Main content view with iOS 18 floating tab bar and animated mesh gradient background
public struct ContentView: View {
    @State private var selectedTab: TabIdentifier = .calculator
    @AppStorage("tabCustomization") private var tabCustomization: TabViewCustomization
    @AppStorage("selectedTheme") private var selectedThemeName: String = GlassTheme.Theme.aurora.rawValue
    @AppStorage(AccessibilityTheme.highContrastKey) private var highContrastUI: Bool = false
    @AppStorage(MeshAnimationSettings.animationEnabledKey) private var meshAnimationEnabled: Bool = true
    @AppStorage(MeshAnimationSettings.reducedFrameRateKey) private var meshReducedFrameRate: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isLowPowerMode: Bool = ProcessInfo.processInfo.isLowPowerModeEnabled
    @State private var thermalState: ProcessInfo.ThermalState = ProcessInfo.processInfo.thermalState
    #if os(macOS)
    @AppStorage("macTabBarMode") private var macTabBarMode: MacTabBarMode = .always
    #endif
    @State private var didApplyDebugTab = false

    private static let debugSelectedTabKey = "debug_selectedTab"

    /// Current theme derived from stored name, forces re-render when changed
    private var currentTheme: GlassTheme.Theme {
        GlassTheme.Theme(rawValue: selectedThemeName) ?? .aurora
    }

    public init() {
        // Make TabView background transparent to show mesh gradient
        #if os(iOS) && !targetEnvironment(macCatalyst)
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }

    /// Tab identifiers for navigation
    /// Limited to 5 tabs to avoid system "More" overflow (which lacks themed background)
    public enum TabIdentifier: String, CaseIterable, Hashable {
        case calculator = "Calculator"
        case tip = "Tip"
        case split = "Split"
        case discount = "Discount"
        case more = "More"

        var icon: String {
            switch self {
            case .calculator: return "plus.forwardslash.minus"
            case .tip: return "dollarsign.circle"
            case .split: return "person.2"
            case .discount: return "tag"
            case .more: return "ellipsis.circle"
            }
        }

        var isPro: Bool {
            switch self {
            case .calculator, .more: return false
            case .tip, .discount, .split: return true
            }
        }
    }

    public var body: some View {
        ZStack {
            ThemedMeshBackground(
                animated: shouldAnimateMesh,
                frameInterval: meshFrameInterval
            )
            .ignoresSafeArea()

            tabContent
        }
            // Force full re-render when theme changes by using theme as view identity
            .id("\(currentTheme.rawValue)-\(highContrastUI)")
            .onAppear {
                applyDebugSelectedTabIfNeeded()
                syncTheme()
            }
            .onChange(of: selectedThemeName) { _, _ in
                syncTheme()
            }
            #if os(iOS)
            .onReceive(NotificationCenter.default.publisher(for: .NSProcessInfoPowerStateDidChange)) { _ in
                isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
            }
            #endif
            .onReceive(NotificationCenter.default.publisher(for: ProcessInfo.thermalStateDidChangeNotification)) { _ in
                thermalState = ProcessInfo.processInfo.thermalState
            }
    }

    /// Sync the static GlassTheme.currentTheme with stored value
    @MainActor
    private func syncTheme() {
        GlassTheme.currentTheme = currentTheme
    }

    private var shouldAnimateMesh: Bool {
        guard meshAnimationEnabled else { return false }
        guard !reduceMotion else { return false }
        guard scenePhase == .active else { return false }
        if isLowPowerMode { return false }
        switch thermalState {
        case .serious, .critical:
            return false
        default:
            return true
        }
    }

    private var meshFrameInterval: Double {
        let useReducedRate = meshReducedFrameRate || thermalState == .fair
        return useReducedRate ? (1.0 / 15.0) : (1.0 / 30.0)
    }

    /// Tab content using iOS 18's new Tab API
    /// Limited to 5 tabs to fit on iPhone tab bar without system "More" overflow
    /// Order: Calculator → Pro features (Tip, Split, Discount) → More (Convert, History, Settings)
    @ViewBuilder
    private var tabContent: some View {
        #if os(macOS)
        macTabContent
        #elseif os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            baseTabView
                .tabViewStyle(.sidebarAdaptable)
        } else {
            baseTabView
        }
        #else
        baseTabView
        #endif
    }

    private var baseTabView: some View {
        TabView(selection: $selectedTab) {
            // Calculator - primary feature (locked, cannot be moved or hidden)
            Tab(value: .calculator) {
                ThemedContent(includeBackground: false) {
                    CalculatorView()
                }
            } label: {
                tabLabel(title: "Calculator", systemImage: TabIdentifier.calculator.icon)
            }
            .customizationID("tab.calculator")
            #if os(iOS)
            .customizationBehavior(.disabled, for: .sidebar, .tabBar)
            #endif
            .accessibilityIdentifier("tab-calculator")

            // Tip - Pro feature (most common after basic calc)
            Tab(value: .tip) {
                ThemedContent(includeBackground: false) {
                    ProGatedView(featureName: "Tip Calculator", featureIcon: TabIdentifier.tip.icon) {
                        TipCalculatorView()
                    }
                }
            } label: {
                tabLabel(title: "Tip", systemImage: TabIdentifier.tip.icon)
            }
            .customizationID("tab.tip")
            .accessibilityIdentifier("tab-tip")

            // Split - Pro feature (common dining scenario)
            Tab(value: .split) {
                ThemedContent(includeBackground: false) {
                    ProGatedView(featureName: "Split Bill", featureIcon: TabIdentifier.split.icon) {
                        SplitBillView()
                    }
                }
            } label: {
                tabLabel(title: "Split", systemImage: TabIdentifier.split.icon)
            }
            .customizationID("tab.split")
            .accessibilityIdentifier("tab-split")

            // Discount - Pro feature
            Tab(value: .discount) {
                ThemedContent(includeBackground: false) {
                    ProGatedView(featureName: "Discount Calculator", featureIcon: TabIdentifier.discount.icon) {
                        DiscountCalculatorView()
                    }
                }
            } label: {
                tabLabel(title: "Discount", systemImage: TabIdentifier.discount.icon)
            }
            .customizationID("tab.discount")
            .accessibilityIdentifier("tab-discount")

            // More - contains Convert, History, Settings with themed navigation
            Tab(value: .more) {
                ThemedContent(includeBackground: false) {
                    MoreView()
                }
            } label: {
                tabLabel(title: "More", systemImage: TabIdentifier.more.icon)
            }
            .customizationID("tab.more")
            .accessibilityIdentifier("tab-more")
        }
        .tabViewCustomization($tabCustomization)
        #if os(iOS)
        .toolbarBackgroundVisibility(.hidden, for: .tabBar)
        #endif
        .tint(GlassTheme.primary)
        .sensoryFeedback(.selection, trigger: selectedTab)
    }

    @ViewBuilder
    private func tabLabel(title: String, systemImage: String) -> some View {
        #if os(macOS)
        Image(systemName: systemImage)
            .accessibilityLabel(Text(title))
            .help(title)
        #else
        Label(title, systemImage: systemImage)
        #endif
    }

    #if os(macOS)
    private var macTabContent: some View {
        MacTabBarContainer(
            selectedTab: $selectedTab,
            mode: $macTabBarMode
        ) {
            contentForTab(selectedTab)
        }
    }
    #endif

    @ViewBuilder
    private func contentForTab(_ tab: TabIdentifier) -> some View {
        switch tab {
        case .calculator:
            #if os(macOS)
            ThemedContent(includeBackground: false) {
                MacCalculatorSplitView()
            }
            #else
            ThemedContent(includeBackground: false) {
                CalculatorView()
            }
            #endif
        case .tip:
            ThemedContent(includeBackground: false) {
                ProGatedView(featureName: "Tip Calculator", featureIcon: TabIdentifier.tip.icon) {
                    TipCalculatorView()
                }
            }
        case .split:
            ThemedContent(includeBackground: false) {
                ProGatedView(featureName: "Split Bill", featureIcon: TabIdentifier.split.icon) {
                    SplitBillView()
                }
            }
        case .discount:
            ThemedContent(includeBackground: false) {
                ProGatedView(featureName: "Discount Calculator", featureIcon: TabIdentifier.discount.icon) {
                    DiscountCalculatorView()
                }
            }
        case .more:
            ThemedContent(includeBackground: false) {
                MoreView()
            }
        }
    }

    private func applyDebugSelectedTabIfNeeded() {
        guard !didApplyDebugTab else { return }
        didApplyDebugTab = true

        if let tabName = UserDefaults.standard.string(forKey: Self.debugSelectedTabKey),
           let tab = TabIdentifier(rawValue: tabName) {
            selectedTab = tab
        }
        UserDefaults.standard.removeObject(forKey: Self.debugSelectedTabKey)
    }
}

#if os(macOS)
private struct MacTabBarContainer<Content: View>: View {
    @Binding var selectedTab: ContentView.TabIdentifier
    @Binding var mode: MacTabBarMode
    let content: Content
    @State private var isTabBarVisible = true
    @State private var hideWorkItem: DispatchWorkItem?

    init(
        selectedTab: Binding<ContentView.TabIdentifier>,
        mode: Binding<MacTabBarMode>,
        @ViewBuilder content: () -> Content
    ) {
        self._selectedTab = selectedTab
        self._mode = mode
        self.content = content()
    }

    var body: some View {
        GeometryReader { proxy in
            let isExpanded = proxy.size.width >= MacLayout.wideThreshold
            content
                .environment(\.macBottomBarInset, barInset(for: isExpanded))
                .onAppear {
                    updateVisibilityForMode()
                }
                .onChange(of: mode) { _, _ in
                    updateVisibilityForMode()
                }
                .onHover { hovering in
                    if hovering {
                        showTabBar()
                    }
                }
                .onTapGesture {
                    showTabBar()
                }
                .overlay(alignment: .bottom) {
                    MacTabBar(selectedTab: $selectedTab, isExpanded: isExpanded)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 8)
                        .opacity(isTabBarVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.2), value: isTabBarVisible)
                        .allowsHitTesting(isTabBarVisible)
                }
        }
    }

    private func barInset(for isExpanded: Bool) -> CGFloat {
        isExpanded ? MacLayout.barInsetExpanded : MacLayout.barInsetCompact
    }

    private func updateVisibilityForMode() {
        hideWorkItem?.cancel()
        switch mode {
        case .always:
            isTabBarVisible = true
        case .autoHide:
            showTabBar()
        }
    }

    private func showTabBar() {
        guard mode == .autoHide else {
            isTabBarVisible = true
            return
        }
        isTabBarVisible = true
        hideWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.2)) {
                isTabBarVisible = false
            }
        }
        hideWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: workItem)
    }
}

private struct MacTabBar: View {
    @Binding var selectedTab: ContentView.TabIdentifier
    let isExpanded: Bool
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @State private var hoveredTab: ContentView.TabIdentifier?

    private var isIncreasedContrast: Bool {
        if #available(macOS 14.0, *) {
            return colorSchemeContrast == .increased
        } else {
            return false
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            if !isExpanded, let hoveredTab {
                MacTabTooltip(title: hoveredTab.rawValue)
            }

            HStack(spacing: isExpanded ? 10 : 8) {
                ForEach(ContentView.TabIdentifier.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        tabButtonContent(for: tab)
                    }
                    .buttonStyle(.plain)
                    .background(selectionBackground(for: tab))
                    .clipShape(Capsule())
                    .help(tab.rawValue)
                    .accessibilityLabel(tab.rawValue)
                    .onHover { hovering in
                        hoveredTab = hovering ? tab : nil
                    }
                }
            }
            .padding(.vertical, isExpanded ? 8 : 7)
            .padding(.horizontal, isExpanded ? 12 : 10)
            .background(
                GlassTheme.glassCapsuleBackground(material: .regularMaterial, reduceTransparency: reduceTransparency)
                    .overlay(
                        Capsule()
                            .fill(Color.white.opacity(reduceTransparency ? 0.18 : 0.1))
                    )
                    .overlay(
                        Capsule()
                            .strokeBorder(
                                GlassTheme.glassBorderGradient(
                                    reduceTransparency: reduceTransparency,
                                    increaseContrast: isIncreasedContrast
                                ),
                                lineWidth: GlassTheme.glassBorderLineWidth(
                                    reduceTransparency: reduceTransparency,
                                    increaseContrast: isIncreasedContrast
                                )
                            )
                            .blendMode(GlassTheme.glassBorderBlendMode(for: colorScheme))
                    )
            )
            .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private func selectionBackground(for tab: ContentView.TabIdentifier) -> some View {
        if selectedTab == tab {
            Capsule()
                .fill(GlassTheme.primary.opacity(reduceTransparency ? 0.94 : 0.9))
        } else {
            Capsule()
                .fill(Color.white.opacity(reduceTransparency ? 0.42 : 0.3))
        }
    }

    private func iconColor(for tab: ContentView.TabIdentifier) -> Color {
        if selectedTab == tab {
            return Color.white
        }
        if isIncreasedContrast {
            return colorScheme == .dark ? Color.white : Color.black
        }
        return colorScheme == .dark
            ? Color.white.opacity(0.97)
            : Color.black.opacity(0.9)
    }

    private func iconShadowColor(for tab: ContentView.TabIdentifier) -> Color {
        let base = colorScheme == .dark ? Color.black : Color.black
        return base.opacity(selectedTab == tab ? 0.45 : 0.35)
    }

    @ViewBuilder
    private func selectionIndicator(for tab: ContentView.TabIdentifier) -> some View {
        if differentiateWithoutColor && selectedTab == tab {
            Circle()
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                .padding(3)
        }
    }

    @ViewBuilder
    private func tabButtonContent(for tab: ContentView.TabIdentifier) -> some View {
        if isExpanded {
            Label(tab.rawValue, systemImage: tab.icon)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(iconColor(for: tab))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .shadow(color: iconShadowColor(for: tab), radius: 1, y: 1)
        } else {
            Image(systemName: tab.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(iconColor(for: tab))
                .frame(minWidth: 34, minHeight: 30)
                .contentShape(Rectangle())
                .overlay(selectionIndicator(for: tab))
                .shadow(color: iconShadowColor(for: tab), radius: 1.5, y: 1)
        }
    }
}

private struct MacTabTooltip: View {
    let title: String
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme

    private var isIncreasedContrast: Bool {
        if #available(macOS 14.0, *) {
            return colorSchemeContrast == .increased
        } else {
            return false
        }
    }

    var body: some View {
        Text(title)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .foregroundStyle(GlassTheme.text)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                GlassTheme.glassCapsuleBackground(material: .regularMaterial, reduceTransparency: reduceTransparency)
                    .overlay(
                        Capsule()
                            .strokeBorder(
                                GlassTheme.glassBorderGradient(
                                    reduceTransparency: reduceTransparency,
                                    increaseContrast: isIncreasedContrast
                                ),
                                lineWidth: GlassTheme.glassBorderLineWidth(
                                    reduceTransparency: reduceTransparency,
                                    increaseContrast: isIncreasedContrast
                                )
                            )
                            .blendMode(GlassTheme.glassBorderBlendMode(for: colorScheme))
                    )
            )
            .clipShape(Capsule())
    }
}

private struct MacCalculatorSplitView: View {
    @AppStorage("macHistoryPanelVisible") private var showHistoryPanel = false
    @State private var isHoveringEdge = false

    var body: some View {
        GeometryReader { proxy in
            let isWide = proxy.size.width >= MacLayout.wideThreshold
            let horizontalPadding: CGFloat = isWide ? MacLayout.expandedHorizontalPadding : MacLayout.compactHorizontalPadding
            let availableWidth = max(0, proxy.size.width - (horizontalPadding * 2))
            let showsHistory = isWide && showHistoryPanel
            let spacing = showsHistory ? MacLayout.contentSpacing : 0
            let paneWidth = showsHistory
                ? max(0, (availableWidth - spacing) / 2)
                : availableWidth

            HStack(alignment: .top, spacing: showsHistory ? spacing : 0) {
                CalculatorView()
                    .frame(width: paneWidth, alignment: .topLeading)
                    .layoutPriority(1)

                if showsHistory {
                    MacHistoryPanel()
                        .frame(width: paneWidth, alignment: .topLeading)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.horizontal, horizontalPadding)
            .animation(.easeInOut(duration: 0.25), value: showsHistory)
            .overlay(alignment: .trailing) {
                if isHoveringEdge || showHistoryPanel {
                    HistoryPanelToggle(isVisible: $showHistoryPanel)
                        .padding(.trailing, 4)
                        .transition(.opacity)
                }
            }
            .overlay(alignment: .trailing) {
                Color.clear
                    .frame(width: 24)
                    .contentShape(Rectangle())
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isHoveringEdge = hovering
                        }
                    }
            }
        }
        .background(
            MacWindowSnapper(
                showHistoryPanel: $showHistoryPanel,
                compactWidth: MacLayout.compactWindowWidth,
                expandedWidth: MacLayout.expandedWindowWidth,
                minHeight: MacLayout.minWindowHeight
            )
        )
    }
}

private struct MacHistoryPanel: View {
    @State private var entries: [HistoryEntry] = []
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    private let maxEntries = 10

    var body: some View {
        GeometryReader { proxy in
            let headerHeight: CGFloat = 28
            let headerSpacing: CGFloat = GlassTheme.spacingSmall
            let rowSpacing: CGFloat = GlassTheme.spacingXS
            let contentPadding: CGFloat = GlassTheme.spacingMedium
            let availableHeight = max(
                0,
                proxy.size.height - (contentPadding * 2) - headerHeight - headerSpacing - (rowSpacing * CGFloat(maxEntries - 1))
            )
            let rowHeight = max(18, availableHeight / CGFloat(maxEntries))

            GlassCard(
                material: .thinMaterial,
                cornerRadius: GlassTheme.cornerRadiusLarge,
                padding: 0
            ) {
                VStack(alignment: .leading, spacing: headerSpacing) {
                    HStack {
                        Text("History")
                            .font(GlassTheme.titleFont)
                            .foregroundStyle(GlassTheme.text)

                        Spacer()

                        Text("Last \(maxEntries)")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                    }
                    .frame(height: headerHeight)

                    if visibleEntries.isEmpty {
                        VStack(spacing: GlassTheme.spacingSmall) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 20))
                                .foregroundStyle(GlassTheme.textTertiary)
                            Text("No history yet")
                                .font(GlassTheme.captionFont)
                                .foregroundStyle(GlassTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        VStack(spacing: rowSpacing) {
                            ForEach(visibleEntries) { entry in
                                MacHistoryRow(
                                    entry: entry,
                                    reduceTransparency: reduceTransparency,
                                    rowHeight: rowHeight
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
                .padding(contentPadding)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .onAppear {
                loadEntries()
            }
            .onReceive(NotificationCenter.default.publisher(for: HistoryService.didUpdateNotification)) { _ in
                loadEntries()
            }
        }
    }

    private var visibleEntries: [HistoryEntry] {
        Array(entries.prefix(maxEntries))
    }

    private func loadEntries() {
        entries = HistoryService.shared.fetchRecent(limit: maxEntries)
    }
}

private struct MacHistoryRow: View {
    let entry: HistoryEntry
    let reduceTransparency: Bool
    let rowHeight: CGFloat

    var body: some View {
        let titleSize = max(10, min(13, rowHeight * 0.38))
        let detailSize = max(9, min(11, rowHeight * 0.3))

        HStack(spacing: 10) {
            Image(systemName: entry.type.icon)
                .font(.system(size: max(12, rowHeight * 0.34), weight: .semibold))
                .foregroundStyle(GlassTheme.primary)
                .frame(width: max(24, rowHeight * 0.8), height: max(24, rowHeight * 0.8))
                .background(
                    Circle()
                        .fill(GlassTheme.primary.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.result)
                    .font(.system(size: titleSize, weight: .semibold))
                    .foregroundStyle(GlassTheme.text)
                    .lineLimit(1)

                Text(entry.details)
                    .font(.system(size: detailSize, weight: .regular))
                    .foregroundStyle(GlassTheme.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(entry.relativeDate)
                .font(.system(size: max(9, min(10, rowHeight * 0.26)), weight: .medium))
                .foregroundStyle(GlassTheme.textTertiary)
        }
        .padding(.horizontal, 10)
        .frame(height: rowHeight)
        .background(
            GlassTheme.glassCardBackground(
                cornerRadius: 12,
                material: .ultraThinMaterial,
                reduceTransparency: reduceTransparency
            )
        )
    }
}

private struct HistoryPanelToggle: View {
    @Binding var isVisible: Bool
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme

    private var isIncreasedContrast: Bool {
        if #available(macOS 14.0, *) {
            return colorSchemeContrast == .increased
        } else {
            return false
        }
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                isVisible.toggle()
            }
        } label: {
            Image(systemName: isVisible ? "chevron.right" : "chevron.left")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(GlassTheme.text)
                .frame(width: 24, height: 40)
                .background(
                    GlassTheme.glassCapsuleBackground(material: .thinMaterial, reduceTransparency: reduceTransparency)
                        .overlay(
                            Capsule()
                                .strokeBorder(
                                    GlassTheme.glassBorderGradient(
                                        reduceTransparency: reduceTransparency,
                                        increaseContrast: isIncreasedContrast
                                    ),
                                    lineWidth: GlassTheme.glassBorderLineWidth(
                                        reduceTransparency: reduceTransparency,
                                        increaseContrast: isIncreasedContrast
                                    )
                                )
                                .blendMode(GlassTheme.glassBorderBlendMode(for: colorScheme))
                        )
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isVisible ? "Hide history panel" : "Show history panel")
    }
}

private struct MacWindowSnapper: NSViewRepresentable {
    @Binding var showHistoryPanel: Bool
    let compactWidth: CGFloat
    let expandedWidth: CGFloat
    let minHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(
            showHistoryPanel: $showHistoryPanel,
            compactWidth: compactWidth,
            expandedWidth: expandedWidth,
            minHeight: minHeight
        )
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            context.coordinator.attach(to: view.window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.update(
            showHistoryPanel: $showHistoryPanel,
            compactWidth: compactWidth,
            expandedWidth: expandedWidth,
            minHeight: minHeight
        )
        DispatchQueue.main.async {
            context.coordinator.attach(to: nsView.window)
            context.coordinator.syncHistoryState()
        }
    }

    @MainActor
    final class Coordinator: NSObject, NSWindowDelegate {
        private var showHistoryPanel: Binding<Bool>
        private var compactWidth: CGFloat
        private var expandedWidth: CGFloat
        private var minHeight: CGFloat
        private weak var window: NSWindow?
        private var isSnapping = false
        private var lastShowHistoryPanel: Bool?

        init(
            showHistoryPanel: Binding<Bool>,
            compactWidth: CGFloat,
            expandedWidth: CGFloat,
            minHeight: CGFloat
        ) {
            self.showHistoryPanel = showHistoryPanel
            self.compactWidth = compactWidth
            self.expandedWidth = expandedWidth
            self.minHeight = minHeight
        }

        func update(
            showHistoryPanel: Binding<Bool>,
            compactWidth: CGFloat,
            expandedWidth: CGFloat,
            minHeight: CGFloat
        ) {
            self.showHistoryPanel = showHistoryPanel
            self.compactWidth = compactWidth
            self.expandedWidth = expandedWidth
            self.minHeight = minHeight
        }

        func attach(to window: NSWindow?) {
            guard let window else { return }
            if self.window !== window {
                window.delegate = self
                self.window = window
                configureWindow()
            }
        }

        func configureWindow() {
            guard let window else { return }
            let minContentSize = NSSize(width: compactWidth, height: minHeight)
            let maxContentSize = NSSize(width: expandedWidth, height: .greatestFiniteMagnitude)
            window.contentMinSize = minContentSize
            window.contentMaxSize = maxContentSize
            let minFrameSize = window.frameRect(forContentRect: NSRect(origin: .zero, size: minContentSize)).size
            let maxFrameSize = window.frameRect(
                forContentRect: NSRect(origin: .zero, size: NSSize(width: maxContentSize.width, height: minHeight))
            ).size
            window.minSize = minFrameSize
            window.maxSize = NSSize(width: maxFrameSize.width, height: .greatestFiniteMagnitude)
            window.contentResizeIncrements = NSSize(width: max(1, expandedWidth - compactWidth), height: 1)
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            window.toolbarStyle = .unifiedCompact
            snapToCurrentState(animated: false)
        }

        func syncHistoryState() {
            let current = showHistoryPanel.wrappedValue
            let shouldAnimate = lastShowHistoryPanel != nil && lastShowHistoryPanel != current
            lastShowHistoryPanel = current
            snapToCurrentState(animated: shouldAnimate)
        }

        func snapToCurrentState(animated: Bool) {
            guard let window else { return }
            let targetWidth = showHistoryPanel.wrappedValue ? expandedWidth : compactWidth
            let currentHeight = max(window.contentLayoutRect.height, minHeight)
            let targetSize = NSSize(width: targetWidth, height: currentHeight)
            guard window.contentLayoutRect.size != targetSize else { return }
            isSnapping = true
            if animated {
                window.animator().setContentSize(targetSize)
            } else {
                window.setContentSize(targetSize)
            }
            isSnapping = false
        }

        func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
            if isSnapping { return frameSize }
            let contentRect = sender.contentRect(forFrameRect: NSRect(origin: .zero, size: frameSize))
            let targetContentWidth = showHistoryPanel.wrappedValue ? expandedWidth : compactWidth
            let targetContentHeight = max(contentRect.height, minHeight)
            let targetFrame = sender.frameRect(forContentRect: NSRect(origin: .zero, size: NSSize(width: targetContentWidth, height: targetContentHeight)))
            return targetFrame.size
        }

        func windowDidEndLiveResize(_ notification: Notification) {
            snapToCurrentState(animated: true)
        }

        func windowDidResize(_ notification: Notification) {
            guard let window else { return }
            if isSnapping { return }
            let width = window.contentLayoutRect.width
            let targetWidth = showHistoryPanel.wrappedValue ? expandedWidth : compactWidth
            if width != targetWidth {
                snapToCurrentState(animated: false)
            }
        }

    }
}
#endif

// MARK: - Themed Content Wrapper

/// Wraps content with the themed mesh gradient background
struct ThemedContent<Content: View>: View {
    let includeBackground: Bool
    @ViewBuilder let content: () -> Content
    #if os(macOS)
    @Environment(\.macBottomBarInset) private var macBottomBarInset
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme
    #endif

    init(includeBackground: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.includeBackground = includeBackground
        self.content = content
    }

    var body: some View {
        ZStack {
            if includeBackground {
                ThemedMeshBackground()
                    .ignoresSafeArea()
            }
            content()
                #if os(macOS)
                .padding(.bottom, macBottomBarInset)
                #endif
        }
        #if os(macOS)
        .overlay(macWindowBorder)
        #endif
    }

    #if os(macOS)
    private var macWindowBorder: some View {
        RoundedRectangle(cornerRadius: 18)
            .strokeBorder(
                GlassTheme.glassBorderGradient(
                    reduceTransparency: reduceTransparency,
                    increaseContrast: isIncreasedContrast
                ),
                lineWidth: 2.5
            )
            .blendMode(GlassTheme.glassBorderBlendMode(for: colorScheme))
            .padding(1)
            .allowsHitTesting(false)
    }

    private var isIncreasedContrast: Bool {
        if #available(macOS 14.0, *) {
            return colorSchemeContrast == .increased
        } else {
            return false
        }
    }
    #endif
}

// MARK: - Preview

#Preview {
    ContentView()
}
