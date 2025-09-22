//
//  Cardify.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 22/09/25.
//

import SwiftUI

struct Cardify: ViewModifier {
    let isFaceUp: Bool
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            
            base
                .strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base
                .opacity(isFaceUp ? 0 : 1)
        }
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
