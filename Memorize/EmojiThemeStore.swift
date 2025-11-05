//
//  EmojiThemeStore.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 05/11/25.
//

import SwiftUI

class EmojiThemeStore: ObservableObject {
    static let userDefaultsKey: String = "EmojiThemeStore"
    var themes: [EmojiTheme] {
        get {
            UserDefaults.standard.emojiThemes(forKey: Self.userDefaultsKey)
        }
        set {
            UserDefaults.standard.saveEmojiThemes(newValue, forKey: Self.userDefaultsKey)
            objectWillChange.send()
        }
    }
}

extension UserDefaults {
    func emojiThemes(forKey key: String) -> [EmojiTheme] {
        let decoder = JSONDecoder()
        if let data = data(forKey: key),
           let decodedData = try? decoder.decode([EmojiTheme].self, from: data) {
            return decodedData
        }
        return EmojiTheme.createEmojiThemes()
    }
    
    func saveEmojiThemes(_ emojiThemes: [EmojiTheme], forKey key: String) {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(emojiThemes) {
            setValue(data, forKey: key)
        }
    }
}
