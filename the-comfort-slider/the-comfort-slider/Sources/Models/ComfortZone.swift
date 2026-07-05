import SwiftUI

enum ComfortZone: CaseIterable {
    case comfortable
    case stretching
    case unhinged

    init(dtiFraction: Double) {
        switch dtiFraction {
        case ..<Constants.stretchingDTI: self = .comfortable
        case ..<Constants.unhingedDTI: self = .stretching
        default: self = .unhinged
        }
    }

    var title: String {
        switch self {
        case .comfortable: "Comfortable"
        case .stretching: "Stretching"
        case .unhinged: "Unhinged"
        }
    }

    var subtitle: String {
        switch self {
        case .comfortable: "Barely feels it"
        case .stretching: "Feels the squeeze"
        case .unhinged: "Sending it"
        }
    }

    var emoji: String {
        switch self {
        case .comfortable: "😌"
        case .stretching: "😬"
        case .unhinged: "🤡"
        }
    }

    var tint: Color {
        switch self {
        case .comfortable: .green
        case .stretching: .orange
        case .unhinged: .red
        }
    }

    var gradient: [Color] {
        switch self {
        case .comfortable:
            [Color(red: 0.81, green: 0.91, blue: 0.82),
             Color(red: 0.58, green: 0.81, blue: 0.68),
             Color(red: 0.96, green: 0.94, blue: 0.85)]
        case .stretching:
            [Color(red: 0.97, green: 0.86, blue: 0.63),
             Color(red: 0.93, green: 0.69, blue: 0.40),
             Color(red: 0.98, green: 0.93, blue: 0.81)]
        case .unhinged:
            [Color(red: 0.95, green: 0.71, blue: 0.60),
             Color(red: 0.88, green: 0.38, blue: 0.30),
             Color(red: 0.98, green: 0.85, blue: 0.76)]
        }
    }

    var sprayParticle: String {
        switch self {
        case .comfortable: "💵"
        case .stretching: "💸"
        case .unhinged: "🤑"
        }
    }

    var sprayIntensity: Int {
        switch self {
        case .comfortable: 1
        case .stretching: 2
        case .unhinged: 3
        }
    }
}

private enum Constants {
    static let stretchingDTI = 0.15
    static let unhingedDTI = 0.40
}
