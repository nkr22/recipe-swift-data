//
//  IngredientsView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct IngredientsView: View {
    var ingredients: [Ingredient]
    @Binding var currentScale: Double
    @State var showScalePopover = false
    
    private func amountView(amount: String) -> String {
        let myDouble = Double(amount)
        
        if let myDouble {
            return String(myDouble * currentScale)
        } else {
            return amount
        }
    }
    
    private func ingredientString(amount: String, unit: String, ingredient: String, notes: String) -> String {
        let amountString = amountView(amount: amount) != "" ? amountView(amount: amount) + " " : ""
        let unitString = unit != "" ? unit + " " : ""
        let ingredientString = ingredient != "" ? ingredient + " " : ""
        let notesString = notes
        
        return amountString + unitString + ingredientString + notesString
        
    }
    

    var body: some View {
        HStack(spacing:0){
            Button(action: {
                showScalePopover = true
            }, label: {
                Label("Current Scale: \(currentScale, specifier: "%.2f")", systemImage: "slider.horizontal.3")
                    .font(.subheadline)
                    .padding(.vertical, 2) 
            })
            .foregroundStyle(.blue)
            .popover(isPresented: $showScalePopover, attachmentAnchor: .point(.bottom), arrowEdge: .bottom) {
                NavigationStack{
                    ScalePopoverView(scaleValue: $currentScale)
                        .toolbar{
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    showScalePopover = false
                                }) {
                                    Text("Done")
                                }
                            }
                        }
                        .navigationBarBackground()
                }
                .frame(minWidth: 200, minHeight: 200)
                .presentationCompactAdaptation(.popover)
            }
            Spacer()
        }
        .listRowSeparator(.hidden)
        
        ForEach(ingredients) {ingredient in
            Text(ingredientString(amount: ingredient.amount, unit: ingredient.unit, ingredient: ingredient.ingredient, notes: ingredient.notes))
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }
    }
}


//#Preview {
//    IngredientsView()
//}
