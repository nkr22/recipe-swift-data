//
//  RecipeSegmentedView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

enum RecipeSegment: String, CaseIterable {
    case ingredients = "Ingredients"
    case directions = "Directions"
}

struct RecipeSegmentedView: View {
    var segment: RecipeSegment
    var recipe: Recipe
    @Binding var currentScale: Double

    var body: some View {
        switch segment {
        case .ingredients:
            IngredientsView(ingredients: recipe.ingredients, currentScale: $currentScale)
        case .directions:
            DirectionsView(directions: recipe.directions, notes: recipe.notes ?? "")
        }
    }
}

//#Preview {
//    RecipeSegmentedView()
//}
