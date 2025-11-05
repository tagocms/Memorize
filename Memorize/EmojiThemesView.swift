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
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(store.themes) { theme in
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
                                Text("\(theme.emojis.count) emojis and \(theme.numberOfPairs) pairs")
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: deleteTheme)
                .onMove(perform: moveTheme)
            }
            .navigationTitle("Memorize Themes")
            .navigationDestination(for: EmojiTheme.self) { theme in
                EmojiMemoryGameView(theme: theme)
                    .id(theme.id)
            }
        } detail: {
            Text("Choose a theme to play.")
                .font(.title2.bold())
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    private func deleteTheme(at offsets: IndexSet) {
        store.themes.remove(atOffsets: offsets)
    }
    
    private func moveTheme(at offsets: IndexSet, newOffset: Int) {
        store.themes.move(fromOffsets: offsets, toOffset: newOffset)
    }
}

#Preview {
    EmojiThemesView()
        .environmentObject(EmojiThemeStore())
}
