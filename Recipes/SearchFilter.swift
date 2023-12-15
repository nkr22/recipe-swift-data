//
//  SearchFilter.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct SearchFilter: View {
    @Binding var showSearchOptionsSheet: Bool
    
    var body: some View {
        
        Button(action: {
            showSearchOptionsSheet = true
        }, label: {
            Label("Search Options", systemImage: "slider.horizontal.3")
        })
        .foregroundStyle(Color("TextColor"))
    }
}

//#Preview {
//    SearchFilter()
//}
