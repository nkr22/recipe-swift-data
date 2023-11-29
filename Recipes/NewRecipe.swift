//
//  NewRecipe.swift
//  Recipes
//
//  Created by Noelia Root on 11/27/23.
//

import SwiftUI

struct NewRecipe: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
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
            
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newRecipe =
                        Recipe(
                            title: title,
                            author: author,
                            dateCreated: df.string(from: Date()),
                            expertiseRequired: expertiseRequired,
                            dateLastViewed: df.string(from: Date()),
                            sourceURL: sourceURL,
                            prepTime: prepTime,
                            cookTime: cookTime,
                            servings: servings,
                            currentScale: 1,
                            isFavorited: false,
                            starRating: 3,
                            imageURL: "",
                            notes: notes,
                            directions: directions,
                            ingredients: ingredients
                        )
                        context.insert(newRecipe)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewRecipe()
}
