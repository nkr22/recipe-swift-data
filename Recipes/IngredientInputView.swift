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
            HStack(alignment: .top)  {
                Text("Amount")
                Spacer()
                TextField("Amount (eg. 500)", text: $ingredient.amount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack(alignment: .top)  {
                Text("Unit")
                Spacer()
                TextField("Unit (eg. g)", text: $ingredient.unit, axis: .vertical)
                    .multilineTextAlignment(.trailing)
            }

            HStack(alignment: .top) {
                Text("Ingredient")
                Spacer()
                TextField("Ingredient", text: $ingredient.ingredient, axis: .vertical)
                    .multilineTextAlignment(.trailing)
            }

            HStack(alignment: .top)  {
                Text("Notes")
                Spacer()
                TextField("Notes", text: $ingredient.notes, axis: .vertical)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

#Preview {
    IngredientInputView(ingredient: .constant(Ingredient(amount: "1", unit: "Cup", ingredient: "Flour", notes: "Unbleached")))
}
