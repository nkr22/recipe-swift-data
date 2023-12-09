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
                .frame(width:15)
        }
        .padding()
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundStyle(.red)
                .opacity(0.5)
                .frame(minWidth: 50, maxWidth: .infinity)
        )
        .onTapGesture {
            showCategorySheet = true
        }
    }
}

//#Preview {
//    SelectCategoryView(currentFilter: "All Recipes")
//}
