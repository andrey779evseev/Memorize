//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Andrew on 1/6/22.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    // MARK: - private
    private static let themes: [MemorizeTheme] = [
        MemorizeTheme(
            name: "Vehicles",
            emojis: ["๐ฒ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "โ๏ธ", "๐", "โต๏ธ", "๐ธ", "๐ถ", "๐", "๐", "๐บ", "๐ก", "๐ต", "๐", "๐", "๐", "๐ป", "๐"],
            numberOfPairsOfCards: 10,
            color: .blue
        ),
        MemorizeTheme(
            name: "Animals",
            emojis: ["๐ถ", "๐ฑ", "๐ญ", "๐น", "๐ฐ", "๐ฆ", "๐ป", "๐ผ", "๐ปโโ๏ธ", "๐จ", "๐ฏ", "๐ฆ", "๐ฎ", "๐ท", "๐ธ", "๐ต", "๐ฆ", "๐ฆ", "๐ฆ", "๐ฆ", "๐", "๐", "๐ก", "๐"],
            numberOfPairsOfCards: 5,
            color: .orange
        ),
        MemorizeTheme(
            name: "Food",
            emojis: ["๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ซ", "๐", "๐", "๐", "๐ฅญ", "๐", "๐ฅฅ", "๐ฅ", "๐", "๐", "๐ฅ", "๐ฅฆ", "๐ฅฌ", "๐ฅ", "๐ถ", "๐ซ", "๐ฝ"],
            numberOfPairsOfCards: 6,
            color: .indigo
        ),
        MemorizeTheme(
            name: "Faces",
            emojis: ["๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐คฃ", "๐ฅฒ", "โบ๏ธ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ฅฐ", "๐", "๐", "๐", "๐", "๐คจ", "๐"],
            numberOfPairsOfCards: 7,
            color: .purple
        ),
        MemorizeTheme(
            name: "Flags",
            emojis: ["๐ณ๏ธโโง๏ธ", "๐บ๐ณ", "๐ฆ๐ซ", "๐ฆ๐ฝ", "๐ฆ๐ฑ", "๐ฉ๐ฟ", "๐ฆ๐ธ", "๐ฆ๐ฉ", "๐ฆ๐ด", "๐ฆ๐น", "๐ฆ๐ฎ", "๐ฆ๐ถ", "๐ฆ๐ฌ", "๐ฆ๐ท", "๐ฆ๐ฒ", "๐ฆ๐ผ", "๐ฆ๐บ", "๐ฆ๐ฟ", "๐ง๐ธ", "๐ง๐ญ", "๐ง๐ฉ", "๐ง๐ง", "๐ง๐พ", "๐ง๐ฟ"],
            numberOfPairsOfCards: 8,
            color: .green
        ),
        MemorizeTheme(
            name: "Electronic",
            emojis: ["โ๏ธ", "๐ฑ", "๐ป", "โจ๏ธ", "๐ฅ", "๐จ", "๐ฑ", "๐ท", "๐ฅ", "๐", "๐บ", "๐ป", "๐", "๐ก", "๐", "๐น", "โฒ", "๐พ", "๐ก", "๐", "๐ฆ", "๐", "๐ฟ", "๐ฒ"],
            numberOfPairsOfCards: 9,
            color: .pink
        )
    ]
    
    init() {
        let result = EmojiMemoryGame.createGame()
        theme = result.theme
        model = result.model
    }
    
    private var theme: MemorizeTheme
    
    private static func createGame(previousTheme: String? = nil) -> (theme: MemorizeTheme, model: MemoryGame<String>) {
        var randomInt = Int.random(in: 0..<themes.count)
        if let name = previousTheme {
            while name == themes[randomInt].name {
                randomInt = Int.random(in: 0..<themes.count)
            }
        }
        let theme = themes[randomInt]
        let emojis = theme.emojis.shuffled()
        return (
            theme: theme,
            model: MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
                emojis[pairIndex]
            }
        )
    }
    
    @Published private var model: MemoryGame<String>
    
    //MARK: - public
    
    var cards: [Card] {
        model.cards
    }
    
    var name: String {
        return theme.name
    }
    
    var color: Color {
        return theme.color
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func restartGame() {
        let result = EmojiMemoryGame.createGame(previousTheme: theme.name)
        theme = result.theme
        model = result.model
    }
    
    func shuffle() {
        model.shuffle()
    }
}
