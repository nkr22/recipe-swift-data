//
//  NewCategoryView.swift
//  Recipes
//
//  Created by Noelia Root on 12/9/23.
//

import SwiftUI
import SwiftData

struct NewCategoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.name)  private var allCategories: [Category]
    @Environment(\.dismiss) var dismiss

    @State var categoryName: String = ""
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $categoryName)
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel, action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addCategory, label: {
                        Text("Add")
                    })
                }
            }
            .toolbarBackground(Color("MainColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)

        }
    }
    private func addCategory() {
        let newCategory = Category(name: categoryName)
        if validateCategory(category: newCategory) {
            context.insert(newCategory)
        }
        dismiss()
    }
    
    private func validateCategory(category: Category) -> Bool {
        let alreadyExists = allCategories.filter {$0.name == category.name}
        if alreadyExists.isEmpty {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    NewCategoryView()
}
