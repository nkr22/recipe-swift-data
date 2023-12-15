//
//  MealInfoDisplayView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct MealInfoDisplayView: View {
    let recipe: Recipe
    
    var servings: String {
        recipe.servings ?? ""
    }
    var prepTime: String{
        recipe.prepTime ?? ""
    }
    var cookTime: String{
        recipe.cookTime ?? ""
    }
    
    private var formattedMealInfo: String {
        let servingsString = servings == "" ? servings : "Servings: \(servings)"
        let prepString = prepTime == "" ? prepTime : "• Prep Time: \(prepTime)"
        let cookString = cookTime == "" ? cookTime : "• Cook Time: \(cookTime)"
        return "\(servingsString) \(prepString) \(cookString)"
    }

    var body: some View {
        Text(formattedMealInfo)
    }
}

//#Preview {
//    MealInfoDisplayView()
//}
