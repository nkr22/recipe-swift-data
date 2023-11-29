//
//  DirectionInputView.swift
//  Recipes
//
//  Created by Noelia Root on 11/28/23.
//

import SwiftUI

struct DirectionInputView: View {
    @Binding var direction: Direction

    var body: some View {

        HStack {
            Text("\(direction.order).")
            TextField("Description", text: $direction.direction)
                .multilineTextAlignment(.leading)
        }

    }
    
}

#Preview {
    DirectionInputView(direction: .constant(Direction(order: 1, direction: "Mix it up")))
}
