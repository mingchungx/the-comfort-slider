import Foundation

/// How often a recurring cost is paid. Everything is normalised to a monthly
/// figure before it reaches the comfort math, so a daily coffee and a yearly
/// insurance premium can be compared and summed.
enum ExpenseFrequency: String, CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly
    case yearly

    var id: String { rawValue }

    var label: String {
        switch self {
        case .daily: "Daily"
        case .weekly: "Weekly"
        case .monthly: "Monthly"
        case .yearly: "Yearly"
        }
    }

    /// Converts an amount at this frequency into what it costs per month.
    /// Daily and weekly go through the year rather than assuming a 30-day month,
    /// so twelve months of them add up to exactly a year's spending.
    func monthlyAmount(for amount: Decimal) -> Decimal {
        switch self {
        case .daily: amount * Constants.daysPerYear / Constants.monthsPerYear
        case .weekly: amount * Constants.weeksPerYear / Constants.monthsPerYear
        case .monthly: amount
        case .yearly: amount / Constants.monthsPerYear
        }
    }
}

private enum Constants {
    static let daysPerYear: Decimal = 365
    static let weeksPerYear: Decimal = 52
    static let monthsPerYear: Decimal = 12
}
