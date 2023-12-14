//
//  ContentView.swift
//  Recipes
//
//  Created by Noelia Root on 11/16/23.
//
// Segment View: https://stackoverflow.com/questions/73673083/swiftui-segmented-control-how-to-switch-to-other-segment-on-tap-in-first-segme

import SwiftUI
import SwiftData
import MarkdownUI


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @Query private var categories: [Category]
    @State private var searchText = ""
    @State var showNewRecipeModal = false
    @State private var showCategorySheet = false
    @State private var showSearchOptionsSheet = false
    @State private var currentCategory: String = "All Recipes"
    @State private var isInitialized = false
    @State var selectedSegment: RecipeSegment = .ingredients
    
    @State private var searchInTitle = true
    @State private var searchInAuthor = false
    @State private var searchInNotes = false
    @State private var searchInIngredients = false
    @State private var searchInDirections = false
    @FocusState private var isSearchBarFocused: Bool
    
    private var filteredRecipes: [Recipe] {
        if currentCategory == "All Recipes" {
            return recipes
        } else if currentCategory == "Most Recent" {
            return recipes.sorted(by: {
                guard let date1 = DateFormatter.myCustomFormatter.date(from: $0.dateLastViewed),
                      let date2 = DateFormatter.myCustomFormatter.date(from: $1.dateLastViewed) else { return false }
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
    
    private var searchFilteredRecipes: [Recipe] {
        guard !searchText.isEmpty else {return filteredRecipes}
        return filteredRecipes.filter { recipe in
            (searchInTitle && recipe.title.localizedCaseInsensitiveContains(searchText)) ||
            (searchInAuthor && recipe.author.localizedCaseInsensitiveContains(searchText)) ||
            (searchInNotes && (recipe.notes?.localizedCaseInsensitiveContains(searchText) ?? false)) ||
            (searchInIngredients && recipe.ingredients.contains(where: {
                $0.ingredient.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText)
            })) ||
            (searchInDirections && recipe.directions.contains(where: {
                $0.direction.localizedCaseInsensitiveContains(searchText)
            }))
        }
    }
    
    var headerView: some View {
            HStack {
                SelectCategoryView(currentFilter: $currentCategory, showCategorySheet: $showCategorySheet)
                Spacer()
                SearchFilter(showSearchOptionsSheet: $showSearchOptionsSheet)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .background(Color("MainColor"))
        }

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0){
               headerView
                if searchFilteredRecipes.isEmpty {
                    Spacer()
                    NoRecipesView()
                    Spacer()
                } else {
                    browseAllList
                }
            }
            .onAppear {
                if !isInitialized {
                   initializeData()
                   isInitialized = true
               }
                UISearchBar.appearance().backgroundColor = .red
                UISearchBar.appearance().tintColor = .white
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
                UISearchBar.appearance().overrideUserInterfaceStyle = .light
            }
            .fullScreenCover(isPresented: $showNewRecipeModal) {
                EditRecipeView(recipe: nil)
            }
            .sheet(isPresented: $showCategorySheet) {
                CategorySheetView(currentFilter: $currentCategory)
            }
            .sheet(isPresented: $showSearchOptionsSheet){
                SearchOptionsSheetView(searchInTitle: $searchInTitle, searchInAuthor: $searchInAuthor, searchInNotes: $searchInNotes, searchInIngredients: $searchInIngredients, searchInDirections: $searchInDirections)
            }
            .navigationBarBackground()
            .navigationTitle("").navigationBarTitleDisplayMode(.inline)
            .toolbar {                                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            HomePageView()
        }
        .searchable(text: $searchText, prompt: "Search for a recipe")

    }
    
    private func recipeImageView(recipe: Recipe, size: CGSize) -> some View {
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
        .frame(width: 80, height: 60)
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
    @State var showScalePopover = false
    @State var scaleForPopover: Double = 1
    private var browseAllList: some View {
            List{
                ForEach(searchFilteredRecipes) { recipe in
                    NavigationLink {
                        RecipeInformationView(recipe: recipe)
                    } label: {
                        RecipeCardView(recipe: recipe)
                         .padding(EdgeInsets())
                         .swipeActions(allowsFullSwipe: false) {
                             
                             Button(role: .destructive) {
                                 deleteRecipe(recipe)
                             } label: {
                                 Label("Delete", systemImage: "trash")
                             }
                             .tint(Color("MainColor"))
                             
                             if !(currentCategory == "Most Recent" || currentCategory == "Uncategorized" || currentCategory == "All Recipes" || currentCategory == "Favorites") {
                                 Button {
                                     removeRecipeFromCategory(recipe: recipe)
                                 } label: {
                                     Label("Remove from Category", systemImage: "folder.badge.minus")
                                 }
                                 .tint(.indigo)
                             }
                             
                             if (currentCategory == "Favorites") {
                                 Button {
                                     removeRecipeFromFavorites(recipe: recipe)
                                 } label: {
                                     Label("Remove from Favorites", systemImage: "heart")
                                 }
                                 .tint(.indigo)
                             }

                        }
                    }
                    

                    
                }
                .onDelete(perform: deleteItems)
                .listRowSeparator(.hidden, edges: .all)
            }
            .listStyle(.inset)
            .listRowInsets(EdgeInsets())
           
            
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    }
    


    private func addItem() {
        showNewRecipeModal = true
    }
    

    private func deleteRecipe(_ recipe: Recipe) {
        withAnimation {
            if let index = searchFilteredRecipes.firstIndex(of: recipe) {
                modelContext.delete(searchFilteredRecipes[index])
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
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

    
    private func removeRecipeFromCategory(recipe: Recipe) {
        withAnimation{
            recipe.categories.removeAll(where: {$0.name == currentCategory})
        }
    }
    
    private func removeRecipeFromFavorites(recipe: Recipe) {
        withAnimation{
            recipe.isFavorited = false
        }
    }
    

}


//#Preview {
//    ContentView()
//        .modelContainer(for: Recipe.self, inMemory: true)
//}


