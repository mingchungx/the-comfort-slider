import Foundation

/// Keeps a free-form text field a well-formed monetary amount: digits, at most
/// one decimal separator, and no more than two fraction digits. The user's
/// locale decimal key (or a plain ".") is accepted and normalised to a canonical
/// "." so the value parses correctly on any device.
enum AmountSanitizer {
    static func sanitize(_ input: String) -> String {
        let localeSeparator = Locale.current.decimalSeparator ?? "."
        var result = ""
        var hasSeparator = false
        var fractionDigits = 0
        for character in input {
            if character.isNumber {
                if hasSeparator {
                    guard fractionDigits < Constants.maxFractionDigits else { continue }
                    fractionDigits += 1
                }
                result.append(character)
            } else if (character == "." || String(character) == localeSeparator) && !hasSeparator {
                hasSeparator = true
                result.append(".")
            }
        }
        return result
    }
}

private enum Constants {
    static let maxFractionDigits = 2
}
