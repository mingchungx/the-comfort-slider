import Foundation
import Observation

@MainActor
@Observable
final class CurrencyStore {
    var selected: Currency {
        didSet { persist() }
    }

    init() {
        let stored = UserDefaults.standard.string(forKey: Constants.storageKey)
        selected = stored.flatMap(Currency.init(rawValue:)) ?? .usd
    }

    private func persist() {
        UserDefaults.standard.set(selected.rawValue, forKey: Constants.storageKey)
    }
}

private enum Constants {
    static let storageKey = "selectedCurrency"
}
