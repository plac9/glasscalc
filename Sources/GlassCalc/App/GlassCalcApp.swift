import SwiftUI

/// GlassCalc App Scene Configuration
///
/// A spectacular glassmorphic calculator for iOS.
/// Part of the LaClair Tech suite.
///
/// Usage in your iOS app:
/// ```swift
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         GlassCalcApp.scene
///     }
/// }
/// ```
@MainActor
public enum GlassCalcApp {
    /// The main app scene
    public static var scene: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
