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
    @State var showEditRecipeModal = false
    @State private var showCategorySheet = false
    @State private var currentCategory: String = "All"
    @State private var isInitialized = false
    @State var selectedSegment: RecipeSegment = .ingredients
    
    @State private var searchInTitle = true
    @State private var searchInAuthor = false
    @State private var searchInNotes = false
    @State private var searchInIngredients = false
    @State private var searchInDirections = false
    @FocusState private var isSearchBarFocused: Bool
    
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
    
    private var searchFilteredRecipes: [Recipe] {
        guard !searchText.isEmpty else {return filteredRecipes}
        return recipes.filter { recipe in
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
    
    private var searchOptionsView: some View {
        VStack(alignment: .leading) {
//            Toggle("Search in Title", isOn: $searchInTitle)
//            Toggle("Search in Author", isOn: $searchInAuthor)
            // ... other search option toggles
            Rectangle()
                .fill(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    var body: some View {
        NavigationSplitView {
            VStack{

                if searchFilteredRecipes.isEmpty {
                    Spacer()
                    NoRecipesView()
                    Spacer()
                } else {
//                        SearchableListView(recipes: filteredRecipes, searchText: $searchText)
                    if isSearchBarFocused {
                        searchOptionsView // Your custom view for search options
                    }
                    browseAllList
                }
            }
            .toolbar {

                ToolbarItem(placement: .principal) {
                    SelectCategoryView(currentFilter: $currentCategory, showCategorySheet: $showCategorySheet)
                        .padding(.bottom, 10)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    SearchFilter(searchInTitle: $searchInTitle, searchInAuthor: $searchInAuthor, searchInNotes: $searchInNotes, searchInIngredients: $searchInIngredients, searchInDirections: $searchInDirections)
                }
                                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
//            .toolbarTitleMenu{
//               Button("blah") {
//                   print("blah")
//               }
//                Button("blah2") {
//                    print("blah2")
//                }
//            }

            .navigationTitle("").navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.init(uiColor: .red), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            
        } detail: {
            HomePageView()
        }
        .onAppear {
            if !isInitialized {
               initializeData()
               isInitialized = true
           }
            UISearchBar.appearance().backgroundColor = .red
            UISearchBar.appearance().tintColor = .white
            UISearchBar.appearance().isTranslucent = false
        }
        .fullScreenCover(isPresented: $showNewRecipeModal) {
           NewRecipe()
        }
        .sheet(isPresented: $showCategorySheet) {
            CategorySheetView(currentFilter: $currentCategory)
        }
        
        .searchable(text: $searchText, prompt: "Search for a recipe")
        .searchScopes($currentCategory) {
            Text("All").tag("All")
            ForEach(categories, id: \.self) { category in
                Text(category.name)
                    .tag(category.name)
            }
        }
        .focused($isSearchBarFocused)
        
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
    
    private var browseAllList: some View {
            List{
                ForEach(searchFilteredRecipes) { recipe in
                    NavigationLink {
                        VStack{
                            VStack(alignment: .leading){
                                Text(recipe.title).font(.headline).fontWeight(.bold)
                                HStack {
                                    recipeImageView(recipe: recipe)
                                        .layoutPriority(0)
                                    VStack(alignment: .leading) {
                                        RatingsDisplayView(maxRating: 5, currentRating: recipe.starRating, sfSymbol: "star", width: 30, color: .systemYellow)
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
                            .frame(maxWidth: .infinity)
                            .padding()
                            Picker("", selection: $selectedSegment) {
                                ForEach(RecipeSegment.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                                .foregroundStyle(.red)
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            RecipeSegmentedView(segment: selectedSegment, recipe: recipe)
                            
                        }
                        .onAppear{
                            updateDateLastViewed(for: recipe)
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
                        .toolbarBackground(Color.red, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .navigationTitle("Recipe Details")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    } label: {
                        RecipeCardView(recipe: recipe)
                            .padding(EdgeInsets())
                         .swipeActions(allowsFullSwipe: false) {
                             Button(role: .destructive) {
                                 deleteRecipe(recipe)
                             } label: {
                                 Label("Delete", systemImage: "trash")
                             }
                             .tint(.red)
                             if !(currentCategory == "Most Recent" || currentCategory == "Uncategorized" || currentCategory == "All") {
                                 Button {
                                     removeRecipeFromCategory(recipe: recipe)
                                 } label: {
                                     Label("Remove from Category", systemImage: "folder.badge.minus")
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
    
    private func removeRecipeFromCategory(recipe: Recipe) {
        withAnimation{
            recipe.categories.removeAll(where: {$0.name == currentCategory})
        }
    }

    private func addItem() {
        showNewRecipeModal = true
    }
    
    private func editRecipe() {
        showEditRecipeModal = true
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

enum RecipeSegment: String, CaseIterable {
    case ingredients = "Ingredients"
    case directions = "Directions"
}

struct RecipeSegmentedView: View {
    var segment: RecipeSegment
    var recipe: Recipe

    var body: some View {
        switch segment {
        case .ingredients:
            IngredientsView(ingredients: recipe.ingredients)
        case .directions:
            DirectionsView(directions: recipe.directions)
        }
    }
}

struct IngredientsView: View {
    var ingredients: [Ingredient]

    var body: some View {
        List(ingredients, id: \.self) { ingredient in
            Text("\(ingredient.quantity) \(ingredient.ingredient) \(ingredient.notes)")
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


struct SearchFilter: View {
    @Binding var searchInTitle: Bool
    @Binding var searchInAuthor: Bool
    @Binding var searchInNotes: Bool
    @Binding var searchInIngredients: Bool
    @Binding var searchInDirections: Bool
    
    var body: some View {
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

//#Preview {
//    ContentView()
//        .modelContainer(for: Recipe.self, inMemory: true)
//}


