import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            CalculatorView()
                .tabItem { Label("Calculator", systemImage: "slider.horizontal.3") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(.primary)
    }
}
