//
//  RecipeInformationView.swift
//  Recipes
//
//  Created by Noelia Root on 12/11/23.
//

import SwiftUI
import SwiftData

struct RecipeInformationView: View {
    let recipe: Recipe
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var selectedSegment: RecipeSegment = .ingredients
    @State var showEditRecipeModal = false
    @State var scaleForPopover: Double = 1
    private var formattedCategoryListString: String {
        recipe.categories.map { $0.name }.joined(separator: ", ")
    }
    var body: some View {
        List{
            Section{
                GeometryReader{ geometry in
                    NavigationStack{
                        VStack{
                            VStack(alignment: .leading){
                                Text(recipe.title)
                                    .font(.system(size: min(geometry.size.width * 0.06, 24)))
                                    .fontWeight(.bold).lineLimit(1)
                                HStack {
                                    recipeImageView(recipe: recipe, size: geometry.size)
                                        .layoutPriority(0)
                                    VStack(alignment: .leading) {
                                        RatingsDisplayView(maxRating: 5, currentRating: recipe.starRating, sfSymbol: "star", width: min(geometry.size.width*0.06, 36), color: Color("BrightAccentColor"))
                                        Text(recipe.author)
                                            .lineLimit(1)
                                            .fontWeight(.bold)
                                            .font(.system(size: min(geometry.size.width * 0.04, 24)))
                                        Text(formattedCategoryListString)
                                            .font(.system(size: min(geometry.size.width * 0.04, 24)))
                                        MealInfoDisplayView(recipe: recipe)
                                            .font(.system(size: min(geometry.size.width * 0.04, 24)))
                                            .foregroundStyle(.gray)
                                    }
                                    .layoutPriority(1)
                                    .padding(.leading)
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            Picker("", selection: $selectedSegment) {
                                ForEach(RecipeSegment.allCases, id: \.self) {
                                    Text($0.rawValue)
                                        .font(.system(size: min(geometry.size.width * 0.04, 24)))
                                }
                                .foregroundStyle(Color("MainColor"))
                            }
                            .pickerStyle(.segmented)        
                        }
                        .fullScreenCover(isPresented: $showEditRecipeModal) {
                            EditRecipeView(recipe: recipe)
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: editRecipe) {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                        }
                        .navigationBarBackground()
                        .navigationTitle("Recipe Details")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .onAppear{
                        updateDateLastViewed(for: recipe)
                        scaleForPopover = recipe.currentScale
                    }
                    .onChange(of: scaleForPopover) {
                        recipe.currentScale = scaleForPopover
                    }
                }
                .frame(height: calculateHeightForSection())
                RecipeSegmentedView(segment: selectedSegment, recipe: recipe, currentScale: $scaleForPopover)
            }
        }
        .listStyle(PlainListStyle())
    }

    private func calculateHeightForSection() -> CGFloat {
        let imageHeight = min(UIScreen.main.bounds.width * 0.25, 200)
        let baseHeight: CGFloat = imageHeight * 1.25
        let isLandscape = UIDevice.current.orientation.isLandscape
        let extraPadding: CGFloat = isLandscape ? 30 : 50
        return baseHeight + extraPadding
    }
    
    private func editRecipe() {
        showEditRecipeModal = true
    }
    
    private func recipeImageView(recipe: Recipe, size: CGSize) -> some View {
        let width = min(size.width * 0.25, 200)
        return(
            Group {
                if let imageData = recipe.imageURL, let uiImage = UIImage(data: imageData)  {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundColor(.gray)
                }
            }
            .scaledToFill()
            .frame(width: width, height: width)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        )
    }
    
    private func updateDateLastViewed(for recipe: Recipe) {
        let currentDate = Date()
        recipe.dateLastViewed = DateFormatter.myCustomFormatter.string(from: currentDate)
        // Save the changes to the model context if necessary
        try? modelContext.save()
    }
}

//#Preview {
//    RecipeInformationView()
//}
