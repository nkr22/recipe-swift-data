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
    let recipe: Recipe?
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Category.name) private var allCategories: [Category]
    @State private var title = ""
    @State private var author = ""
    @State private var isFavorited: Bool = false
    @State private var starRating: Int? = nil
    @State private var expertiseRequired = ExpertiseLevel.beginner
    @State private var sourceURL: String = ""
    @State private var prepTime: PrepTime? = nil
    @State private var cookTime: CookTime? = nil
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
    
    @State private var prepTimeValue: Double?
    @State private var cookTimeValue: Double?
    @State private var selectedPrepUnit: TimeUnit = .minutes
    @State private var selectedCookUnit: TimeUnit = .minutes
    
    let df = DateFormatter()
    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func addIngredient () {
        ingredients.append(Ingredient(amount: "", unit: "", ingredient: "", notes: ""))
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
                    // Additional fields for prepTime, cookTime, servings, etc.
                    Toggle("Favorited Recipe", isOn: $isFavorited)
                    MultiSelector(label: Text("Select Categories"), options: allCategories, optionToString: {$0.name}, selected: $selectedCategories)

                    
                }
                
                Section(header: Text("Additional Information")) {
                    HStack {
                        Text("Rating")
                            .foregroundColor(.secondary)
                        Spacer()
                        RatingsView(maxRating: 5, currentRating: $starRating, sfSymbol: "star", width: 30.0, color: Color("BrightAccentColor"))
                    }
                    TextField("Source URL", text: $sourceURL)
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
                                    .foregroundStyle(Color("MainColor"))
                            }
                        }
                }
                Section(header: Text("Meal Information")) {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Servings:")
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            TextField("e.g. 5", value: $servings, formatter: decimalFormatter)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Prep Time:")
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            TextField("e.g. 20", value: $prepTimeValue, formatter: decimalFormatter)
                                .keyboardType(.numberPad)
                            Picker("", selection: $selectedPrepUnit) {
                                ForEach(TimeUnit.allCases) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 100)
                        }
                        
                        HStack {
                            Text("Cook Time:")
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            TextField("e.g. 20", value: $cookTimeValue, formatter: decimalFormatter)
                                .keyboardType(.numberPad)
                            Picker("", selection: $selectedCookUnit) {
                                ForEach(TimeUnit.allCases) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 100)
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
                    TextField("Notes", text: $notes, axis: .vertical).multilineTextAlignment(.leading)
                }
            
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
//                ToolbarItem {
//                    HeartFavoriteView(isFavorited: $isFavorited, sfSymbol: "heart", width: 30.0, color: .systemRed)
//                }
                ToolbarItem(placement: .topBarTrailing) {
                   Button("Save") {
                       if let recipe {
                           if isChanged {
                               recipe.title = title
                               recipe.author = author
                               recipe.expertiseRequired = expertiseRequired
                               recipe.sourceURL = sourceURL
                               recipe.prepTime?.value = prepTimeValue ?? recipe.prepTime?.value ?? 0
                               recipe.cookTime?.value = cookTimeValue ?? recipe.cookTime?.value ?? 0
                               recipe.prepTime?.unit = selectedPrepUnit
                               recipe.cookTime?.unit = selectedCookUnit
                               recipe.prepTime?.unit = selectedPrepUnit
                               recipe.cookTime?.unit = selectedCookUnit
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
                       } else {
                           let newPrepTime = prepTimeValue != nil ? PrepTime(value: prepTimeValue!, unit: selectedPrepUnit) : nil
                           let newCookTime = cookTimeValue != nil ? CookTime(value: cookTimeValue!, unit: selectedCookUnit) : nil

                           let newRecipe =
                           Recipe(
                               title: title,
                               author: author,
                               dateCreated: df.string(from: Date()),
                               expertiseRequired: expertiseRequired,
                               dateLastViewed: df.string(from: Date()),
                               sourceURL: sourceURL,
                               prepTime: newPrepTime,
                               cookTime: newCookTime,
                               servings: servings,
                               currentScale: 1,
                               isFavorited: isFavorited,
                               starRating: starRating,
                               imageURL: imageData,
                               notes: notes,
                               directions: directions,
                               ingredients: ingredients,
                               categories: Array(categories)
                           )
                           context.insert(newRecipe)
                           dismiss()
                       }
                   }
               }
            }
            .navigationBarBackground()
            .navigationTitle((recipe != nil) ? "Edit Recipe" : "New Recipe")
            .navigationBarTitleDisplayMode(.inline)

            .onAppear() {
                if !isInitialized {
                    initializeViewWithRecipe(recipe)
                }

            }
        }

        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                imageData = data
            }
        }
    
    }
    
    private func initializeViewWithRecipe(_ recipe: Recipe?) {
           if let recipe {
               title = recipe.title
               author = recipe.author
               expertiseRequired = recipe.expertiseRequired
               recipe.dateLastViewed = df.string(from: Date())
               sourceURL = recipe.sourceURL ?? ""
               imageData = recipe.imageURL
               prepTime = recipe.prepTime
               cookTime = recipe.cookTime
               prepTimeValue = prepTime?.value ?? 0
               cookTimeValue = cookTime?.value ?? 0
               selectedPrepUnit = prepTime?.unit ?? TimeUnit.minutes
               selectedCookUnit = cookTime?.unit ?? TimeUnit.minutes
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
           isInitialized = true
       }
    
    private var isChanged: Bool {
        if let recipe {
            title != recipe.title ||
            author != recipe.author ||
            expertiseRequired != recipe.expertiseRequired ||
            sourceURL != recipe.sourceURL ||
            prepTimeValue != recipe.prepTime?.value ||
            selectedPrepUnit != recipe.prepTime?.unit ||
            cookTimeValue != recipe.cookTime?.value ||
            selectedCookUnit != recipe.cookTime?.unit ||
            servings != recipe.servings ||
            isFavorited != recipe.isFavorited ||
            starRating != recipe.starRating ||
            notes != recipe.notes ||
            directions != recipe.directions ||
            ingredients != recipe.ingredients ||
            Array(selectedCategories) != recipe.categories ||
            imageData != recipe.imageURL
        } else {
            false
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
