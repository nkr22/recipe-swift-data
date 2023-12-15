//
//  MultiSelector.swift
//  Recipes
//
//  Created by Noelia Root on 12/3/23.
//
// Followed this tutorial and code: https://www.fline.dev/multi-selector-in-swiftui/

import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding var selected: Set<Selectable>
    @State var openNewCategorySheet = false
    
    var body: some View {
        NavigationStack{
            CategoryList
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: addCategory) {
                    Label("Add Category", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $openNewCategorySheet) {
            NewCategoryView()
        }
        .navigationBarBackground()
    }
    var CategoryList: some View {
        List {
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable)).foregroundColor(.black)
                        
                        Spacer()
                        
                        if (selected.contains { $0.id == selectable.id }) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }.tag(selectable.id)
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func addCategory() {
        openNewCategorySheet = true
    }
    
    private func toggleSelection(selectable: Selectable) {
        print("Selected Category: \(selectable.id) \(selectable.self)")
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
        
        for selected in selected {
            print(selected.id)
        }
    }
    

}

