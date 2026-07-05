import SwiftUI

@main
struct TheComfortSliderApp: App {
    @State private var currencyStore = CurrencyStore()
    @State private var preferences = PreferencesStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(currencyStore)
                .environment(preferences)
        }
    }
}
