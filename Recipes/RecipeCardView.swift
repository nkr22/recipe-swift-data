//
//  RecipeCardView.swift
//  Recipes
//
//  Created by Noelia Root on 12/10/23.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            cardImageView
                .scaledToFill()
                .frame(height: 150)
                .clipped()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(recipe.title)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.black)
                        .lineLimit(2)
                    Spacer()
                    HeartDisplayView(isFavorited: recipe.isFavorited)
                }
                .padding(.bottom, 1)
                
                HStack(spacing: 0) {
                    RatingsDisplayView(maxRating: 5, currentRating: recipe.starRating, sfSymbol: "star", width: 30, color: Color("BrightAccentColor"))
                    Spacer()
                }
                .padding(.bottom, 1)
                
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(recipe.categories, id: \.self) { tag in
                            Text(tag.name)
                                .encapsulate(color: .black.opacity(0.8), foregroundColor : .white)
                        }
                        Spacer()
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 15)
        }
        .background(Color(.white))
        .cornerRadius(10)
        .shadow(radius: 5)
        .contextMenu{
            Button(action: {
                recipe.isFavorited.toggle()
            }, label: {
                Label(recipe.isFavorited ? "Remove from Favorites" : "Add to Favorites", systemImage: "heart.fill")
            }
                   )
        }
    }
    
    private var cardImageView: some View {
        Group {
            if let selectedPhotoData = recipe.imageURL, let uiImage = UIImage(data: selectedPhotoData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image("default-image")
                    .resizable()
            }
        }
    }
}

//#Preview {
//    RecipeCardView()
//}
