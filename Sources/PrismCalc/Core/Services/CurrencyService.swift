import Foundation

/// Currency conversion service using Frankfurter API (free, ECB data)
public actor CurrencyService {
    public static let shared = CurrencyService()

    private let baseURL = "https://api.frankfurter.app"
    private var cachedRates: [String: Double] = [:]
    private var lastFetch: Date?
    private let cacheValidityMinutes: Double = 60

    private init() {}

    // MARK: - Public API

    /// Fetch latest exchange rates for a base currency
    public func fetchRates(base: String = "USD") async throws -> [String: Double] {
        // Return cached rates if still valid
        if let lastFetch, let cached = getCachedRates(base: base),
           Date().timeIntervalSince(lastFetch) < cacheValidityMinutes * 60 {
            return cached
        }

        let url = URL(string: "\(baseURL)/latest?from=\(base)")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw CurrencyError.networkError
        }

        let result = try JSONDecoder().decode(FrankfurterResponse.self, from: data)
        cachedRates = result.rates
        lastFetch = Date()

        return result.rates
    }

    /// Convert amount from one currency to another
    public func convert(
        amount: Double,
        from sourceCurrency: String,
        to targetCurrency: String
    ) async throws -> Double {
        // Same currency, no conversion needed
        if sourceCurrency == targetCurrency {
            return amount
        }

        let rates = try await fetchRates(base: sourceCurrency)

        guard let rate = rates[targetCurrency] else {
            throw CurrencyError.unsupportedCurrency
        }

        return amount * rate
    }

    /// Get list of available currencies
    public func availableCurrencies() async throws -> [Currency] {
        let url = URL(string: "\(baseURL)/currencies")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw CurrencyError.networkError
        }

        let currencies = try JSONDecoder().decode([String: String].self, from: data)

        return currencies.map { Currency(code: $0.key, name: $0.value) }
            .sorted { $0.code < $1.code }
    }

    // MARK: - Private

    private func getCachedRates(base: String) -> [String: Double]? {
        // Simple cache - in production would key by base currency
        cachedRates.isEmpty ? nil : cachedRates
    }
}

// MARK: - Models

public struct Currency: Identifiable, Hashable, Sendable {
    public let code: String
    public let name: String

    public var id: String { code }

    public var flag: String {
        // Convert currency code to flag emoji (works for most codes)
        let base: UInt32 = 127397
        var flag = ""
        for scalar in code.prefix(2).uppercased().unicodeScalars {
            if let unicode = Unicode.Scalar(base + scalar.value) {
                flag.append(Character(unicode))
            }
        }
        return flag
    }
}

struct FrankfurterResponse: Codable {
    let amount: Double
    let base: String
    let date: String
    let rates: [String: Double]
}

public enum CurrencyError: Error, LocalizedError {
    case networkError
    case unsupportedCurrency
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .networkError:
            return "Unable to fetch exchange rates. Check your connection."
        case .unsupportedCurrency:
            return "Currency not supported."
        case .invalidResponse:
            return "Invalid response from server."
        }
    }
}
