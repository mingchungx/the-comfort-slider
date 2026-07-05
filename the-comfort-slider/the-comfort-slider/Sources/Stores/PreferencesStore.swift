import Foundation
import Observation

@MainActor
@Observable
final class PreferencesStore {
    var taxEnabled: Bool {
        didSet { UserDefaults.standard.set(taxEnabled, forKey: Keys.taxEnabled) }
    }

    var salaryText: String {
        didSet {
            let sanitized = AmountSanitizer.sanitize(salaryText)
            if salaryText != sanitized { salaryText = sanitized }
            UserDefaults.standard.set(salaryText, forKey: Keys.salaryText)
        }
    }

    var defaultAPRText: String {
        didSet {
            let sanitized = AmountSanitizer.sanitize(defaultAPRText)
            if defaultAPRText != sanitized { defaultAPRText = sanitized }
            UserDefaults.standard.set(defaultAPRText, forKey: Keys.defaultAPRText)
        }
    }

    var defaultTaxText: String {
        didSet {
            let sanitized = AmountSanitizer.sanitize(defaultTaxText)
            if defaultTaxText != sanitized { defaultTaxText = sanitized }
            UserDefaults.standard.set(defaultTaxText, forKey: Keys.defaultTaxText)
        }
    }

    var defaultSalary: Decimal? {
        let trimmed = salaryText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let value = Decimal(string: trimmed), value > .zero else { return nil }
        return value
    }

    var defaultAPR: Double {
        max(0, Double(defaultAPRText) ?? Constants.fallbackAPR)
    }

    var defaultTax: Double {
        min(Constants.maxPercent, max(0, Double(defaultTaxText) ?? 0))
    }

    init() {
        taxEnabled = UserDefaults.standard.bool(forKey: Keys.taxEnabled)
        salaryText = UserDefaults.standard.string(forKey: Keys.salaryText) ?? ""
        defaultAPRText = UserDefaults.standard.string(forKey: Keys.defaultAPRText) ?? Constants.initialAPRText
        defaultTaxText = UserDefaults.standard.string(forKey: Keys.defaultTaxText) ?? ""
    }
}

private enum Keys {
    static let taxEnabled = "taxEnabled"
    static let salaryText = "defaultSalaryText"
    static let defaultAPRText = "defaultAPRText"
    static let defaultTaxText = "defaultTaxText"
}

private enum Constants {
    static let fallbackAPR = 7.5
    static let initialAPRText = "7.5"
    static let maxPercent = 100.0
}
