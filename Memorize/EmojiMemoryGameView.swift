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
                    .padding(4)
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
                .padding(4)
                .onTapGesture {
                    viewModel.chooseCard(card)
                }
        }
        .foregroundStyle(viewModel.emojiThemeColor)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
    
    init (_ card: MemoryGame<String>.Card) {
        self.card = card
    }
}

#Preview {
    EmojiMemoryGameView(EmojiMemoryGame())
}
