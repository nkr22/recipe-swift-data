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
    @State var showModal = false
    @Query private var recipes: [Recipe]

    var body: some View {
        NavigationSplitView {
            VStack {
                Text("Recipes")
                browseAllList

#if os(macOS)
                    
#endif
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
        .fullScreenCover(isPresented: $showModal) {
           NewRecipe()
        }
    }
    
    private var browseAllList: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink {
                    VStack{
                        List {
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Markdown {
                                    "\(ingredient.quantity) \(ingredient.ingredient) \(ingredient.notes)"
                                }
                            }
                            ForEach(recipe.directions, id: \.self) { direction in
                                Markdown {
                                    "\(direction.order). \(direction.direction)"
                                }
                            }
                        }
                        
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
        showModal = true
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
                               ingredients: recipe.ingredients
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
