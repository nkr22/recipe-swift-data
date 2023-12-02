//
//  EditRecipeView.swift
//  Recipes
//
//  Created by Noelia Root on 11/30/23.
//

import SwiftUI

struct EditRecipeView: View {
    let recipe: Recipe
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var isFavorited: Bool = false
    @State private var starRating: Int? = nil
    @State private var expertiseRequired = ExpertiseLevel.beginner
    @State private var sourceURL: String = ""
    @State private var prepTime: Int? = nil
    @State private var cookTime: Int? = nil
    @State private var servings: Double? = nil
    @State private var notes: String = ""
    @State private var directions: [Direction] = []
    @State private var directionCount: Int = 1
    @State private var ingredients: [Ingredient] = []
    
    let df = DateFormatter()
    
    func addIngredient () {
        ingredients.append(Ingredient(quantity: "", ingredient: "", notes: ""))
    }
    
    func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    func addDirection () {
        directions.append(Direction(order: directionCount , direction: ""))
        directionCount += 1
    }
    
    func deleteDirection(at offsets: IndexSet) {
        directions.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    Picker("Expertise Required", selection: $expertiseRequired) {
                        ForEach(ExpertiseLevel.allCases, id: \.self) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    }
                    HStack {
                        Text("Rating")
                            .foregroundColor(.secondary)
                        Spacer()
                        RatingsView(maxRating: 5, currentRating: $starRating, sfSymbol: "star", width: 30.0, color: .systemYellow)
                            .frame(maxWidth: UIScreen.main.bounds.width/2)
                    }
                    TextField("Source URL", text: $sourceURL)
                    // Additional fields for prepTime, cookTime, servings, etc.
                }

                Section(header: Text("Ingredients")) {
                    Button(action: addIngredient) {
                        Label("Add Ingredient", systemImage: "plus")
                    }
                    ForEach($ingredients, id: \.id) { $ingredient in
                        IngredientInputView(ingredient: $ingredient)
                    }
                    .onDelete(perform: deleteIngredient)
                    
                }
                
                
                Section(header: Text("Directions")) {
                    Button(action: addDirection) {
                        Label("Add Direction", systemImage: "plus")
                    }
                    ForEach($directions, id: \.id) { $direction in
                        DirectionInputView(direction: $direction)
                    }
                    .onDelete(perform: deleteDirection)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                }
            
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem {
                    HeartFavoriteView(isFavorited: $isFavorited, sfSymbol: "heart", width: 30.0, color: .systemRed)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if isChanged {
                            recipe.title = title
                            recipe.author = author
                            recipe.expertiseRequired = expertiseRequired
                            recipe.sourceURL = sourceURL
                            recipe.prepTime = prepTime
                            recipe.cookTime = cookTime
                            recipe.servings = servings
                            recipe.isFavorited = isFavorited
                            recipe.starRating = starRating
                            recipe.notes = notes
                            recipe.directions = directions
                            recipe.ingredients = ingredients
                        }
                    }
                }
            }
            .onAppear() {
                title = recipe.title
                author = recipe.author
                expertiseRequired = recipe.expertiseRequired
                recipe.dateLastViewed = df.string(from: Date())
                sourceURL = recipe.sourceURL ?? ""
                prepTime = recipe.prepTime
                cookTime = recipe.cookTime
                servings = recipe.servings
                isFavorited = recipe.isFavorited
                starRating = recipe.starRating
                notes = recipe.notes ?? ""
                directions = recipe.directions
                ingredients = recipe.ingredients
            }
        }
        
        var isChanged: Bool {
            title != recipe.title ||
            author != recipe.author ||
            expertiseRequired != recipe.expertiseRequired ||
            sourceURL != recipe.sourceURL ||
            prepTime != recipe.prepTime ||
            cookTime != recipe.cookTime ||
            servings != recipe.servings ||
            isFavorited != recipe.isFavorited ||
            starRating != recipe.starRating ||
            notes != recipe.notes ||
            directions != recipe.directions ||
            ingredients != recipe.ingredients
        }
    }
}

//#Preview {
//    let df = DateFormatter()
//    let recipe =  Recipe(
//        title: "Cake",
//        author: "Noelia Root",
//        dateCreated: df.string(from: Date()),
//        expertiseRequired: ExpertiseLevel.beginner,
//        dateLastViewed: df.string(from: Date()),
//        sourceURL: "",
//        prepTime: 15,
//        cookTime: 35,
//        servings: 4,
//        currentScale: 1,
//        isFavorited: false,
//        starRating: 3,
//        imageURL: "",
//        notes: "",
//        directions: [Direction(order: 1, direction: "Mix Stuff")],
//        ingredients: [Ingredient(quantity: "1 cup", ingredient: "flour", notes: "Unbleached")]
//    )
//    EditRecipeView(recipe: recipe)
//}
