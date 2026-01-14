import SwiftUI

public struct LingRootView: View {
    @StateObject private var readViewModel: ReadViewModel
    @StateObject private var savedViewModel: SavedViewModel
    @StateObject private var settingsViewModel: SettingsViewModel

    public init(environment: AppEnvironment = .inMemory()) {
        _readViewModel = StateObject(wrappedValue: ReadViewModel(environment: environment))
        _savedViewModel = StateObject(wrappedValue: SavedViewModel(environment: environment))
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(environment: environment))
    }

    public var body: some View {
        TabView {
            ReadView(viewModel: readViewModel)
                .tabItem {
                    Label("Read", systemImage: "doc.plaintext")
                }

            SavedView(viewModel: savedViewModel)
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }

            SettingsView(viewModel: settingsViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
