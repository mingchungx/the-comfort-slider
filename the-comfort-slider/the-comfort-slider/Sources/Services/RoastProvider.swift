import Foundation

struct RoastProvider {
    func roast(for zone: ComfortZone) -> String {
        bank(for: zone).randomElement() ?? ""
    }
}

private extension RoastProvider {
    func bank(for zone: ComfortZone) -> [String] {
        switch zone {
        case .comfortable: Self.comfortable
        case .stretching: Self.stretching
        case .unhinged: Self.unhinged
        }
    }

    static let comfortable = [
        "Look at you, financially responsible. Disgusting.",
        "Your accountant would be proud. Your group chat, less so.",
        "This is the budgeting equivalent of going to bed at 9pm.",
        "Safe. Boring. Sustainable. Who even are you?",
        "You could buy this and still sleep at night. Lame.",
        "Certified adult behavior detected.",
        "No risk, no debt, no fun.",
        "You're basically a spreadsheet with a pulse.",
        "Even your future self can't complain about this one.",
        "This won't make the algorithm. Try harder.",
        "Responsible to the point of being a little smug, honestly.",
        "Your savings account didn't even flinch.",
    ]

    static let stretching = [
        "Doable, if you skip lunch. Every lunch. Forever.",
        "Your budget just took a deep breath in.",
        "This is a 'check the account before you tap' purchase.",
        "Living on the edge, but the edge still has a railing.",
        "You'll afford it and quietly panic. That's the vibe.",
        "One surprise bill away from regret.",
        "The math works. Your nervous system, less so.",
        "This is a 'don't tell anyone what it cost' situation.",
        "You can swing it. You'll just feel the swing.",
        "Bold. Slightly sweaty, but bold.",
        "Your rent is watching this decision very closely.",
        "Affordable the way a parachute is optional.",
    ]

    static let unhinged = [
        "This isn't a budget, it's a cry for help.",
        "Bankruptcy has entered the chat.",
        "Your bank just scheduled a wellness check.",
        "Sending it like rent is a rumor.",
        "Financial advisors are gathering outside your home.",
        "This is how cautionary tales begin.",
        "You don't afford this. You survive it.",
        "The number went up. Your odds went down.",
        "Delusion has never looked this expensive.",
        "Future you is already filing the complaint.",
        "We did the math. The math is screaming.",
        "Buy it. Therapy is also a purchase.",
    ]
}
