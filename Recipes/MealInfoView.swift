//
//  MealInfoView.swift
//  Recipes
//
//  Created by Noelia Root on 12/12/23.
//

import SwiftUI

struct MealInfoView: View {
    @Binding var servings: String
    @Binding var prepTime: String
    @Binding var cookTime: String
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Meal Information")) {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Servings:")
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            TextField("e.g. 5", text: $servings)
                                .frame(width: 100, alignment: .trailing)
                        }
                        
                        HStack {
                            Text("Prep Time:")
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            TextField("e.g. 20 minutes", text: $prepTime)
                                .frame(width: 100, alignment: .trailing)
                        }
                        
                        HStack {
                            Text("Cook Time:")
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            TextField("e.g. 20 minutes", text: $cookTime)
                                .frame(width: 100, alignment: .trailing)
                        }
                    }
                }
            }
            .navigationBarBackground()
        }
        
    }
}

//#Preview {
//    MealInfoView()
//}
