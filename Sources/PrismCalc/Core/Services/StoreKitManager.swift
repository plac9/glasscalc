import StoreKit
import SwiftUI
import Observation

/// StoreKit manager for PrismCalc Pro purchases
@Observable
@MainActor
public final class StoreKitManager {

    // MARK: - Singleton

    public static let shared = StoreKitManager()

    // MARK: - Product IDs

    public static let proProductID = "com.laclairtech.prismcalc.pro"

    // MARK: - State

    public private(set) var products: [Product] = []
    public private(set) var purchasedProductIDs: Set<String> = []
    public private(set) var isLoading: Bool = false
    public private(set) var errorMessage: String?

    // MARK: - Computed

    public var isPro: Bool {
        // Check debug flag for UI testing
        if UserDefaults.standard.bool(forKey: "debug_simulatePro") {
            return true
        }
        return purchasedProductIDs.contains(Self.proProductID)
    }

    public var proProduct: Product? {
        products.first { $0.id == Self.proProductID }
    }

    public var proPrice: String {
        proProduct?.displayPrice ?? "$2.99"
    }

    // MARK: - Init

    private init() {
        Task {
            await loadProducts()
            await updatePurchasedProducts()
            await listenForTransactions()
        }
    }

    // MARK: - Load Products

    public func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            products = try await Product.products(for: [Self.proProductID])
            Diagnostics.storeKit.info("Loaded products: \(self.products.map(\.id).joined(separator: ", "), privacy: .public)")
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            Diagnostics.storeKit.error("Failed to load products: \(error.localizedDescription, privacy: .public)")
        }

        isLoading = false
    }

    // MARK: - Purchase

    public func purchase() async throws {
        guard let product = proProduct else {
            throw StoreKitError.productNotFound
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            Diagnostics.storeKit.info("Starting purchase for product: \(product.id, privacy: .public)")
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                Diagnostics.storeKit.info("Purchase success, verifying transaction")
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updatePurchasedProducts()

            case .userCancelled:
                Diagnostics.storeKit.info("Purchase cancelled by user")
                break

            case .pending:
                Diagnostics.storeKit.info("Purchase pending approval")
                errorMessage = "Purchase is pending approval"

            @unknown default:
                Diagnostics.storeKit.notice("Unknown purchase result")
                errorMessage = "Unknown purchase result"
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            Diagnostics.storeKit.error("Purchase failed: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

    // MARK: - Restore Purchases

    public func restorePurchases() async {
        Diagnostics.storeKit.info("Restoring purchases")
        isLoading = true
        errorMessage = nil

        do {
            try await AppStore.sync()
            Diagnostics.storeKit.info("AppStore sync complete")
            await updatePurchasedProducts()

            if !isPro {
                errorMessage = "No previous purchases found"
            }
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
            Diagnostics.storeKit.error("Restore failed: \(error.localizedDescription, privacy: .public)")
        }

        isLoading = false
    }

    // MARK: - Private

    private func updatePurchasedProducts() async {
        var purchased: Set<String> = []

        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }

            if transaction.revocationDate == nil {
                purchased.insert(transaction.productID)
            }
        }

        purchasedProductIDs = purchased
        let productList = purchased.sorted().joined(separator: ", ")
        Diagnostics.storeKit.info("Updated entitlements: \(productList.isEmpty ? "none" : productList, privacy: .public)")
    }

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            guard case .verified(let transaction) = result else { continue }
            await transaction.finish()
            Diagnostics.storeKit.info("Transaction finished for product: \(transaction.productID, privacy: .public)")
            await updatePurchasedProducts()
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            Diagnostics.storeKit.error("Unverified StoreKit transaction")
            throw StoreKitError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - Errors

public enum StoreKitError: LocalizedError {
    case productNotFound
    case verificationFailed

    public var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Product not found"
        case .verificationFailed:
            return "Transaction verification failed"
        }
    }
}
