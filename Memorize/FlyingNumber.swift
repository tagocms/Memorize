//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 29/09/25.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number)
        }
    }
}

#Preview {
    FlyingNumber(number: 5)
}
