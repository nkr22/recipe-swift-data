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
        HStack{
            if let selectedPhotoData = recipe.imageURL,
              let uiImage = UIImage(data: selectedPhotoData) {
               Image(uiImage: uiImage)
                   .resizable()
                   .scaledToFill()
                   .aspectRatio(1, contentMode: .fill)
                   .layoutPriority(0)
                   .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/12)
                   .clipShape(RoundedRectangle(cornerRadius: 10,
                                               style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/12)
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fill)
                    .layoutPriority(0)
                
            }
            VStack(alignment:.leading){
                Text(recipe.title).lineLimit(1)
                RatingsDisplayView(maxRating: 5, currentRating: recipe.starRating, sfSymbol: "star", width: 30, color: .systemYellow)
            }
                .layoutPriority(1)
                .padding()
            
        }
        
    }
}

//#Preview {
//    RecipeComponentView(recipe: Recipe(title: "New Recipe", author: "Noelia Root", dateCreated: "", expertiseRequired: ExpertiseLevel.expert, dateLastViewed: "", sourceURL: "", prepTime: 25, cookTime: 25, servings: 4, currentScale: 1, isFavorited: false, starRating: 4, imageURL: nil, notes: "No notes", directions: [], ingredients: [], categories: []))
//}
