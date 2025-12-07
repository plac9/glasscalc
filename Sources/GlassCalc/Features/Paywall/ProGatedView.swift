import SwiftUI

/// Wrapper view that shows content or paywall based on Pro status
public struct ProGatedView<Content: View>: View {
    private var storeKit: StoreKitManager { StoreKitManager.shared }

    public let featureName: String
    public let featureIcon: String
    @ViewBuilder public let content: () -> Content

    public init(
        featureName: String,
        featureIcon: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.featureName = featureName
        self.featureIcon = featureIcon
        self.content = content
    }

    public var body: some View {
        Group {
            if storeKit.isPro {
                content()
            } else {
                PaywallView(featureName: featureName, featureIcon: featureIcon)
            }
        }
    }
}
