import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case usd
    case eur
    case gbp
    case jpy
    case cad
    case aud
    case inr

    var id: String { rawValue }

    var code: String { rawValue.uppercased() }

    var symbol: String {
        switch self {
        case .usd, .cad, .aud: "$"
        case .eur: "€"
        case .gbp: "£"
        case .jpy: "¥"
        case .inr: "₹"
        }
    }

    var displayName: String {
        switch self {
        case .usd: "US Dollar"
        case .eur: "Euro"
        case .gbp: "British Pound"
        case .jpy: "Japanese Yen"
        case .cad: "Canadian Dollar"
        case .aud: "Australian Dollar"
        case .inr: "Indian Rupee"
        }
    }

    var label: String { "\(displayName) (\(symbol))" }
}
