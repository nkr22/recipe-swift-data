//
//  EditRecipeView.swift
//  Recipes
//
//  Created by Noelia Root on 11/30/23.
//
//  Followed this tutorial for images: https://www.youtube.com/watch?v=y3LofRLPUM8&list=PLvUWi5tdh92wZ5_iDMcBpenwTgFNan9T7&index=8

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
    @State private var prepTime: String = ""
    @State private var cookTime: String = ""
    @State private var servings: String = ""
    @State private var notes: String = ""
    @State private var directions: [Direction] = []
    @State private var directionCount: Int = 1
    @State private var ingredients: [Ingredient] = []
    @State private var categories: [Category] = []
    @State private var selectedCategories: Set<Category> = []
    @State private var isInitialized = false
    @State private var imageData: Data? = nil
    @State private var selectedPhoto: PhotosPickerItem?
    
    private var formattedMealInfo: String {
        let servingsString = servings == "" ? servings : "Servings: \(servings)"
        let prepString = prepTime == "" ? prepTime : "\nPrep Time: \(prepTime)"
        let cookString = cookTime == "" ? cookTime : "\nCook Time: \(cookTime)"
        return "\(servingsString) \(prepString) \(cookString)"
    }
    
    private var isChanged: Bool {
        if let recipe {
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
        } else {
            false
        }
    }

    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var additionalInfoView: some View {
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
    }
    
    var basicInfoView: some View {
        Section(header: Text("Basic Information")) {
            LabeledContent {
                TextField("Title", text: $title)
                    .multilineTextAlignment(.trailing)
            } label: {
                Text("Title")
            }
            LabeledContent {
                TextField("Author", text: $author)
                    .multilineTextAlignment(.trailing)
            } label: {
                Text("Author")
            }
            Picker("Expertise Required", selection: $expertiseRequired) {
                ForEach(ExpertiseLevel.allCases, id: \.self) { level in
                    Text(level.rawValue.capitalized).tag(level)
                }
            }
            Toggle("Favorited Recipe", isOn: $isFavorited)
            NavigationLink{
                MealInfoView(servings: $servings, prepTime: $prepTime, cookTime: $cookTime)
            } label: {
                HStack(alignment: .center) {
                    Text("Info")
                    Spacer()
                    Text(formattedMealInfo)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
            }

            MultiSelector(label: Text("Select Categories"), options: allCategories, optionToString: {$0.name}, selected: $selectedCategories)
        }
    }
    
    var ingredientsView: some View {
        Section(header: Text("Ingredients")) {
            Button(action: addIngredient) {
                Label("Add Ingredient", systemImage: "plus")
            }
            ForEach($ingredients, id: \.id) { $ingredient in
                IngredientInputView(ingredient: $ingredient)
            }
            .onDelete(perform: deleteIngredient)
            
        }
    }
    
    var directionsView: some View {
        Section(header: Text("Directions")) {
            Button(action: addDirection) {
                Label("Add Direction", systemImage: "plus")
            }
            ForEach($directions.sorted { $0.order.wrappedValue < $1.order.wrappedValue }, id: \.id) { $direction in
                DirectionInputView(direction: $direction)
            }
            .onDelete(perform: deleteDirection)
        }
    }
    
    var notesView: some View {
        Section(header: Text("Notes")) {
            TextField("Notes", text: $notes, axis: .vertical).multilineTextAlignment(.leading)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                basicInfoView
                additionalInfoView
                ingredientsView
                directionsView
                notesView
            
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                   Button("Save") {
                       if let recipe {
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
                       } else {
                           let newRecipe =
                           Recipe(
                               title: title,
                               author: author,
                               dateCreated: DateFormatter.myCustomFormatter.string(from: Date()),
                               expertiseRequired: expertiseRequired,
                               dateLastViewed: DateFormatter.myCustomFormatter.string(from: Date()),
                               sourceURL: sourceURL,
                               prepTime: prepTime,
                               cookTime: cookTime,
                               servings: servings,
                               currentScale: 1,
                               isFavorited: isFavorited,
                               starRating: starRating,
                               imageURL: imageData,
                               notes: notes,
                               directions: directions,
                               ingredients: ingredients,
                               categories: Array(selectedCategories)
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
    
    private func addIngredient () {
        ingredients.append(Ingredient(amount: "", unit: "", ingredient: "", notes: ""))
    }
    
    private func addDirection () {
        directions.append(Direction(order: directionCount , direction: ""))
        directionCount += 1
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    private func deleteDirection(at offsets: IndexSet) {
        directions.remove(atOffsets: offsets)
    }
    
    private func initializeViewWithRecipe(_ recipe: Recipe?) {
           if let recipe {
               title = recipe.title
               author = recipe.author
               expertiseRequired = recipe.expertiseRequired
               recipe.dateLastViewed = DateFormatter.myCustomFormatter.string(from: Date())
               sourceURL = recipe.sourceURL ?? ""
               imageData = recipe.imageURL
               prepTime = recipe.prepTime ?? ""
               cookTime = recipe.cookTime ?? ""
               servings = recipe.servings ?? ""
               isFavorited = recipe.isFavorited
               starRating = recipe.starRating
               notes = recipe.notes ?? ""
               directions = recipe.directions
               ingredients = recipe.ingredients
               categories = recipe.categories
               selectedCategories = Set(recipe.categories)
               directionCount = recipe.directions.count + 1
               isInitialized = true
           }
           isInitialized = true
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
