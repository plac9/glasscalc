import SwiftUI

public extension View {
    /// Constrain large-screen content width for iPadOS/macOS while keeping iPhone layout fluid.
    func prismContentMaxWidth() -> some View {
        #if os(macOS)
        let maxWidth = GlassTheme.contentMaxWidthWide
        #else
        let maxWidth = GlassTheme.contentMaxWidth
        #endif
        return frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}
