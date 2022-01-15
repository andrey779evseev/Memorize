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
            emojis: ["🚲", "🚂", "🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️", "🛸", "🛶", "🚌", "🏍", "🛺", "🚡", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"],
            numberOfPairsOfCards: 10,
            color: .blue
        ),
        MemorizeTheme(
            name: "Animals",
            emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🦅", "🦆", "🦉", "🦇", "🐌", "🐙", "🐡", "🐜"],
            numberOfPairsOfCards: 5,
            color: .orange
        ),
        MemorizeTheme(
            name: "Food",
            emojis: ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶", "🫑", "🌽"],
            numberOfPairsOfCards: 6,
            color: .indigo
        ),
        MemorizeTheme(
            name: "Faces",
            emojis: ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "🥲", "☺️", "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😝", "😜", "🤨", "😎"],
            numberOfPairsOfCards: 7,
            color: .purple
        ),
        MemorizeTheme(
            name: "Flags",
            emojis: ["🏳️‍⚧️", "🇺🇳", "🇦🇫", "🇦🇽", "🇦🇱", "🇩🇿", "🇦🇸", "🇦🇩", "🇦🇴", "🇦🇹", "🇦🇮", "🇦🇶", "🇦🇬", "🇦🇷", "🇦🇲", "🇦🇼", "🇦🇺", "🇦🇿", "🇧🇸", "🇧🇭", "🇧🇩", "🇧🇧", "🇧🇾", "🇧🇿"],
            numberOfPairsOfCards: 8,
            color: .green
        ),
        MemorizeTheme(
            name: "Electronic",
            emojis: ["⌚️", "📱", "💻", "⌨️", "🖥", "🖨", "🖱", "📷", "🎥", "📞", "📺", "📻", "🎙", "💡", "📟", "🕹", "⏲", "💾", "📡", "🔋", "🔦", "🔌", "💿", "🖲"],
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
