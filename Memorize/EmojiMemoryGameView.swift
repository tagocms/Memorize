//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 01/09/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
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
            Spacer()
            score
            timer
            newGame
        }
        .padding()
        .onChange(of: viewModel.chosenEmojiTheme) {
            withAnimation {
                viewModel.shuffleCards()
            }
        }
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .font(.headline.bold())
            .animation(nil)
    }
    
    private var timer: some View {
        Text(viewModel.time, style: .timer)
            .font(.headline.bold())
    }
    
    private var newGame: some View {
        Button {
            withAnimation {
                viewModel.makeNewGame()
            }
        } label: {
            Label("New Game", systemImage: "gamecontroller.fill")
                .font(.subheadline)
                .padding(spacing)
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
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .onTapGesture {
                    withAnimation {
                        viewModel.chooseCard(card)
                    }
                }
        }
        .foregroundStyle(viewModel.emojiThemeColor)
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        return 0
    }
}

#Preview {
    EmojiMemoryGameView(EmojiMemoryGame())
}
