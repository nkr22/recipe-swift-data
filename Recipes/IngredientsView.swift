//
//  IngredientsView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct IngredientsView: View {
    var ingredients: [Ingredient]
    var currentScale: Double
    
    private func amountView(amount: String) -> String {
        let myDouble = Double(amount)
        
        if let myDouble {
            return String(myDouble * currentScale)
        } else {
            return amount
        }
    }
    

    var body: some View {
        List(ingredients, id: \.self) { ingredient in
            Text("\(amountView(amount: ingredient.amount)) \(ingredient.unit) \(ingredient.ingredient) \(ingredient.notes)")
                .font(.subheadline)
        }
    }
}


//#Preview {
//    IngredientsView()
//}
