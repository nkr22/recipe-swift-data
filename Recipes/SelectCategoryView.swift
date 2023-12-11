//
//  SelectCategoryView.swift
//  Recipes
//
//  Created by Noelia Root on 12/3/23.
//

import SwiftUI

struct SelectCategoryView: View {
    
    @Binding var currentFilter: String
    @Binding var showCategorySheet: Bool
    
    
    var body: some View {
        
        HStack{
            Text(currentFilter)
                .font(.subheadline)
            Image(systemName: "chevron.down")
                .frame(width:10)
        }
        .padding()
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundStyle(.blue)
                .opacity(0.5)
                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 20, maxHeight: 25)
        )
        .onTapGesture {
            showCategorySheet = true
        }
    }
}

//#Preview {
//    SelectCategoryView(currentFilter: "All Recipes")
//}
