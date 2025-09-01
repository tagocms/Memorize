//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 01/09/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    
    init(_ game: EmojiMemoryGame) {
        self._viewModel = ObservedObject(initialValue: game)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            title
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Spacer()
            Button {
                viewModel.makeNewGame()
            } label: {
                Label("New Game", systemImage: "gamecontroller.fill")
            }
        }
        .padding()
        .onChange(of: viewModel.emojiThemeOld) {
            viewModel.shuffleCards()
        }
    }
    
    func buildThemePickerButton(_ theme: EmojiThemes) -> some View {
        Button {
            viewModel.setEmojiTheme(theme)
        } label: {
            VStack(alignment: .center) {
                Group {
                    switch theme {
                    case .halloween:
                        Image(systemName: "balloon.fill")
                    case .animals:
                        Image(systemName: "hare.fill")
                    case .ocean:
                        Image(systemName: "fish.fill")
                    }
                }
                .imageScale(.large)
                .font(.largeTitle)
                
                Text(theme.rawValue)
                    .font(.subheadline)
            }
        }
        .foregroundStyle(theme == viewModel.emojiThemeOld ? viewModel.emojiThemeOld.color : .primary)
    }
    
    var themePicker: some View {
        HStack(alignment: .lastTextBaseline) {
            ForEach(EmojiThemes.allCases, id: \.self) { theme in
                buildThemePickerButton(theme)
            }
        }
    }
    
    var title: some View {
        Text("Memorize!")
            .font(.largeTitle.bold())
    }
    
    func optimalGridSize(for cardCount: Int) -> Double {
        switch cardCount {
        case ...8:
            return 100
        case ...12:
            return 85
        case ...24:
            return 65
        case 25...:
            return 50
        default:
            return 65
        }
    }
    
    var cards: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(
                        minimum: optimalGridSize(for: viewModel.cards.count)
                    ),
                    spacing: 0
                )
            ],
            spacing: 0
        ) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.chooseCard(card)
                    }
            }
        }
        .foregroundStyle(viewModel.emojiThemeOld.color)
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
