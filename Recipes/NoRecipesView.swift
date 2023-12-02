//
//  NoRecipesView.swift
//  Recipes
//
//  Created by Noelia Root on 11/30/23.
//

import SwiftUI

struct NoRecipesView: View {
    var body: some View {
        VStack {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundStyle(.red)
            Text("Enter your first recipe").font(.title)
        }
        
    }
}

#Preview {
    NoRecipesView()
}
