import SwiftUI
#if os(iOS)
import UIKit
#endif

private extension View {
    @ViewBuilder
    func ifAvailableiOS17<Content: View>(_ transform: (Self) -> Content) -> some View {
        if #available(iOS 17.0, *) {
            transform(self)
        } else {
            self
        }
    }
}

/// Floating glass card with material background and subtle shadow
///
/// Usage:
/// ```swift
/// GlassCard {
///     Text("Content")
/// }
/// ```
public struct GlassCard<Content: View>: View {
    let content: Content
    var material: Material
    var cornerRadius: CGFloat
    var padding: CGFloat
    @Environment(\EnvironmentValues.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private var isIncreasedContrast: Bool {
        if #available(iOS 17.0, *) {
            return colorSchemeContrast == .increased
        } else {
            #if os(iOS)
            return UIAccessibility.isDarkerSystemColorsEnabled
            #else
            return false
            #endif
        }
    }

    public init(
        material: Material = .regular,
        cornerRadius: CGFloat = GlassTheme.cornerRadiusMedium,
        padding: CGFloat = GlassTheme.spacingMedium,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.material = material
        self.cornerRadius = cornerRadius
        self.padding = padding
    }

    public var body: some View {
        Group {
            content
                .padding(padding)
                .background(
                    GlassTheme.glassCardBackground(
                        cornerRadius: cornerRadius,
                        material: material,
                        reduceTransparency: reduceTransparency
                    )
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(
                                    GlassTheme.glassBorderGradient(
                                        reduceTransparency: reduceTransparency,
                                        increaseContrast: isIncreasedContrast
                                    ),
                                    lineWidth: GlassTheme.glassBorderLineWidth(
                                        reduceTransparency: reduceTransparency,
                                        increaseContrast: isIncreasedContrast
                                    )
                                )
                        )
                )
                .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 10, y: 5)
                .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacitySecondary), radius: 20, y: 10)
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

        GlassCard {
            VStack(spacing: 12) {
                Text("Glass Card")
                    .font(GlassTheme.titleFont)
                Text("With material background")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

