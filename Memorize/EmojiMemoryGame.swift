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
    
    private let emojiThemes: [EmojiTheme]
    
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
    
    var emojiThemeColor: Gradient {
        switch chosenEmojiTheme.color {
        case "orange":
            return Gradient(colors: [.orange])
        case "pink":
            return Gradient(colors: [.pink])
        case "green":
            return Gradient(colors: [.green])
        case "blue":
            return Gradient(colors: [.blue])
        case "red":
            return Gradient(colors: [.red])
        case "yellow":
            return Gradient(colors: [.yellow])
        case "purpleGradient":
            return Gradient(colors: [.purple, .blue])
        default:
            return Gradient(colors: [.black])
        }
    }
    
    
    // MARK: Initializers
    
    init() {
        self.memoryGame = .init(numberOfPairsOfCards: 12) { pairIndex in
            return ""
        }
        self.emojiThemes = Self.createEmojiThemes()
        
        self.chosenEmojiTheme = EmojiTheme(
            name: "Halloween",
            emojis: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭"],
            numberOfPairs: 12,
            color: "orange"
        )
        createMemoryGame()
    }
    
    private func createMemoryGame() {
        refreshChosenEmoji()
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
    
    private func refreshChosenEmoji() {
        let randomIndex = Int.random(in: 0..<emojiThemes.count)
        chosenEmojiTheme = self.emojiThemes.count >= 1 ? self.emojiThemes[randomIndex] : EmojiTheme(
            name: "Halloween",
            emojis: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭"],
            numberOfPairs: 12,
            color: "orange"
        )
        
        chosenEmojiTheme.shuffleEmojis()
    }
    
    static func createEmojiThemes() -> [EmojiTheme] {
        [
            EmojiTheme(
                name: "Halloween",
                emojis: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭"],
                numberOfPairs: 12,
                color: "orange"
            ),
            EmojiTheme(
                name: "Animals",
                emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻", "🐼", "🐨", "🐵", "🐿️", "🐦", "🐧"],
                numberOfPairs: 12,
                color: "green"
            ),
            EmojiTheme(
                name: "Ocean",
                emojis: ["🐠", "🐟", "🐙", "🐚", "🐦", "🦅", "🐡", "🐌", "🐞", "🦋", "🐊", "🐢"],
                numberOfPairs: 12,
                color: "blue",
                showsFixedNumberOfCards: false
            ),
            EmojiTheme(
                name: "Candy",
                emojis: ["🍬", "🍭", "🍫", "🍦", "🍩", "🍪", "🍰"],
                numberOfPairs: 6,
                color: "purpleGradient"
            ),
            EmojiTheme(
                name: "Vehicles",
                emojis: ["🚗", "🚀", "🚙", "🚐", "🚌", "🚎", "🚍", "🚕", "🚔", "🚛"],
                numberOfPairs: 10,
                color: "red"
            ),
            EmojiTheme(
                name: "Faces",
                emojis: ["😄", "😁", "😂", "🤣", "😃", "🤪", "😅", "😆", "😇", "😊"],
                numberOfPairs: 8,
                color: "yellow",
                showsFixedNumberOfCards: false
            ),
        ]
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
