//
//  IngredientInputView.swift
//  Recipes
//
//  Created by Noelia Root on 11/27/23.
//

import SwiftUI

struct IngredientInputView: View {
    @Binding var ingredient: Ingredient

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Quantity")
                Spacer()
                TextField("Quantity", text: $ingredient.quantity)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Description")
                Spacer()
                TextField("Description", text: $ingredient.ingredient)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Notes")
                Spacer()
                TextField("Notes", text: $ingredient.notes)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

#Preview {
    IngredientInputView(ingredient: .constant(Ingredient(quantity: "1 Cup", ingredient: "Flour", notes: "Unbleached")))
}
