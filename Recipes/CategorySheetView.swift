//
//  CategorySheetView.swift
//  Recipes
//
//  Created by Noelia Root on 12/3/23.
//

import SwiftUI
import SwiftData

struct CategorySheetView: View {
    @Environment(\.dismiss) var dismiss
    @Query(sort: \Category.name) private var categories: [Category]
    @Binding var currentFilter: String
    @State var showNewCategorySheet: Bool = false
    var body: some View {
        NavigationStack{
            List {
                CategorySheetComponentView(label: "All Recipes", symbol: "house", onSelect: { currentFilter = "All Recipes" })
                CategorySheetComponentView(label: "Most Recent", symbol: "clock", onSelect: { currentFilter = "Most Recent" })
                CategorySheetComponentView(label: "Favorites", symbol: "heart", onSelect: { currentFilter = "Favorites" })
                CategorySheetComponentView(label: "Uncategorized", symbol: "questionmark.folder", onSelect: { currentFilter = "Uncategorized" })
                ForEach(categories, id: \.self) {category in
                    CategorySheetComponentView(label: category.name, symbol: "folder", onSelect: { currentFilter = category.name })
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showNewCategorySheet = true
                    }, label: {
                        Label("Add Category", systemImage: "plus")
                    })
                    .foregroundStyle(Color("TextColor"))
                }
                
            }
            .navigationTitle("Filter by Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("MainColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showNewCategorySheet) {
                NewCategoryView()
            }
        }
    }
}

//#Preview {
//    CategorySheetView(currentFilter: .constant("All"))
//}
