import SwiftUI
import LingCore

public struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    public init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("翻译服务") {
                    Picker("Provider", selection: $viewModel.provider) {
                        ForEach(TranslationProvider.allCases, id: \.self) { provider in
                            Text(provider.rawValue)
                                .tag(provider)
                        }
                    }
                    TextField("Base URL", text: $viewModel.baseURLString)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                    TextField("Model", text: $viewModel.model)
                    SecureField("API Key", text: $viewModel.apiKey)
                }

                Section("提示词") {
                    TextEditor(text: $viewModel.prompt)
                        .frame(minHeight: 120)
                }

                Section {
                    Button(action: viewModel.save) {
                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("保存配置")
                        }
                    }
                }

                if let status = viewModel.statusMessage {
                    Section {
                        Text(status)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear(perform: viewModel.load)
        }
    }
}
