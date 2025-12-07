import SwiftUI

// MARK: - Cross-Platform Keyboard Support

extension View {
    /// Apply decimal keyboard type on iOS, no-op on macOS
    @ViewBuilder
    public func decimalKeyboard() -> some View {
        #if os(iOS)
        self.keyboardType(.decimalPad)
        #else
        self
        #endif
    }

    /// Apply number keyboard type on iOS, no-op on macOS
    @ViewBuilder
    public func numberKeyboard() -> some View {
        #if os(iOS)
        self.keyboardType(.numberPad)
        #else
        self
        #endif
    }
}

// MARK: - Conditional Modifier

extension View {
    /// Apply a modifier only when a condition is true
    @ViewBuilder
    public func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
