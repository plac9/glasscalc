import SwiftUI

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

    public init(
        material: Material = .regularMaterial,
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
        content
            .padding(padding)
            .background(
                GlassTheme.glassCardBackground(cornerRadius: cornerRadius, material: material)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(GlassTheme.glassBorderGradient, lineWidth: GlassTheme.glassBorderLineWidth)
                    )
            )
            .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 10, y: 5)
            .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacitySecondary), radius: 20, y: 10)
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
