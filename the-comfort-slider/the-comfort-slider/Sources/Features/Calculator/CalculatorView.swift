import SwiftUI

struct CalculatorView: View {
    @Environment(CurrencyStore.self) private var currencyStore
    @Environment(PreferencesStore.self) private var preferences
    @State private var viewModel = CalculatorViewModel()
    @FocusState private var focused: CalcField?

    var body: some View {
        NavigationStack {
            ScrollView {
                sections
                    .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .background(ShaderBackground(zone: viewModel.zone))
            .navigationTitle("The Comfort Slider")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { keyboardToolbar }
            .onChange(of: viewModel.zone) { viewModel.refreshRoastIfNeeded() }
            .task { viewModel.refreshRoastIfNeeded() }
            .onChange(of: preferences.taxEnabled, initial: true) { _, enabled in
                viewModel.taxEnabled = enabled
            }
            .onChange(of: preferences.defaultAPR, initial: true) { _, apr in
                viewModel.aprPercent = apr
            }
            .onChange(of: preferences.defaultTax, initial: true) { _, tax in
                viewModel.taxPercent = tax
            }
            .onChange(of: preferences.defaultSalary, initial: true) { _, salary in
                viewModel.defaultSalary = salary
                viewModel.lockToDefaultSalary()
            }
            .onChange(of: viewModel.monthly) { viewModel.syncSliderIfFollowing() }
            .sensoryFeedback(.selection, trigger: viewModel.rerollTick)
        }
    }
}

private extension CalculatorView {
    var sections: some View {
        GlassEffectContainer(spacing: Constants.glassSpacing) {
            VStack(spacing: Constants.sectionSpacing) {
                priceField
                financingSection
                if preferences.taxEnabled {
                    taxSection
                }
                comfortResult
            }
        }
    }

    var priceField: some View {
        PriceFieldView(text: $viewModel.priceText, currency: currencyStore.selected, focus: $focused)
    }

    var financingSection: some View {
        FinancingView(
            downPaymentPercent: viewModel.downPaymentPercent,
            downPaymentAmount: viewModel.downPaymentAmount,
            canDecreaseDownPayment: viewModel.canDecreaseDownPayment,
            canIncreaseDownPayment: viewModel.canIncreaseDownPayment,
            onDecreaseDownPayment: viewModel.decreaseDownPayment,
            onIncreaseDownPayment: viewModel.increaseDownPayment,
            aprPercent: viewModel.aprPercent,
            interestAmount: viewModel.totalInterest,
            canDecreaseAPR: viewModel.canDecreaseAPR,
            onDecreaseAPR: viewModel.decreaseAPR,
            onIncreaseAPR: viewModel.increaseAPR,
            currency: currencyStore.selected,
            termMonths: $viewModel.termMonths
        )
    }

    var taxSection: some View {
        TaxView(
            taxPercent: viewModel.taxPercent,
            taxAmount: viewModel.taxAmount,
            canDecreaseTax: viewModel.canDecreaseTax,
            canIncreaseTax: viewModel.canIncreaseTax,
            onDecreaseTax: viewModel.decreaseTax,
            onIncreaseTax: viewModel.increaseTax,
            currency: currencyStore.selected
        )
    }

    var comfortResult: some View {
        ComfortResultView(
            sliderValue: $viewModel.sliderValue,
            zone: viewModel.zone,
            result: viewModel.result,
            roast: viewModel.roast,
            currency: currencyStore.selected,
            onReroll: viewModel.rerollRoast
        )
    }

    @ToolbarContentBuilder
    var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") { focused = nil }
                .fontWeight(.semibold)
        }
    }
}

private enum Constants {
    static let sectionSpacing = 20.0
    static let glassSpacing = 0.0
}
