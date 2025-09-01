//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 03/09/25.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var memoryGame: MemoryGame<String>
    @Published private(set) var emojiThemeOld: EmojiThemes
    @Published private(set) var emojiTheme: EmojiTheme
    
    var cards: Array<MemoryGame<String>.Card> {
        return memoryGame.cards
    }
    
    
    // MARK: Initializers
    
    init() {
        self._emojiThemeOld = Published(initialValue: .halloween)
        self.memoryGame = .init(numberOfPairsOfCards: 12) { pairIndex in
            return ""
        }
        self.emojiTheme = EmojiTheme(
            name: "Halloween",
            emojis: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭"],
            numberOfPairs: 12,
            color: "orange"
        )
        createMemoryGame()
    }
    
    private func createMemoryGame() {
        memoryGame = MemoryGame(numberOfPairsOfCards: 12) { pairIndex in
            if emojiThemeOld.emojis.indices.contains(pairIndex) {
                emojiThemeOld.emojis[pairIndex]
            } else {
                "⁉"
            }
        }
        
        memoryGame.shuffle()
    }
    
    // MARK: - Intents
    
    // MARK: Reset
    func makeNewGame() {
        createMemoryGame()
    }
    
    // MARK: - Model
    func shuffleCards() {
        memoryGame.shuffle()
    }
    
    func chooseCard(_ card: MemoryGame<String>.Card) {
        memoryGame.choose(card)
    }
    
    // MARK: - EmojiTheme
    
    func setEmojiTheme(_ emojiTheme: EmojiThemes) {
        self.emojiThemeOld = emojiTheme
        createMemoryGame()
    }
}

// MARK: - EmojiThemes Enum

enum EmojiThemes: String, CaseIterable {
    case halloween = "Halloween"
    case animals = "Animals"
    case ocean = "Ocean"
    
    var emojis: [String] {
        switch self {
        case .animals:
            ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻", "🐼", "🐨", "🐵", "🐿️", "🐦", "🐧"]
        case .halloween:
            ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭"]
        case .ocean:
            ["🐠", "🐟", "🐙", "🐚", "🐦", "🦅", "🐡", "🐌", "🐞", "🦋", "🐊", "🐢"]
        }
    }
    
    var color: Color {
        switch self {
        case .animals:
                .green
        case .halloween:
                .orange
        case .ocean:
                .blue
        }
    }
}
