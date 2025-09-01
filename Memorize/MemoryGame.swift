//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 03/09/25.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var id: String
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        
        var debugDescription: String {
            "id: \(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "not matched")"
        }
    }
    private(set) var cards: Array<Card>
    private(set) var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            
            cards.append(Card(id: "\(pairIndex+1)a", content: content))
            cards.append(Card(id: "\(pairIndex+1)b", content: content))
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first: nil
    }
}
