//
//  EmojiTheme.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 05/09/25.
//

import Foundation

struct EmojiTheme: Identifiable, Equatable, Codable, Hashable {
    typealias ID = UUID
    private(set) var id: ID
    var name: String
    var emojis: [String] {
        didSet {
            if emojis.count < numberOfPairs && emojis.count >= 2 {
                numberOfPairs = emojis.count
            }
            emojis = emojis.uniqued
        }
    }
    var numberOfPairs: Int
    var color: RGBA
    var showsFixedNumberOfCards: Bool
    
    init(id: UUID = UUID(), name: String, emojis: [String], numberOfPairs: Int, color: RGBA, showsFixedNumberOfCards: Bool = true) {
        self.id = id
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

