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
    @State var showNewRecipeModal = false
    @State var showEditRecipeModal = false
    @Query private var recipes: [Recipe]
    @Query private var categories: [Category]

    var body: some View {
        NavigationSplitView {
            TabView {
                VStack{
                    if recipes.isEmpty {
                        NoRecipesView()
                    } else {
                        Text("Recipes")
                        browseAllList
                    }
                }
                .tabItem{
                    Label("Recipes", systemImage: "list.bullet")
                }
                VStack{
                    ForEach(categories, id: \.self) {category in
                        Text("\(category.name)")
                    }
                }
                .tabItem {
                    Label("Blah", systemImage: "list.star")
                }
            }
            
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button(action: initializeRecipes) {
                        Label("Initialize", systemImage: "arrow.clockwise")
                    }
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
        }
            
        } detail: {
            Markdown {
                """
                *Select* an **item**
                """
            }
        }
        .fullScreenCover(isPresented: $showNewRecipeModal) {
           NewRecipe()
        }
        
    }
    
    private var browseAllList: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink {
                    Button(action: editRecipe) {
                        Label("Edit", systemImage: "pencil")
                    }
                    VStack{
                        List {
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
                    .fullScreenCover(isPresented: $showEditRecipeModal) {
                       EditRecipeView(recipe: recipe)
                    }
                } label: {
                    Text("\(recipe.title)")
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
    
    private func initializeRecipes() {
        withAnimation{
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
                               categories: []
                              )
                        )
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
