import SwiftUI

struct SettingsView: View {
    @Environment(CurrencyStore.self) private var currencyStore
    @Environment(PreferencesStore.self) private var preferences
    @FocusState private var focusedField: SettingsField?

    var body: some View {
        @Bindable var currencyStore = currencyStore
        @Bindable var preferences = preferences
        NavigationStack {
            Form {
                Section {
                    Picker("Currency", selection: $currencyStore.selected) {
                        ForEach(Currency.allCases) { currency in
                            Text(currency.label).tag(currency)
                        }
                    }
                } header: {
                    Text("Currency")
                } footer: {
                    Text("Changes the symbol used to display amounts, formatted for your region.")
                }

                Section {
                    HStack {
                        Text(currencyStore.selected.symbol)
                            .foregroundStyle(.secondary)
                        TextField("Not set", text: $preferences.salaryText)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .salary)
                            .multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Default salary")
                } footer: {
                    Text("When set, the comfort slider starts from this salary and moves as the price changes. You can still drag it.")
                }

                Section {
                    percentField("7.5", text: $preferences.defaultAPRText, field: .apr)
                } header: {
                    Text("Default APR")
                } footer: {
                    Text("The interest rate the calculator starts with.")
                }

                Section {
                    // The tab bar's `.tint(.primary)` propagates into this view, so the
                    // switch needs its stock green restored explicitly.
                    Toggle("Enable sales tax", isOn: $preferences.taxEnabled)
                        .tint(.green)
                    if preferences.taxEnabled {
                        percentField("0", text: $preferences.defaultTaxText, field: .tax)
                    }
                } header: {
                    Text("Sales tax")
                } footer: {
                    Text("Adds a collapsible sales-tax percentage to the calculator, starting at this rate.")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

private extension SettingsView {
    func percentField(_ placeholder: String, text: Binding<String>, field: SettingsField) -> some View {
        HStack {
            TextField(placeholder, text: text)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: field)
                .multilineTextAlignment(.trailing)
            Text("%")
                .foregroundStyle(.secondary)
        }
    }
}

private enum SettingsField {
    case salary
    case apr
    case tax
}
