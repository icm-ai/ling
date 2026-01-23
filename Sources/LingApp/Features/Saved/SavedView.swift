import SwiftUI
import LingCore

public struct SavedView: View {
    @StateObject private var viewModel: SavedViewModel

    public init(viewModel: SavedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                #if os(iOS)
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                #else
                Color(NSColor.windowBackgroundColor).ignoresSafeArea()
                #endif
                
                if viewModel.items.isEmpty {
                    ContentUnavailableView {
                        Label("No Saved Translations", systemImage: "bookmark.slash")
                    } description: {
                        Text("Items you save while reading will appear here.")
                    }
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            SavedItemRow(item: item)
                                #if os(iOS)
                                .listRowBackground(Color(uiColor: .secondarySystemGroupedBackground))
                                #else
                                .listRowBackground(Color.secondary.opacity(0.1))
                                #endif
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                            viewModel.delete(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .contextMenu {
                                    Button {
                                        #if os(iOS)
                                        UIPasteboard.general.string = item.translatedText
                                        #elseif os(macOS)
                                        NSPasteboard.general.clearContents()
                                        NSPasteboard.general.setString(item.translatedText, forType: .string)
                                        #endif
                                    } label: {
                                        Label("Copy Translation", systemImage: "doc.on.doc")
                                    }
                                    
                                    Button(role: .destructive) {
                                        if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                            viewModel.delete(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Saved")
            .onAppear(perform: viewModel.load)
            .refreshable {
                viewModel.load()
            }
        }
    }
}

struct SavedItemRow: View {
    let item: TranslationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.originalText)
                    .font(.system(.body, design: .serif))
                    .lineLimit(2)
                Spacer()
                Text(item.createdAt.formatted(.dateTime.month().day()))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Text(item.translatedText)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.blue)
                .lineLimit(3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                #if os(iOS)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                #else
                .fill(Color.secondary.opacity(0.1))
                #endif
                .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.1), lineWidth: 0.5)
        )
    }
}
