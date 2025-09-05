//
//  EmojiTheme.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 05/09/25.
//

import Foundation

struct EmojiTheme: Identifiable, Equatable {
    let id = UUID()
    let name: String
    private(set) var emojis: [String]
    private(set) var numberOfPairs: Int
    let color: String
    let showsFixedNumberOfCards: Bool
    
    init(name: String, emojis: [String], numberOfPairs: Int, color: String, showsFixedNumberOfCards: Bool = true) {
        self.name = name
        self.emojis = emojis
        if numberOfPairs > emojis.count {
            self.numberOfPairs = emojis.count
        } else if numberOfPairs < 2 {
            self.numberOfPairs = 2
        } else {
            self.numberOfPairs = numberOfPairs
        }
        self.color = color
        self.showsFixedNumberOfCards = showsFixedNumberOfCards
    }
    
    mutating func changeNumberOfPairs(to newValue: Int) {
        numberOfPairs = newValue
    }
    
    mutating func shuffleEmojis() {
        emojis.shuffle()
    }
}


