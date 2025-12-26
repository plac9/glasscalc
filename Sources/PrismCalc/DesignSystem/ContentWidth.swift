import SwiftUI

private struct PrismContentWidthModifier: ViewModifier {
    #if !os(macOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    func body(content: Content) -> some View {
        #if os(macOS)
        let maxWidth = GlassTheme.contentMaxWidthWide
        #else
        let maxWidth = horizontalSizeClass == .regular
            ? GlassTheme.contentMaxWidthWide
            : GlassTheme.contentMaxWidth
        #endif
        return content
            .frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}

struct AdaptiveColumns<Left: View, Right: View>: View {
    let isSplit: Bool
    let spacing: CGFloat
    let left: Left
    let right: Right

    init(
        isSplit: Bool,
        spacing: CGFloat,
        @ViewBuilder left: () -> Left,
        @ViewBuilder right: () -> Right
    ) {
        self.isSplit = isSplit
        self.spacing = spacing
        self.left = left()
        self.right = right()
    }

    var body: some View {
        if isSplit {
            HStack(alignment: .top, spacing: spacing) {
                left
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                right
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        } else {
            VStack(spacing: spacing) {
                left
                right
            }
        }
    }
}

public extension View {
    /// Constrain large-screen content width for iPadOS/macOS while keeping iPhone layout fluid.
    func prismContentMaxWidth() -> some View {
        modifier(PrismContentWidthModifier())
    }
}
