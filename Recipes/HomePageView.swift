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
    private let cardWidthFactor: CGFloat = 0.3
    
    private var recentRecipes: [Recipe] {
        let sortedRecipes = recipes.sorted(by: {
            guard let date1 = DateFormatter.myCustomFormatter.date(from: $0.dateLastViewed),
                  let date2 = DateFormatter.myCustomFormatter.date(from: $1.dateLastViewed) else { return false }
            return date1 > date2
        })
        return Array(sortedRecipes.prefix(6))
    }
    
    private var buttonView: some View {
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
    
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationStack{
                VStack{
                    headerView(size: geometry.size)
                        .frame(minHeight: geometry.size.height * 0.3)
                    Spacer()
                    recipeScrollView(size: geometry.size)
                    .padding(.vertical)
                    .padding(.leading)
                    
                    Spacer()
                    buttonView
                }
            }
            
            .fullScreenCover(isPresented: $showNewRecipeModal) {
                EditRecipeView(recipe: nil)
            }
            .toolbarBackground(Color("MainColor"))
            .toolbarColorScheme(.dark, for: .navigationBar)
        }

    }
    private func calculateCardWidth(size: CGSize) -> CGFloat {
        let totalPadding = cardPadding * 4
        let cardWidth = (size.width - totalPadding) * cardWidthFactor > 0 ? (size.width - totalPadding) * cardWidthFactor : 200
        return min(cardWidth, 200)
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
    
    private func headerView(size: CGSize) -> some View {
        Rectangle()
            .fill(Color("AccentColor").opacity(0.3))
            .edgesIgnoringSafeArea(.all)
            .overlay{
                Image("Recipeat")
                    .resizable()
                    .scaledToFit()
                    .frame(height: size.height * 0.4)
            }
    }
    
    private func recipeScrollView(size: CGSize) -> some View {
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
                                    .frame(width: calculateCardWidth(size: size), height: calculateCardWidth(size: size))
                                    .cornerRadius(10)

                                Text(recipe.title)
                                    .font(.title2)
                                    .lineLimit(2)
                                    .frame(width: calculateCardWidth(size: size))
                            }
                            .padding(.vertical, cardPadding)
                        }
                    }
                }
                .frame(height: calculateCardWidth(size: size) + cardPadding * 4)
               .padding(.horizontal, cardPadding)
            }
        }
    }

}

//#Preview {
//    HomePageView()
//}
