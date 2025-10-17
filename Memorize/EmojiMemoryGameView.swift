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
    // MARK: UI State
    @State private var lastScoreChange: (amount: Int, causedByCardId: Card.ID) = (0, "")
    @State private var dealt = Set<Card.ID>()
    @Namespace private var dealingNamespace
    
    private let cardAspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealInterval: TimeInterval = 0.15
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let deckWidth: CGFloat = 50
    
    
    init(_ game: EmojiMemoryGame) {
        self._viewModel = ObservedObject(initialValue: game)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            title
            cards
            Spacer()
            HStack {
                VStack {
                    score
                    timer
                    newGame
                }
                deck
            }
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
                dealt.removeAll()
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
            if isDealt(card) {
                CardView(card, time: viewModel.time)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
        .foregroundStyle(viewModel.emojiThemeColor)
    }
    
    @ViewBuilder private var deck: some View {
        if !undealtCards.isEmpty {
            ZStack {
                ForEach(undealtCards) { card in
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
            }
            .foregroundStyle(viewModel.emojiThemeColor)
            .frame(width: deckWidth, height: deckWidth / cardAspectRatio)
            .onTapGesture {
                deal()
            }
        }
    }
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.chooseCard(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, card.id)
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

#Preview {
    EmojiMemoryGameView(EmojiMemoryGame())
}
