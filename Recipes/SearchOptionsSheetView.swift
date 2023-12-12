//
//  SearchOptionsSheetView.swift
//  Recipes
//
//  Created by Noelia Root on 12/11/23.
//

import SwiftUI

struct SearchOptionsSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var searchInTitle: Bool
    @Binding var searchInAuthor: Bool
    @Binding var searchInNotes: Bool
    @Binding var searchInIngredients: Bool
    @Binding var searchInDirections: Bool
    
    var body: some View {
            NavigationView {
                Form {
                    Toggle("Search in Title", isOn: $searchInTitle)
                    Toggle("Search in Author", isOn: $searchInAuthor)
                    Toggle("Search in Notes", isOn: $searchInNotes)
                    Toggle("Search in Ingredients", isOn: $searchInIngredients)
                    Toggle("Search in Directions", isOn: $searchInDirections)
                }
                .navigationBarTitle("Search Options", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .toolbarBackground(Color("MainColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
        }
}

//#Preview {
//    SearchOptionsSheetView()
//}
