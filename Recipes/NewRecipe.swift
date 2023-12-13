////
////  NewRecipe.swift
////  Recipes
////
////  Created by Noelia Root on 11/27/23.
////
//
//import SwiftUI
//import SwiftData
//import PhotosUI
//
//struct NewRecipe: View {
//    @Environment(\.modelContext) private var context
//    @Query(sort: \Category.name)  private var allCategories: [Category]
//    @Environment(\.dismiss) var dismiss
//    @State private var title = ""
//    @State private var author = ""
//    @State private var isFavorited: Bool = false
//    @State private var starRating: Int? = nil
//    @State private var expertiseRequired = ExpertiseLevel.beginner
//    @State private var sourceURL: String = ""
//    @State private var prepTime: PrepTime? = nil
//    @State private var cookTime: CookTime? = nil
//    @State private var servings: Double? = nil
//    @State private var notes: String = ""
//    @State private var directions: [Direction] = []
//    @State private var directionCount: Int = 1
//    @State private var ingredients: [Ingredient] = []
//    @State private var categories: Set<Category> = []
//    @State private var imageData: Data? = nil
//    @State private var selectedPhoto: PhotosPickerItem?
//    
//    @State private var ingredientsSectionExpanded = true
//        @State private var directionsSectionExpanded = true
//    
//    let df = DateFormatter()
//    
//    func addIngredient () {
//        ingredients.append(Ingredient(amount: "", unit: "", ingredient: "", notes: ""))
//    }
//    
//    func deleteIngredient(at offsets: IndexSet) {
//        ingredients.remove(atOffsets: offsets)
//    }
//    
//    func addDirection () {
//        directions.append(Direction(order: directionCount , direction: ""))
//        directionCount += 1
//    }
//    
//    func deleteDirection(at offsets: IndexSet) {
//        directions.remove(atOffsets: offsets)
//    }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Basic Information")) {
//                    TextField("Title", text: $title)
//                    TextField("Author", text: $author)
//                    Picker("Expertise Required", selection: $expertiseRequired) {
//                        ForEach(ExpertiseLevel.allCases, id: \.self) { level in
//                            Text(level.rawValue.capitalized).tag(level)
//                        }
//                    }
//                    HStack {
//                        Text("Rating")
//                            .foregroundColor(.secondary)
//                        Spacer()
//                        RatingsView(maxRating: 5, currentRating: $starRating, sfSymbol: "star", width: 30.0, color: Color("BrightAccentColor"))
//                    }
//                    TextField("Source URL", text: $sourceURL)
//                    MultiSelector(label: Text("Select Categories"), options: allCategories, optionToString: {$0.name}, selected: $categories)
//                    if let selectedPhotoData = imageData,
//                           let uiImage = UIImage(data: selectedPhotoData) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(maxWidth: .infinity, maxHeight: 300)
//                        }
//                    PhotosPicker(selection: $selectedPhoto,
//                                 matching: .images,
//                                 photoLibrary: .shared()) {
//                                        Label("Add Image", systemImage: "photo")
//                                    }
//                    if imageData != nil {
//                            Button(role: .destructive) {
//                                withAnimation {
//                                    selectedPhoto = nil
//                                    imageData = nil
//                                }
//                            } label: {
//                                Label("Remove Image", systemImage: "xmark")
//                                    .foregroundStyle(Color("MainColor"))
//                            }
//                        }
//                                    
//                }
//
//                Section(header: Text("Ingredients")) {
//                    Button(action: addIngredient) {
//                        Label("Add Ingredient", systemImage: "plus")
//                            .foregroundStyle(Color("MainColor"))
//                    }
//                    ForEach($ingredients, id: \.id) { $ingredient in
//                        IngredientInputView(ingredient: $ingredient)
//                    }
//                    .onDelete(perform: deleteIngredient)
//                    
//                }
//                
//                
//                Section(header: Text("Directions")) {
//                    Button(action: addDirection) {
//                        Label("Add Direction", systemImage: "plus")
//                            .foregroundStyle(Color("MainColor"))
//                    }
//                    ForEach($directions.sorted { $0.order.wrappedValue < $1.order.wrappedValue }, id: \.id) { $direction in
//                        DirectionInputView(direction: $direction)
//                    }
//                    .onDelete(perform: deleteDirection)
//                }
//                
//                Section(header: Text("Notes")) {
//                    TextField("Notes", text: $notes, axis: .vertical).multilineTextAlignment(.leading)
//                }
//            
//            }
//            .navigationTitle("New Recipe")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem {
//                    HeartFavoriteView(isFavorited: $isFavorited, sfSymbol: "heart", width: 30.0, color: .systemRed)
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Save") {
//                        let newRecipe =
//                        Recipe(
//                            title: title,
//                            author: author,
//                            dateCreated: df.string(from: Date()),
//                            expertiseRequired: expertiseRequired,
//                            dateLastViewed: df.string(from: Date()),
//                            sourceURL: sourceURL,
//                            prepTime: prepTime,
//                            cookTime: cookTime,
//                            servings: servings,
//                            currentScale: 1,
//                            isFavorited: isFavorited,
//                            starRating: starRating,
//                            imageURL: imageData,
//                            notes: notes,
//                            directions: directions,
//                            ingredients: ingredients,
//                            categories: Array(categories)
//                        )
//                        context.insert(newRecipe)
//                        dismiss()
//                    }
//                }
//            }
//            .navigationBarBackground()
//            
//            .task(id: selectedPhoto) {
//                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
//                    imageData = data
//                }
//            }
//
//        }
//    }
//}
//
////#Preview {
////    NewRecipe()
////}
