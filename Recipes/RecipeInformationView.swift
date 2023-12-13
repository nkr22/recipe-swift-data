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
    @State var showScalePopover = false
    @State var scaleForPopover: Double = 1
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationStack{
                VStack{
                    VStack(alignment: .leading){
                        Text(recipe.title).font(.headline).fontWeight(.bold).lineLimit(1)
                        HStack {
                            recipeImageView(recipe: recipe)
                                .frame(maxWidth: geometry.size.width/3)
                                .layoutPriority(0)
                            VStack(alignment: .leading) {
                                RatingsDisplayView(maxRating: 5, currentRating: recipe.starRating, sfSymbol: "star", width: 30, color: Color("BrightAccentColor"))
                                Text(recipe.author)
                                    .lineLimit(1)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.gray)
                                recipeSourceView(recipe: recipe)
                            }
                            .layoutPriority(1)
                            .padding(.leading)
                            Spacer()
                        }
                    }
                    .padding()
                    HStack{
                        Button(action: {
                            showScalePopover = true
                        }, label: {
                            Label("Current Scale: \(recipe.currentScale, specifier: "%.2f")", systemImage: "slider.horizontal.3")
                        })
                        .foregroundStyle(.blue)
                        .popover(isPresented: $showScalePopover, attachmentAnchor: .point(.bottom), arrowEdge: .bottom) {
                            NavigationStack{
                                ScalePopoverView(scaleValue: $scaleForPopover)
                                    .toolbar{
                                        ToolbarItem(placement: .topBarTrailing) {
                                            Button(action: {
                                                showScalePopover = false
                                            }) {
                                                Text("Done")
                                            }
                                        }
                                    }
                                    .navigationBarBackground()
                            }
                            .frame(minWidth: 200, minHeight: 200)
                            .presentationCompactAdaptation(.popover)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    Picker("", selection: $selectedSegment) {
                        ForEach(RecipeSegment.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                        .foregroundStyle(Color("MainColor"))
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    RecipeSegmentedView(segment: selectedSegment, recipe: recipe, currentScale: scaleForPopover)
                    
                }
                .fullScreenCover(isPresented: $showEditRecipeModal) {
                    EditRecipeView(recipe: recipe)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: editRecipe) {
                            Label("Edit", systemImage: "pencil")
                                .labelStyle(.titleAndIcon)
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
    }
    
    private func recipeImageView(recipe: Recipe) -> some View {
        Group {
            if let imageData = recipe.imageURL, let uiImage = UIImage(data: imageData)  {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.gray)
            }
        }
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
     
    private func recipeSourceView(recipe: Recipe) -> some View {
        Group {
            if let sourceData = recipe.sourceURL, let url = URL(string: sourceData) {
                Link("\(sourceData)", destination: url)
                    .foregroundStyle(.blue)
            } else {
                Text("Unknown source")
                    .foregroundStyle(.gray)
            }
        }
        .lineLimit(1)
    }
    
    private func editRecipe() {
        showEditRecipeModal = true
    }
    
    private func updateDateLastViewed(for recipe: Recipe) {
        let currentDate = Date()
        recipe.dateLastViewed = dateFormatter.string(from: currentDate)
        // Save the changes to the model context if necessary
        try? modelContext.save()
    }
}

enum RecipeSegment: String, CaseIterable {
    case ingredients = "Ingredients"
    case directions = "Directions"
}


struct RecipeSegmentedView: View {
    var segment: RecipeSegment
    var recipe: Recipe
    var currentScale: Double

    var body: some View {
        switch segment {
        case .ingredients:
            IngredientsView(ingredients: recipe.ingredients, currentScale: currentScale)
        case .directions:
            DirectionsView(directions: recipe.directions)
        }
    }
}


struct ScalePopoverView: View {
    @Binding var scaleValue: Double

    var body: some View {
        // This is just a simple example; you can customize it as needed
        VStack {
            Text("Scale Ingredients")
                .font(.headline)

            Slider(value: $scaleValue, in: 0.5...3.0, step: 0.5)
            Text("Scale: \(scaleValue, specifier: "%.1f")x")
        }
        .padding()
    }
}

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
        }
    }
}

struct DirectionsView: View {
    var directions: [Direction]

    var body: some View {
        List(directions.sorted { $0.order < $1.order }, id: \.self) { direction in
            Text("\(direction.order). \(direction.direction)")
        }
    }
}

//#Preview {
//    RecipeInformationView()
//}
