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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    private var recentRecipes: [Recipe] {
        return recipes.sorted(by: {
            guard let date1 = dateFormatter.date(from: $0.dateLastViewed),
                  let date2 = dateFormatter.date(from: $1.dateLastViewed) else { return false }
            return date1 > date2
        })
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Image("Recipeat")
                    .resizable()
                    .scaledToFit()
                    .background {
                        Rectangle()
                            .ignoresSafeArea()
                            .foregroundStyle(.gray.opacity(0.5))
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
                Spacer()
                VStack(alignment: .leading){
                    Text("Most Recent Recipes").font(.largeTitle).fontWeight(.bold)
                    ScrollView(.horizontal){
                        HStack(spacing: 40){
                            ForEach(recentRecipes) {recipe in
                                NavigationLink{
                                    RecipeInformationView(recipe: recipe)
                                } label: {
                                    VStack{
                                        RoundedRectangle(cornerRadius: 8.0)
                                            .foregroundStyle(.gray)
                                            .aspectRatio(1, contentMode: .fill)
                                            .layoutPriority(0)
                                        Text(recipe.title)
                                            .font(.largeTitle)
                                            .layoutPriority(1)
                                    }
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/4)
                            }
                        }
                    }
                    .padding()
                }
                .padding()
                
                Spacer()
                if UIDevice.current.userInterfaceIdiom != .phone {
                    GeometryReader{geometry in
                        VStack {
                            Spacer() // This will push the button to the middle
                            HStack {
                                Spacer()
                                Button(action: {
                                    showNewRecipeModal = true
                                }, label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Add a Recipe")
                                    }
                                    .font(.largeTitle)
                                    .padding()
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
                                    .background(RoundedRectangle(cornerRadius: 12.0).fill(Color("MainColor")))
                                })
                                .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                                Spacer()
                            }
                            
                            Spacer() // This will also push the button to the middle
                        }
                        .frame(height: geometry.size.height)
                        
                    }
                }
            }
        }

        .fullScreenCover(isPresented: $showNewRecipeModal) {
            EditRecipeView(recipe: nil)
        }
        
    }
}

//#Preview {
//    HomePageView()
//}
