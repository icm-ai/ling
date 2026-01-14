import SwiftUI
import LingCore

public struct SavedView: View {
    @StateObject private var viewModel: SavedViewModel

    public init(viewModel: SavedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.items.isEmpty {
                    ContentUnavailableView("暂无保存的翻译", systemImage: "tray")
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.originalText)
                                    .font(.body)
                                Text(item.translatedText)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Saved")
            .onAppear(perform: viewModel.load)
        }
    }
}
