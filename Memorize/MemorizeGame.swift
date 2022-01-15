//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Andrew on 1/6/22.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(id: UUID.init(), content: content))
            cards.append(Card(id: UUID.init(), content: content))
        }
        cards = cards.shuffled()
    }
    
    private(set) var cards: [Card]
    
    private(set) var score: Int = 0
    
    private var indexOfFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            cards.indices.forEach { index in
                let tempIsFaceUp = cards[index].isFaceUp
                cards[index].isFaceUp = index == newValue
                if tempIsFaceUp && !cards[index].isFaceUp {
                    cards[index].seen = true
                }
            }
        }
    }
    
    private var lastFaceUpCardTime: Date = .now
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchedIndex = indexOfFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchedIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchedIndex].isMatched = true
                    let sec = lastFaceUpCardTime.timeIntervalSinceNow
                    score += max(10 - Int((sec)), 1) * 2
                } else {
                    if cards[chosenIndex].seen {
                        let sec = lastFaceUpCardTime.timeIntervalSinceNow
                        score += max(10 - Int((sec)), 1) * -1
                    }
                    if cards[potentialMatchedIndex].seen {
                        let sec = lastFaceUpCardTime.timeIntervalSinceNow
                        score += max(10 - Int((sec)), 1) * -1
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfFaceUpCard = chosenIndex
            }
            lastFaceUpCardTime = .now
        }
    }
    
    struct Card: Identifiable {
        let id: UUID
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        var seen = false
    }
}


