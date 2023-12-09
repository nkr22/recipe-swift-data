//
//  TestView.swift
//  Recipes
//
//  Created by Noelia Root on 12/7/23.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @Query private var categories: [Category]
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    @State private var selectedRecipe: Recipe?
    @State private var isInitialized = false

    var body: some View {
        NavigationSplitView {
            List(categories, id: \.self) { category in
                NavigationLink(category.name,
                               tag: category,
                               selection: $selectedCategory) {
                    RecipeListView(category: category, selectedRecipe: $selectedRecipe)
                }
            }
        } detail: {
            if let selectedRecipe = selectedRecipe {
                RecipeDetailView(recipe: selectedRecipe)
            } else if let selectedCategory = selectedCategory {
                RecipeListView(category: selectedCategory, selectedRecipe: $selectedRecipe)
            } else {
                Text("Select a Category")
                    .onAppear {
                        if !isInitialized {
                            initializeData()
                            isInitialized = true
                        }
                    }
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

}

struct RecipeListView: View {
    var category: Category
    @Binding var selectedRecipe: Recipe?
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @State private var searchText = ""

    var body: some View {
        List {
            ForEach(recipes.filter { $0.categories.contains(category) }) { recipe in
                NavigationLink(recipe.title,
                               tag: recipe,
                               selection: $selectedRecipe) {
                    RecipeDetailView(recipe: recipe)
                }
            }
        }
        .searchable(text: $searchText)
        // Add other view modifiers and functionality as needed
    }
}

struct RecipeDetailView: View {
    var recipe: Recipe
    // Define the detail view for the recipe
    var body: some View {
        Text(recipe.title) // Replace with detailed view
        // Add other view elements and functionality
    }
}


#Preview {
    TestView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
