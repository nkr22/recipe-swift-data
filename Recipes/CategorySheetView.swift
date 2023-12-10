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
                CategorySheetComponentView(label: "All", symbol: "house", onSelect: { currentFilter = "All" })
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
                    .foregroundStyle(.red)
                }
                
            }
            .toolbarBackground(Color.red, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showNewCategorySheet) {
                NewCategoryView()
            }
        }
    }
}

#Preview {
    CategorySheetView(currentFilter: .constant("All"))
}
