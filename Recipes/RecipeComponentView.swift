//
//  RecipeComponentView.swift
//  Recipes
//
//  Created by Noelia Root on 11/26/23.
//

import SwiftUI

struct RecipeComponentView: View {
    var recipe: Recipe

    var body: some View {
        HStack {
            recipeImageView
                .layoutPriority(0)
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .lineLimit(1)
                    .font(.headline)
                RatingsDisplayView(maxRating: 5, currentRating: recipe.starRating, sfSymbol: "star", width: 20, color: .systemYellow)
            }
            .layoutPriority(1)
            .padding(.leading)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var recipeImageView: some View {
        Group {
            if let selectedPhotoData = recipe.imageURL, let uiImage = UIImage(data: selectedPhotoData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.gray)
            }
        }
        .scaledToFill()
        .frame(width: 80, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//#Preview {
//    RecipeComponentView(recipe: Recipe(title: "New Recipe", author: "Noelia Root", dateCreated: "", expertiseRequired: ExpertiseLevel.expert, dateLastViewed: "", sourceURL: "", prepTime: 25, cookTime: 25, servings: 4, currentScale: 1, isFavorited: false, starRating: 4, imageURL: nil, notes: "No notes", directions: [], ingredients: [], categories: []))
//}
