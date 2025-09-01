//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 01/09/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game)
        }
    }
}
