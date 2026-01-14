import SwiftUI

public struct ReadView: View {
    @StateObject private var viewModel: ReadViewModel

    public init(viewModel: ReadViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("阅读与翻译")
                    .font(.title2)
                    .fontWeight(.semibold)

                TextEditor(text: $viewModel.inputText)
                    .frame(minHeight: 140)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.3)))
                    .padding(.bottom, 4)

                HStack {
                    Button(action: viewModel.translate) {
                        if viewModel.isTranslating {
                            ProgressView()
                        } else {
                            Text("翻译")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    if viewModel.canSave {
                        Button("保存", action: viewModel.save)
                            .buttonStyle(.bordered)
                    }
                }

                if !viewModel.translatedText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("结果")
                            .font(.headline)
                        Text(viewModel.translatedText)
                            .font(.body)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.08))
                            .cornerRadius(10)
                    }
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Read")
        }
    }
}
