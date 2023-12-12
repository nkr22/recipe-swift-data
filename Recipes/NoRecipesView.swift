//
//  NoRecipesView.swift
//  Recipes
//
//  Created by Noelia Root on 11/30/23.
//

import SwiftUI

struct NoRecipesView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundStyle(Color("MainColor"))
            Text("Enter a recipe").font(.title)
        }
        
    }
}

#Preview {
    NoRecipesView()
}
