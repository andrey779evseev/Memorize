//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Andrew on 1/4/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var dealingNamespace
    @State private var dealt = Set<UUID>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (Constants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: Constants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(game.name)
                Spacer()
                Text("\(game.score)")
                Spacer()
                Button {
                    game.restartGame()
                } label: {
                    Text("New game")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .font(.title)
            grid
            deck
            shuffleButton
        }.padding()
    }
    
    var grid: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUnDealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            game.choose(card)
                        }
                    }
                    .foregroundColor(game.color)
            }
        }
    }
    
    var deck: some View {
        ZStack {
            ForEach(game.cards.filter(isUnDealt)) { card in
                CardView(card: card)
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: Constants.unDealtWidth, height: Constants.unDealtHeight)
        .foregroundColor(game.color)
        .onTapGesture {
            game.cards.forEach { card in
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    private struct Constants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let unDealtHeight: CGFloat = 90
        static let unDealtWidth = unDealtHeight * aspectRatio
    }
    
}


struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90 ))
                    .padding(5)
                    .opacity(0.6)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        let scale = min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
        return max(scale, 0.1)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
//        game.choose(game.cards.first!)
        return Group {
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.light)
        }
    }
}
