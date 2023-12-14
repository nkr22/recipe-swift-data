//
//  HomePageView.swift
//  Recipes
//
//  Created by Noelia Root on 12/4/23.
//

import SwiftUI
import SwiftData

struct HomePageView: View {
    @Query private var recipes: [Recipe]
    @State var showNewRecipeModal = false
    
    private let cardPadding: CGFloat = 10
    private let cardWidthFactor: CGFloat = 0.25
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    private var recentRecipes: [Recipe] {
        let sortedRecipes = recipes.sorted(by: {
            guard let date1 = dateFormatter.date(from: $0.dateLastViewed),
                  let date2 = dateFormatter.date(from: $1.dateLastViewed) else { return false }
            return date1 > date2
        })
        return Array(sortedRecipes.prefix(5))
    }
    
    private func cardImageView(_ recipe: Recipe) -> some View {
        Group {
            if let selectedPhotoData = recipe.imageURL, let uiImage = UIImage(data: selectedPhotoData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image("default-image")
                    .resizable()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        .cornerRadius(10)
    }
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationStack{
                VStack{
                    Rectangle()
                        .fill(Color("AccentColor").opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .overlay{
                            Image("Recipeat")
                                .resizable()
                                .scaledToFit()
                                .frame(height: geometry.size.height / 3)
                        }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Most Recent Recipes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 1)
                        ScrollView(.horizontal){
                            HStack(spacing: cardPadding) {
                                ForEach(recentRecipes) { recipe in
                                    NavigationLink(destination: RecipeInformationView(recipe: recipe)) {
                                        VStack {
                                            cardImageView(recipe)
                                                .frame(width: calculateCardWidth(size: geometry.size), height: calculateCardWidth(size: geometry.size))
                                                .cornerRadius(10)

                                            Text(recipe.title)
                                                .font(.title2)
                                                .lineLimit(2)
                                                .frame(width: calculateCardWidth(size: geometry.size))
                                        }
                                        .padding(.vertical, cardPadding)
                                    }
                                }
                            }
                            .frame(height: calculateCardWidth(size: geometry.size) + cardPadding * 4)
                           .padding(.horizontal, cardPadding)
                        }
                    }
                    .padding(.vertical)
                    .padding(.leading)
                    
                    Spacer()
                    GeometryReader{geometry in
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 12.0)
                                    .fill(Color("MainColor"))
                                    .overlay(
                                        Button(action: {
                                            showNewRecipeModal = true
                                        }, label: {
                                            Label("Add Recipe", systemImage: "plus")
                                        })
                                    )
                                    .frame(width: min(geometry.size.width * 0.3, 240), height: min(geometry.size.height * 0.3, 80))
                                    .foregroundStyle(Color("TextColor"))
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            
            .fullScreenCover(isPresented: $showNewRecipeModal) {
                EditRecipeView(recipe: nil)
            }
        }
    }
    private func calculateCardWidth(size: CGSize) -> CGFloat {
        let totalPadding = cardPadding * 4
        let cardWidth = (size.width - totalPadding) * cardWidthFactor
        return cardWidth > 0 ? cardWidth : 100
    }
}

//#Preview {
//    HomePageView()
//}
