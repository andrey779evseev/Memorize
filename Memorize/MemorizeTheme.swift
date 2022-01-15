//
//  MemorizeTheme.swift
//  Memorize
//
//  Created by Andrew on 1/6/22.
//

import Foundation
import SwiftUI

struct MemorizeTheme {
    init(name: String, emojis: [String], numberOfPairsOfCards: Int? = nil, color: Color) {
        self.name = name
        self.emojis = emojis
        if let numberOfPairsOfCards = numberOfPairsOfCards, numberOfPairsOfCards < emojis.count {
            self.numberOfPairsOfCards = numberOfPairsOfCards
        } else {
            self.numberOfPairsOfCards = emojis.count
        }
        self.color = color
    }
    
    var name: String
    var emojis: [String]
    var numberOfPairsOfCards: Int
    var color: Color
}
