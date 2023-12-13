//
//  CategorySheetComponentView.swift
//  Recipes
//
//  Created by Noelia Root on 12/4/23.
//

import SwiftUI

struct CategorySheetComponentView: View {
    @Environment(\.dismiss) var dismiss
    var label: String
    var symbol: String
    var onSelect: () -> Void
    
    var body: some View {
        Button(action: {
            onSelect()
            dismiss()
        }) {
            HStack {
                Image(systemName: symbol)
                    .foregroundStyle(Color("MainColor"))
                Text(label)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    CategorySheetComponentView(label: "All", symbol: "house") {
       print("category")
    }
}
