//
//  ContentView.swift
//  Recipes
//
//  Created by Noelia Root on 11/16/23.
//

import SwiftUI
import SwiftData
import MarkdownUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @Query private var categories: [Category]
    @State private var searchText = ""
    @State var showNewRecipeModal = false
    @State var showEditRecipeModal = false
    @State private var showCategorySheet = false
    @State private var currentCategory: String = "All"
    @State private var isInitialized = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" 
        return formatter
    }()
    
    private var filteredRecipes: [Recipe] {
        if currentCategory == "All" {
            return recipes
        } else if currentCategory == "Most Recent" {
            return recipes.sorted(by: {
                guard let date1 = dateFormatter.date(from: $0.dateLastViewed),
                      let date2 = dateFormatter.date(from: $1.dateLastViewed) else { return false }
                return date1 > date2
            })
        } else if currentCategory == "Favorites" {
            return recipes.filter { $0.isFavorited == true}
        } else if currentCategory == "Uncategorized" {
            return recipes.filter { $0.categories.isEmpty }
        } else {
            return recipes.filter { $0.categories.contains(where: { $0.name == currentCategory }) }
        }
    }

    var body: some View {
        NavigationSplitView {
            TabView {
                VStack{
                    SelectCategoryView(currentFilter: $currentCategory, showCategorySheet: $showCategorySheet)
                        .padding(.bottom, 10)

                    if filteredRecipes.isEmpty {
                        Spacer()
                        NoRecipesView()
                        Spacer()
                    } else {
//                        SearchableListView(recipes: filteredRecipes, searchText: $searchText)
                        browseAllList
                    }
                }
                .tabItem{
                    Label("Recipes", systemImage: "list.bullet")
                }
                HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            }
            
            
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    SearchFilter()
                }
#if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
        }
            
        } detail: {
            HomePageView()
        }
        .onAppear {
            if !isInitialized {
               initializeData()
               isInitialized = true
           }
}
        .fullScreenCover(isPresented: $showNewRecipeModal) {
           NewRecipe()
        }
        .sheet(isPresented: $showCategorySheet) {
            CategorySheetView(currentFilter: $currentCategory)
        }
        .searchable(text: $searchText, prompt: "Search for a recipe")
        .navigationTitle("New Recipe")
        
    }
    
    private var browseAllList: some View {
        List {
            ForEach(filteredRecipes) { recipe in
                NavigationLink {
                    
                    VStack{
                        List {
                            ForEach(recipe.categories, id: \.self) { category in
                                Markdown {
                                    "\(category.name)"
                                }
                            }
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Markdown {
                                    "\(ingredient.quantity) \(ingredient.ingredient) \(ingredient.notes)"
                                }
                            }
                            let sortedDirections = recipe.directions.sorted { $0.order < $1.order }
                            ForEach(sortedDirections, id: \.self) { direction in
                                Markdown {
                                    "\(direction.order). \(direction.direction)"
                                }
                            }
                        }
                        
                    }
                    .onAppear{
                        updateDateLastViewed(for: recipe)
                    }
                    
                    .fullScreenCover(isPresented: $showEditRecipeModal) {
                       EditRecipeView(recipe: recipe)
                    }
                    .toolbar {
        #if os(iOS)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: editRecipe) {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                        
        #endif
                        ToolbarItem {
                            Button(action: addItem) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                }

                } label: {
                    RecipeComponentView(recipe: recipe)
                }
                
            }
            .onDelete(perform: deleteItems)
            
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    }

    private func addItem() {
        showNewRecipeModal = true
    }
    
    private func editRecipe() {
        showEditRecipeModal = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
            }
        }
    }
    
    private func initializeData() {
        initializeRecipes()
        initializeCategories()
    }
    
    private func initializeRecipes() {
        if let recipes = loadJson(filename: "RecipesInitializer") {
            for recipe in recipes {
                modelContext.insert(
                    Recipe(title: recipe.title,
                           author: recipe.author,
                           dateCreated: recipe.dateCreated,
                           expertiseRequired: recipe.expertiseRequired,
                           dateLastViewed: recipe.dateLastViewed,
                           sourceURL: recipe.sourceURL,
                           prepTime: recipe.prepTime,
                           cookTime: recipe.cookTime,
                           servings: recipe.servings,
                           currentScale: recipe.currentScale,
                           isFavorited: recipe.isFavorited,
                           starRating: recipe.starRating,
                           imageURL: recipe.imageURL,
                           notes: recipe.notes,
                           directions: recipe.directions,
                           ingredients: recipe.ingredients,
                           categories: recipe.categories
                          )
                    )
            }
        }
    }
    private func initializeCategories() {
        if let categories = loadCategoryJson(filename: "CategoriesInitializer") {
            for category in categories {
                modelContext.insert(
                    Category(name: category.name)
                )
            }
        }
    }
    
    private func updateDateLastViewed(for recipe: Recipe) {
        let currentDate = Date()
        recipe.dateLastViewed = dateFormatter.string(from: currentDate)
        // Save the changes to the model context if necessary
        try? modelContext.save()
    }
}

//struct SearchableListView: View {
//    var recipes: [Recipe]
//    @Binding var searchText: String
//
//
//    private var filteredRecipes: [Recipe] {
//            if searchText.isEmpty {
//                return recipes
//            } else {
//                return recipes.filter { recipe in
//                    (searchInTitle && recipe.title.localizedCaseInsensitiveContains(searchText)) ||
//                    (searchInAuthor && recipe.author.localizedCaseInsensitiveContains(searchText)) ||
//                    (searchInNotes && (recipe.notes?.localizedCaseInsensitiveContains(searchText) ?? false)) ||
//                    (searchInIngredients && recipe.ingredients.contains(where: {
//                        $0.ingredient.localizedCaseInsensitiveContains(searchText) ||
//                        $0.notes.localizedCaseInsensitiveContains(searchText)
//                    })) ||
//                    (searchInDirections && recipe.directions.contains(where: {
//                        $0.direction.localizedCaseInsensitiveContains(searchText)
//                    }))
//                }
//            }
//        }
//
//
//    var body: some View {
//        VStack{
//            
//            List {
//                ForEach(filteredRecipes) { recipe in
//                    NavigationLink {
//                        // Navigation link content...
//                    } label: {
//                        Text(recipe.title)
//                    }
//                }
//            }
//        }
//    }
//}

struct SearchFilter: View {
    @State private var searchInTitle = true
    @State private var searchInAuthor = false
    @State private var searchInNotes = false
    @State private var searchInIngredients = false
    @State private var searchInDirections = false
    
    var body: some View{
        Menu {
            Toggle("Search in Title", isOn: $searchInTitle)
            Toggle("Search in Author", isOn: $searchInAuthor)
            Toggle("Search in Notes", isOn: $searchInNotes)
            Toggle("Search in Ingredients", isOn: $searchInIngredients)
            Toggle("Search in Direction", isOn: $searchInDirections)
        } label: {
            Label("Search Options", systemImage: "slider.horizontal.3")
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recipe.self, inMemory: true)
}


