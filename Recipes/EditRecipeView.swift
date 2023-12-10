//
//  EditRecipeView.swift
//  Recipes
//
//  Created by Noelia Root on 11/30/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditRecipeView: View {
    let recipe: Recipe
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Category.name) private var allCategories: [Category]
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
    @State private var categories: [Category] = []
    @State private var selectedCategories: Set<Category> = []
    @State private var isInitialized = false
    @State private var imageData: Data? = nil
    @State private var selectedPhoto: PhotosPickerItem?
    
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
                    }
                    TextField("Source URL", text: $sourceURL)
                    // Additional fields for prepTime, cookTime, servings, etc.
                    MultiSelector(label: Text("Select Categories"), options: allCategories, optionToString: {$0.name}, selected: $selectedCategories)
                    if let selectedPhotoData = imageData,
                           let uiImage = UIImage(data: selectedPhotoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                                        Label("Add Image", systemImage: "photo")
                                    }
                    if imageData != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    selectedPhoto = nil
                                    imageData = nil
                                }
                            } label: {
                                Label("Remove Image", systemImage: "xmark")
                                    .foregroundStyle(.red)
                            }
                        }
                    
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
                    ForEach($directions.sorted { $0.order.wrappedValue < $1.order.wrappedValue }, id: \.id) { $direction in
                        DirectionInputView(direction: $direction)
                    }
                    .onDelete(perform: deleteDirection)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes).multilineTextAlignment(.leading)
                }
            
            }
            .navigationTitle("Edit Recipe")
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
                            recipe.categories = Array(selectedCategories)
                            recipe.imageURL = imageData
                        }
                        dismiss()
                    }
                }
            }
            .toolbarBackground(Color.red, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear() {
                if !isInitialized {
                    title = recipe.title
                    author = recipe.author
                    expertiseRequired = recipe.expertiseRequired
                    recipe.dateLastViewed = df.string(from: Date())
                    sourceURL = recipe.sourceURL ?? ""
                    imageData = recipe.imageURL
                    prepTime = recipe.prepTime
                    cookTime = recipe.cookTime
                    servings = recipe.servings
                    isFavorited = recipe.isFavorited
                    starRating = recipe.starRating
                    notes = recipe.notes ?? ""
                    directions = recipe.directions
                    ingredients = recipe.ingredients
                    categories = recipe.categories
                    selectedCategories = Set(recipe.categories)
                    isInitialized = true
                }
            }
        }

        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                imageData = data
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
            ingredients != recipe.ingredients ||
            Array(selectedCategories) != recipe.categories ||
            imageData != recipe.imageURL
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
