import Pow
import SwiftUI

struct ComfortResultView: View {
    @Binding var sliderValue: Double
    let zone: ComfortZone
    let result: AffordabilityResult?
    let roast: String
    let currency: Currency
    let onReroll: () -> Void

    @State private var tapTick = 0

    var body: some View {
        GlassCard(title: "How uncomfortable?") {
            VStack(spacing: Constants.sectionSpacing) {
                comfortControl
                Divider()
                outcome
            }
            .frame(maxWidth: .infinity)
            .animation(.smooth, value: result == nil)
        }
        .animation(.smooth, value: zone)
        .animation(.smooth, value: roast)
        .sensoryFeedback(.impact(weight: .medium, intensity: 0.8), trigger: zone)
    }
}

private extension ComfortResultView {
    var comfortControl: some View {
        VStack(spacing: Constants.spacing) {
            VStack {
                Text(zone.title)
                    .font(.title2.bold())
                    .foregroundStyle(zone.tint)
                Text(zone.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            Slider(value: $sliderValue, in: Constants.range) {
                Text("Comfort")
            } minimumValueLabel: {
                Text(ComfortZone.comfortable.emoji)
            } maximumValueLabel: {
                Text(ComfortZone.unhinged.emoji)
            }
            .tint(zone.tint)
            zoneLabels
        }
    }

    var zoneLabels: some View {
        HStack {
            ForEach(ComfortZone.allCases, id: \.self) { item in
                Text(item.title)
                    .font(.caption2)
                    .foregroundStyle(item == zone ? item.tint : Color.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    var outcome: some View {
        if let result {
            VStack(spacing: Constants.spacing) {
                incomeHeadline(result)
                monthlyLine(result)
                Divider()
                roastLine
            }
        } else {
            prompt
        }
    }

    func incomeHeadline(_ result: AffordabilityResult) -> some View {
        VStack(spacing: Constants.tightSpacing) {
            headline(result)
                .font(.system(.largeTitle, design: .rounded).bold())
                .contentTransition(.numericText())
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(incomeCaption(result))
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .contentShape(.rect)
        .onTapGesture { tapTick += 1 }
        .changeEffect(.spray { Text(sprayParticle) }, value: zone)
        .changeEffect(.spray { Text(sprayParticle) }, value: tapTick)
        .sensoryFeedback(.impact(weight: .light), trigger: tapTick)
        .animation(.snappy, value: result.requiredAnnualIncome)
    }

    @ViewBuilder
    func headline(_ result: AffordabilityResult) -> some View {
        if let income = result.requiredAnnualIncome {
            Text(income, format: currencyFormat)
        } else {
            Text("Not possible")
        }
    }

    func monthlyLine(_ result: AffordabilityResult) -> some View {
        VStack(spacing: Constants.tightSpacing) {
            (Text(result.monthlyPayment, format: currencyFormat).font(.title2.bold())
                + Text(" / mo").font(.subheadline).foregroundStyle(.secondary))
                .contentTransition(.numericText())
                .animation(.snappy, value: result.monthlyPayment)
            Text("\(termLabel(result)) · \(aprLabel(result))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var roastLine: some View {
        Text(roast)
            .font(.callout)
            .italic()
            .multilineTextAlignment(.center)
            .transition(.movingParts.blur)
            .id(roast)
            .frame(maxWidth: .infinity)
            .contentShape(.rect)
            .onTapGesture(perform: onReroll)
    }

    var prompt: some View {
        VStack(spacing: Constants.spacing) {
            Text("💸")
                .font(.largeTitle)
            Text("Enter a total price")
                .font(.headline)
            Text("Set a price above to see the salary and monthly damage at this comfort level.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }

    var sprayParticle: String {
        String(repeating: zone.sprayParticle, count: zone.sprayIntensity)
    }

    func incomeCaption(_ result: AffordabilityResult) -> String {
        guard result.requiredAnnualIncome != nil else {
            return "0% of income — no salary makes this that comfortable"
        }
        return "salary to afford it · \(dtiLabel(result)) of income"
    }

    func dtiLabel(_ result: AffordabilityResult) -> String {
        result.dtiFraction.formatted(.percent.precision(.fractionLength(0)))
    }

    func termLabel(_ result: AffordabilityResult) -> String {
        let years = result.months / 12
        return years == 1 ? "1 yr" : "\(years) yrs"
    }

    func aprLabel(_ result: AffordabilityResult) -> String {
        "\(result.annualRatePercent.formatted())% APR"
    }

    var currencyFormat: Decimal.FormatStyle.Currency {
        .currency(code: currency.code).precision(.fractionLength(0))
    }
}

private enum Constants {
    static let range = 0.0...100.0
    static let sectionSpacing = 16.0
    static let spacing = 12.0
    static let tightSpacing = 2.0
}
