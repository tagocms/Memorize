//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 03/09/25.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private var memoryGame: MemoryGame<String>
    @Published private(set) var chosenEmojiTheme: EmojiTheme
    
    var cards: Array<Card> {
        return memoryGame.cards
    }
    
    var score: Int {
        return memoryGame.score
    }
    
    var timeSecondsDelta: Int {
        return memoryGame.timeSecondsDelta
    }
    
    var time: Date {
        return memoryGame.time
    }
    
    
    // MARK: Initializers
    
    init(theme: EmojiTheme) {
        self.memoryGame = .init(numberOfPairsOfCards: 12) { pairIndex in
            return ""
        }
        
        self.chosenEmojiTheme = theme
        createMemoryGame()
    }
    
    private func createMemoryGame() {
        if !chosenEmojiTheme.showsFixedNumberOfCards {
            chosenEmojiTheme.changeNumberOfPairs(to: Int.random(in: 2...chosenEmojiTheme.emojis.count))
        }
        memoryGame = MemoryGame(numberOfPairsOfCards: chosenEmojiTheme.numberOfPairs) { pairIndex in
            if chosenEmojiTheme.emojis.indices.contains(pairIndex) {
                chosenEmojiTheme.emojis[pairIndex]
            } else {
                "⁉"
            }
        }
        
        shuffleCards()
        resetScore()
    }
    
    // MARK: - Intents
    
    // MARK: Reset
    func makeNewGame() {
        createMemoryGame()
    }
    
    // MARK: - Model
    func resetScore() {
        memoryGame.resetScore()
    }
    
    func shuffleCards() {
        memoryGame.shuffle()
    }
    
    func chooseCard(_ card: Card) {
        memoryGame.choose(card)
    }
    
    // MARK: - EmojiTheme
    
    func setEmojiTheme(_ emojiTheme: EmojiTheme) {
        self.chosenEmojiTheme = emojiTheme
        createMemoryGame()
    }
}


extension EmojiTheme {
    static func createEmojiThemes() -> [EmojiTheme] {
        [
            EmojiTheme(
                name: "Halloween",
                emojis: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭"],
                numberOfPairs: 12,
                color: RGBA(color: .orange)
            ),
            EmojiTheme(
                name: "Animals",
                emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻", "🐼", "🐨", "🐵", "🐿️", "🐦", "🐧"],
                numberOfPairs: 12,
                color: RGBA(color: .green)
            ),
            EmojiTheme(
                name: "Ocean",
                emojis: ["🐠", "🐟", "🐙", "🐚", "🐦", "🦅", "🐡", "🐌", "🐞", "🦋", "🐊", "🐢"],
                numberOfPairs: 12,
                color: RGBA(color: .blue),
                showsFixedNumberOfCards: false
            ),
            EmojiTheme(
                name: "Candy",
                emojis: ["🍬", "🍭", "🍫", "🍦", "🍩", "🍪", "🍰"],
                numberOfPairs: 6,
                color: RGBA(color: .purple)
            ),
            EmojiTheme(
                name: "Vehicles",
                emojis: ["🚗", "🚀", "🚙", "🚐", "🚌", "🚎", "🚍", "🚕", "🚔", "🚛"],
                numberOfPairs: 10,
                color: RGBA(color: .red)
            ),
            EmojiTheme(
                name: "Faces",
                emojis: ["😄", "😁", "😂", "🤣", "😃", "🤪", "😅", "😆", "😇", "😊"],
                numberOfPairs: 8,
                color: RGBA(color: .yellow),
                showsFixedNumberOfCards: false
            ),
        ]
    }
    
    static let defaultTheme: EmojiTheme =  EmojiTheme(
        name: "Halloween",
        emojis: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭"],
        numberOfPairs: 12,
        color: RGBA(color: .orange)
    )
    
    var colorView: Color {
        Color(rgba: color)
    }
}
