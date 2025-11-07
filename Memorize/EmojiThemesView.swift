//
//  EmojiThemesView.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 05/11/25.
//

import SwiftUI

struct EmojiThemesView: View {
    struct Constants {
        static let textPadding: CGFloat = 4
    }
    @EnvironmentObject var store: EmojiThemeStore
    @State private var themeToEditIndex: Int?
    
    var body: some View {
        NavigationSplitView {
            List {
                listItems
            }
            .navigationTitle("Memorize")
            .navigationDestination(for: EmojiTheme.self) { theme in
                EmojiMemoryGameView(theme: theme)
                    .id(theme.id)
            }
            .toolbar {
                customToolbar
            }
            .sheet(item: $themeToEditIndex) { themeToEditIndex in
                EditThemeView(theme: $store.themes[themeToEditIndex])
            }
        } detail: {
            Text("Choose a theme to play.")
                .font(.title2.bold())
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    private var listItems: some View {
        ForEach(store.themes) { theme in
            themeListItem(for: theme)
                .swipeActions(edge: .leading) {
                    Button("Edit", systemImage: "pencil") {
                        editTheme(theme)
                    }
                    .tint(.yellow)
                }
        }
        .onDelete(perform: deleteTheme)
        .onMove(perform: moveTheme)
    }
    
    private var customToolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                let newEmojiTheme = EmojiTheme(name: "", emojis: EmojiTheme.defaultTheme.emojis, numberOfPairs: 2, color: RGBA(color: .black))
                store.themes.append(newEmojiTheme)
                editTheme(newEmojiTheme)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    private func themeListItem(for theme: EmojiTheme) -> some View {
        NavigationLink(value: theme) {
            HStack {
                VStack(alignment: .leading) {
                    Text(theme.name)
                        .font(.title2.bold())
                        .padding(.bottom, Constants.textPadding)
                        .foregroundStyle(theme.colorView)
                    Text(theme.emojis.joined(separator: " "))
                        .lineLimit(1)
                        .padding(.bottom, Constants.textPadding)
                    Group {
                        if theme.showsFixedNumberOfCards {
                            Text("\(theme.emojis.count) emojis and \(theme.numberOfPairs) pairs")
                        } else {
                            Text("\(theme.emojis.count) emojis with random number of pairs")
                        }
                    }
                    .font(.subheadline)
                }
                Spacer()
            }
        }
    }
    
    private func deleteTheme(at offsets: IndexSet) {
        store.themes.remove(atOffsets: offsets)
    }
    
    private func moveTheme(at offsets: IndexSet, newOffset: Int) {
        store.themes.move(fromOffsets: offsets, toOffset: newOffset)
    }
    
    private func editTheme(_ theme: EmojiTheme) {
        if let index = store.themes.firstIndex(of: theme) {
            themeToEditIndex = index
        }
    }
}

#Preview {
    EmojiThemesView()
        .environmentObject(EmojiThemeStore())
}


extension Int: @retroactive Identifiable {
    public var id: Int { self }
}
