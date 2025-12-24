import SwiftUI

enum WatchTheme {
    static let backgroundGradient: [Color] = [
        Color(red: 0.10, green: 0.20, blue: 0.45),
        Color(red: 0.20, green: 0.30, blue: 0.60),
        Color(red: 0.08, green: 0.12, blue: 0.28)
    ]

    static let accent = Color(red: 0.45, green: 0.55, blue: 0.95)
    static let text = Color.white
    static let textSecondary = Color.white.opacity(0.7)
}
