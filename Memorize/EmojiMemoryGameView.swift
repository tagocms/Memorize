//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 01/09/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let cardAspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    
    
    init(_ game: EmojiMemoryGame) {
        self._viewModel = ObservedObject(initialValue: game)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            title
            cards
                .animation(.default, value: viewModel.cards)
            Spacer()
            Text("Score: \(viewModel.score)")
                .font(.headline.bold())
            Text(viewModel.time, style: .timer)
                .font(.headline.bold())
            Button {
                viewModel.makeNewGame()
            } label: {
                Label("New Game", systemImage: "gamecontroller.fill")
                    .font(.subheadline)
                    .padding(spacing)
            }
            
        }
        .padding()
        .onChange(of: viewModel.chosenEmojiTheme) {
            viewModel.shuffleCards()
        }
    }
    
    var title: some View {
        Text("Memorize: \(viewModel.chosenEmojiTheme.name)")
            .font(.largeTitle.bold())
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
            CardView(card)
                .padding(spacing)
                .onTapGesture {
                    viewModel.chooseCard(card)
                }
        }
        .foregroundStyle(viewModel.emojiThemeColor)
    }
}

#Preview {
    EmojiMemoryGameView(EmojiMemoryGame())
}
