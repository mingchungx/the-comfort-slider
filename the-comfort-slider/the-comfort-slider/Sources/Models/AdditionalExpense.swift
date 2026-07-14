import Foundation

/// One recurring cost that rides along with the purchase — gas, insurance,
/// maintenance, condo fees. Deliberately unnamed: naming each row is friction,
/// and the comfort math only ever needs the number.
struct AdditionalExpense: Identifiable {
    let id = UUID()
    var frequency: ExpenseFrequency = .monthly

    var amountText: String = "" {
        didSet {
            let sanitized = AmountSanitizer.sanitize(amountText)
            if amountText != sanitized {
                amountText = sanitized
            }
        }
    }

    var amount: Decimal {
        let trimmed = amountText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let value = Decimal(string: trimmed), value > .zero else { return .zero }
        return value
    }

    var monthlyAmount: Decimal {
        frequency.monthlyAmount(for: amount)
    }
}
